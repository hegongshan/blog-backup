---
title: Linux终端中的键盘快捷键
date: 2020-12-03 01:02:21
tags: linux
categories: linux
---

本文对常用的Linux终端快捷键进行了梳理和总结。

<!--more-->

### Tab

自动补全。

### Ctrl+L

清空屏幕，等价于`clear`命令。

### Ctrl+Z

使程序在后台运行。

### 快速移动

* Ctrl+A：将光标移至行首
*  Ctrl+E：将光标移至行尾
*  Ctrl+B：将光标往前移动一个字符，相当于**方向键中的左键**
*  Ctrl+F：将光标往后移动一个字符，相当于**方向键中的右键**
*  Alt+B：将光标移至前一个单词的首字母处
*  Alt+F：将光标移至后一个单词的**首字母前**

### 中断与退出

* Ctrl+C：中断当前程序


### 编辑

* Ctrl+U：剪切光标所在位置至行首的全部内容
* Ctrl+K：剪切光标所在位置至行尾的全部内容
* Ctrl+W：剪切光标所在位置至前一个单词的首字母所在的位置的全部内容
* Ctrl+Y：在光标所在位置，粘贴上述三类操作剪切的内容
* Ctrl+H：删除光标所在位置的前一个字符
* Ctrl+D：删除光标所在位置的后一个字符（即光标覆盖的那个字符）；若命令行没有任何字符，则退出终端，等价于`exit`命令

### 查看历史命令

* Ctrl+P：查看前一条命令
* Ctrl+N：查看后一条命令

* Ctrl+R：进入反转搜索模式，搜索历史命令

```
(reverse-i-search)`': 
```

在找到匹配的命令后，

1.若按下**Enter键**，则执行该命令。

2.若按下**Esc键**，则在命令行中显示该命令，但是不执行

* Ctrl+G：退出历史搜索