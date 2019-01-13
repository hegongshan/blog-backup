---
title: python3教程-第4章 字符串
date: 2018-06-12 16:32:13
tags: python
categories: python
---

字符串是一系列字符。在python中，用引号括起来的都是字符串，这里的引号可以是单引号，也可以是双引号。

<!--more-->

### 修改字符串的大小写

涉及的字符串方法有upper()、isupper()、lower()、islower()

示例：

```python
name = "hegongshan"
# 判断是否为大写字符串
print(name.isupper())
# 将字符串中的字母均转为大写
print(name.upper())

name2 = "heGONGshan"
# 判断字符串是否为小写
print(name2.islower())
#　将字符串中的字母均转为小写
print(name2.lower())
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623211639.png)



### 拼接字符串

和大多数高级编程语言一样，python使用加号（+）来拼接字符串。

示例：

```python
message = "I " + "love "
message = message + "you."
print(message)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623211949.png)

### 首字母大写

涉及的方法有title()、capitalize()

示例：

```python
name = "he gong shan"
print(name.title())
print(name.capitalize())

name2 = "123 hegongshan"
print(name2.title())
print(name2.capitalize())

message = "123hgs520"
print(message.title())
print(message.capitalize())
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623213455.png)

从上面的结果，我们可以很容易地看出title()和capitalize()的区别：

title()方法会将字符串中所有单词的首字母都转为大写，而capitalize()方法只会将字符串的首字母转为大写

### 去掉字符串中的空白字符

涉及的方法有strip()、rstrip()和lstrip()

strip()：去掉字符串**左右**的空白字符

lstrip()：去掉字符串**左边**的空白字符

rstrip()：去掉字符串**右边**的空白字符

示例：

```python
message = "   I love you !   "
print(message.lstrip())

print(message.rstrip() + "hhh")

print(message.strip() + "233")
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623214342.png)

