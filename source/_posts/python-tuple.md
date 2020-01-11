---
title: Python元组（tuple）
date: 2019-09-29 19:06:23
tags: python
categories: python
---

在Python中，元组与列表类似，不同之处在于列表中的元素是可以修改的，而元组中的元素是不可修改的。

元组用圆括号`()`来标识，并用逗号来分隔其中的元素。

<!--more-->

创建空元组

```python
# 定义空元组
digits = ()
print(digits)
# 输出digits的类型
print(type(digits))
```

输出：

```python
()
<class 'tuple'>
```

元组中只包含一个元素时，需要在元素后面添加逗号`,`

```python
digits = (1,)
print(digits)
print(type(digits))
```

输出：

```python
(1,)
<class 'tuple'>
```

元组中没有append()和insert()等插入元素的方法。

```python
digits = (1, 2)
# 元组没有append和insert方法
digits.append(3)
```

输出：

```python
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
AttributeError: 'tuple' object has no attribute 'append'
```

元组中的元素是不可变的，一旦初始化便不可修改。

```python
digits = (1, 2)
# 尝试修改元组中索引为0的元素
digits[0] = 2
```

输出：

```python
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
TypeError: 'tuple' object does not support item assignment
```

