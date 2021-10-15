---
title: 在Docker容器中启动SSHD服务
date: 2021-09-07 21:34:55
tags: docker
categories: docker
---

在Docker容器中启动SSHD服务，并通过SSH远程登录Docker容器。

<!--more-->

### 启动容器

```shell
[root@hgs ~]# docker run -itd --name mycontainer myimage[:tag]
```

### 安装SSHD

1.要想在容器中执行命令，可以使用Docker中的`exec`命令：

```shell
[root@hgs ~]# docker exec -it mycontainer /bin/bash
```

2.安装SSHD服务

* Ubuntu

```shell
apt-get install openssh-server
```

* CentOS

```shell
yum install -y openssh-server
```

### 配置SSHD

修改/etc/ssh/sshd_config文件，将`PermitRootLogin`的值（默认值为`prohibit-password`）更新为`yes`：

```shell
# 允许root用户登录
PermitRootLogin yes
```

### 创建新容器

1.生成新镜像。使用Docker中的`commit`命令可以从容器创建一个新的镜像。

```shell
[root@hgs ~]# docker commit mycontainer newimage[:tag]
```

2.根据新镜像，创建并启动新容器

```shell
[root@hgs ~]# docker run -itd --name mycontainer2 -p 6666:22 -v /root/hegongshan:/home newimage
```

3.在新容器中开启SSHD服务

* 自动启动

```shell
# Ubuntu
service ssh start

# CentOS
service sshd start
```

* 手动启动

```shell
/usr/sbin/sshd -D &
```

启动过程中可能会出现如下提示：

```shell
root@145e68ad0d95:/# /usr/sbin/sshd -D &  
[1] 321
root@145e68ad0d95:/# Missing privilege separation directory: /var/run/sshd
```

如果出现上述提示，则需要创建privilege separation directory：

```shell
root@145e68ad0d95:/# mkdir /var/run/sshd
```

4.修改root用户的密码

```shell
root@145e68ad0d95:/# passwd root
Enter new UNIX password: 
Retype new UNIX password: 
passwd: password updated successfully
```

### 测试SSH登录

测试用端口映射登陆容器：

```shell
ssh root@hostname -p 6666 
```

