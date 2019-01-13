---
title: python数据分析之NumPy
date: 2018-06-25 22:12:48
tags: 数据分析
categories: python
---

NumPy（Numerical Python）是高性能科学计算和数据分析的基础包。

下面记录一些NumPy中的基础函数及应用。

按照标准约定，我们在使用NumPy时，最好遵循如下格式：

```python
import numpy as np
```

<!--more-->

### ndarray

ndarray是一个n维数组对象，其中的所有元素必须是相同类型的值。

ndarray常见属性：

* shape：表示各个维度大小的元组
* dtype：表示数组数据类型的对象

通过NumPy中的array()函数，即可将一切序列型的对象转换为NumPy中的数组。

示例：

```python
import numpy as np
data = np.array([[1,2,4,5],[1.1,23,1234,5]])
print(data.shape)
print(data.dtype)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/13/%2020180713114022.png)

### zeros, ones

除了可以使用array()函数创建数组外，还可以使用zeros、ones来创建数组。

接受参数：

* 表示维度大小的元组shape
* 表示数据类型的dtype

返回：一个指定维度且元素值全为0或1的数组

示例：

```python
import numpy as np
# 创建一个１行３列的全0数组
np.zeros(3)
# 创建一个３行3列的全0数组
np.zeros((3,3))
# 创建一个3x3x2的全0数组
np.zeros((3,3,2))
np.ones(3)
np.ones((3,3))
np.ones((3,3,2))
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/13/20180713114346.png)

可以看到，如果我们只传入一个数字n，则会创建一个1xn的数组。

### shape

shape()函数用于测量NumPy中数组、矩阵等的维度，返回一个表示维度的元组。

示例：

```python
import numpy as np
np.shape([[1, 2]])
np.shape([0])
np.shape(0)
data = np.array([[[1,2,3],[1,2,3]],
                [[4,5,6],[7,8,9]]])
np.shape(data)
```

输出：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/13/20180713121056.png)

### eye

eye()函数用于创建一个指定大小的单位数组(类似于线性代数中的单位矩阵)。

接受参数：一个表示维度大小的整数

示例：

```python
import numpy as np
np.eye(3)
```

输出：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/13/20180713121243.png)

### arange

arange()函数类似于python中的range()，但它返回的是一个NumPy数组。



### random

random.uniform



### mat

mat()函数用于创建矩阵。