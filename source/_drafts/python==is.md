---
title: Python中==和is的区别
date: 2019-11-23 17:20:49
tags: python
categories: python
---

在Python中，==和is都可以用于判断两个对象是否相等，但二者的作用并不相同。

<!--more-->

### ==

==用于比较两个对象的值是否相等。

```python
>>> a = 'hgs'
>>> b = 'hgs'
>>> a == b
True
>>> x = [1,2,3]
>>> y = [1,2,3]
>>> x == y
True
```

### is

is用于比较两个对象的id值是否相等，即比较两个对象是否为同一个对象，指向同一个内存地址。

* int型

由于Python会将[-5, 256]内的整数缓存起来，在引用这些整数对象时，不会重新创建新的对象。

因此，若整型变量的值在[-5, 256]区间时，其id相同，导致is与==结果一致。

```python
>>> a = -5
>>> b = -5
>>> a is b
True
```

当整数超出[-5, 256]时，由于其id不同，导致is与==结果不一致。

```python
>>> a = -6
>>> b = -6
>>> a is b
False
>>> a = 257
>>> b = 257
>>> a is b
False
```

