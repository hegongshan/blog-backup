---
title: IO测试工具之IO500
date: 2021-12-02 20:26:55
tags:
---

官网为https://io500.org

<!--more-->

https://github.com/IO500/io500

### IO500

IO500由一系列Benchmark和工具组成：

| Benchmarks |           说明           |
| :--------: | :----------------------: |
|   mdtest   | 测试元数据的并行读写性能 |
|    IOR     |  测试数据的并行读写性能  |

https://github.com/hpc/ior

|    工具     |               说明                | 地址                                       |
| :---------: | :-------------------------------: | ------------------------------------------ |
|    pfind    | parallel find，find命令的并行版本 | https://github.com/VI4IO/pfind             |
| shema-tools |                                   | https://github.com/VI4IO/cdcl-schema-tools |

### 下载IO500

```shell
$ wget https://github.com/IO500/io500/archive/refs/tags/io500-scc21.tar.gz
```

解压缩

```shell
$ tar -zxf io500-scc21.tar.gz
$ cd io500-io500-scc21/
```

### 安装准备

```shell
$ ./prepare.sh
```

> 为避免GitHub下载过慢，可以使用镜像网址替换`prepare.sh`中的github.com，比如hub.fastgit.org

```shell
configure: error: MPI compiler requested, but could not use MPI.
```

解决办法：安装OpenMPI

```shell
yum install -y openmpi3 openmpi3-devel
```

<strong style="color:red;">注意：</strong>上述操作会将编译好的openmpi3下载到`/usr/lib64/openmpi3`中。然而，`/usr/lib64`并不在`PATH`中，因此无法直接使用openmpi3。

修改`/etc/profile`或者`${USER}/.bash_profile`，追加如下内容：

```shell
if [ -z "$OPENMPI_ADDED" ]; then
    export PATH=/usr/lib64/openmpi3/bin:$PATH
    export OPENMPI_ADDED=yes
fi
```

### 运行IO500

```shell
$ mpiexec -np 2 ./io500 config-minimal.ini
```

