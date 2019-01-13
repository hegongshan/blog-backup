---
title: 矩阵求导
date: 2018-08-17 14:07:11
tags: 线性代数
categories: 机器学习
mathjax: true
---

最近在学习机器学习的时候，经常会碰到矩阵求导，这里记录下矩阵的求导操作。

向量和矩阵的导数满足乘法法则（product rule）
$$
\frac {\partial x^{T} \alpha}{ \partial x } = \frac {\partial \alpha^{T} x }{ \partial x } = \alpha
$$

$$
\frac {\partial AB} {\alpha x} = \frac{\partial A} {\partial x} B + A \frac{\partial B} {\partial x}
$$

<!--more-->

由于$A^{-1} A = I$和上式，逆矩阵的导数可表示为
$$
\frac {\partial A^{-1} } {\partial x} = - A^{-1} \frac {\partial A} {\partial x} A^{-1}
$$
证明：
$$
\begin{align}
\frac{\partial I} {\partial x} &= \frac{\partial A^{-1} A} {\partial x} \\\
&= \frac{\partial A} {\partial x} A^{-1} + A \frac{\partial  A^{-1} } {\partial x} \\\
&= 0
\end{align}
$$
从而，
$$
\begin{align}
&=> -A \frac{\partial  A^{-1} } {\partial x} =  \frac{\partial A} {\partial x} A^{-1} \\\
&=>  \frac{\partial A^{-1}} {\partial x} =  -A^{-1} \frac{\partial  A } {\partial x} A^{-1}
\end{align}
$$


