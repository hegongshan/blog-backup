---
title: 数学基础——各种矩阵
date: 2020-09-28 21:14:49
tags: mathematics
categories: mathematics
mathjax: true
---

本文回顾了常见的各类矩阵。

<!--more-->

### 单位矩阵

主对角线上的元素都为1，其余元素全为0的n阶矩阵称为n阶**单位矩阵（Identity Matrix）**，记为$\mathbf{I}_n$或$\mathbf{E}_n$，通常用$\mathbf{I}$或$\mathbf{E}$表示。
$$
\mathbf{I}_n = 
\begin{bmatrix}
1 & 0 & \cdots & 0 \\\\
0 & 1 & \cdots & 0 \\\\
\vdots & \vdots & \ddots & \vdots \\\\
0 & 0 & \cdots & 1
\end{bmatrix}
$$

NumPy：使用np.eye()函数生成单位矩阵

```python
>>> import numpy as np
>>> np.eye(3, dtype=int)
array([[1, 0, 0],
       [0, 1, 0],
       [0, 0, 1]])
```

### 对角矩阵

对角矩阵（Diagonal Matrix）
$$
\mathbf{A} = 
\begin{bmatrix}
a_1 & & & \\\\
& a_2 & & \\\\
& & \ddots & \\\\
& & & a_n
\end{bmatrix}
$$

### 对称矩阵

对称矩阵（Symmetric Matrix）：以主对角线为对称轴，各元素对应相等的矩阵。

### 三角矩阵

### 转置矩阵

transposed matrix

设$\mathbf{A} = (a_{ij})_{m \times n}$，$\mathbf{A}$的转置矩阵$\mathbf{A}^T$为
$$
\mathbf{A}^T =
\begin{bmatrix}
a_{11} & a_{21} & \cdots & a_{m1} \\\\
a_{12} & a_{22} & \cdots & a_{m2} \\\\
\vdots & \vdots & & \vdots \\\\
a_{1n} & a_{2n} & \cdots & a_{mn}
\end{bmatrix}
$$

示例：
$$
\mathbf{A} = 
\begin{bmatrix}
0 & 1 & 2 \\\\
3 & 4 & 5
\end{bmatrix}, 
\mathbf{A}^T = 
\begin{bmatrix}
0 & 3 \\\\
1 & 4 \\\\
2 & 5
\end{bmatrix}
$$
NumPy：使用**类numpy.ndarray的属性T**，或者使用**np.transpose()函数**

```python
>>> import numpy as np
>>> x = np.array([[0, 1, 2], [3, 4, 5]])
>>> type(x)
<class 'numpy.ndarray'>
>>> x.T
array([[0, 3],
       [1, 4],
       [2, 5]])
>>> np.transpose(x)
array([[0, 3],
       [1, 4],
       [2, 5]])
```

### 逆矩阵

设$\mathbf{A} = (a_{ij})_{n \times n}$，$\mathbf{A}$的逆矩阵$\mathbf{A}^{-1}$为
$$
\mathbf{A} \mathbf{A}^{-1} = \mathbf{E}
$$

示例：
$$
\begin{bmatrix}
1 & 2 \\\\
3 & 4
\end{bmatrix}
\times
\begin{bmatrix}
-2 & 1 \\\\
3/2 & -1/2
\end{bmatrix}
=
\begin{bmatrix}
1 & 0 \\\\
0 & 1
\end{bmatrix}
$$
NumPy：使用**np.linalg.inv()**求逆矩阵

```python
>>> import numpy as np
>>> x = np.array([[1, 2], [3, 4]])
>>> np.linalg.inv(x)
array([[-2. ,  1. ],
       [ 1.5, -0.5]])
```

### 复矩阵



### 共轭矩阵

$$
\overline{A} = 
$$



### 共轭转置矩阵



### 厄米特矩阵



### 酉矩阵



### 正定矩阵

(正在完善中...)