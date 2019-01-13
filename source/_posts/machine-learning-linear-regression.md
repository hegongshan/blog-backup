---
title: 机器学习之线性回归
date: 2018-08-17 15:34:42
tags: 机器学习
categories: 机器学习
mathjax: true
---

线性回归（linear regression），就是将输入项分别乘以一些常量，再将结果加起来得到预测值，而这些常量称之为回归系数。

线性回归可以用如下的等式来表示：
$$
Y = X^{T} w
$$
其中，$Y$为预测值，$X$为输入值，$w$是一个包含回归系数的向量

<!--more-->

已知$X$和对应的$Y$，怎么才能找到$w$呢？一个常用的方法就是找出使误差最小的$w$。这里的误差是指预测Y值和真实Y值之间的差值，使用该误差的简单累加将使得正差值和负差值相互抵消，为了避免这种情况，可以使用平方误差。

平方误差可写为：
$$
\sum_{i=1}^{m} (y_i - x_i ^{T} w) ^2
$$
若用矩阵表示，则可写为：
$$
(Y - X w)^{T} (Y - Xw)
$$
令
$$
\begin{align}
f(w) &= (Y - X w)^{T} (Y - Xw) \\\
&= Y^{T} Y - Y^{T} X w - w^{T} X^{T} Y + w^{T} X^{T} X w \\\
\end{align}
$$
f(w) 对$w$求导，得到
$$
\begin{align}
\frac{\partial f(w)}{\partial w} &= \frac{\partial (Y^{T} Y)} {\partial w} - \frac{\partial ( Y^{T} X w)} {\partial w} - \frac{\partial (w^{T} X^{T} Y)} {\partial w} + \frac{\partial (w^{T} X^{T} X w )} {\partial w} \\\
&= 0 - X^{T} Y -  X^{T} Y + 2 X^{T} X w \\\
&= 2 X^{T} (Xw - Y)
\end{align}
$$
令$\frac{\partial f(w)}{\partial w} = 0$，则
$$
X^{T} (X w - Y) = 0 \\\
=> X^{T} X w = X^{T} Y \\\
$$
两边左乘$(X^{T}X)^{-1}$，得
$$
\hat w = (X^{T} X )^{-1} X^{T} Y
$$


