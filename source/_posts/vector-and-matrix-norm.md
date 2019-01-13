---
title: 向量和矩阵的范数
date: 2018-08-27 18:49:12
tags: 线性代数
categories: 机器学习
mathjax: true
---

阅读《机器学习》和《机器学习实战》的时候，都碰到过**范数（norm）**这个概念，这里记录一下。

<!--more-->

### 向量范数

* 定义

设V是数域P上的线性空间，$\lVert \alpha \rVert$是以V中的向量$\alpha$为自变量的非负实值函数，如果它满足以下三个条件：

（1）非负性：当$\alpha \neq 0$时，$\lVert \alpha \rVert > 0$；当$\alpha = 0$时，$\lVert \alpha \rVert = 0$；

（2）齐次性：对任意$k \in P，\alpha \in V$，有$\lVert k \alpha \rVert = \lvert k \rvert\ \lVert\alpha \rVert $；

（3）三角不等式：对任意$\alpha，\beta \in V$，有$\lVert \alpha + \beta \rVert \leq \lVert \alpha \rVert + \lVert \beta \rVert$，

则称$\lVert \alpha \rVert$ 为向量$\alpha$的**范数**，并称定义了范数的线性空间为**赋范线性空间**。

> 什么是数域？
>
> 设P是包含0和1在内的数集，如果P中任意两个数的和、差、积、商（除数不为0）仍是P中的数，则称P为一个**数域**。

* 常见的向量范数

在n维向量空间$C^n$中，对任意的向量$x = (x_1,x_2,\dots,x_n)^{T} \in C^{n} $,有
$$
\lVert x \rVert_{1} = \sum_{i=1}^{n} \lvert x_{i} \rvert \tag{1}
$$

$$
\lVert x \rVert_{2} = (\sum_{i=1}^{n} \lvert x_{i} \rvert^{2})^{\frac{1}{2}} \tag{2}
$$

$$
\lVert x \rVert_{\infty} = \max_{1 \leq i \leq n} \lvert x_{i} \rvert \tag{3}
$$

其中，$\lVert x \rVert_{1}、\lVert x \rVert_{2}、\lVert x \rVert_{\infty}$分别称为**1范数，2范数（Euclid范数或欧式范数）和$\infty$范数**。

对$1\leq p < +\infty$，在$C^{n}$上定义
$$
\lVert x \rVert_{p} = (\sum_{i=1}^{n} \lvert x_{i} \rvert^{p})^{\frac{1}{p}}，1 \leq p < +\infty \tag{4}
$$
$\lVert x \rVert_{p}$称为**p范数**。若未标明p，则默认为2范数。

### 矩阵范数

* 定义

设$\lVert \mathbf{A} \rVert$是以$C^{m \times n}$中的矩阵$\mathbf{A}$为自变量的非负实值函数，如果它满足以下三个条件：

（1）非负性：当$\mathbf{A} \neq 0$时，$\lVert \mathbf{A} \rVert> 0$；当$\mathbf{A}= 0$时，$\lVert \mathbf{A} \rVert = 0$；

（2）齐次性：对任意$k \in C，\mathbf{A} \in C^{m \times n}$，有$\lVert k \mathbf{A} \rVert = \lvert k \rvert\ \lVert A \rVert $；

（3）三角不等式：对任意$\mathbf{A}，\mathbf{B} \in C^{m \times n}$，有$\lVert \mathbf{A} + \mathbf{B} \rVert \leq \lVert \mathbf{A} \rVert + \lVert \mathbf{B} \rVert$，

则称$\lVert \mathbf{A} \rVert$ 为$m \times n$矩阵$\mathbf{A}$的**范数**。

* 常见的矩阵范数

对于$\mathbf{A} = (a_{ij}) \in \mathbf{C}^{m \times n}$，令
$$
\lVert \mathbf{A} \rVert_{1} \equiv \sum_{i=1}^{m}\sum_{j=1}^{n}\ \lvert a_{ij} \rvert \tag{5}
$$

$$
\lVert \mathbf{A} \rVert_{\infty} \equiv \max_{i,\ j}\ \lvert a_{ij} \rvert \tag{6}
$$

$$
\lVert \mathbf{A} \rVert_{F} \equiv (\sum_{i=1}^{m}\sum_{j=1}^{n}\ \lvert a_{ij} \rvert^{2})^{\frac{1}{2}}= (tr({\mathbf{A}^{H}\mathbf{A}}))^{\frac{1}{2}} \tag{7}
$$

其中，$\lVert \mathbf{A} \rVert_{F}$称为$\mathbf{A}$的**Frobenius范数**，$A^{H}$是$A$的共轭转置矩阵。

### 补充知识

1.复矩阵：元素中含有复数的矩阵。

2.共轭矩阵：

当$A=(a_{ij})$为复矩阵时，用 $ \overline{a} $ 表示 $a $的共轭复数，记 $\overline{A} = (\overline{a_{ji}})$，则$\overline{A}$为A的共轭矩阵。

例如，
$$
A = 
\begin{vmatrix}
3+i & 5\\\\
2-2i & i
\end{vmatrix}
$$
其共轭矩阵$\overline{A}$为
$$
\overline{A} = 
\begin{vmatrix}
3-i & 5 \\\\
2+2i & -i
\end{vmatrix}
$$
3.共轭转置矩阵

当$A=(a_{ij})$为复矩阵时，用 $ \overline{a} $ 表示 $a $的共轭复数，记 $\overline{A} = (\overline{a_{ji}})$，则$（\overline{A}）^{T} = \overline{A^{T}}$为A的共轭转置矩阵。

还是用上面的例子，
$$
(\overline{A})^{T}  =
\begin{vmatrix}
3-i & 5 \\\\
2+2i & -i
\end{vmatrix}^{T} 
 =
\begin{vmatrix}
3-i & 2+2i \\\\
5 & -i
\end{vmatrix}
$$


4.Hermite矩阵

n阶复方阵A的对称元素互为共轭，即A的共轭转置矩阵等于它本身，则A是Hermite矩阵。

例如，
$$
B = 
\begin{vmatrix}
3 & 2+i \\\\
2-i & 2
\end{vmatrix}
$$
B的共轭转置矩阵如下
$$
\overline{B}^{T} =
\begin{vmatrix}
3 & 2-i \\\\
2+i & 2
\end{vmatrix}^{T} 
=
\begin{vmatrix}
3 & 2+i \\\\
2-i & 2
\end{vmatrix} = B
$$
故，B是一个Hermite矩阵。

<hr>

参考资料

* 戴华，矩阵论，科学出版社