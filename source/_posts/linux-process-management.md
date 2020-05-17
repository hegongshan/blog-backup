---
title: 在Linux中存活下来之进程管理
date: 2020-02-25 15:40:10
tags: linux
categories: linux
---

在Linux中，涉及进程管理的常用命令有ps、top和kill等。

<!--more-->

### ps

全称**p**rocess **s**tatus，用于显示当前时刻进程的状态。

**常用选项：**

* -e：列出所有进程。
* -f：按照完整格式显示进程信息。

**示例：**

1.查看系统所有进程

```shell
ps -ef 或者 ps aux
```

2.查看特定的进程

```shell
ps -ef | grep 进程名
```

### top

用于实时显示进程的状态。

**常用选项：**

* -d：设置更新周期

**输出结果：**

1. VIRT：Virtual Memory Size (KiB)，表示进程使用的虚拟内存的总量。VIRT = SWAP + RES
2. RES：Resident Memory Size (KiB)，表示进程正在使用的非交换物理内存。RES = CODE + DATA
3. SHR：Shared Memory Size (KiB)，表示与其他进程共享的内存。
4. SWAP：Swapped Size (KiB)
5. CODE：Code Size (KiB)，也叫作Text Resident Set size（TRS），表示可执行代码使用的物理内存总量。
6. DATA：Data + Stack Size (KiB)，也叫作Data Resident Set size（DRS），表示除可执行代码外，进程使用的物理内存总量。
7. %CPU：CPU Usage，CPU使用率。
8. %MEM：Memory Usage (RES)，进程使用的物理内存百分比。

**示例：**

```shell
# 每2秒更新一次
top -d 2
```

### kill

顾名思义，用于终止进程。

**常用选项：**

* -l [signal]：list，打印信号名称列表，或者将给定的信号值（名称）转换为对应的名称（值）。

**示例：**

1.查看信号值9对应的名称

```shell
# KILL
kill -l 9
```

2.强迫进程立即终止

```shell
# kill -KILL PID
kill -9 PID
```

### nohup

全称**no** **h**ang**up**，运行命令时忽略挂起信号SIGHUP(1)——关闭终端时触发。

**示例：**

1.让进程在后台运行

```shell
# &表示忽略SIGINT(2)——使用Ctrl+C时触发
nohup python3 test.py &
```

### netstat

全称**net**work **stat**us。

**常用选项：**

* -t或者`--tcp`：显示TCP
* -u或者`--udp`：显示UDP
* -n或者`--numeric`：以数字的形式表示主机名、端口号和用户名。例如：将localhost:mysql变为127.0.0.1:3306
* -l或者`--listening`：只显示正处于监听下的套接字。
* -a或者`--all`：显示listening和non-listening（对于TCP来说，表示已经建立连接）
* -p或者`--program`：显示每个套接字所在的PID和程序名称。

**示例：**

1.查看占用端口的进程

```shell
netstat -anp | grep port
```

### lsof

全称list open files。

**示例：**

1.查看占用端口的进程

```shell
lsof -i :port
```

