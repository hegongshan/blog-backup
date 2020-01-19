---
title: 向量乘法
date: 2020-01-14 20:03:03
tags: mathematics
categories: mathematics
mathjax: true
---

向量乘法

<!--more-->

假设$\mathbf{a} \in \mathbb{R}^n, \mathbf{b} \in \mathbb{R}^n$

### 内积

内积（inner product或者dot product）
$$
\mathbf{a} \cdot \mathbf{b} = \mathbf{a}^T \mathbf{b} = \sum_{i=1}^n a_i \times b_i \tag{1}
$$

### 逐元素相乘

逐元素相乘（element-wise product）
$$
\mathbf{a} \odot \mathbf{b} = 
\begin{bmatrix}
a_1 \times b_1 \\\\
a_2 \times b_2 \\\\
\cdots \\\\
a_n \times b_n
\end{bmatrix} \tag{2}
$$

### 外积

外积（outer product）
$$
\mathbf{a} \otimes \mathbf{b}
= \mathbf{a} \mathbf{b}^T
= \begin{bmatrix}
a_1 \times b_1 & a_1 \times b_2 & \cdots & a_1 \times b_n \\\\
a_2 \times b_1 & a_2 \times b_2 & \cdots & a_2 \times b_n \\\\
\vdots & \vdots & \vdots & \vdots \\\\
a_n \times b_1 & a_n \times b_2 & \cdots & a_n \times b_n 
\end{bmatrix} \tag{3}
$$

