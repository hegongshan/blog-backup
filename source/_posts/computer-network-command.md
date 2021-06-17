---
title: 网络常用命令
date: 2020-08-15 20:03:16
tags: computer network
categories: computer network
---

在看过《计算机是怎样跑起来的》关于网络的一章后，我发现自己对网络相关的常用命令似乎还不太了解。

<!--more-->

### ping

发送一条消息，主要用于测试网络是否连通。

> ping www.baidu.com

### ipconfig/ifconfig

查看本机的IP地址和MAC地址

* Windows使用ipconfig
* Linux/Mac使用ifconfig

注：Mac中既有ipconfig，又有ifconfig。

### nslookup

域名解析

* 查询域名对应的IP

```shell
nslookup www.baidu.com
```

* 输入nslookup可以进入交互模式

```shell
hgs:~ hegongshan$ nslookup
> 
```

输入exit，可以退出交互模式。

### arp

地址解析协议（Address Resolution Protocol，ARP）

### route

路由表

### telnet

远程登录

* 测试远程主机端口是否可用

```shell
telnet 127.0.0.1 3306
```

