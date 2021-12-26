---
title: Linux中的inode与dentry
date: 2021-10-09 11:05:39
tags: file system
categories: file system
---

理解文件系统中的inode与dentry。

<!--more-->

### inode

inode，全称为index node（索引节点）。它定义在[include/linux/fs.h](https://github.com/torvalds/linux/blob/master/include/linux/fs.h)中：

```c
struct inode {
    umode_t			i_mode;
    kuid_t			i_uid; 
    kgid_t			i_gid;
    struct super_block	*i_sb;
    unsigned long		i_ino; /* inode number */
    union {
      	const unsigned int i_nlink; /* 硬链接数 */
      	unsigned int __i_nlink;
    };
    dev_t			i_rdev; /* 设备号 */
    loff_t			i_size; /* 文件大小（以位为单位）*/
    struct timespec64	i_atime; /* access time */
    struct timespec64	i_mtime; /* modify time */
    struct timespec64	i_ctime; /* change time */
    unsigned short          i_bytes;
  
    atomic_t		i_count; /* 内存引用计数 */
    union {
        struct hlist_head	i_dentry; /* “被使用的”目录项链表 */
        struct rcu_head		i_rcu;
    };
    // ...
};
```

1.`umode_t i_mode;`中的类型`umode_t`定义在[include/linux/types.h](https://github.com/torvalds/linux/blob/master/include/linux/types.h)：

```c
typedef unsigned short		umode_t;
```

在C语言中，short类型占用2个字节，共计16位。变量i_mode的内存布局如下图所示：

![](/static/images/linux-vfs-inode-mode.png)

2.`struct hlist_head`定义在[include/linux/types.h](https://github.com/torvalds/linux/blob/master/include/linux/types.h)中：

```c
struct hlist_head {
    struct hlist_node *first;
};

struct hlist_node {
    struct hlist_node *next, **pprev;
};
```

### dentry

dentry，全称为directory entry（目录项）。它定义在[include/linux/dcache.h](https://github.com/torvalds/linux/blob/master/include/linux/dcache.h)中：

```c
/*
 * "quick string" -- eases parameter passing, but more importantly
 * saves "metadata" about the string (ie length and the hash).
 *
 * hash comes first so it snuggles against d_parent in the
 * dentry.
 */
struct qstr {
    union {
        struct {
            HASH_LEN_DECLARE;
        };
        u64 hash_len;
    };
    const unsigned char *name;
};

struct dentry {
    struct dentry *d_parent;	/* 父目录 */
    struct qstr d_name;	/* 目录项名称 */
    struct inode *d_inode;	/* 索引节点 */
    unsigned char d_iname[DNAME_INLINE_LEN];	/* 短名称 */

    struct list_head d_child;	/* 父目录链表 */
    struct list_head d_subdirs;	/* 子目录链表 */

    union {
        struct list_head d_lru;		/* LRU list（“最近被使用的”双向链表） */
        wait_queue_head_t *d_wait;	/* in-lookup ones only */
    };
    // ....
};
```

其中，`struct list_head`定义在[include/linux/types.h](https://github.com/torvalds/linux/blob/master/include/linux/types.h)中：

```c
// 双向链表
struct list_head {
    struct list_head *next, *prev;
};
```

### super block

super block，超级块，定义在[include/linux/fs.h](https://github.com/torvalds/linux/blob/master/include/linux/fs.h)中：

```c
struct super_block {
    struct dentry		*s_root; /* 文件系统的根目录 */
};
```

### file

file，文件，定义在[include/linux/fs.h](https://github.com/torvalds/linux/blob/master/include/linux/fs.h)中：

```c
struct file {
    struct inode		*f_inode;	/* 文件的inode */
};
```

https://github.com/torvalds/linux/blob/master/include/linux/sched.h

```c
struct task_struct {
    /* Open file information: */
    struct files_struct		*files;
};
```

https://github.com/torvalds/linux/blob/master/include/linux/fdtable.h

```c
/*
 * Open file table structure
 */
struct files_struct {
    /*
     * read mostly part
     */
    atomic_t count;

    struct fdtable __rcu *fdt;
    struct fdtable fdtab;

    struct file __rcu * fd_array[NR_OPEN_DEFAULT];
};

struct fdtable {
    unsigned int max_fds;
    struct file __rcu **fd;      /* current fd array */
    unsigned long *close_on_exec;
    unsigned long *open_fds;
    unsigned long *full_fds_bits;
    struct rcu_head rcu;
};
```

### 使用Shell命令查看文件信息

#### ls

查看文件的相关属性`ls -l`。

```shell
hgs:storage-systems hegongshan$ ls -l
total 16
-rw-r--r--@ 1 hegongshan  staff  4199 10  9 18:26 README.md
```

解析：

```shell
[file mode] [number of links] [owner name] [group name] [number of bytes in the file] [modify time] [path name]

modify time: [month] [day] [hour]:[minute]
```

#### stat

查看文件的状态信息。

### 参考资料

1. 《Linux内核设计与实现》，机械工业出版社
2. Linux，https://github.com/torvalds/linux/

