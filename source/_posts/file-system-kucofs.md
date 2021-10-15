---
title: 论文阅读 Scalable Persistent Memory File System with Kernel-Userspace Collaboration
date: 2021-10-12 16:27:26
tags: file system
categories: file system
---

KucoFS一文发表在2021年的FAST会议上，作者提出了一种基于持久内存的混合文件系统。

<!--more-->

### 基础概念

|            概念             |                             解释                             |
| :-------------------------: | :----------------------------------------------------------: |
| two types of metadata items | inode (describe file attributes) and dentry (map file name to inode number) |
|        block mapping        |             map a logical file to physical pages             |
|     stray writes (误写)     | Misused pointers can lead to write to incorrect locations and corrupt the data. |

Epoch-based Reclamation (EBR）：基于代的回收

lease：租约

### 数据结构

Skip List：跳跃链表

Partition Tree：划分树

Bitmap：位图

### 参考资料

1. [论文地址](https://www.usenix.org/system/files/fast21-chen-youmin.pdf)

2. [Slides](https://www.usenix.org/sites/default/files/conference/protected-files/fast21_slides_chen_youmin.pdf)
