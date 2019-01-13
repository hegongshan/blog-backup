---
title: 序列最小最优化算法SMO
date: 2018-07-28 19:33:13
tags: 机器学习
categories: 机器学习
mathjax: true
---

如何高效地实现支持向量机学习呢？常用的是1998年Platt提出的序列最小最优化算法(Sequential minimal optimization，SMO)算法。

SMO算法要解的是如下的一个最优化问题：
$$
\min_{\alpha} \left( \frac{1}{2} \sum_{i=1}^N \sum_{j=1}^N \alpha_i \alpha_j y_i y_j K(x_i,x_j) - \sum_{i=1}^N \alpha_i\right) \tag{1} 
$$

$$
subject \; to \sum_{i=1}^N \alpha_i y_i = 0, \tag{2}
$$

$$
0 \leq \alpha_i \leq C, \forall i \tag{3}
$$

整个SMO算法包括两个部分：求解两个变量二次规划的解析方法和选择变量的启发式方法。

<!--more-->

### 两个变量二次规划的求解方法

假设选择的两个变量是$\alpha_1,\alpha_2$，其他变量$\alpha_i (i=3,4,\dots,N)$是固定的。因此，上面的最优化问题(1)~(3)的子问题可写为
$$
\min_{\alpha_1,\alpha_2} G(\alpha_1,\alpha_2) = \frac{1}{2} K_{11} \alpha_1^2 + \frac{1}{2} K_{22} \alpha_2^2 + y_1 y_2 K_{12} \alpha_1 \alpha_2 - (\alpha_1 + \alpha_2) + \\\
y_1 \alpha_1 \sum_{i=3}^{N} y_i \alpha_i K_{i1} + y_2 \alpha_2 \sum_{i=3}^{N} y_i \alpha_i K_{i2} \tag{4}
$$

$$
subject \; to \; \alpha_1 y_1 + \alpha_2 y_2 = - \sum_{i=3}^{N} y_i \alpha_i = \beta, \tag{5}
$$

$$
0 \leq \alpha_i \leq C, \forall i \tag{6}
$$

其中，$K_{ij} = K(x_i,x_j) ,i,j = 1,2, \dots ,N$，（４）中省略了不含$\alpha_1,\alpha_2$的常数项。

由于只有两个变量$(\alpha_1,\alpha_2)$，约束可以用二维空间中的图形表示。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/28/20180728202502.png)

不等式约束（6）使得$（\alpha_1,\alpha_2）$在区域 [0, C] x [0, C] 内，等式约束（５）使得$（\alpha_1,\alpha_2）$在平行于区域 [0, C] x [0, C] 的对角线的直线上。因此要求的是目标函数在一条平行于对角线的线段上的最优值。这使得两个变量的最优化问题成为实质上的单变量的最优化问题，不妨考虑为变量$\alpha_2$的最优化问题。

假设问题（４）～（６）的初始可行解为$\alpha_1,\alpha_2$，最优解为$\alpha_1^{new},\alpha_2^{new}$，沿着约束方向经剪辑后$\alpha_2$的最优解为$\alpha_2^{new,clipped}$。

由于$\alpha_2^{new}$满足不等式约束（５），所以最优值$\alpha_2^{new}$的取值范围必须满足条件
$$
L \leq \alpha_2^{new} \leq H
$$
其中，L与H分别是$\alpha_2^{new}$所在的对角线段端点的下、上界。

如果$y_1 \neq y_2$ ，则
$$
L = \max (0, \alpha_2 - \alpha_1)，H = \min ( C, C + \alpha_2 - \alpha_1  ) \tag{7}
$$
如果$y_i = y_2$，则
$$
L = \max (0, \alpha_2 + \alpha_1 - C)，H = \min ( C,  \alpha_2 + \alpha_1  ) \tag{8}
$$
 记
$$
w(x) = \sum_{i=1}^{N} \alpha_i y_i K(x_i,x) + b \tag{9}
$$
令
$$
E_i = w(x_i) - y_i = \left (   \sum_{i=1}^{N} \alpha_i y_i K(x_i,x) + b \right) - y_i, i = 1,2, \tag{10}
$$
当i = 1, 2时，$E_i$为函数w(x)对输入$x_i$的预测值与真实输出$y_i$之间的误差。

由
$$
\alpha_1 y_1 + \alpha_2 y_2 = \beta　及 　y_i^2 = 1
$$
$\alpha_1$可表示为
$$
\alpha_1 = ( \beta - y_2 \alpha_2 ) y_1 \tag{11}
$$
代入（４）中，得到仅含$\alpha_2$的目标函数：
$$
G(\alpha_2) = \frac{1}{2} K_{11} ( \beta - y_2 \alpha_2 )^2 + \frac{1}{2} K_{22} \alpha_2^2 + y_2 K_{12} ( \beta - y_2 \alpha_2 ) \alpha_2 -  ( \beta - y_2 \alpha_2 )y_1 - \alpha_2 + \\\
( \beta - y_2 \alpha_2 ) \sum_{i=3}^{N} y_i \alpha_i K_{i1} + y_2 \alpha_2 \sum_{i=3}^{N} y_i \alpha_i K_{i2}
$$
对$\alpha_2$求导数，并令其为 0
$$
\frac {\partial G} {\partial \alpha_2}  = K_{11}( \alpha_2 - \beta y_2) + K_{22} \alpha_2 + y_2 K_{12} (\beta - 2 y_2 \alpha_2) + \\\
y_1 y_2 -1 -  y_2 \sum_{i=3}^{N} y_i \alpha_i K_{i1} + y_2 \sum_{i=3}^{N} y_i \alpha_i K_{i2} = 0
$$

$$
\begin{align}
=> ( K_{11} +K_{22} -2 K_{12} ) \alpha_2 &= y_2 ( y_2 - y_1 + \beta K_{11} - \beta K_{12} + \sum_{i=3}^{N} y_i \alpha_i K_{i1} - \sum_{i=3}^{N} y_i \alpha_i K_{i2} ) \\\
&= y_2 [ y_2 - y_1 + \beta K_{11} - \beta K_{12} + \left(  w(x_1) - \sum_{j=1}^{2} y_j \alpha_j K_{1j}  - b \right) \\\
& - \left(  w(x_2) - \sum_{j=1}^{2} y_j \alpha_j K_{2j} - b \right) ]
\end{align}
$$

将$\beta = \alpha_1 y_1 + \alpha_2 y_2 $代入，得到
$$
\begin{align}
( K_{11} +K_{22} -2 K_{12} ) \alpha_2^{new} &= y_2 \left ( y_2 - y_1 + (\alpha_1 y_1 + \alpha_2 y_2) K_{11} - (\alpha_1 y_1 + \alpha_2 y_2) K_{12} + \\\
w(x_1) - w(x_2) \tag {12}  - y_1 \alpha_1 K_{11} - y_2 \alpha_2 K_{12} + y_1 \alpha_1 K_{21} + y_2 \alpha_2 K_{22} \right) \\\
& = y_2 \left( E_1 - E_2 + \alpha_2 y_2 (K_{11} - 2 K_{12} + K_{22}) \right) \\\
& = \alpha_2 (K_{11} - 2 K_{12} + K_{22}) + y_2(E_1 - E_2)
\end{align}
$$
令
$$
\eta = K_{11} - 2 K_{12} + K_{22} \tag{13}
$$
将$\eta$代入（１２）
$$
\eta \alpha_2^{new} = \alpha_2 \eta + y_2 (E_1 - E_2) \\\
=> \alpha_2^{new} = \alpha_2 + \frac {y_2 (E_1 - E_2)}{\eta} \tag {14}
$$
要将$\alpha_2^{new}$限制在区间[L, H]中 ，则
$$
\alpha_2^{new,clipped} =  
\begin{cases}
H, & \alpha_2^{new} > H \\\
\alpha_2^{new}, & L \leq \alpha_2^{new} \leq H \\\
L, &  \alpha_2^{new} < L
\end{cases} \tag {15}
$$
由式（５）可得
$$
\alpha_1 y_1 + \alpha_2 y_2 = \alpha_1^{new} y_1 + \alpha_2^{new,clipped} y_2
$$
两边同乘以$y_1$，得
$$
\alpha_1 + \alpha_2 y_1 y_2 = \alpha_1^{new} + \alpha_2^{new,clipped} y_1 y_2
$$
从而，
$$
\alpha_1^{new} = \alpha_1 + y_1 y_2 ( \alpha_2^{new,clipped} - \alpha_2)　\tag{16}
$$
故，最优化问题（４）～（６）的解为$（\alpha_1^{new},\alpha_2^{new,clipped}）$

（未完待续。。。）