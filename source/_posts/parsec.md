---
title: PARSEC-3.0的编译和运行
date: 2021-09-10 21:35:18
tags: operating system
categories: operating system
---

PARSEC，全称**P**rinceton **A**pplication **R**epository for **S**hared-M**e**mory **C**omputers，官网为[https://parsec.cs.princeton.edu](https://parsec.cs.princeton.edu)。

<!--more-->

1.下载PARSEC

```shell
[root@hgs ~]# wget http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-core.tar.gz
```

2.解压

```shell
[root@hgs ~]# tar -zxf parsec-3.0-core.tar.gz
[root@hgs ~]# cd parsec-3.0
```

3.设置环境变量

```shell
[root@hgs ~]# source env.sh
```

4.编译

```shell
[root@hgs ~]# parsecmgmt -a build -p all
```

编译过程中，可能会出现如下问题：

* 问题1

```shell
POD document had syntax errors at /usr/bin/pod2man line 68.
make: *** [install_docs] Error 255
Makefile:680: recipe for target 'install_docs' failed
[PARSEC] Error: 'env PATH=/usr/bin:/root/parsec-3.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/parsec-3.0/bin /usr/bin/make install' failed.
```

解决办法：删除`/usr/bin/pod2man`

```shell
rm -f /usr/bin/pod2man
```

* 问题2

```shell
*** You must have either have gettext support in your C library, or use the
*** GNU gettext library. (http://www.gnu.org/software/gettext/gettext.html
```

解决办法：安装gettext

```shell
# Ubuntu
apt install -y gettext

# CentOS
yum install -y gettext
```

* 问题3

```shell
configure: error: X11 development libraries needed for xlib driver
[PARSEC] Error: 'env ./configure --with-driver=xlib --enable-glut --enable-static --disable-shared --prefix=/root/parsec-3.0/pkgs/libs/mesa/inst/amd64-linux.gcc' failed.
```

解决办法：安装X11开发库

```shell
# Ubuntu
apt install -y libx11-dev

# CentOS
yum install -y libX11-devel.x86_64
```

* 问题4

```shell
No package 'xext' found
```

解决办法：

```shell
# Ubuntu
apt install -y libxext-dev

# CentOS
yum install -y libXext-devel.x86_64
```

* 问题5

```shell
No package 'xt' found
```

解决办法：

```shell
# Ubuntu
apt install -y libxt-dev

# CentOS
yum install -y libXt-devel.x86_64
```

* 问题6

```shell
No package 'xmu' found
No package 'xi' found
```

解决办法：

```shell
# Ubuntu
apt install -y libxmu-dev libxi-dev

# CentOS
yum install -y libXmu-devel.x86_64 libXi-devel.x86_64
```

* 问题7

```shell
/usr/include/wchar.h:94:3: 错误：与‘__mbstate_t’类型冲突
 } __mbstate_t;
```

解决办法：注释掉\_\_mbstate_t的定义。

首先，编辑文件`pkgs/libs/uptcpip/src/include/sys/bsd__types.h`：

```shell
vim pkgs/libs/uptcpip/src/include/sys/bsd__types.h
```

然后，注释掉第102~105行：

```c
//typedef union {
//        char            __mbstate8[128];
//        __int64_t       _mbstateL;      /* for alignment */
//} __mbstate_t;
```

* 问题8

```shell
[PARSEC] Error: 'env version=tbb /usr/bin/make' failed.
```

解决办法：安装tbb

```shell
apt install -y libtbb2 tbb-examples
```

如果最后输出`Done`，则说明编译成功

```shell
[PARSEC]
[PARSEC] BIBLIOGRAPHY
[PARSEC]
[PARSEC] [1] Bienia. Benchmarking Modern Multiprocessors. Ph.D. Thesis, 2011.
[PARSEC] [2] Woo et al. The SPLASH-2 Programs: Characterization and Methodological Considerations. ISCA, 1995.
[PARSEC]
[PARSEC] Done.
```

5.运行

```shell
[root@hgs ~]# parsecmgmt -a run -p all
```

### 参考资料

1.https://parsec.cs.princeton.edu/parsec3-doc.htm

2.https://blog.csdn.net/ai297313/article/details/46731131

3.https://www.cnblogs.com/aaron2015/p/5132825.html
