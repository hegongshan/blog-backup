---
title: 端口扫描工具nmap
date: 2021-11-06 20:01:08
tags: information security
categories: information security
---

nmap，**n**etwork **map**per

<!--more-->

```shell
# Ubuntu
sudo apt install -y nmap
```

### 主机发现（Host Discovery）

-sL：

-sn：禁用端口扫描

```shell
hegongshan@hgs:~/Desktop$ nmap -sn 180.101.49.11 180.101.49.12
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-23 23:21 CST
Nmap scan report for 180.101.49.11
Host is up (0.056s latency).
Nmap scan report for 180.101.49.12
Host is up (0.056s latency).
Nmap done: 2 IP addresses (2 hosts up) scanned in 0.14 seconds
```

### 端口扫描（Port Scan）

默认扫描最常用的1000个端口：

```shell
hegongshan@hgs:~/Desktop$ nmap www.github.com
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-23 22:51 CST
Nmap scan report for www.github.com (20.205.243.166)
Host is up (0.12s latency).
Not shown: 995 filtered ports
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
80/tcp   open  http
443/tcp  open  https
9418/tcp open  git

Nmap done: 1 IP address (1 host up) scanned in 23.84 seconds
```

#### 基础概念

interesting ports table：包含端口号、使用的协议、端口状态以及监听该端口的服务名称。

其中，端口共有以下六种状态：

1.`open`：有应用在监听该端口

2.`filtered`：存在防火墙、过滤器或者其他的网络障碍，导致nmap无法确定端口是否处于open状态。

3.`closed`：没有应用在监听该端口

4.`unfiltered`：端口可以访问，但是无法确定是处于open状态，还是closed状态。

5.`open|filtered`：无法确定端口是处于open状态，还是filtered状态

6.`closed|filtered`：无法确定端口是处于closed状态，还是filtered状态

#### 扫描指定端口

```shell
-p [<port>|<range>]
```

* 扫描某个端口

```shell
hegongshan@hgs:~/Desktop$ nmap -p 80 www.github.com
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-23 23:36 CST
Nmap scan report for www.github.com (20.205.243.166)
Host is up (0.65s latency).

PORT   STATE SERVICE
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 1.49 seconds
```

* 扫描某个端口范围

```shell
hegongshan@hgs:~/Desktop$ nmap -p 1-80 www.github.com
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-23 23:38 CST
Nmap scan report for www.github.com (20.205.243.166)
Host is up (0.13s latency).
Not shown: 77 filtered ports
PORT   STATE SERVICE
21/tcp open  ftp
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 4.25 seconds
```

### 版本检测（Version Detection）

`-sV`：检测监听指定端口的服务版本信息：

```shell
nmap -sV www.github.com
```

### 操作系统检测（OS Detection）

-O：检测远程操作系统的类型和版本

### 拾遗补缺

* -A：默认情况，不会进行版本检测和操作系统检测。

```shell
nmap -A
```

* --traceroute

```shell
hegongshan@hgs:~/Desktop$ nmap --traceroute wwww.github.com
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-23 23:52 CST
Traceroute has to be run as root
QUITTING!
```



```shell
hegongshan@hgs:~/Desktop$ sudo nmap --traceroute wwww.github.com
[sudo] password for hegongshan: 
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-23 23:52 CST
Nmap scan report for wwww.github.com (185.199.111.153)
Host is up (0.0095s latency).
Other addresses for wwww.github.com (not scanned): 185.199.108.153 185.199.109.153 185.199.110.153 2606:50c0:8001::153 2606:50c0:8000::153 2606:50c0:8002::153 2606:50c0:8003::153
rDNS record for 185.199.111.153: cdn-185-199-111-153.github.com
Not shown: 997 filtered ports
PORT    STATE SERVICE
21/tcp  open  ftp
80/tcp  open  http
443/tcp open  https

TRACEROUTE (using port 80/tcp)
HOP RTT     ADDRESS
1   2.02 ms _gateway (10.0.2.2)
2   2.05 ms cdn-185-199-111-153.github.com (185.199.111.153)

Nmap done: 1 IP address (1 host up) scanned in 25.65 seconds
```

RTT：Round-Trip Time，往返时间
