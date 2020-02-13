---
title: 在Linux中存活下来之history
date: 2020-02-13 23:08:24
tags: linux
categories: linux
---

history命令用于显示历史执行过的命令。

<!--more-->

选项

* -c：清空当前历史命令
* -d offset：删除历史记录中第offset个命令
* -w: 将当前历史命令写入历史命令文件中

参数

* n：查看最近的n条命令

执行历史命令

1.使用!number执行第number条命令

2.使用!!执行上一条命令