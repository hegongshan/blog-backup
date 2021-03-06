---
title: Python切片操作
date: 2019-12-22 16:30:39
tags: python
categories: python
---

为了访问list、str等序列类型中某些元素所构成的子集，Python提供了一种简单的语法——切片。

<!--more-->

### 切片语法

#### 普通切片

切片操作的基本写法是somelist[start:end]，取值范围[start,end)，不包括end。

```python
a = list(range(10))
a[2:4] # [2, 3]
```

如果从开头获取切片，则可以不写start。

```python
a[:4] # [0, 1, 2, 3]
# a[0:4]等同于a[:4]
print(a[0:4] == a[:4]) # True
```

同样地，如果切片要取到末尾，则可以不写end。

```python
a[4:] # [4, 5, 6, 7, 8, 9]
# a[4:len(a)]等同于a[4:]
print(a[4:len(a)] == a[4:])
```

如果start和end都被省略，则表示原对象的一份拷贝。

```python
a[:]	  # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
a[:] == a # True
a[:] is a # False
```

在指定切片起止索引时，若要从尾部向前算，则可以使用负数来表示相关偏移量。

```python
a[:-1]    # [0, 1, 2, 3, 4, 5, 6, 7, 8]
a[-5:]    # [5, 6, 7, 8, 9]
a[-5:-1]  # [5, 6, 7, 8]
a[2:-1]   # [2, 3, 4, 5, 6, 7, 8]
```

对序列进行切片时，即使start或end索引越界也不会出问题。

```python
a[:20]  # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
a[-20:] # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

对切片操作得到的新列表进行修改，不会影响原列表。

```python
>>> b = a[:4]
>>> b
[0, 1, 2, 3]
>>> b[1] = 100
>>> b
[0, 100, 2, 3]
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9
```

#### 带间隔的切片

除了基本的切片操作外，Python还提供了somelist[start:end:step]的写法，表示在[start,end)内，以step为间隔取值。

```python
a = list(range(10))
a[::2]  # [0, 2, 4, 6, 8]
a[1::2] # [1, 3, 5, 7, 9]
```

Python中有一种常见的技巧——以-1为间隔，来反转列表或者字符串等。

```python
a[::-1] # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
```

### 给切片赋值

如果把切片放在赋值语句的左边，会把序列中处在指定范围内的对象替换为新值。

切片的长度与新值的个数无需相等。序列会根据新值的个数相应地扩张或收缩。

```python
a = list(range(10))
# 收缩 [0, 1, 20, 30, 5, 6, 7, 8, 9]
a[2:5] = [20, 30]
# 扩张 [0, 1, 20, 30, 40, 5, 6, 7, 8, 9]
a[2:4] = [20, 30, 40]
```

如果把切片放在赋值语句的左边，那么右侧必须是个可迭代对象（即使只有单独一个值）。

注意下面的两种写法：

```python
a[2:5] = 100   # 错误的写法
a[2:5] = [100] # 正确的写法
```

第一种写法将会导致如下的错误：

```python
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: can only assign an iterable
```

将切片作为del操作的对象，可以删除序列中的元素。

```python
>>> a = list(range(10))
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> del a[2:5] 
>>> a
[0, 1, 5, 6, 7, 8, 9]
```

