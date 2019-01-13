---
title: python3教程-第6章 循环
date: 2018-06-13 18:11:53
tags: python
categories: python
---

### for循环

语法如下：

```python
for 变量名 in　集合(字符串|列表|元组|字典):
    循环体
```

<!--more-->

示例：

```python
str = "I love you!"
for c in str:
    print(c)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623193854.png)

### while循环

语法如下：

```python
while 条件表达式:
    循环体
```

示例如下：

```python
current_number = 1
while current_number < 5:
    print(current_number)
    current_number += 1
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623195647.png)

### 使用标志结束循环

在要求很多条件都满足才继续运行的程序中，可定义一个变量，用于判断整个程序是否处于活动状态。这个变量称为标志，充当程序的交通信号灯，决定循环是否继续进行，还是结束。

示例：

```python
active = True
while active:
    message = input("\n请输入一个字符串，\n如果输入exit则退出循环：")
    if message == 'exit':
        active = False
    else:
        print(message)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623200803.png)

### 使用break结束循环

使用break语句，可以直接退出循环，不再继续执行循环中余下的代码

示例：

```python
# 循环输入一串字符串，如果输入的是exit，则退出循环
while True:
    message = input("\n请输入一个字符串，\n如果输入exit则退出循环：")
    if message == 'exit':
    	break    
    else:
        print(message)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623201350.png)

### 在循环中使用continue

使用continue语句，继续执行下一次循环，不再执行当前循环中余下的代码。

示例：

```python
# 打印１-10中的所有奇数
current_number = 0
while current_number < 10:
    current_number += 1
    if current_number % 2 == 0:
        continue
    print(current_number)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623202848.png)