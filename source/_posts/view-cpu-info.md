---
title: 如何查看电脑中CPU的详细信息？
date: 2021-04-05 18:56:24
tags: cpu
categories: cpu
---

在学位论文的写作过程中，通常会对实验的软硬件环境进行详细的描述，而CPU信息是一个非常重要的参数。那么，如何查看电脑中的CPU描述信息呢？

<!--more-->

### 手动查看逻辑CPU个数

在实验中，我使用一台个人电脑MacBook Pro和多台Linux服务器。

* 对于Linux来说，CPU的描述信息均存放在文件`/proc/cpuinfo`中

1.如何直接查看CPU的型号呢？

```shell
[root@hgs ~]# cat /proc/cpuinfo | grep "model name" | uniq
model name	: Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz
```

2.如何直接查看物理CPU的个数呢？
```shell
[root@hgs ~]# cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
2
```

3.如何直接查看每个物理CPU的核数呢？

```shell
[root@hgs ~]# cat /proc/cpuinfo | grep "cpu cores" | uniq
cpu cores	: 14
```

4.如何直接查看每个物理CPU中逻辑CPU的个数呢？

```shell
[root@hgs ~]# cat /proc/cpuinfo | grep "siblings" | uniq
siblings	: 28
```

5.如何直接查看计算机中逻辑CPU的总数呢？

```shell
[root@hgs ~]# cat /proc/cpuinfo | grep "processor" | wc -l
56
```

**逻辑CPU的数量 = 物理CPU的数量 * 每个物理CPU中逻辑CPU的数量**

* 对于macOS来说，可以使用下面的命令：

```shell
# 该命令会输出关于CPU的全部信息
sysctl machdep.cpu
```

1.如果只想查看CPU的型号，可以使用如下的方式：

```shell
hgs:~ hegongshan$ sysctl machdep.cpu.brand_string
machdep.cpu.brand_string: Intel(R) Core(TM) i5-7360U CPU @ 2.30GHz
```

2.如果只想查看每个物理CPU的核数：

```shell
hgs:~ hegongshan$ sysctl machdep.cpu.core_count
machdep.cpu.core_count: 2
hgs:~ hegongshan$ sysctl hw.physicalcpu
hw.physicalcpu: 2
```

3.查看计算机中逻辑CPU的总数

```shell
hgs:~ hegongshan$ sysctl machdep.cpu.thread_count
machdep.cpu.thread_count: 4
hgs:~ hegongshan$ sysctl hw.logicalcpu
hw.logicalcpu: 4
```

4.查看CPU个数

```shell
hgs:~ hegongshan$ system_profiler SPHardwareDataType | grep "Number of Processors"
      Number of Processors: 1
```

### 使用编程语言查看逻辑CPU个数

* C：使用unistd.h中的sysconf函数

```c
// 定义在unistd.h中
long sysconf(int name)
```

代码如下：

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    printf("%ld\n", sysconf(_SC_NPROCESSORS_CONF));
    return 0;
}
```

* Java

```shell
jshell> Runtime.getRuntime().availableProcessors();
$1 ==> 4

jshell> 
```

* Python

```python
>>> import os
>>> os.cpu_count()
4
>>> 
```

