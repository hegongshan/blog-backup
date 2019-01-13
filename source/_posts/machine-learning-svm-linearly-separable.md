---
title: 线性可分支持向量机
date: 2018-07-16 19:08:48
tags: 机器学习
categories: 机器学习
mathjax: true
---

### 线性可分支持向量机

分离超平面
$$
\mathbf w \cdot \mathbf x +b = 0　\tag {1}
$$

其中，w为分离超平面的法向量，b为截距

分类决策函数
$$
f(x) = sign(\mathbf w \cdot \mathbf x +b)
$$
其中，sign()称为符号函数，
$$
sign(x) =
\begin{cases}
-1, & x < 0 \\\
0, & x = 0 \\\
1, & x > 0
\end{cases}
$$
<!--more-->

### 函数间隔

定义：对于给定的训练数据集T和超平面(w,b)，定义超平面(w,b)关于样本点($x_i,y_i$)的函数间隔为
$$
\hat \gamma_i = y_i ( w \cdot x_i + b)
$$
定义超平面(w,b)关于训练数据集T的函数间隔为超平面(w,b)关于T中所有样本点($x_i,y_i$)的函数间隔之最小值，即
$$
\hat \gamma  = \min_{i=1,\dots,N} \hat \gamma_i
$$

### 几何间隔

定义：对于给定的训练数据集T和超平面(w,b)，定义超平面(w,b)关于样本点($x_i,y_i$)的几何间隔为
$$
\gamma_i = y_i \frac {w \cdot x_i + b}{||w||}
$$
定义超平面(w,b)关于训练数据集T的几何间隔为超平面(w,b)关于T中所有样本点($x_i,y_i$)的几何间隔之最小值，即
$$
\gamma = \min_{i=1,\dots,N} \gamma_i
$$
超平面（w，b）关于样本点（$x_i,y_i$）的几何间隔是`实例点到超平面的带符号的距离`。

函数间隔和几何间隔有如下关系：
$$
\gamma_i = \frac{\hat \gamma_i}{||w||}
$$

$$
\gamma = \frac{\hat \gamma}{||w||}
$$

若||w||=1，则函数间隔和几何间隔相等。如果超平面参数w和b成比例地改变（超平面没有改变），函数间隔也会按比例改变，而几何间隔不变。

### 间隔最大化

如何求得几何间隔最大的分离超平面，即最大间隔分离超平面呢？可用下面的约束最优化问题来表示
$$
\max_{w,b} \gamma \\\
s.t. y_i \frac{w \cdot x_i +b }{||w||} \geq \gamma, i=1,2,\dots,N
$$
约束条件表示超平面(w,b)关于每个训练样本点的几何间隔至少是$\gamma$

根据函数间隔和几何间隔的关系，上面的问题可写为
$$
\max_{w,b} \frac{\hat \gamma}{||w||}
$$

$$
s.t. y_i ( w \cdot x_i +b ) \geq \hat \gamma, i=1,2,\dots,N
$$

*函数间隔$\hat \gamma$的取值并不影响最优化问题的解*。因为将w和b按比例改变为$\lambda w 和\lambda b$，这时函数间隔变为$\lambda \hat \gamma$，函数间隔的改变对上面的最优化问题的不等式约束没有影响，对目标函数的优化也没有影响。

不妨取$\hat \gamma = 1$，将其代入上面的最优化问题，得$\max_{w,b} \frac{1}{||w||}$，又最大化$\frac{1}{||w||}$等价于最小化$\frac{1}{2}||w||^2$。

故得到了下面的线性可分支持向量机学习的最优化问题
$$
\min_{w,b} \frac{1}{2}||w||^2
$$

$$
s.t. y_i ( w \cdot x_i +b ) - 1 \geq 0, i = 1,2,\dots,N
$$

对式（4）使用拉格朗日乘数法（Lagrange multipliers）可得到其“对偶问题”(dual problem)。对式（4）的每条约束添加拉格朗日乘数$\alpha_i \geq 0$，则该问题的拉格朗日函数可写为
$$
L(w,b,\alpha) = \frac{1}{2}||w||^2 + \sum_{i=1}^{m} \alpha_i (1-y_i(w \cdot x_i +b)) \tag{5}，\\\
其中 \alpha = (\alpha_i,\alpha_2,\dots,\alpha_m)^T
$$
令L(w,b,$\alpha$)对w和b的偏导数为零，
$$
\begin{align}
& \frac{\partial L}{\partial w} = w - \sum_{i=1}^{m} \alpha_i y_i \mathbf x_i = 0\\\
& \frac{\partial L}{\partial b} = -\sum_{i=1}^{m} \alpha_i y_i = 0
\end{align}
$$
从而，
$$
w =  \sum_{i=1}^{m} \alpha_i y_i \mathbf x_i \tag {6}
$$

$$
0 = \sum_{i=1}^{m} \alpha_i y_i \tag {7}
$$

将式（6）、（7）代入式（5）中，得：
$$
\begin{align}
L(w,b,\alpha) & = \frac{1}{2}  \sum_{i=1}^{m} \alpha_I y_i \mathbf x_i^T   \sum_{j=1}^{m} \alpha_j y_j \mathbf x_j + \sum_{i=1}^{m} \alpha_i ( 1 - y_i( \mathbf x_i \sum_{j=1}^{m} \alpha_j y_j \mathbf x_j^T + b) )\\\
& =\sum_{i=1}^{m} \alpha_i - \frac{1}{2}\sum_{i=1}^{m} \sum_{j=1}^{m} \alpha_i \alpha_j y_i y_j \mathbf x_i^T x_j
\end{align}
$$

故，式(4)的对偶问题为
$$
\max_\alpha [ \sum_{i=1}^{m} \alpha_i - \frac{1}{2}\sum_{i=1}^{m} \sum_{j=1}^{m} \alpha_i \alpha_j y_i y_j (\mathbf x_i \cdot \mathbf x_j) ] \tag{8} \\\
s.t. \sum_{i=1}^{m} \alpha_i y_i = 0,\\\
\alpha_i \geq 0, i = 1,2,\dots,m
$$
### 例题

已知一个训练数据集，其正例点是$x_1 = (3,3),x_2 = (4,3)$,负例点是$x_3 = (1,1)$，求线性可分支持向量机。

**解：**对偶问题是
$$
\min_\alpha  \left ( \frac{1}{2}\sum_{i=1}^{m} \sum_{j=1}^{m} \alpha_i \alpha_j y_i y_j (\mathbf x_i \cdot \mathbf x_j) - \sum_{i=1}^{m} \alpha_i \right) \\\
=  \frac{1}{2}(18 \alpha_1^2+25 \alpha_2^2 + 2 \alpha_3^2 + 42\alpha_1 \alpha_2 - 12 \alpha_1 \alpha_3 - 14 \alpha_2 \alpha_3) -\alpha_1 - \alpha_2 - \alpha_3 \\\
s.t. \alpha_1 + \alpha_2 - \alpha_3 = 0 \\\
\alpha_i \geq 0 , i = 1,2,3
$$
将$\alpha_3 = \alpha_1 + \alpha_2$代入目标函数并记为
$$
s(\alpha_1,\alpha_2) = 4 \alpha_1^2 + \frac{13}{2} \alpha_2^2 + 10 \alpha_1 \alpha_2 - 2 \alpha_1 - 2 \alpha_2
$$

对$\alpha_1,\alpha_2$求偏导数，并其为0
$$
\frac{\partial s}{\partial \alpha_1} = 8 \alpha_1 + 10 \alpha_2 - 2 = 0\\\
\frac{\partial s}{\partial \alpha_2} = 13 \alpha_2 + 10 \alpha_1 - 2 = 0
$$
联立上式，解得：
$$
\alpha_1 = \frac{3}{2}, \alpha_2 = -1
$$
从而，$s(\alpha_1,\alpha_2)在（\frac{3}{2}, -1）$取极值，但该点不满足约束条件$\alpha_2 \geq 0$，所以最小值应在边界上取得。

当$\alpha_1 = 0$时，
$$
\begin{align}
s(\alpha_2) &= \frac{13}{2} \alpha_2^2 - 2 \alpha_2 \\\
&=  \frac{13}{2} (\alpha_2^2 - \frac{4}{13} \alpha_2) \\\
&=  \frac{13}{2} (\alpha_2 - \frac{2}{13})^2 - \frac{2}{13}
\end{align}
$$
显然，当$\alpha_2 = \frac{2}{13}$时，$s(\alpha_1,\alpha_2)$取得最小值$s(0,\frac{2}{13}) = - \frac{2}{13}$。

同理可得，当$\alpha_2 = 0$时，$s(\alpha_1,\alpha_2)$的最小值$s(\frac{1}{4},0) = - \frac{1}{4}$。

故，$s(\alpha_1,\alpha_2)$在$\alpha_1 = \frac{1}{4} ,\alpha_2 = 0)$处达到最小，此时，$\alpha_3 = \frac{1}{4}$

因此，$\alpha_1^\* = \alpha_3^\* = \frac{1}{4}$对应的实例点$x_1,x_3$是支持向量。
$$
\begin{align}
w_1^{\*} & = \alpha_1^{\*} y_1 x_{11} + \alpha_3^{\*} y_3 x_{31}\\\
&=\frac{1}{4} \times 1 \times 3 + \frac{1}{4} \times (-1) \times 1\\\
&=\frac{1}{2}
\end{align}
$$
同理可得，
$$
w_2^\* = \alpha_1^\* y_1 x_{12} + \alpha_3^\* y_3 x_{32} =\frac{1}{2}
$$

$$
\begin{align}
b^\* &= y_1 - [ \alpha_1^\*y_1(x_1 \cdot x_1)  + \alpha_3^\*y_3(x_3 \cdot x_1)] \\\
&= 1 - \left( \frac{1}{4} \times 1 \times [ (3,3) \cdot (3,3) ] + \frac{1}{4} \times (-1) \times [(1,1) \cdot (3,3) \right) \\\
&= -2
\end{align}
$$

故，分离超平面为
$$
\frac{1}{2}x^{(1)} + \frac{1}{2} x^{(1)} - 2 = 0
$$
分类决策函数为
$$
f(x) = sign \left( \frac{1}{2}x^{(1)} + \frac{1}{2} x^{(1)} - 2 \right)
$$

（未完待续。。。）
