---
title: 编译Linux内核
date: 2021-09-10 18:47:51
tags: operating system
categories: operating system
---

编译Linux内核，听起来似乎是一件难度极高的事情。事实上，真的如此吗？

<!--more-->

1.准备工作

* 下载Linux

```shell
git clone https://github.com/torvalds/linux
```

* 进入linux目录

```shell
cd linux
```

* 切换分支

```shell
# 本文使用4.4版本
git checkout v4.4
```

2.配置内核

make defconfig：使用默认配置

make menuconfig：使用图形界面，依赖库ncurses

make xconfig：

```shell
make menuconfig
```



3.编译

本文采用ARM64交叉编译，如果系统中没有安装，可以使用如下方式进行安装：

```shell
# GNU C compiler for the arm64 architecture
# Ubuntu
apt install -y gcc-aarch64-linux-gnu

# CentOS
yum install -y gcc-aarch64-linux-gnu
```

下面开始编译：

```shell
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image -j8
```

如果编译成功，最后会输出如下信息：

```shell
  OBJCOPY arch/arm64/boot/Image
```

表示编译后的内核文件为`arch/arm64/boot/Image`。

当然，编译过程中可能会出现一些问题，比如：

```shell
/bin/sh: 1: bc: not found
Kbuild:32: recipe for target 'include/generated/timeconst.h' failed
make[1]: *** [include/generated/timeconst.h] Error 127
make[1]: *** Waiting for unfinished jobs....
Makefile:1091: recipe for target 'prepare0' failed
make: *** [prepare0] Error 2
```

原因分析：找不到`bc`

解决办法：安装`bc`

```shell
# Ubuntu
apt install -y bc

# CentOS
yum install -y bc
```

