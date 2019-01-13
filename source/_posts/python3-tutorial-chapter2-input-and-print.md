---
title: python3教程-第2章 标准输入和输出
date: 2018-06-12 16:26:17
tags: python
categories: python
---

### 标准输出print()

* 简单输出

函数print()接受一个参数：需要打印的信息，如字符串，整数，列表等。

示例：

```python
print("hello print")
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612155807.png)

<!--more-->

### 标准输入input()

函数input()让程序暂停运行，等待用户输入一些文本。获取输入后，python将其存储在一个变量中，以便后续使用。input()接受一个参数：要向用户显示的提示或说明信息。

示例：

```python
str = input("请输入一句话:")
```
输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612160622.png)

需要注意的是，使用input()函数时，python将用户输入解读为字符串。

示例：

```python
age = input("请输入您的年龄:")
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612160842.png)

可以看到，输出的age是带引号的，也就是说它确实被python解读为字符串。

如果需要将输入的数字转换为数值型，可以使用int()函数，将字符串转换为整型某某某

示例：

```python
age = input("请输入您的年龄:")
age = int(age)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612161251.png)

可以看到，使用int()函数转换后，输出的age是不带引号的，age 确实变成了整型。