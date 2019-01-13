---
title: Nginx返回413 Request Entity Too Large
date: 2018-10-14 22:54:23
tags: nginx
categories: nginx
---

* 问题描述

晚上9点55分，前老板在讨论组中截了一张图片，显示的是课程网站上传文件失败的弹框，弹框内容如下

```
SyntaxError: JSON.parse: unexpected character at line2 column 1 of the JSON data
```

下意识以为是自己代码写的有问题，赶紧在本机测试了下，发现很小的文件都能正常上传，但是稍大一点的文件就会出现如下错误

```
SyntaxError: Unexpected token < in JSON at position 1
```

浏览器控制台报错内容如下

```
413 Request Entity Too Large
```

查看了下Spring MVC的配置文件，上传大小写的足够大，这显然不是Spring MVC的问题。后来发现可能是Nginx的问题，试着改了下本地Nginx的配置文件，果然就传成功了。

* 原因

nginx服务器做反向代理时，对上传的文件大小有限制，默认为2M

* 解决办法

在nginx.conf的http{}中，添加一行

```shell
client_max_body_size 200m;
```

文件大小限制可以根据需求自行改变。