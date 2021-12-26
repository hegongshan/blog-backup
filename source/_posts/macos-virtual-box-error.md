---
title: Virtual Box与macos
date: 2021-10-26 09:51:43
tags: 虚拟化
---

默认情况下，Virtual Box中安装的虚拟机无法清晰地全屏展示。

* 网上的解决办法

点击[Devices] → [Install Guest Additions CD image]。

然而，点击该按钮后，弹出了如下错误提示框：

* 最终的解决办法：手动安装

```shell
sudo apt install -y virtualbox-guest-utils
```

### 扩容

#### 调整磁盘大小

```shell
VBoxManage modifymedium     [disk|dvd|floppy] <uuid|filename>
                            [--resize <megabytes>|--resizebyte <bytes>]
```





```shell
hgs:~ hegongshan$ cd /Applications/VirtualBox.app/Contents/MacOS/
hgs:MacOS hegongshan$ VBoxManage list hdds
hgs:MacOS hegongshan$ VBoxManage modifyhd 5bed3e8e-039c-489b-8f59-b213c2f9d1e9 --resize 20480
```





```shell
/Users/hegongshan/VirtualBox VMs/ubuntu/ubuntu.vdi
```



```shell
VBoxManage modifyhd /Users/hegongshan/VirtualBox VMs/ubuntu/ubuntu.vdi --resize 20480
```

#### 新建分区

```shell
fdisk /dev/sda


```

