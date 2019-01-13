---
title: 使用PuTTY实现Windows和Linux的文件传输
date: 2018-08-17 14:04:30
tags: putty
categories: putty
---

安装完PuTTY以后，进入命令行界面，就可以使用PuTTY的**pscp命令**进行文件传输。

### pscp

语法：

```shell
pscp 源文件路径 目标文件路径
```

<!--more-->

示例：

```shell
pscp root@111.199.227.74:/mnt/files/abc.txt D:/file/
```

值得一提的是，pscp命令只能用于**文件**的上传下载，若要进行**文件夹（目录）**的上传下载，可以先压缩，然后再使用pscp命令进行文件传输。

若命令行中显示找不到pscp命令，只需将PuTTY的安装路径添加到系统变量Path中即可。

