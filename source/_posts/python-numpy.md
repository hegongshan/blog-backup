---
title: NumPy入门
date: 2018-06-25 22:12:48
tags: 数据分析
categories: python
---

NumPy（Numerical Python）是高性能科学计算和数据分析的基础包。

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

#### 算术运算

NumPy中的ndarray支持逐元素的算术运算`+`、`-`、`*`、`/`、`%`和`//`等。

```python
import numpy as np
data1 = np.array([[1,2,3],[4,5,6],[7,8,9]])

data2 = np.array([[11,21,31],[41,51,61],[71,81,91]])
print('data1和data2逐元素相加：')
print(data1 + data2)
print('data1和data2逐元素相减：')
print(data2 - data1)
print('data1和data2逐元素相乘：')
print(data1 * data2)
print('data2和data1逐元素相除：')
print(data2 / data1)
print('data2和data1逐元素相除取余：')
print(data2 % data1)
print('data2和data1逐元素相除取商：')
print(data2 // data1)
```

输出：

```python
data1和data2逐元素相加：
[[ 12  23  34]
 [ 45  56  67]
 [ 78  89 100]]
data1和data2逐元素相减：
[[10 19 28]
 [37 46 55]
 [64 73 82]]
data1和data2逐元素相乘：
[[ 11  42  93]
 [164 255 366]
 [497 648 819]]
data2和data1逐元素相除：
[[11.         10.5        10.33333333]
 [10.25       10.2        10.16666667]
 [10.14285714 10.125      10.11111111]]
data2和data1逐元素相除取余：
[[0 1 1]
 [1 1 1]
 [1 1 1]]
data2和data1逐元素相除取商：
[[11 10 10]
 [10 10 10]
 [10 10 10]]
```

#### 将NumPy中的ndarray转换为Python中的list

使用ndarray的tolist()函数，可以将NumPy数组转换为Python中的list

```python
import numpy as np
data = np.array([[1,2,4,5],[1.1,23,1234,5]])
print(type(data))
ls = data.tolist()
print(ls)
print(type(ls))
```

输出：

```python
<class 'numpy.ndarray'>
[[1.0, 2.0, 4.0, 5.0], [1.1, 23.0, 1234.0, 5.0]]
<class 'list'>
```

#### 数组复制

使用ndarray的copy()方法，可以创建数组副本。

```python
import numpy as np

data = np.array([[1,2,4,5],[12,23,1234,5]])
x = data.copy()
print(x is data)
print(x == data)
```

输出：

```python
False
[[ True  True  True  True]
 [ True  True  True  True]]
```

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
print(np.zeros(3))
# 创建一个３行3列的全0数组
print(np.zeros((3,3)))

print(np.ones(3))
```

输出结果：

```python
[0. 0. 0.]
[[0. 0. 0.]
 [0. 0. 0.]
 [0. 0. 0.]]
[1. 1. 1.]
```

可以看到，如果我们只传入一个数字n，则会创建一个1xn的数组。

### shape

shape()函数用于测量NumPy中数组、矩阵等的维度，返回一个表示维度的元组。

示例：

```python
import numpy as np
print(np.shape([[1, 2]]))
print(np.shape([0]))
data = np.array([[[1,2,3],[1,2,3]],
                [[4,5,6],[7,8,9]]])
print(np.shape(data))

print(data.shape)
```

输出：

```python
(1, 2)
(1,)
(2, 2, 3)
(2, 2, 3)
```

### full

函数原型：

```python
full(shape, fill_value, dtype=None, order='C')
```

* shape：数组的维度
* fill_value：填充的值
* dtype：指定的数据类型

示例：

```python
import numpy as np

print(np.full((2,2),1.))
```

输出：

```python
[[1. 1.]
 [1. 1.]]
```

### 广播

#### broadcast_to

函数原型：

```python
broadcast_to(array, shape, subok=False)
```

* array：待广播的数组
* shape：期望的维度（用元组表示）

示例：

```python
import numpy as np

x = np.array([1,2,3,4])
print(np.broadcast_to(x, (2,4)))
```

输出：

```python
[[1 2 3 4]
 [1 2 3 4]]
```

#### tile

函数原型：

```python
tile(A, reps)
```

沿着每个轴，将数组中的元素重复指定次数。

https://docs.scipy.org/doc/numpy/reference/generated/numpy.tile.html

示例：

```python
import numpy as np

x = np.array([1,2,3,4])
print(np.tile(x,3))
print(np.tile(x,(2,2)))
```

输出：

```python
[1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]
[[1 2 3 4 1 2 3 4]
 [1 2 3 4 1 2 3 4]]
```

### eye

eye()函数用于创建一个指定大小的单位数组(类似于线性代数中的单位矩阵)。

接受参数：一个表示维度大小的整数

示例：

```python
import numpy as np
np.eye(3)
```

输出：

```python
array([[1., 0., 0.],
       [0., 1., 0.],
       [0., 0., 1.]])
```

### arange

arange()函数类似于python中的range()，但它返回的是一个NumPy数组。

```python
import numpy as np
np.arange(5)
```

输出：

```python
array([0, 1, 2, 3, 4])
```

### mat

mat()函数用于创建矩阵。

### random

#### seed

设置随机数生成器种子。保证每次运行，生成的随机数相同。

#### randint

函数原型：

```python
numpy.random.randint(low, high=None, size=None, dtype='l')
```

返回一个或者多个随机整数，范围从低（包括）到高（不包括），即[low, high)。如果没有写参数high的值，则返回[0,low)的值。

#### shuffle

打乱ndarray中数据的顺序。

### 保存/加载NumPy对象

要想保存NumPy对象，可以使用numpy.save()方法

```python
import numpy as np

np.save(np.ones((1,)),'./test.npy')
```

加载保存在本地的NumPy对象，可以使用numpy.load()方法

```python
import numpy as np

np.load('./test.npy')
```

