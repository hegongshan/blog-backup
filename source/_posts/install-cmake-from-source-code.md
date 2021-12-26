---
title: 从源码安装CMake
date: 2021-09-16 14:58:13
tags:
---

本文梳理了从源码安装CMake的流程，回顾了安装过程中遇到的一些问题。

<!--more-->

### 安装过程

1.下载源码

从[CMake仓库](https://github.com/Kitware/CMake/releases )中选择需要的版本，下面以`v3.21.3`为例：

```shell
[root@hgs ~]# wget https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz
```

2.解压

```shell
[root@hgs ~]# tar -zxf cmake-3.21.3.tar.gz
```

3.切换目录，进入解压后的cmake目录

```shell
[root@hgs ~]# cd cmake-3.21.3
```

4.执行引导程序

```shell
[root@hgs cmake-3.21.3]# ./bootstrap
```

执行过程中出现了`Could NOT find OpenSSL`错误：

```shell
Could NOT find OpenSSL, try to set the path to OpenSSL root folder in the system variable OPENSSL_ROOT_DIR (missing: OPENSSL_CRYPTO_LIBRARY OPENSSL_INCLUDE_DIR) 
CMake Error at Utilities/cmcurl/CMakeLists.txt:525 (message):
  Could not find OpenSSL.  Install an OpenSSL development package or
  configure CMake with -DCMAKE_USE_OPENSSL=OFF to build without OpenSSL.
```

解决办法：根据提示信息，安装OpenSSL开发包

```shell
# Ubuntu
apt install -y libssl-dev

# CentOS
yum install -y openssl-devel
```

之后，重新执行引导程序即可。若输出如下结果，则说明执行成功：

```shell
-- Build files have been written to: /root/cmake-3.21.3
---------------------------------------------
CMake has bootstrapped.  Now run make.
```

5.编译和安装

```shell
[root@hgs cmake-3.21.3]# make -j8 && make install
```

6.验证安装是否成功

* 查看cmake所在位置

```shell
[root@hgs cmake-3.21.3]# which cmake
/usr/local/bin/cmake
```

* 查看CMake版本

```shell
[root@hgs cmake-3.21.3]# /usr/local/bin/cmake --version
cmake version 3.21.3

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

7.删除源码

一旦安装完成后，压缩包和解压目录都不再需要，可以删除它们，释放磁盘空间：

```shell
[root@hgs cmake-3.21.3]# cd ..
[root@hgs ~]# rm -rf cmake-3.21.3*
```

### 参考资料

* Installing CMake，https://cmake.org/install/



