---
title: 如何查看Linux/macOS的版本信息
date: 2021-10-17 22:22:02
---

在阅读论文的过程中，我发现作者均会说明实验使用的内核版本号和发行版本。那么，如何查看Linux/macOS的这些版本信息呢？

<!--more-->

![](/static/images/view-kernel-os-version.png)

### 查看内核版本

#### uname

uname，全称为unix name，用于打印系统信息。macOS和所有的Linux发行版均支持该命令。

```shell
uname -sr
```

* -s：内核名字
* -r：内核版本

#### cat /proc/version

此外，Linux还支持通过`/proc/version`查看内核版本：

```shell
[hegongshan@hgs ~]$ cat /proc/version
Linux version 3.10.0-1160.36.2.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) ) #1 SMP Wed Jul 21 11:57:15 UTC 2021
```

### 查看系统发行版本

#### lsb_release

lsb，全称为Linux Standard Base，用于打印Linux发行版本信息。

安装：

```shell
# CentOS
yum install -y redhat-lsb-core
```

使用：

```shell
[hegongshan@hgs ~]$ lsb_release -a
LSB Version:	:core-4.1-amd64:core-4.1-noarch
Distributor ID:	CentOS
Description:	CentOS Linux release 7.9.2009 (Core)
Release:	7.9.2009
Codename:	Core
```

#### cat /etc/redhat-release

该方法适用于RedHat发布的Linux发行版，比如CentOS等。

```shell
[hegongshan@hgs ~]$ cat /etc/redhat-release 
CentOS Linux release 7.9.2009 (Core)
```

#### sw_vers

sw_vers，全称为**S**oft**w**are **Vers**ion，用于打印macOS的版本。

```shell
hgs:~ hegongshan$ sw_vers
ProductName:	Mac OS X
ProductVersion:	10.13.6
BuildVersion:	17G65
```

sw_vers的源码为：

https://opensource.apple.com/source/DarwinTools/DarwinTools-1/sw_vers.c.auto.html
