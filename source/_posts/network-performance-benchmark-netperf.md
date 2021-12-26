---
title: 网络性能Benchmark——Netperf
date: 2021-12-20 15:43:14
tags: computer network
categories: computer network
mathjax: true
---

Netperf是惠普公司开发的一个网络性能Benchmark。

Currently, its focus is on bulk data transfer and request/response performance using either TCP or UDP, and the Berkeley Sockets interface.

> Netperf is a benchmark that can be used to measure the performance of many different types of networking. It provides tests for both unidirectional throughput, and end-to-end latency.

<!--more-->

### 安装Netperf

https://github.com/HewlettPackard/netperf

1.下载需要的版本Netperf，以当前的最新版`2.7.0`为例：

```shell
wget https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-2.7.0.zip
```

2.解压缩

```shell
unzip netperf-2.7.0.zip
```

3.进入源码目录

```shell
cd netperf-netperf-2.7.0/
```

4.执行配置程序

```shell
./configure 
```

5.编译和安装

```shell
make -j5 && make install
```

6.查看版本

```shell
[root@hgs netperf-netperf-2.7.0]# netperf -V
Netperf version 2.7.0
```

### 使用Netperf

netperf的命令行选项分为两大类：全局命令行选项和测试相关选项，两者之间使用`--`分割。

```shell
netperf <global> -- <test-specific>
```

全局命令行选项：

* `-H name|ip,family (*)`：指定服务端地址
* `-l testlen`：指定测试的持续时间，默认为10秒。＜0则表示字节数，或者请求/响应的事务数。
* `-t testname`：指定测试的类型，默认为`TCP_STREAM`。
* `-P 0|1`：是否显示测试Banner。1表示显示，0表示不显示。

```shell
MIGRATED TCP STREAM TEST from (null) (::) port 0 AF_INET6 to localhost (::1) port 0 AF_INET6
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

```

* `-f G|M|K|g|m|k|x`：指定输出的单位。例如，G表示2^30bytes/s，g表示10^9bits/s

测试相关选项：

* `-m`：指定每次发送的消息大小

### 应用实例

#### 批量数据传输

1.启动服务端

```shell
[root@hgs1 netperf-netperf-2.7.0]# netserver
Starting netserver with host 'IN(6)ADDR_ANY' port '12865' and family AF_UNSPEC
```

2.启动客户端

```shell
[root@hgs2 netperf-netperf-2.7.0]# netperf -H 192.168.0.28
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.28 () port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.00    9368.98 
```

​	1.服务端使用的socket接收缓冲区大小为87380字节

​	2.客户端使用的socket发送缓冲区大小为16384字节

​	3.一次发送的测试消息大小为16384字节

​	4.测试的持续时间为10秒

​	5.网络吞吐率为$9368.98Mbps\approx 1.09GB/s$

### 参考资料

1.http://www.netperf.org
