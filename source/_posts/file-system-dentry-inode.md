---
title: Linux中的inode与dentry
date: 2021-10-09 11:05:39
tags: file system
categories: file system
---

理解文件系统中的inode与dentry。

<!--more-->

### inode

inode，全称为index node，即索引节点。它定义在`include/linux/fs.h`中：

```c
struct inode {
    umode_t			i_mode;
    kuid_t			i_uid; 
    kgid_t			i_gid;
    struct super_block	*i_sb;
    unsigned long		i_ino; /* inode number */
    union {
      	const unsigned int i_nlink;
      	unsigned int __i_nlink;
    };
    loff_t			i_size;
    struct timespec64	i_atime; /* access time */
    struct timespec64	i_mtime; /* modify time */
    struct timespec64	i_ctime; /* change time */
    // ...
}
```

### dentry

dentry，全称为directory entry，即目录项。它定义在`include/linux/dcache.h`中：

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
    // ....
}
```

其中，`struct list_head`定义在`include/linux/types.h`中：

```c
struct list_head {
    struct list_head *next, *prev;
};
```

### 参考资料

1. 《Linux内核设计与实现》

2. https://github.com/torvalds/linux/
