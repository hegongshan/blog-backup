---
title: SPEC CPU2006的编译和运行
date: 2021-09-10 21:35:33
tags: computer system
categories: computer system
---

SPEC，全称**S**tandard **P**erformance **E**valuation **C**orporation。官网为https://www.spec.org

<!--more-->

### 前期准备

#### 安装编译器

* 安装本地编译器gcc-4.9、g++-4.9以及gfortran-4.9

```shell
# 逗号左右不能有空格
apt install -y {gcc,g++,gfortran}-4.9
```

查看gcc的安装位置：

```shell
[root@hgs ~]# which {gcc,g++,gfortran}-4.9
/usr/bin/gcc-4.9
/usr/bin/g++-4.9
/usr/bin/gfortran-4.9
```

也可以使用源码安装，具体参看[通过源码安装GCC](/2021/09/15/linux-install-specified-version-of-gcc/)。

* 安装交叉编译工具

```shell
apt install -y {gcc,g++,gfortran}-4.9-aarch64-linux-gnu
```

查看安装位置：

```shell
[root@hgs ~]# which aarch64-linux-gnu-{gcc,g++,gfortran}-4.9
/usr/bin/aarch64-linux-gnu-gcc-4.9
/usr/bin/aarch64-linux-gnu-g++-4.9
/usr/bin/aarch64-linux-gnu-gfortran-4.9
```

注意安装时和使用时的区别：安装时gcc在库名的开头，使用时gcc在命令的结尾。

#### SPEC CPU2006环境

1.下载SPEC CPU2006（目前，SPEC CPU2006需要付费下载）

2.解压

```shell
[root@hgs ~]# mkdir spec2006
[root@hgs ~]# tar -jxf cpu2006.tar.bz2 -C spec2006
[root@hgs ~]# cd spec2006
```

3.执行安装脚本

```shell
[root@hgs spec2006]# ./install.sh

SPEC CPU2006 Installation

Top of the CPU2006 tree is '/home/spec2006'

These appear to be valid toolsets:

linux-suse101-i386            For 32-bit i386 Linux systems.
tail: cannot open '+2' for reading: No such file or directory
==> /home/spec2006/tools/bin/linux-suse101-i386/description <==
For 32-bit i386 Linux systems.
                              Built on SuSE Linux 10.1 with 
                              gcc V4.1.0 (SUSE Linux)

linux-suse101-AMD64           For 64-bit AMD64 Linux systems.
tail: cannot open '+2' for reading: No such file or directory
==> /home/spec2006/tools/bin/linux-suse101-AMD64/description <==
For 64-bit AMD64 Linux systems.
                              Built on SuSE Linux 10.1 with 
                              gcc V4.1.0 (SUSE Linux)
                              Should also be usable on 64 bit EM64T systems

linux-redhat62-ia32           For x86-based Linux systems with GLIBC 2.1.3+
tail: cannot open '+2' for reading: No such file or directory
==> /home/spec2006/tools/bin/linux-redhat62-ia32/description <==
For x86-based Linux systems with GLIBC 2.1.3+
                              Built on RedHat 6.2 with gcc 2.95.3


Enter the architecture you are using:
```

这里输入`linux-suse101-i386`：

```shell
linux-suse101-i386


Checking the integrity of your source tree...


Checksums are all okay.
Removing previous tools installation
Unpacking binary tools for linux-suse101-i386...
Checking the integrity of your binary tools...

Checksums are all okay.
Top of SPEC benchmark tree is '/home/spec2006'
Everything looks okay.  cd to /home/spec2006,
source the shrc file and have at it!
```

修改配置文件

```shell
[root@hgs spec2006]# cd config/
[root@hgs config]# cp linux32-i386-gcc42.cfg qemurio-x86.cfg
```

4.设置环境变量

```shell
[root@hgs spec2006]# source shrc
```

之后，就可以使用SPEC提供的各种工具了，比如runspec等。

### Integer Benchmark

整数测试

#### 本地编译

```shell
[root@hgs spec2006]# runspec -a build -c qemurio-x86.cfg -i ref --tuning=base int
```

运行结果：

```shell
Build errors: 483.xalancbmk(base)
Build successes: 400.perlbench(base), 401.bzip2(base), 403.gcc(base), 429.mcf(base), 445.gobmk(base), 456.hmmer(base), 458.sjeng(base), 462.libquantum(base), 464.h264ref(base), 471.omnetpp(base), 473.astar(base), 999.specrand(base)
```

查看错误信息：

```shell
FormatterToHTML.cpp:139:42: error: 'memset' was not declared in this scope
  memset(m_charsMap, 0, sizeof(m_charsMap));
                                          ^
specmake: *** [FormatterToHTML.o] Error 1
Error with make 'specmake build': check file '/home/spec2006/benchspec/CPU2006/483.xalancbmk/run/build_base_qemurio.0000/make.err'
  Error with make!
*** Error building 483.xalancbmk
```

原因分析：`FormatterToHTML.cpp`使用了`string.h`中的memset函数，但是在编译时找不到“memset”。因此，需要在g++中添加编译参数`-include cstring`。

```shell
CC           = /usr/bin/gcc-4.9
CXX          = /usr/bin/g++-4.9 -include cstring
```

运行

```shell
[root@hgs spec2006]# runspec -a run -c qemurio-x86.cfg -i ref --tuning=base int
```

#### 使用ARM64交叉编译

修改配置文件中的编译器CC

```shell
CC           = /usr/bin/aarch64-linux-gnu-gcc-4.9
```

### Floating Point Benchmark

浮点数测试

#### 本地编译和运行

##### 编译

```shell
[root@hgs spec2006]# runspec -a build -c qemurio-x86.cfg -i ref --tuning=base fp
```

输出结果：

```shell
Build errors: 410.bwaves(base), 416.gamess(base), 434.zeusmp(base), 435.gromacs(base), 436.cactusADM(base), 437.leslie3d(base), 447.dealII(base), 454.calculix(base), 459.GemsFDTD(base), 465.tonto(base), 481.wrf(base)
Build successes: 433.milc(base), 444.namd(base), 450.soplex(base), 453.povray(base), 470.lbm(base), 482.sphinx3(base), 998.specrand(base)
```

错误分析：

* 410、416、434、435、436、437、454的问题为

```shell
specmake: /usr/local/gcc42-0715-32/bin/gfortran: Command not found
```

解决办法：安装gfortran

```shell
[root@hgs spec2006]# apt install -y gfortran-4.9
[root@hgs spec2006]# which gfortran-4.9
/usr/bin/gfortran-4.9
```

并修改配置文件中的FC值：

```shell
# FC           = /usr/local/gcc42-0715-32/bin/gfortran
FC           = /usr/bin/gfortran-4.9
```

* 447的问题比较多

1.`xx does not name a type`

```shell
include/lac/block_vector.h:227:17: error: 'ptrdiff_t' does not name a type
include/lac/block_vector.h:333:38: error: 'difference_type' does not name a type
include/lac/block_vector.h:1727:5: error: prototype for 'typename internal::BlockVectorIterators::Iterator<number, constness>::difference_type internal::BlockVectorIterators::Iterator<number, constness>::operator-(const internal::BlockVectorIterators::Iterator<number, constness>&) const' does not match any in class 'internal::BlockVectorIterators::Iterator<number, constness>'
     Iterator<number,constness>::
     ^
include/lac/block_vector.h:489:18: error: candidate is: internal::BlockVectorIterators::Iterator<number, constness> internal::BlockVectorIterators::Iterator<number, constness>::operator-(const int&) const
         Iterator operator - (const difference_type &d) const;
                  ^
```

解决办法：添加编译参数`-include cstddef`

```shell
CXX          = /usr/local/bin/g++ -include cstddef
```

2.`'atof' is not a member of 'std'`

```shell
quadrature.cc:64:26: error: 'atof' is not a member of 'std'
   weights(points.size(), std::atof("Inf"))
                          ^
specmake: *** [quadrature.o] Error 1
```

解决办法：添加编译参数`-include cstdlib`

```shell
CXX          = /usr/local/bin/g++ -include cstddef -include cstdlib
```

3.`'strcat' is not a member of 'std'`

```shell
include/lac/vector.templates.h:750:3: error: 'strcat' is not a member of 'std'
   std::strcat(buf, "\n[");
   ^
include/lac/vector.templates.h:752:18: error: 'strlen' is not a member of 'std'
   out.write(buf, std::strlen(buf));
                  ^
specmake: *** [vector.o] Error 1
```

解决办法：添加编译参数`-include cstring`

```shell
CXX          = /usr/local/bin/g++ -include cstddef -include cstdlib -include cstring
```

##### 运行

```shell
[root@hgs spec2006]# runspec -a run -c qemurio-x86.cfg -i ref --tuning=base fp
```

#### 交叉编译

编译结果：

```shell
Build errors: 435.gromacs(base), 436.cactusADM(base), 454.calculix(base), 481.wrf(base)
Build successes: 410.bwaves(base), 416.gamess(base), 433.milc(base), 434.zeusmp(base), 437.leslie3d(base), 444.namd(base), 447.dealII(base), 450.soplex(base), 453.povray(base), 459.GemsFDTD(base), 465.tonto(base), 470.lbm(base), 482.sphinx3(base), 998.specrand(base)
```

其中，435、436、454以及481编译失败的原因为：

```shell
/usr/bin/ld: xxx.o: Relocations in generic ELF (EM: 183)
xxx.o: error adding symbols: File in wrong format
collect2: error: ld returned 1 exit status
```

解决办法：安装gfortran-4.9-aarch64-linux-gnu

```shell
[root@hgs spec2006]# apt install -y gfortran-4.9-aarch64-linux-gnu
```

并修改配置文件中的`FC`值：

```shell
# FC           = /usr/bin/gfortran-4.9
FC           = /usr/bin/aarch64-linux-gnu-gfortran-4.9
```

### 参考资料

1.https://www.spec.org/cpu2006/Docs/

