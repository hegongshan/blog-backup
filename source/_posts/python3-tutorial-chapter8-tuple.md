---
title: python3教程-第8章 元组
date: 2018-06-15 18:23:12
tags: python
categories: python
---

列表非常适合用于存储在程序运行期间可能变化的数据集。列表是可以修改的。如果需要创建一系列不可修改的元素，可以使用python中的元组。简单来说，**元组就是数据元素不可变的列表**。

<!--more-->

### 定义元组

用**圆括号**定义元组。语法如下：

```python
(元素１,元素２,...)
```

访问元组中元素的方法，与访问列表中的元素类似。

示例：

```python
positions = (5,20)
print(positions[0])
print(positions[1])
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623185318.png)

下面我们尝试修改下元组positions中的元素

```python
positions = (5,20)
positions[1] = 21
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623183800.png)

python解释器告诉我们，元组（tuple）不支持元素赋值。

### 修改元组变量

虽然不能修改元组中的元素，但可以给存储元组的变量赋值。

```python
positions = (5,20)
print(positions)
positions = (23,33)
print(positions)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/23/20180623184949.png)