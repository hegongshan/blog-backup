---
title: 玩转TensorFlow2张量操作
date: 2019-11-09 21:06:09
tags: deep learning
categories: deep learning
mathjax: true
---

本文总结了TensorFlow2中常见的张量操作。

<!--more-->

### 张量定义

#### 常量

在TensorFlow中，创建常量的函数主要有tf.constant、tf.zeros、tf.ones、tf.fill。

* tf.constant

```python
tf.constant(
    value,
    dtype=None,
    shape=None,
    name='Const'
)
```

* tf.zeros：创建一个元素值全为0的张量

```python
tf.zeros(
    shape, 
    dtype=tf.float32, 
    name=None
)
```

示例：

```python
>>> print(tf.zeros([3, 4], dtype=tf.int32))
tf.Tensor(
[[0 0 0 0]
 [0 0 0 0]
 [0 0 0 0]], shape=(3, 4), dtype=int32)
```

* tf.ones：创建一个元素值全为1的张量

```python
tf.ones(
    shape, 
    dtype=tf.float32, 
    name=None
)
```

示例：

```python
>>> print(tf.ones([3, 4], dtype=tf.int32))
tf.Tensor(
[[1 1 1 1]
 [1 1 1 1]
 [1 1 1 1]], shape=(3, 4), dtype=int32)
```


* tf.fill：使用某个值填充张量

```python
tf.fill(
    dims, 
    value, 
    name=None
)
```

示例：

```python
>>> tf.fill([2, 3], 9)
<tf.Tensor: shape=(2, 3), dtype=int32, numpy=
array([[9, 9, 9],
       [9, 9, 9]], dtype=int32)>
```

#### 变量

在TensorFlow中，如果要创建变量，需要使用类tf.Variable。

```python
tf.Variable([2,2])
```

### 张量运算

假设$\mathbf{a}，\mathbf{b} \in \mathbb{R}^n$

#### 逐元素相加

$$
\mathbf{a} + \mathbf{b} = 
\begin{bmatrix}
a_1 + b_1 \\\\
a_2 + b_2 \\\\
\vdots\\\\
a_n + b_n
\end{bmatrix}
$$

> tf.add(x,y,name=None)

示例：

```python
print(tf.add(1,2))
print(tf.add([1,2],[3,4]))
```



```python
tf.Tensor(3, shape=(), dtype=int32)
tf.Tensor([4 6], shape=(2,), dtype=int32)
```

#### 逐元素相减

$$
\mathbf{a} - \mathbf{b} = 
\begin{bmatrix}
a_1 - b_1 \\\\
a_2 - b_2 \\\\
\vdots\\\\
a_n - b_n
\end{bmatrix}
$$

> tf.subtract(x, y, name=None)

示例：

```python
print(tf.subtract([1,2],[3,4]))
tf.Tensor([-2 -2], shape=(2,), dtype=int32)
```

#### 逐元素相乘

$$
\mathbf{a} \odot \mathbf{b} = 
\begin{bmatrix}
a_1 \times b_1 \\\\
a_2 \times b_2 \\\\
\vdots \\\\
a_n \times b_n
\end{bmatrix}
$$

> tf.multiply(x, y, name=None)

示例:

1.使用tf.multiply

```python
>>> x = tf.constant([1, 2, 3, 4])
>>> tf.multiply(x, x)
<tf.Tensor: shape=(4,), dtype=int32, numpy=array([ 1,  4,  9, 16], dtype=int32)>
```

2.使用乘号

```python
>>> x * x
<tf.Tensor: shape=(4,), dtype=int32, numpy=array([ 1,  4,  9, 16], dtype=int32)>
```

可以看到：对两个张量执行tf.multiply，和直接使用乘号，效果是一样的。

#### 矩阵乘法

$$
\mathbf{A}_{m \times n} \times \mathbf{B}_{n \times k} = \mathbf{C}_{m \times k}
$$

> tf.matmul

示例：

```python
a = tf.constant([1, 2, 3, 4, 5, 6], shape=[2, 3])
b = tf.constant([7, 8, 9, 10, 11, 12], shape=[3, 2])
c = tf.matmul(a, b)
print(c)
```



```python
tf.Tensor(
[[ 58  64]
 [139 154]], shape=(2, 2), dtype=int32)
```

#### 平方

$$
\mathbf{a} \odot \mathbf{a} = 
\begin{bmatrix}
a_1^2 \\\\
a_2^2 \\\\
\vdots\\\\
a_n^2
\end{bmatrix}
$$

> tf.square(x,name=None)

示例：

```python
print(tf.square(5))
print(tf.square([1,2]))
```



```python
tf.Tensor(25, shape=(), dtype=int32)
tf.Tensor([1 4], shape=(2,), dtype=int32)
```

#### 幂操作

> tf.pow(x, y, name=None)

#### 指数

> tf.exp

#### 逐元素相除

> tf.divide(x, y, name=None)

#### 拼接

> tf.concat(values, axis, name='concat')

1. 一维张量

```python
>>> a = tf.ones(2)
>>> b = tf.zeros(3)
>>> tf.concat([a, b], axis=0)
<tf.Tensor: shape=(5,), dtype=float32, numpy=array([1., 1., 0., 0., 0.], dtype=float32)>
```

2. 二维张量

```python
>>> a = tf.ones([2,2])
>>> b = tf.zeros([2,3])
>>> tf.concat([a, b], axis=-1)
<tf.Tensor: shape=(2, 5), dtype=float32, numpy=
array([[1., 1., 0., 0., 0.],
       [1., 1., 0., 0., 0.]], dtype=float32)>
```

#### 求和

> tf.reduce_sum(input_tensor, axis=None, keepdims=False, name=None)

### 维度变换

#### 扩展维度

expand_dims

reshape

stack

transpose

Tile

（正在完善中...）


### 与NumPy N维数组的相互转换

1. TensorFlow张量=>NumPy ndarray：使用类tf.Tensor的numpy()方法

```python
>>> x = tf.ones([2, 3])
>>> x.numpy()
array([[1., 1., 1.],
       [1., 1., 1.]], dtype=float32)
```

2. NumPy N维数组=>TensorFlow张量

### 实战：实现softmax

softmax公式如下：
$$
\mathrm{softmax}(\mathbf{x})_k = \frac{\exp(x_k)}{\sum_{i = 1}^n \exp(x_i)}
$$

首先，使用TensorFlow内置的softmax函数进行计算

```python
>>> x = tf.constant([[1., 2., 3.], [2., 5., 6.]])
>>> tf.nn.softmax(x, axis=-1)
<tf.Tensor: shape=(2, 3), dtype=float32, numpy=
array([[0.09003057, 0.24472848, 0.66524094],
       [0.01321289, 0.26538792, 0.7213992 ]], dtype=float32)>
```

然后，再利用上述张量运算，自己实现softmax，并对比二者的计算结果

```python
>>> exp = tf.exp(x)
>>> exp / tf.reduce_sum(exp, axis=-1, keepdims=True)
<tf.Tensor: shape=(2, 3), dtype=float32, numpy=
array([[0.09003057, 0.24472848, 0.66524094],
       [0.01321289, 0.26538792, 0.7213992 ]], dtype=float32)>
```