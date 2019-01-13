---
title: 使用PuTTY远程登录Linux服务器
date: 2018-08-16 14:55:33
tags: putty
categories: putty
---

使用PuTTY已经很长时间了，是时候总结下PuTTY的用法了。

* 什么是PuTTY?

下面是PuTTY官网的介绍

PuTTY is an SSH and telnet client, developed originally by Simon Tatham for the Windows platform. 

翻译过来就是说，PuTTY是Windows平台下的一个SSH客户端。

* 为什么要使用PuTTY？

与商用的XShell相比，PuTTY是开源免费的>_<。

<!--more-->

### 安装PuTTY

从[PuTTY官网](https://www.putty.org)下载合适的版本，目前的最新稳定版本是0.70。

成功安装后目录结构如下，我的安装路径为G:\putty

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816183626.png)

### 远程登录

双击putty.exe，将会显示如下界面

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816184134.png)

在Host Name(or IP address)，也就是下图中红框标明的地方，输入远程Linux服务器的IP地址

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816184446.png)

然后点击Open按钮，将会显示如下界面。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816184906.png)

在login as：后输入用户名

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816185216.png)

按照要求输入密码即可登录，值得一提的是，密码是不会显示的，这也很符合Linux设计的哲学。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816185506.png)

### 小经验

刚才那样的登录，每次都需要输入服务器IP地址，实际上，PuTTY提供了保存IP地址，下次自动导入的功能。

第一次登录时，输入IP地址，在Saved Sessions下的输入框中输入想保存的名字，然后点击Save按钮（图中用红框标明）。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816190008.png)

这里以127.0.0.1为例，设置session的名字为server，点击Save按钮，Default Settings下出现了一个server

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/16/20180816190808.png)

下一次登录时，只需要选择server，然后点击Load按钮，IP地址将会被自动导入。

如果不想再保存该IP地址了，则选中session的名字，然后点击Delete按钮即可删除存储的session。