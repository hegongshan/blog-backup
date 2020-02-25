---
title: 在Linux中存活下来之进程管理
date: 2020-02-25 15:40:10
tags: linux
categories: linux
---

在Linux中，涉及进程管理的常用命令有ps、top和kill等。

<!--more-->

### ps

全称process status，用于显示当前时刻进程的状态。

常用选项：

* -e：列出所有进程。
* -f：按照完整格式显示进程信息。

示例：

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

常用选项：

* -d：设置更新周期

示例：

```shell
# 每2秒更新一次
top -d 2
```

### kill

顾名思义，用于终止进程。

常用选项：

* -l [signal]：list，打印信号名称列表，或者将给定的信号值（名称）转换为对应的名称（值）。

示例：

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

### netstat

全称network status。

示例：

查看占用端口的进程

```shell
netstat -anp | grep port
```

### lsof

全称list open files。

示例：

查看占用端口的进程

```shell
lsof -i :port
```

