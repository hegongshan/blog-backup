---
title: python3教程-第1章 入门
date: 2018-06-11 18:38:47
tags: python
categories: python
---

> 课题组要求每一个组员必须学会python，并能使用scrapy（python的一个爬虫框架）编写爬虫，故有了这个系列的教程。
>
> 教程使用教材：《python编程从入门到实践》

本文是python3教程系列的第一篇，主要讲下python环境的搭建，以及永恒的hello wolrd  &gt;_&lt;

<!--more-->

### 安装python3

* Windows/Mac os

[python官网下载地址](https://www.python.org/downloads/release)，按照官网的提示下载对应的版本，安装就行。安装完后，Windows用户双击安装目录下的python.exe，即可进入python命令行交互模式。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/11/20180611185954.png)

当然，最好在系统环境变量PATH中添加下python的安装路径，这样只要打开命令行界面，**输入python就可以进入python命令行交互模式**。

Mac用户自己解决问题咯，因为我没用过Mac os，哈哈哈。

* Linux

如果你用的Linux操作系统，咱不需要下载python，为什么呢？因为大多数Linux系统已经自带了python环境。

我们可以在终端输入python，试探下系统是否已经安装python环境

下图是我在ubuntu下的测试结果

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/11/20180611184149.png)

系统提示我没有找到python命令，并给我提供了python的安装方法，最后又提示我，系统已经安装了python3，我可以直接输入python3，出现>>>，表示已经进入python命令行交互模式。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/11/20180611185452.png)

### hello python

进入python命令行交互模式后，输入

```python
print("hello python")
```

不出意外的话，下面会打印一行“hello python”

实际操作及结果如下：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/11/20180611190300.png)

输入exit()或者ctrl+D可以退出python命令行交互模式

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612144035.png)

<hr>

刚才演示的是在python命令行交互模式直接写代码，我们能不能像其他语言一样，把代码写在一个文件里，然后编译执行呢？答案当然是可以的。

现在我在桌面新建一个hello.py文件，并把刚才写的代码在文件里重新写一遍

输入如下命令（Windows/Mac用python代替我的python3）

```python
python3 hello.py
```

输出如下

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/11/20180612143844.png)