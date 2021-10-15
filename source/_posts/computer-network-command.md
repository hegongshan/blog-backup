---
title: 计算机网络常用命令
date: 2020-08-15 20:03:16
tags: computer network
categories: computer network
---

在看过《计算机是怎样跑起来的》关于网络的一章后，我发现自己对网络相关的常用命令似乎还不太了解。

<!--more-->

### 检测网络连通性

#### ping

ping，全称为**p**acket **in**ternet **g**roper。

功能：发送一条消息，主要用于测试网络是否连通。

```shell
hgs:~ hegongshan$ ping www.baidu.com
PING www.a.shifen.com (182.61.200.7): 56 data bytes
64 bytes from 182.61.200.7: icmp_seq=0 ttl=52 time=31.000 ms
64 bytes from 182.61.200.7: icmp_seq=1 ttl=52 time=32.655 ms
64 bytes from 182.61.200.7: icmp_seq=2 ttl=52 time=30.705 ms
64 bytes from 182.61.200.7: icmp_seq=3 ttl=52 time=44.550 ms
64 bytes from 182.61.200.7: icmp_seq=4 ttl=52 time=30.965 ms
64 bytes from 182.61.200.7: icmp_seq=5 ttl=52 time=30.944 ms
^C
--- www.a.shifen.com ping statistics ---
6 packets transmitted, 6 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 30.705/33.470/44.550/4.997 ms
```

其中，icmp_seq表示序列号，ttl（Time To Live）表示icmp包的转发次数，time表示往返时间。

注意，本机向www.baidu.com发送了56字节的数据，返回的数据大小为发送数据大小加8，即64字节。

#### telnet

telnet本是一种远程登录协议，由于安全性问题，已被ssh取代。现在常用来测试远程主机的端口号是否可用。

* 测试百度的80端口：

```shell
hgs:~ hegongshan$ telnet www.baidu.com 80
Trying 182.61.200.7...
Connected to www.a.shifen.com.
Escape character is '^]'.
^]
telnet> quit
Connection closed.
```

首先按下`CTRL+]`进入命令模式，然后输入`quit`即可退出。

### ipconfig/ifconfig

功能：查看本机的IP（Internet Protocol）地址和MAC（Media Access Control）地址

* Windows使用ipconfig
* Linux/macOS使用ifconfig（全称**i**nter**f**ace **config**）

以maOS为例：

```shell
hgs:~ hegongshan$ ifconfig | grep "inet" | grep -v "inet6\|127.0.0.1"
	inet 192.168.31.8 netmask 0xffffff00 broadcast 192.168.31.255
```

IP地址为`192.168.31.8`。

### 域名解析

#### nslookup

nslookup，全称**n**ame **s**erver **lookup**。

功能：域名解析

* 查询域名对应的IP地址

```shell
hgs:~ hegongshan$ nslookup www.baidu.com
Server:		192.168.31.1
Address:	192.168.31.1#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 182.61.200.6
Name:	www.a.shifen.com
Address: 182.61.200.7
```

上述结果表明：百度的主页同时部署在两台服务器上，IP地址分别为`182.61.200.6`和`182.61.200.7`。

<div style="clear:both"><img src="/static/images/computer-network-nslookup-baidu1.png" width="50%" height="200" style="float:left"/><img src="/static/images/computer-network-nslookup-baidu2.png" width="50%" height="200" style="float:left"/></div>
* 输入nslookup可以进入交互模式（注意下方的`>`符号）

```shell
hgs:~ hegongshan$ nslookup
> www.baidu.com
Server:		192.168.31.1
Address:	192.168.31.1#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 182.61.200.7
Name:	www.a.shifen.com
Address: 182.61.200.6
> exit
hgs:~ hegongshan$ 
```

输入exit命令，可以退出交互模式。

#### host

```shell
hgs:~ hegongshan$ host www.baidu.com
www.baidu.com is an alias for www.a.shifen.com.
www.a.shifen.com has address 182.61.200.7
www.a.shifen.com has address 182.61.200.6
hgs:~ hegongshan$ 
```

### arp

arp，全称为地址解析协议（Address Resolution Protocol，ARP），用于将IP地址转化为对应的MAC地址。

* 显示所有的项

```shell
arp -a
```

### 路由信息

#### route

路由表

#### traceroute/tracert

功能：查看路由路径。

* Windows使用tracert
* Linux/macOS使用traceroute

