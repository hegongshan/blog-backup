---
title: 从源码安装GCC
date: 2021-09-15 22:13:06
tags: gcc
categories: gcc
---

本文梳理了从源码安装GCC的流程，回顾了安装过程中遇到的一些问题。

<!--more-->

1.下载GCC

```shell
# wget http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz
[root@hgs ~]# wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz
```

2.解压

```shell
[root@hgs ~]# tar -zxf gcc-4.9.4.tar.gz
[root@hgs ~]# cd gcc-4.9.4
```

3.下载必要的依赖

```shell
[root@hgs gcc-4.9.4]# ./contrib/download_prerequisites
```

若出现下述问题：

```shell
tar (child): bzip2：无法 exec: 没有那个文件或目录
tar (child): Error is not recoverable: exiting now
tar: Child returned status 2
tar: Error is not recoverable: exiting now
```

则需要安装bzip2：

```shell
# apt-get install -y bzip2
yum install -y bzip2
```

4.配置GCC

```shell
[root@hgs gcc-4.9.4]# mkdir build
[root@hgs gcc-4.9.4]# cd build/
[root@hgs build]# ../configure --enable-checking=release --enable-languages=c,c++ --disable-multilib
```

5.编译

```shell
[root@hgs build]# make -j8
```

在编译的过程中，可能会出现如下问题：

问题一：

```shell
./md-unwind-support.h:65:47: error: dereferencing pointer to incomplete type
       sc = (struct sigcontext *) (void *) &uc_->uc_mcontext;
                                               ^
```

此时，只需要编辑`build/x86_64-unknown-linux-gnu/libgcc/md-unwind-support.h`，将第61行中的`ucontext`修改为`ucontext_t`即可。

```c
[root@hgs build]# vim x86_64-unknown-linux-gnu/libgcc/md-unwind-support.h

// struct ucontext *uc_ = context->cfa;
struct ucontext_t *uc_ = context->cfa;
```

6.安装

```shell
[root@hgs build]# make install
```

7.查看GCC的安装位置和版本

```shell
[root@hgs build]# which gcc
/usr/local/bin/gcc
[root@hgs build]# gcc --version
gcc (GCC) 4.9.4
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

