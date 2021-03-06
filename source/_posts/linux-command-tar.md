---
title: 在Linux中存活下来之tar压缩和解压缩文件
date: 2018-05-14 21:08:13
updated: 2018-05-14 21:08:13
tags: [linux,压缩,解压缩]
categories: linux
---
>最近需要在Linux服务器上解压tar.gz文件，于是乎学习了下tar命令的使用。

tar命令参数很多，暂时就只用到以下几个参数，其他的以后用到再补上。

<!--more-->

#### 参数说明：

* -c：全称create，用于创建文件
* -v：全称verbose，用于显示详细的命令执行信息
* -f：全称file，用于指定需要压缩或者解压缩的文件名
* -x：用于解压文件
* -C：切换到指定目录
* -z：通过gzip命令处理文件。简单来说，如果需要压缩为\*.gz文件，或者解压缩\*.gz文件，就要带上-z

####  示例

1.解压缩tar.gz文件

```shell
tar -zxvf apache-tomcat-8.5.31.tar.gz
```

2.解压缩tar.gz文件到指定目录，这里以/usr/local目录为例

```shell
tar -zxvf apache-tomcat-8.5.31.tar.gz -C /usr/local
```

3.将某个（些）目录或文件压缩为tar.gz文件

```shell
tar -zcvf archive.tar.gz file1 file2 ...
```

archive.tar.gz是生成的压缩文件名，file1、file2等是要压缩的文件和目录列表。