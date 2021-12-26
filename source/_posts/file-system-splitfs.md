---
title: 论文阅读《SplitFS&#58 Reducing Software Overhead in File Systems for Persistent Memory》
date: 2021-11-17 22:03:24
tags: file system
categories: file system
mathjax: true
---

SplitFS发表在SOSP‘19上。

<!--more-->

### 拦截POSIX调用

作者通过设置环境变量`LD_PRELOAD`，拦截POSIX调用：

```shell
export LD_PRELOAD=xxx
```

### 日志操作

SplitFS着重优化了追加操作。追加操作的日志项append_log_entry定义在头文件[splitfs/log.h](https://github.com/utsaslab/SplitFS/blob/master/splitfs/log.h)中。

```c
struct append_log_entry {
    uint32_t checksum;
    uint32_t file_ino;
    uint32_t dr_ino;
    loff_t file_offset;
    loff_t dr_offset;
    size_t data_size; // long unsigned int
    uint8_t padding[28];
};
```

$$
追加操作的日志项大小 = 4 \times 3 + 8 \times 2 + 8 + 28 = 64B
$$

#### 校验和（checksum）

> P499: First, to distinguish between valid and invalid or torn log entries, we incorporate a 4B transactional checksum within the 64B log entry.

校验和（占用4个字节）使用了循环冗余校验（Cyclic Redundancy Check， CRC）。

在CRC中，有几个重要的概念：

第一，模2运算。加法不进位，减法不借位，等价于异或运算（eXclusive OR，XOR）。

第二，生成多项式（Generator Polynomial）。

第三，余数初始值（Initial Remainder）。

第四，结果异或值（XOR）
$$
CRC =（D \ll 2^r) \oplus G
$$

其中，G的长度为r + 1。

校验和的实现代码如下所示：

```c
// 计算r的校验码
uint32_t crc32_for_byte(uint32_t r) {
    for(int j = 0; j < 8; ++j)
        r = (r & 1? 0: (uint32_t)0xEDB88320L) ^ r >> 1;
    return r ^ (uint32_t)0xFF000000L;
}

/*
 * data: 原始数据指针
 * n_bytes: 原始数据占用的字节数
 * crc: 校验和指针
 */
void create_crc32(const void *data, size_t n_bytes, uint32_t* crc) {
    // 使用static修饰符，表明table只计算一次，后续调用不再计算
    static uint32_t table[0x100];
    if(!*table)
        for(size_t i = 0; i < 0x100; ++i)
            table[i] = crc32_for_byte(i);
    for(size_t i = 0; i < n_bytes; ++i)
        *crc = table[(uint8_t)*crc ^ ((uint8_t*)data)[i]] ^ *crc >> 8;
}
```

其中，`0xEDB88320`是CRC-32的生成多项式：

$$
\mathrm{poly} = 0xEDB88320 = 0b1110\ 1101\ 1011\ 1000\ 1000\ 0011\ 0010\ 0000 \\\\
$$

```c
// 计算r的校验码
uint32_t crc32_for_byte(uint32_t r) {
    for(int j = 0; j < 8; ++j)
        r = (r & 1? 0: (uint32_t)0xEDB88320L) ^ r >> 1;
    return r ^ (uint32_t)0xFF000000L;
}
```

将三目运算符改写为条件判断语句：

```c
uint32_t crc32_for_byte(uint32_t r) {
    for(int j = 0; j < 8; ++j) {
        if (r & 1) {
            r = r >> 1;
        } else {
            r = ((uint32_t)0xEDB88320L) ^ (r >> 1);
        }
    }
    return r ^ (uint32_t)0xFF000000L;
}
```



#### CAS操作

> P499: Second, we maintain a tail for the log in DRAM and concurrent threads use the tail as a synchronization variable. They **use compare-and-swap to atomically advance the tail** and write to their respective log entries concurrently.

比较并交换（Compare And Swap，简称CAS）操作：

```c
type __sync_fetch_and_add(type *ptr, type value, ...);

bool __sync_bool_compare_and_swap(type *ptr, type oldval, type newval, ...);
type __sync_val_compare_and_swap(type *ptr, type oldval, type newval, ...);
```



```c
void persist_append_entry(uint32_t file_ino,
              uint32_t dr_ino,
              loff_t file_off,
              loff_t dr_off,
              size_t size) {
    loff_t log_off;
    struct append_log_entry app_entry;
 fetch_and_add:
    log_off = __sync_fetch_and_add(&app_log_tail, APPEND_LOG_ENTRY_SIZE);
    if (app_log_tail > app_log_lim) {
        if (__sync_bool_compare_and_swap(&clearing_app_log, 0, 1))
            sync_and_clear_app_log();
        goto fetch_and_add;
    }
    app_entry.file_ino = file_ino;
    app_entry.dr_ino = dr_ino;
    app_entry.file_offset = file_off;
    app_entry.dr_offset = dr_off;
    app_entry.data_size = size;
    create_crc32((void *) &(app_entry.file_ino), 32, &(app_entry.checksum)); 
    //app_entry.checksum = checksum; // [TODO] Calculate Checksum
    MEMCPY_NON_TEMPORAL((void *)app_log + log_off,
                &app_entry,
                APPEND_LOG_ENTRY_SIZE);
    _mm_sfence();   
#if NVM_DELAY
    perfmodel_add_delay(0, APPEND_LOG_ENTRY_SIZE);
#endif
}
```

其中，日志文件的最大容量`app_log_lim`：

```c
// log.h
#define APPEND_LOG_SIZE (128*1024*1024)

loff_t app_log_lim;

// log.c > init_append_log()
app_log_lim = APPEND_LOG_SIZE;
```

> P499: We employ a **128MB** operation log file and **if it becomes full**, we checkpoint the state of the application by **calling relink() on all the open files that have data in staging files**. We **then zero out** the log and reuse it.

对应代码中的条件判断：

```c
 fetch_and_add:
    log_off = __sync_fetch_and_add(&app_log_tail, APPEND_LOG_ENTRY_SIZE);
    if (app_log_tail > app_log_lim) {
        if (__sync_bool_compare_and_swap(&clearing_app_log, 0, 1))
            sync_and_clear_app_log();
        goto fetch_and_add;
    }
```

### fsync()

```c
#include <unistd.h>

// 将内存中的修改同步到存储设备中
int fsync(int fd);
```

### 内存屏障

内存屏障（Memory Barrier），内存栅栏（Memory Fence）sfence

```c
#include <emmintrin.h>

void _mm_sfence(void);
```

### Relink()

ext4中的函数ext4_ioctl()中的EXT4_IOC_MOVE_EXT命令。

https://github.com/torvalds/linux/blob/v4.13/fs/ext4/ioctl.c#L717

```c
    case EXT4_IOC_MOVE_EXT: {
        struct move_extent me;
        struct fd donor;
        int err;

        if (!(filp->f_mode & FMODE_READ) ||
            !(filp->f_mode & FMODE_WRITE))
            return -EBADF;

        if (copy_from_user(&me,
            (struct move_extent __user *)arg, sizeof(me)))
            return -EFAULT;
        me.moved_len = 0;

        donor = fdget(me.donor_fd);
        if (!donor.file)
            return -EBADF;

        if (!(donor.file->f_mode & FMODE_WRITE)) {
            err = -EBADF;
            goto mext_out;
        }

        if (ext4_has_feature_bigalloc(sb)) {
            ext4_msg(sb, KERN_ERR,
                 "Online defrag not supported with bigalloc");
            err = -EOPNOTSUPP;
            goto mext_out;
        } else if (IS_DAX(inode)) {
            ext4_msg(sb, KERN_ERR,
                 "Online defrag not supported with DAX");
            err = -EOPNOTSUPP;
            goto mext_out;
        }

        err = mnt_want_write_file(filp);
        if (err)
            goto mext_out;

        err = ext4_move_extents(filp, donor.file, me.orig_start,
                    me.donor_start, me.len, &me.moved_len);
        mnt_drop_write_file(filp);

        if (copy_to_user((struct move_extent __user *)arg,
                 &me, sizeof(me)))
            err = -EFAULT;
mext_out:
        fdput(donor);
        return err;
    }      
```

### 参考资料

1.论文：https://www.cs.utexas.edu/~vijay/papers/sosp19-splitfs.pdf

2.代码：https://github.com/utsaslab/SplitFS

3.libcrc：https://github.com/lammertb/libcrc

