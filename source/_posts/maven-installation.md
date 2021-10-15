---
title: 安装Apache Maven
date: 2021-09-19 16:05:59
tags: maven
categories: java
---

Maven是Java中的一个项目构建工具。

<!--more-->

1.下载Maven

Maven下载页面：https://maven.apache.org/download.cgi

```shell
wget https://downloads.apache.org/maven/maven-3/3.8.2/binaries/apache-maven-3.8.2-bin.tar.gz
```

2.解压

```shell
tar -zxf apache-maven-3.8.2-bin.tar.gz -C /usr/local/
```

3.将bin添加到环境变量PATH中

```shell
vim ~/.bash_profile
```

添加如下内容：

```shell
export PATH=/usr/local/apache-maven-3.8.2/bin:$PATH
```

4.验证安装是否成功

```shell
hgs-2:blog-backup hegongshan$ mvn --version
Apache Maven 3.8.2 (ea98e05a04480131370aa0c110b8c54cf726c06f)
Maven home: /usr/local/apache-maven-3.8.2
Java version: 1.8.0_192, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk1.8.0_192.jdk/Contents/Home/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "mac os x", version: "10.13.6", arch: "x86_64", family: "mac"
```

