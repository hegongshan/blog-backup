---
title: 在Linux存活下来之通过taskset设置CPU亲密度
date: 2021-09-23 11:41:45
tags: linux
categories: linux
---

taskset让进程在特定的CPU中运行。

<!--more-->

retrieve or set a process's CPU affinity

```shell
用法：taskset [选项] [掩码 | cpu列表] [pid|命令 [参数...]]
```

### 查询进程的CPU掩码

```shell
[root@node14 ~]# ./test.sh &
[1] 12787
[root@node14 ~]# taskset -p 12787
pid 12787's current affinity mask: ffffffffffffff
```

14个f，表示有14 x 4 = 56个处理器。

### 设置进程的CPU掩码

```shell
[root@node14 ~]# taskset -p 3 12787
pid 12787's current affinity mask: ffffffffffffff
pid 12787's new affinity mask: 3
[root@node14 ~]# taskset -pc 12787
pid 12787's current affinity list: 0,1
```



```shell
[root@node14 ~]# taskset -pc 0,3,7-11 12787
pid 12787's current affinity list: 0,1
pid 12787's new affinity list: 0,3,7-11
[root@node14 ~]# taskset -p 12787
pid 12787's current affinity mask: f89
```



```shell
0xf89 = 0b1111 1000 1001
```

