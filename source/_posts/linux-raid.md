---
title: 存储设备之RAID
date: 2021-11-30 22:37:53
tags: linux
categories: linux
---

近期遇到了一个需求——删除创建的软RAID，趁机了解了下RAID的知识和操作。

<!--more-->

### 什么是RAID

RAID，全称为Redundancy Array of Independent Disk。

mdadm是管理Linux中软件RAID的工具。其中，md的全称为multiple devices。

### 创建RAID

```shell
# mdadm --create
mdadm -C /dev/md0 -l 10 -n /dev/sdb{1..4}
```

-l, --level：设置RAID级别

-n, --raid-devices：指定RAID中的活跃磁盘数

### 管理RAID

* 添加一个磁盘

```shell
mdadm /dev/md0 --add /dev/sdb
```

* 删除一个磁盘

```shell
mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
```

### 查看RAID信息

```shell
cat /proc/mdstat
```

### 运行RAID

```shell
mdadm -A -s /dev/md0
```

### 查看某个RAID

```shell
mdadm -D /dev/md0
```

### 删除RAID

1.卸载RAID

```shell
umount /dev/md0
```

2.停用RAID设备

```shell
# mdadm --stop /dev/md0
mdadm -S /dev/md0
```

3.删除RAID中的所有磁盘

```shell
mdadm --zero-superblock /dev/sda{a..f}
```

4.删除配置文件

```shell
rm -f /etc/mdadm.conf
```

5.删除fstab中的配置

```shell
vim /etc/fstab
```

可能出现的问题：

```shell
mdadm: Couldn't open sdb for write - not zeroing
```

