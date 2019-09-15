---
title: 在MacOS中配置MySQL
date: 2019-07-01 15:31:50
tags: macos
categories: macos
---

“好记性不如烂笔头。”这里，记录下我在MacOS中安装MySQL的过程。

<!--more-->

1.下载及安装

下载地址：https://dev.mysql.com/downloads/mysql/

默认安装路径为`/usr/local/mysql`

2.启动服务

在系统偏好设置中，查看MySQL服务是否启动，如果没有启动，则启动服务。

![图片1](/static/images/macos-mysql-installation-1.png)

![图片2](/static/images/macos-mysql-installation-2.png)

3.配置环境变量

由于没有配置环境变量，此时，若在终端输入`mysql`，将找不到命令

```shell
hgs:bin hegongshan$ mysql
-bash: mysql: command not found
```

修改～/.bash_profile文件，在其中添加如下内容

```shell
# mysql
PATH=$PATH:/usr/local/mysql/bin
```

然后，在终端中输入如下命令，使刚才的配置生效

```shell
source ~/.bash_profile
```

4.检查配置是否成功

在终端中尝试输出mysql的版本号，检查配置是否成功

```shell
mysql --version
```

输出如下

```shell
hgs:bin hegongshan$ mysql --version
mysql  Ver 8.0.16 for macos10.14 on x86_64 (MySQL Community Server - GPL)
```

