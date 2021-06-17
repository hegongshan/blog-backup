---
title: 如何查看电脑中CPU的详细信息？
date: 2021-04-05 18:56:24
tags: cpu
categories: cpu
---

在学位论文的写作过程中，通常会对实验的软硬件环境进行详细的描述，而CPU型号是一个非常重要的参数。那么，如何查看电脑中的CPU描述信息呢？

<!--more-->

在实验中，我使用一台个人电脑MacBook Pro和多台Linux服务器。

* 对于Linux来说，可以使用如下的方式查看CPU信息：

```shell
cat /proc/cpuinfo
```

* 对于MacOS来说，可以使用下面的命令：

```shell
# 该命令会输出关于CPU的全部信息
sysctl machdep.cpu
```

如果只想查看CPU的型号，可以使用如下的方式：

```shell
sysctl machdep.cpu.brand_string
```

