---
title: CentOS网络配置
date: 2021-09-13 16:55:59
tags: centos
categories: centos
---

在CentOS中，网络启动相关配置存放在目录`/etc/sysconfig/network-scripts`中：

```shell
cd /etc/sysconfig/network-scripts
```

查看目录下形如`ifcfg-xxx`的文件

```shell
cat ifcfg-enp2s0f0
```

BOOTPROTO：启动协议（**Boot Proto**col）

* none

* static：固定IP

* dhcp：Dynamic Host Configuration Protocol，动态主机配置协议，动态分配IP

ONBOOT

### 实验过程

1.修改网络配置

```shell
IPADDR=192.168.255.101
GATEWAY=192.168.255.2
NETMASK=255.255.255.0
DNS=192.168.255.1
```

2.配置DNS

```shell
[root@hgs ~]# echo nameserver 8.8.8.8 > /etc/resolv.conf
[root@hgs ~]# echo nameserver 114.114.114.114 > /etc/resolv.conf
```

3.重启网络服务

```shell
[root@hgs ~]# systemctl restart network
```

查看网络状态

```shell
[root@hgs ~]# systemctl status network
```

4.查看本机的IP地址

```shell
[root@hgs ~]# ifconfig
```

不出意外的话，输出的IP地址将与文件`/etc/sysconfig/network-scripts/ifcfg-enp2s0f0`中配置的IP地址一致。

5.测试网络连通性

```shell
ping www.baidu.com
```

如果找不到ping命令：

```shell
bash: ping: command not found
```

则需要安装iputils库

```shell
yum install -y iputils
```

