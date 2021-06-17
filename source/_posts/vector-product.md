---
title: 向量乘法
date: 2020-01-14 20:03:03
tags: mathematics
categories: mathematics
mathjax: true
---

在阅读相关论文时，总能看到各种向量乘法，包括內积、哈达玛积等。本文对向量的各种乘法运算进行了总结和梳理。

<!--more-->

假设$\mathbf{a} \in \mathbb{R}^n, \mathbf{b} \in \mathbb{R}^n$

### 点积

点积（dot product），又称内积（inner product）、标量积（scalar product）、数量积。
$$
\mathbf{a} \cdot \mathbf{b} = \mathbf{a}^T \mathbf{b} = \sum_{i=1}^n a_i \times b_i \tag{1}
$$

几何意义：
$$
\mathbf{a} \cdot \mathbf{b} = \lVert \mathbf{a} \rVert \times \lVert \mathbf{b} \rVert \times \cos \theta \tag{2}
$$

### 哈达玛积

哈达玛积（element-wise product或者hadamard product）
$$
\mathbf{a} \odot \mathbf{b} = 
\begin{bmatrix}
a_1 \times b_1 \\\\
a_2 \times b_2 \\\\
\cdots \\\\
a_n \times b_n
\end{bmatrix} \tag{3}
$$

### 向量积

向量积，又称叉积（cross product）、**外积**（exterior product）。
$$
\begin{align}
\mathbf{a} \times \mathbf{b}
&= 
\begin{vmatrix}
\vec{i} & \vec{j} & \vec{k} \\\\
a_x & a_y & a_z \\\\
b_x & b_y & b_z
\end{vmatrix} \\\\
&= (a_y \times b_z - a_z \times b_y) \mathbf{i} + (a_z \times b_x - a_x \times b_z) \mathbf{j} + (a_x \times b_y - a_y \times b_x) \mathbf{k}
\end{align} \tag{4}
$$
几何意义：
$$
\lVert \mathbf{a} \times \mathbf{b} \rVert = \lVert \mathbf{a} \rVert \times \lVert \mathbf{b} \rVert \times \sin \theta \tag{5}
$$

### 张量积

张量积（tensor product），又称**外积**（outer product）。
$$
\mathbf{a} \otimes \mathbf{b}
= \mathbf{a} \mathbf{b}^T
= \begin{bmatrix}
a_1 \times b_1 & a_1 \times b_2 & \cdots & a_1 \times b_n \\\\
a_2 \times b_1 & a_2 \times b_2 & \cdots & a_2 \times b_n \\\\
\vdots & \vdots & \vdots & \vdots \\\\
a_n \times b_1 & a_n \times b_2 & \cdots & a_n \times b_n 
\end{bmatrix} \tag{6}
$$

