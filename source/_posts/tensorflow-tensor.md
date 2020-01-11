---
title: TensorFlow2张量操作
date: 2019-11-09 21:06:09
tags: deep learning
categories: deep learning
---

本文总结了TensorFlow2中常见的张量操作。

<!--more-->

* 逐元素相加

```python
tf.add(x,y,name=None)
```

示例：

```python
print(tf.add(1,2))
print(tf.add([1,2],[3,4]))
```



```python
tf.Tensor(3, shape=(), dtype=int32)
tf.Tensor([4 6], shape=(2,), dtype=int32)
```

* 逐元素相减



平方

tf.square(x,name=None)

示例：

```python
print(tf.square(5))
print(tf.square([1,2]))
```



```python
tf.Tensor(25, shape=(), dtype=int32)
tf.Tensor([1 4], shape=(2,), dtype=int32)
```

tf.pow()



tf.constant

创建常数常量

```python
tf.constant(
    value,
    dtype=None,
    shape=None,
    name='Const'
)
```

tf.zeros、tf.ones、tf.fill



tf.matmul



tf.reduce_sum()



tf.tile



### 与NumPy ndarray的相互转换



TensorFlow numpy()



tf.Variable



tf.cast