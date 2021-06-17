---
title: 数学基础——矩阵乘积
date: 2020-09-23 15:12:30
tags: mathematics
categories: mathematics
mathjax: true
---

科研人必知必会的几种矩阵乘积。

<!--more-->

### 矩阵乘法

设 $\mathbf{A} = (a_{ij})_{m \times n},  \mathbf{B} = (b_{ij})_{n \times p}$
$$
\mathbf{A}_{m \times n} \times \mathbf{B}_{n \times p} = (\sum_{j=1}^n a_{ij} b_{jk})_{m \times p} \tag{1}
$$
示例：
$$
\begin{bmatrix}
1 & 2 & 3 \\\\
4 & 5 & 6
\end{bmatrix}
\times
\begin{bmatrix}
4 & 5 \\\\
6 & 7 \\\\
8 & 9
\end{bmatrix}
= 
\begin{bmatrix}
1 \times 4 + 2 \times 6 + 3 \times 8 & 1 \times 5 + 2 \times 7 + 3 \times 9 \\\\
4 \times 4 + 5 \times 6 + 6 \times 8 & 4 \times 5 + 5 \times 7 + 6 \times 9
\end{bmatrix}
=
\begin{bmatrix}
40 & 46 \\\\
94 & 109
\end{bmatrix}
$$

* NumPy：使用**np.matmul()**或者**@运算符**

```python
>>> import numpy as np
>>> x = np.array([[1, 2, 3], 
                  [4, 5, 6]])
>>> y = np.array([[4, 5], 
                  [6, 7], 
                  [8, 9]])
>>> np.matmul(x, y)
array([[ 40,  46],
       [ 94, 109]])
>>> x @ y
array([[ 40,  46],
       [ 94, 109]])
```

* TensorFlow：使用**tf.matmul()**或者**@运算符**

```python
>>> import tensorflow as tf
>>> x = tf.constant([[1, 2, 3],
                     [4, 5, 6]])
>>> y = tf.constant([[4, 5], 
                     [6, 7], 
                     [8, 9]])
>>> tf.matmul(x,y)
<tf.Tensor: shape=(2, 2), dtype=int32, numpy=
array([[ 40,  46],
       [ 94, 109]], dtype=int32)>
>>> x @ y
<tf.Tensor: shape=(2, 2), dtype=int32, numpy=
array([[ 40,  46],
       [ 94, 109]], dtype=int32)>
```

### 哈达玛积

设 $\mathbf{A} ,\mathbf{B} \in \mathbb{C}^{m \times n}$，$\mathbf{A}$和$\mathbf{B}$的哈达玛积（Hadamard Product）$\mathbf{A} \circ \mathbf{B}$定义为
$$
\mathbf{A} \circ \mathbf{B}
=(a_{ij} \times b_{ij})_{m \times n}
=
\begin{bmatrix}
a_{11} b_{11} & a_{12} b_{12} & \cdots & a_{1n} b_{1n} \\\\
a_{21} b_{21} & a_{22} b_{22} & \cdots & a_{2n} b_{2n} \\\\
\vdots & \vdots & & \vdots \\\\
a_{m1} b_{m1} & a_{m2} b_{m2} & \cdots & a_{mn} b_{mn}
\end{bmatrix} \tag{2}
$$
示例：
$$
\begin{bmatrix}
1 & 2 & 3 \\\\
4 & 5 & 6
\end{bmatrix}
\circ
\begin{bmatrix}
4 & 5 & 6 \\\\
7 & 8 & 9
\end{bmatrix}
=
\begin{bmatrix}
1 \times 4 & 2 \times 5 & 3 \times 6 \\\\
4 \times 7 & 5 \times 8 & 6 \times 9
\end{bmatrix}
=
\begin{bmatrix}
4 & 10 & 18 \\\\
28 & 40 & 54
\end{bmatrix}
$$

* Numpy：使用**np.multiply()**或者***运算符**

```python
>>> import numpy as np
>>> x = np.array([[1, 2, 3], [4, 5, 6]])
>>> y = np.array([[4, 5, 6], [7, 8, 9]])
>>> np.multiply(x, y)
array([[ 4, 10, 18],
       [28, 40, 54]])
>>> x * y
array([[ 4, 10, 18],
       [28, 40, 54]])
```

* TensorFlow：使用**tf.multiply()**或者***运算符**

```python
>>> import tensorflow as tf
>>> x = tf.constant([[1, 2, 3], [4, 5, 6]])
>>> y = tf.constant([[4, 5, 6], [7, 8, 9]])
>>> tf.multiply(x, y)
<tf.Tensor: shape=(2, 3), dtype=int32, numpy=
array([[ 4, 10, 18],
       [28, 40, 54]], dtype=int32)>
>>> x * y
<tf.Tensor: shape=(2, 3), dtype=int32, numpy=
array([[ 4, 10, 18],
       [28, 40, 54]], dtype=int32)>
```

### 克罗内克积

设 $\mathbf{A} \in \mathbb{C}^{m \times n},\mathbf{B} \in \mathbb{C}^{p \times q}$，称如下的分块矩阵
$$
\mathbf{A} \otimes \mathbf{B} 
= 
\begin{bmatrix}
a_{11} \mathbf{B} & a_{12} \mathbf{B} & \cdots & a_{1n} \mathbf{B} \\\\
a_{21} \mathbf{B} & a_{22} \mathbf{B} & \cdots & a_{2n} \mathbf{B} \\\\
\vdots & \vdots & & \vdots \\\\
a_{m1} \mathbf{B} & a_{m2} \mathbf{B} & \cdots & a_{mn} \mathbf{B}
\end{bmatrix} \tag{3}
$$
为$\mathbf{A}$与$\mathbf{B}$的克罗内克积（Kronecker Product）或直积。

示例：设$\mathbf{A}=\begin{bmatrix} 1 & 2 \\\\ 3 & 4 \end{bmatrix}$，$\mathbf{B} = \begin{bmatrix}2 & -1 \end{bmatrix}$，则
$$
\mathbf{A}
\otimes
\mathbf{B}
=
\begin{bmatrix}
\mathbf{B} & 2 \mathbf{B} \\\\
3 \mathbf{B} & 4 \mathbf{B}
\end{bmatrix}
=
\begin{bmatrix}
2 & -1 & 4 & -2 \\\\
6 & -3 & 8 & -4
\end{bmatrix}
$$

* NumPy：使用**np.kron()**

```python
>>> import numpy as np
>>> x = np.array([[1, 2], [3, 4]])
>>> y = np.array([2, -1])
>>> np.kron(x, y)
array([[ 2, -1,  4, -2],
       [ 6, -3,  8, -4]])
```

