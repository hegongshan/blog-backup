---
title: Command 'scrapy' not found
date: 2018-06-30 14:24:24
tags: [python,scrapy]
categories: scrapy
---

### 问题描述

在ubuntu中执行

```python
pip3 install scrapy
```

成功安装scrapy，且在python命令行交互模式中成功执行

```python
import scrapy
```

但是在终端中执行scrapy startproject xxx时，出现＂Command 'scrapy' not found＂

<!--more-->

### 解决办法

找到python的主目录，我的是

```python
/home/hegongshan/.local/lib/python3.6
```

在上面lib的同级目录bin下有一个scrapy文件，我的是**/home/hegongshan/.local/bin**

为该目录下的scrapy文件在/usr/bin目录下建立一个软链接

```shell
sudo ln -s /home/hegongshan/.local/bin/scrapy /usr/bin
```

然后在终端下执行scrapy，可以看到，

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/30/20180630144107.png)