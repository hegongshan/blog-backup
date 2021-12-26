---
title: C标准库中strcpy、memcpy以及memmove的实现和区别
date: 2021-11-11 15:04:52
tags: c
categories: c
---

在C标准库中，函数strcpy、memcpy以及memmove都可以完成复制操作，它们是怎么实现的？为什么要有三个复制函数呢？

<!--more-->

下面以GNU的glibc来分析三者的实现和区别。

### strcpy

函数strcpy()由`glibc/string/strcpy.c`实现，用于执行字符串的复制操作：

```c
/* Copy SRC to DEST.  */
char *
STRCPY (char *dest, const char *src)
{
    return memcpy (dest, src, strlen (src) + 1);
}
```

strcpy()内部直接调用了memcpy()。`strlen (src) + 1`目的在于，加上末尾的结束符`'\0'`。

### memcpy

函数memcpy()由`glibc/string/memcpy.c`实现，其按照从前往后的顺序依次复制，无法正确处理重叠问题：

```c
void *
MEMCPY (void *dstpp, const void *srcpp, size_t len)
{
    unsigned long int dstp = (long int) dstpp;
    unsigned long int srcp = (long int) srcpp;

    /* Copy from the beginning to the end.  */
    /* If there not too few bytes to copy, use word copy.  */
    if (len >= OP_T_THRES) {
        /* Copy just a few bytes to make DSTP aligned.  */
        len -= (-dstp) % OPSIZ;
        BYTE_COPY_FWD (dstp, srcp, (-dstp) % OPSIZ);

        /* Copy whole pages from SRCP to DSTP by virtual address manipulation,
           as much as possible.  */
        PAGE_COPY_FWD_MAYBE (dstp, srcp, len, len);

        /* Copy from SRCP to DSTP taking advantage of the known alignment of
           DSTP.  Number of bytes remaining is put in the third argument,
           i.e. in LEN.  This number may vary from machine to machine.  */
        WORD_COPY_FWD (dstp, srcp, len, len);
        /* Fall out and copy the tail.  */
    }

    /* There are just a few bytes to copy.  Use byte memory operations.  */
    BYTE_COPY_FWD (dstp, srcp, len);

    return dstpp;
}
```

1.条件判断`len >= OP_T_THRES`中的`OP_T_THRES`定义在`glibc/sysdeps/generic/memcopy.c`中：

```c
/* Type to use for aligned memory operations.
   This should normally be the biggest type supported by a single load
   and store.  */
#define op_t    unsigned long int
#define OPSIZ   (sizeof (op_t))

/* Threshold value for when to enter the unrolled loops.  */
#define OP_T_THRES      16
```

2.宏`BYTE_COPY_FWD`定义同样在`glibc/sysdeps/generic/memcopy.c`中，用于执行从前往后逐字节的复制操作：

```c
/* Copy exactly NBYTES bytes from SRC_BP to DST_BP,
   without any assumptions about alignment of the pointers.  */
#define BYTE_COPY_FWD(dst_bp, src_bp, nbytes)                                 \
  do                                                                          \
    {                                                                         \
      size_t __nbytes = (nbytes);                                             \
      while (__nbytes > 0)                                                    \
        {                                                                     \
          byte __x = ((byte *) src_bp)[0];                                    \
          src_bp += 1;                                                        \
          __nbytes -= 1;                                                      \
          ((byte *) dst_bp)[0] = __x;                                         \
          dst_bp += 1;                                                        \
        }                                                                     \
    } while (0)
```

其中，`do {} while(0)`的目的在于，确保预编译时，宏定义中的语句被正确替换。

3.宏PAGE_COPY_FWD_MAYBE的定义如下：

```c
# define PAGE_COPY_FWD_MAYBE(dstp, srcp, nbytes_left, nbytes)                 \
  do                                                                          \
    {                                                                         \
      if ((nbytes) >= PAGE_COPY_THRESHOLD                                     \
          && PAGE_OFFSET ((dstp) - (srcp)) == 0)                              \
        {                                                                     \
          /* The amount to copy is past the threshold for copying             \
             pages virtually with kernel VM operations, and the               \
             source and destination addresses have the same alignment.  */    \
          size_t nbytes_before = PAGE_OFFSET (-(dstp));                       \
          if (nbytes_before != 0)                                             \
            {                                                                 \
              /* First copy the words before the first page boundary.  */     \
              WORD_COPY_FWD (dstp, srcp, nbytes_left, nbytes_before);         \
              assert (nbytes_left == 0);                                      \
              nbytes -= nbytes_before;                                        \
            }                                                                 \
          PAGE_COPY_FWD (dstp, srcp, nbytes_left, nbytes);                    \
        }                                                                     \
    } while (0)
```

### memmove

函数memmove()定义在`glibc/string/memmove.c`中。

当目标区域和源区域不存在重叠时，其直接调用了函数memcpy()，按照**从前往后**的顺序依次复制；

而当目标区域和源区域<strong style="color:red;">存在重叠问题时</strong>，其按照<strong style="color:red;">从后往前</strong>的顺序依次复制：

```c
void *
MEMMOVE (void *dest, const void *src, size_t len)
{
    unsigned long int dstp = (long int) dest;
    unsigned long int srcp = (long int) src;

    /* This test makes the forward copying code be used whenever possible.
       Reduces the working set.  */
    /* *Unsigned* compare!  */
    if (dstp - srcp >= len) {
        /* Copy from the beginning to the end.  */
#if MEMCPY_OK_FOR_FWD_MEMMOVE
        dest = memcpy (dest, src, len);
#else
        // 此处的代码与函数memcpy()中的代码一模一样，
      	// 为了缩减代码长度，省略该部分代码
#endif /* MEMCPY_OK_FOR_FWD_MEMMOVE */
    } else {
        /* Copy from the end to the beginning.  */
        srcp += len;
        dstp += len;

        /* If there not too few bytes to copy, use word copy.  */
        if (len >= OP_T_THRES) {
          /* Copy just a few bytes to make DSTP aligned.  */
          len -= dstp % OPSIZ;
          BYTE_COPY_BWD (dstp, srcp, dstp % OPSIZ);

          /* Copy from SRCP to DSTP taking advantage of the known
             alignment of DSTP.  Number of bytes remaining is put
             in the third argument, i.e. in LEN.  This number may
             vary from machine to machine.  */
          WORD_COPY_BWD (dstp, srcp, len, len);
          /* Fall out and copy the tail.  */
        }

        /* There are just a few bytes to copy.  Use byte memory operations.  */
        BYTE_COPY_BWD (dstp, srcp, len);
    }

    return dest;
}
```

### 区别和联系

|   函数    |     描述     | 复制方法                                                     |
| :-------: | :----------: | ------------------------------------------------------------ |
| strcpy()  |  复制字符串  | 从前往后依次复制，内部调用了函数memcpy()                     |
| memcpy()  | 复制内存区域 | 从前往后依次复制                                             |
| memmove() | 复制内存区域 | 1.当目标区域和源区域**不存在重叠**时，按照**从前往后**的顺序依次复制；<br>2.当目标区域和源区域**存在重叠**时，按照**从后往前**的顺序依次复制 |

### 参考资料

1.The GNU C Library (glibc)，https://www.gnu.org/software/libc/

2.BYTE_COPY_FWD 源码解析，https://justinyan.me/post/1689

3.memmove vs memcpy how different? implement your own code?

https://www.equestionanswers.com/c/memcpy-vs-memmove.php
