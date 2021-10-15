---
title: 文件系统的制作、安装以及卸载
date: 2021-09-10 21:09:37
tags: operating system
---

### Busybox

官网：https://busybox.net

1.下载最新的稳定版Busybox

```shell
wget https://busybox.net/downloads/busybox-1.33.1.tar.bz2
```

2.解压

```shell
tar -jxf busybox-1.33.1.tar.bz2
```

3.安装Arm64 GCC

```shell
# Ubuntu
apt install gcc-aarch64-linux-gnu

# CentOS
yum install gcc-aarch64-linux-gnu
```

4.配置

```shell
make defconfig
```

5.编译

```shell
make CROSS_COMPILE=aarch64-linux-gnu-
```

6.安装

```shell
make install
```

`_install`文件夹

