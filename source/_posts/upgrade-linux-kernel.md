---
title: 升级Linux内核
date: 2021-12-21 21:22:28
tags: linux
categories: linux
---

最近的测试，需要使用4.x及以上版本的Linux内核，而服务器上的CentOS 7.9还停留在3.x时代。因此，有必要升级下内核版本。本文总结了通过源码安装Linux内核的全过程。

<!--more-->

在升级Linux内核前，查看下当前的内核版本

```shell
[root@hgs ~]# uname -r
3.10.0-1160.el7.x86_64
```

1.下载内核。从[官网](https://www.kernel.org)下载需要的<strong style="color:red;">longterm</strong>内核版本：

```shell
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.87.tar.xz
```

2.解压缩

```shell
tar -xf linux-5.10.87.tar.xz 
```

3.进入源码目录

```shell
cd linux-5.10.87/
```

4.拷贝一份现有的配置到源码目录下

* 确认当前使用的内核项：

```shell
[root@hgs linux-5.10.87]# grub2-editenv list
saved_entry=CentOS Linux (3.10.0-1160.49.1.el7.x86_64) 7 (Core)
```

* 复制对应的配置到源码目录，新的文件名为`.config`

```shell
cp /boot/config-3.10.0-1160.49.1.el7.x86_64 .config
```

5.配置内核

* 安装配置依赖

```shell
yum install -y flex bison
```

* 配置内核：配置项很多，一直按`Enter`键就好

```shell
make oldconfig
```

6.安装编译依赖

```shell
yum install -y elfutils-libelf-devel openssl-devel
```

7.编译

```shell
make -j40
```

8.安装模块：把编译好的模块拷贝到系统目录`/lib/modules`下

```shell
make modules_install
```

9.安装内核

```shell
make install
```

待安装完毕后，在`/boot`下生成了对应的内核文件：

```shell
[root@hgs linux-5.10.87]# ls /boot | grep 5.10.87
initramfs-5.10.87.img
System.map-5.10.87
vmlinuz-5.10.87
```

此外，在grub的配置文件中，出现了新安装的内核信息：

```shell
[root@hgs linux-5.10.87]# cat /boot/grub2/grub.cfg | grep Core
menuentry 'CentOS Linux (5.10.87) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-1160.el7.x86_64-advanced-ddb4ef8b-2c56-44dd-8ea2-302dd8bdd237' {
menuentry 'CentOS Linux (3.10.0-1160.49.1.el7.x86_64) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-1160.el7.x86_64-advanced-ddb4ef8b-2c56-44dd-8ea2-302dd8bdd237' {
menuentry 'CentOS Linux (3.10.0-1160.el7.x86_64) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-1160.el7.x86_64-advanced-ddb4ef8b-2c56-44dd-8ea2-302dd8bdd237' {
menuentry 'CentOS Linux (0-rescue-f1a1b65c997e453d9a72b2349f0000df) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-0-rescue-f1a1b65c997e453d9a72b2349f0000df-advanced-ddb4ef8b-2c56-44dd-8ea2-302dd8bdd237' {
```

设置开机默认内核：

```shell
grub2-set-default [OPTION] MENU_ENTRY
```

其中，`MENU_ENTRY`可以是数字、菜单项的标题或者ID。

```shell
[root@hgs ~]# awk -F "'" '$1 == "menuentry " {print i++ " : " $2}' /etc/grub2.cfg
0 : CentOS Linux (5.10.87) 7 (Core)
1 : CentOS Linux (3.10.0-1160.49.1.el7.x86_64) 7 (Core)
2 : CentOS Linux (3.10.0-1160.el7.x86_64) 7 (Core)
3 : CentOS Linux (0-rescue-f1a1b65c997e453d9a72b2349f0000df) 7 (Core)
```

设置启动项：

```shell
grub2-set-default 0
# grub2-set-default 'CentOS Linux (5.10.87) 7 (Core)'
```

10.重启系统

```shell
reboot
```

11.查看内核版本

```shell
[root@hgs ~]# uname -r
5.10.87
```



