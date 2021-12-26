---
title: 网络带宽测试工具——iperf
date: 2021-12-19 15:45:55
tags: network
categories: network
---

本文介绍了网络带宽测试工具iperf的安装和使用。

<!--more-->

iperf是一个网络带宽测试工具，可以用于测试TCP、UDP以及SCTP的网络带宽。

### 安装iperf3

#### 使用包管理器

```shell
# Ubuntu
apt install -y iperf3

# CentOS
yum install -y iperf3
```

包管理器的优点在于安装简单，但软件包的版本通常不是最新的版本。

#### 源码安装

下面👇使用源码安装iperf3：

1.下载iperf3

从[官网](https://downloads.es.net/pub/iperf/)中选择需要的版本，这里以`v3.10.1`为例：

```shell
wget https://downloads.es.net/pub/iperf/iperf-3.10.1.tar.gz
```

2.解压缩

```shell
tar -zxf iperf-3.10.1.tar.gz
```

3.进入源码目录

```shell
cd iperf-3.10.1
```

4.执行配置程序

```shell
./configure
```

若出现如下的错误：

```shell
configure: error: no acceptable C compiler found in $PATH
```

则表明没有安装C语言编译器。此时，需要安装任意一种C语言编译器，如GCC：

```shell
yum install -y gcc
```

5.编译

```shell
make -j5
```

6.安装

```shell
make install
```

7.查看版本

```shell
# iperf3 --version
iperf3 -v
```

![查看版本](/static/images/iperf-version.png)

### 测试网络带宽

在使用iperf3执行网络带宽测试前，需要确保客户端和服务器端都已经安装了iperf3。

1.启动服务器端

```shell
# 在前台运行
iperf3 --server
iperf3 -s
```

![启动服务器端](/static/images/iperf-server.png)

默认情况下，服务器端会在前台执行。可以使用`-D`或`--daemon`让服务器端在后台运行：

```shell
iperf3 -s -D
```

默认情况下，服务器端监听的是TCP的5201端口。可以使用`-p`手动设置监听端口：

```shell
iperf3 -s -D -p 5002
```

2.启动客户端

```shell
iperf3 -c <host>
```

其中，`<host>`表示服务器端的地址

下面使用本机作为服务器端（客户端和服务器端在一台机器上）：

![启动客户端](/static/images/iperf-client.png)

其中，Retr表示`Retransmission`，Cwnd表示`Congestion Window`（拥塞窗口）。

若出现如下错误：

```shell
iperf3: error - unable to connect to server: No route to host
```

则需要关闭服务器端的防火墙：

```shell
systemctl stop firewalld
```

* 测试持续时间

默认情况下，只会运行10秒。可以使用`-t`设置持续时间（秒）：

```shell
# 持续60秒
iperf3 -c <host> -t 60
```

* 指定连接端口

如果服务器端监听的不是默认端口，则客户端必须指定连接端口：

```shell
iperf3 -c <host> -p 5002
```

* 指定日志文件：默认情况下，统计结果直接输出在终端中。可以使用`--logfile`指定存储输出结果的日志文件。

```shell
iperf3 -c <host> -t 60 --logfile result.txt
```

* 指定输出的单位：`-f `或者`--format [kmgtKMGT]`

```shell
# 大写字母表示使用字节为单位输出结果，小写字母表示使用比特为单位，如G表示GBytes，g表示Gbits
iperf3 -c <host> -t 60 -f G --logfile result.txt
```

* 指定其他数据传输模式：默认情况下，数据传输采用普通模式，即从客户端上传到服务器端。

使用`-R`或者`--reverse`指定以反向模式运行，即从服务器端下载到客户端；

使用`--bidir`指定以双向模式运行，即从客户端上传数据到服务器端，同时从服务器端下载数据到客户端。

在输出结果的Role列中，RX表示Receive，TX表示Transmit，-C表示Client，-S表示Server。

```shell
iperf3 -c <host> -t 60 -f G --bidir --logfile result.txt
```

* 输出JSON格式

```shell
iperf3 -c <host> -t 60 -J > result.json
```

### 参考资料

1.iperf3主页：https://software.es.net/iperf/

2.源码仓库：https://github.com/esnet/iperf

3.http://ce.sc.edu/cyberinfra/workshops/Material/NTP/Lab%202.pdf

4.what "Retr" field mean，https://github.com/esnet/iperf/issues/343
