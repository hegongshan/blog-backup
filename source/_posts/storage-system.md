---
title: 存储系统 入坑指南
date: 2021-09-17 14:56:14
tags: storage system
categories: storage system
sticky: 2
---

存储系统（Storage System）是我博士期间的研究方向。新的研究方向，一切都是未知的，需要自己不断探索。

<!--more-->

### 相关期刊

1.TOS：ACM Transactions on Storage，CCF A

### 相关会议

#### 存储系统

1. FAST：Conference on File and Storage Technologies，CCF A
2. USENIX ATC：USENIX Annul Technical Conference，CCF A
3. SC：International Conference for High Performance Computing, Networking, Storage, and Analysis，CCF A
4. MSST：Mass Storage Systems and Technologies，CCF B，https://www.storageconference.us
5. SYSTOR: ACM International Systems and Storage Conference, CCF C
6. HotStorage: USENIX Workshop on Hot Topics in Storage and File Systems

#### 操作系统

1. OSDI：USENIX Symposium on Operating Systems Design and Implementations，CCF A

2. SOSP：ACM Symposium on Operating Systems Principles，CCF A

3. ASPLOS: International Conference on Architectural Support for Programming Languages and Operating Systems, CCF A

### 相关书籍

#### 操作系统

1. 《深入理解计算机系统》（Computer Systems: A Programmer’s Perspective, 简称CSAPP），机械工业出版社
2. 《现代操作系统》（Modern Operating System，简称MOS），机械工业出版社
3. 《Linux内核设计与实现》（Linux Kernel Development，简称LKD），机械工业出版社
4. 《Unix环境高级编程》（Advanced Programming in the Unix Environment，简称APUE），人民邮电出版社

#### 存储系统

1. <strong style="color:red;">《大数据存储技术》</strong>，陈康、武永卫等，人民邮电出版社
2. 《大规模分布式存储系统：原理解析与架构实战》，杨传辉，机械工业出版社
2. 《Linux开源存储全栈详解：从Ceph到容器存储》，英特尔亚太研发有限公司，电子工业出版社
2. 《对象存储：实战指南》，罗庆超，电子工业出版社
4. 《Redis设计与实现》，黄健宏，机械工业出版社

#### 分布式系统

1. 《大数据日知录：架构与算法》，张俊林，电子工业出版社
2. 《数据密集型应用系统设计》（Design Data-Intensive Applications，简称DDIA），中国电力出版社

#### 编程语言

1. 《C程序设计语言》（The C Programming Language，简称K&R）

### 相关课程和实验

1. CSAPP Labs @ CMU, http://csapp.cs.cmu.edu/3e/labs.html
2. Operating System Engineering @ MIT，https://pdos.csail.mit.edu/6.828/
3. 如何写好科研论文 @ 清华大学，https://www.xuetangx.com/course/THU04011000365/7754650

### Benchmark

1. Filebench: https://github.com/filebench/filebench
2. FxMark (Filesystem Multicore Scalability Benchmark): https://github.com/sslab-gatech/fxmark
3. File and Storage System Benchmarking Portal, https://fsbench.filesystems.org

### Top实验室

#### 国内

<!--

1. 存储系统实验室 @ 清华大学，http://storage.cs.tsinghua.edu.cn
2. Applied Distributed Systems Lab @ 香港中文大学, http://adslab.cse.cuhk.edu.hk
3. 并行与分布式系统研究所 @ 上海交通大学，https://ipads.se.sjtu.edu.cn
4. 先进数据系统实验室 @ 中国科学技术大学，http://adsl.ustc.edu.cn
5. 信息系统存储教育部重点实验室 @ 华中科技大学，http://storage.hust.edu.cn

-->

|       学校       | 实验室名称                      | 实验室网址                        |
| :--------------: | :------------------------------ | --------------------------------- |
|     清华大学     | 存储系统实验室                  | http://storage.cs.tsinghua.edu.cn |
|   香港中文大学   | Applied Distributed Systems Lab | http://adslab.cse.cuhk.edu.hk     |
|   上海交通大学   | 并行与分布式系统研究所          | https://ipads.se.sjtu.edu.cn      |
| 中国科学技术大学 | 先进数据系统实验室              | http://adsl.ustc.edu.cn           |
|   华中科技大学   | 信息系统存储教育部重点实验室    | http://storage.hust.edu.cn        |

#### 国外

<!--

2. The **AD**vanced **S**ystems **L**aboratory @ University of Wisconsin – Madison, https://research.cs.wisc.edu/adsl/
3. Non-Volatile Systems Lab @ University of California, San Diego, https://www.nvsl.io
3. File systems and Storage Lab @ Stony Brook University, https://www.fsl.cs.sunysb.edu
4. Parallel Data Lab @ CMU, https://www.pdl.cmu.edu
5. Rutgers Systems Research Lab @ Rutgers University, https://people.cs.rutgers.edu/~sk2113/rsrl.html
6. Storage Systems Research Center @ University of California, Santa Cruz, https://www.ssrc.ucsc.edu

-->

|                 学校                 | 实验室名称                                  | 实验室网址                                      |
| :----------------------------------: | ------------------------------------------- | ----------------------------------------------- |
|  University of Wisconsin – Madison   | The **AD**vanced **S**ystems **L**aboratory | https://research.cs.wisc.edu/adsl/              |
| University of California, San Diego  | Non-Volatile Systems Lab                    | https://www.nvsl.io                             |
|        Stony Brook University        | File systems and Storage Lab                | https://www.fsl.cs.sunysb.edu                   |
|                 CMU                  | Parallel Data Lab                           | https://www.pdl.cmu.edu                         |
|          Rutgers University          | Rutgers Systems Research Lab                | https://people.cs.rutgers.edu/~sk2113/rsrl.html |
| University of California, Santa Cruz | Storage Systems Research Center             | https://www.ssrc.ucsc.edu                       |

### 开源存储系统

#### 文件系统

1. HDFS: Hadoop Distributed File System, http://hadoop.apache.org
2. Ceph: An open-source, distributed storage system, https://ceph.io
3. libfuse: The reference implementation of the Linux FUSE (Filesystem in Userspace) interface, https://github.com/libfuse/libfuse

#### 键值对存储

1. Redis: https://redis.io
2. LevelDB: https://github.com/google/leveldb
3. RocksDB: http://rocksdb.org

#### 数据库

1. HBase: https://hbase.apache.org

### 常见概念

- Data Block：数据块，固定长度的连续数据内容。
- Data Chunk：数据片，可变长度的连续数据内容。
- xx-bound：受xx限制的，比如IO-bound，即为受IO限制的
- workload：工作负载
- overhead：开销

#### 数据结构

* Skip List：跳跃链表，简称跳表
* Log Structure Merge Tree （LSM-Tree）：日志结构合并树🌲
* Radix Tree：基数树
* Bitmap：位图
* Bloom Filter：布隆过滤器
* Ring Buffer：环形缓冲区

#### 并发控制

* lock-free：无锁的
* Copy-On-Write （COW）：写时复制
* Read-Copy Update（RCU）：读-副本-更新，https://www.kernel.org/doc/html/latest/RCU/whatisRCU.html

#### 垃圾回收

* reclamation：回收

#### 一致性

* Crash Consistency：崩溃一致性

Read-After-Write

Read-After-Delete

#### 单机存储

* inode：index node，索引节点，用于描述文件的属性。
* dentry：directory entry，目录项，用于将文件名映射为inode。
* VFS：Virtual File System，虚拟文件系统。
* FUSE：**F**ilesystem in **USE**rspace，用户级文件系统，即在用户态实现文件系统。

#### 分布式存储

- *tenant*：租户
- lease：租约
- 保证数据可靠性的两种方式：
  - 多副本（Replication）：存储空间开销高；
  - 纠删码（Erasure Code）：计算开销高。


#### 性能评估

* Throughput：吞吐率
* IOPS：Input/Output Per Second，每秒输入/输出次数
* MOPS：Million Operations Per Second：每秒百万次操作数
