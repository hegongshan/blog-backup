---
title: 使用lsscsi命令查看存储设备及其属性
date: 2021-11-27 20:35:31
tags: storage
categories: linux
---

如何查看服务器使用的磁盘类型呢？

<!--more-->

lsscsi，全称为list small computer system interface，用于列出SCSI设备及其属性。

### 安装lsscsi

默认情况下，服务器不会安装lsscsi工具。因此，需要手动安装。

```shell
# CentOS
yum install -y lsscsi

# Ubuntu
apt install -y lsscsi
```

### 查看存储设备类型

```shell
lsscsi
设备类型 厂家 型号 版本 设备名
```

* 查看存储设备的容量

```shell
lsscsi -s
```

