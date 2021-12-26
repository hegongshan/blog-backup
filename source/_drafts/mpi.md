---
title: openmpi
date: 2021-12-02 21:35:26
tags:
---



MPI（Message Passing Interface）

https://www.open-mpi.org

### 安装OpenMPI

#### yum

```shell
yum install -y openmpi3
```



#### 源码安装

1.下载

```shell
$ wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz
```

2.解压缩

```shell
$ tar -zxf openmpi-4.1.2.tar.gz 
```

3.切换目录

```shell
$ cd openmpi-4.1.2
```

4.查看安装指南

```shell
$ less INSTALL
```

5.

```shell
./configure --prefix=/where/to/install
```

### 参考资料

1.Open MPI安装使用，http://hmli.ustc.edu.cn/doc/mpi/openmpi-install.htm

2.[CS 365](https://ycpcs.github.io/cs365-spring2019/): Setting up OpenMPI，https://ycpcs.github.io/cs365-spring2019/openmpiSetup.html
