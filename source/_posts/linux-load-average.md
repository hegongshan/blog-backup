---
title: 查看系统的平均负载
date: 2021-12-20 22:21:51
tags: operation
categories: operation
---

如何查看系统的运行时间和平均负载

<!--more-->

### uptime

显示系统的运行时间

> The current time, how long the system has been running,  how  many  users  are currently logged on, and the system load averages for the past 1, 5, and 15 minutes.

![uptime](/static/images/linux-uptime.png)

> System load averages is the average number of processes that are either in a runnable or uninterruptable state.

### /proc/loadavg

```shell
[root@hgs ~]# cat /proc/loadavg
0.05 0.05 0.00 1/531 18313
```

前三项表示1、5、15分钟内系统的平均负载（进程数）；

第四项的分子表示正在运行的进程数，分母表示进程总数；

第五项表示最近运行的进程ID。
