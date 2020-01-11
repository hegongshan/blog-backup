---
title: 论文阅读 Fast Matrix Factorization for Online Recommendation with Implicit Feedback
date: 2019-12-04 18:35:49
tags: recommender systems
categories: recommender systems
mathjax: true
---


$$
\hat r_{ui} = <\mathbf{p}_u, \mathbf{q}_i> = \mathbf{p}_u^T \mathbf{q}_i \tag{1}
$$
biasedMF
$$
\hat r_{ui} = b_u + b_i + <\mathbf{p}_u^B, \mathbf{q}_i^B> 
$$
令$\mathbf{p}_u \leftarrow [\mathbf{p}_u^B, b_u, 1]$，$\mathbf{q}_i \leftarrow [\mathbf{p}_u^B, 1, b_i]$

从而，可以将带偏置的矩阵分解归入式
$$
\hat r_{ui} = b_u + b_i + <\mathbf{p}_u^B, \mathbf{q}_i^B>
=
\begin{bmatrix}
\mathbf{p}_u^B & b_u & 1
\end{bmatrix}
\begin{bmatrix}
\mathbf{p}_u^B \\\\
1 \\\\
b_i
\end{bmatrix}
= \mathbf{p}_u^T \mathbf{q}_i 
$$
目标函数：
$$
L = \sum_{u=1}^M \sum_{i=1}^N w_{ui} (r_{ui} - \hat r_{ui})^2 + 
\lambda (
	\sum_{u=1}^M \left \Vert \mathbf{p}_u \right \Vert^2 +
	\sum_{i=1}^N \left \Vert \mathbf{q}_i \right \Vert^2
) \tag{2}
$$
使用交替最小二乘法（Alternating Least Square, ALS）：迭代地优化一个参数，而保持其他参数不变

考虑$\mathbf{p}_u$：
$$
L_u = \left \Vert 
	\mathbf{W}^u (\mathbf{r}_u - \mathbf{Q} \mathbf{p}_u) 
\right \Vert^2 + \lambda \left \Vert \mathbf{p}_u \right \Vert^2
$$
其中，$\mathbf{W}^u$是$N \times N$的对角矩阵，其对角元素$W_{ii}^u = w_{ui}$。

令$L_u$对$\mathbf{p}_u$的一阶导数等于0：
$$
\frac{ \partial L_u }{ \partial \mathbf{p}_u }
= -2 \mathbf{Q}^T \mathbf{W}^u (\mathbf{r}_u - \mathbf{Q} \mathbf{p}_u) + 2 \lambda \mathbf{p}_u = 0 \\\\
\begin{align}
&\Rightarrow ( \mathbf{Q}^T \mathbf{W}^u \mathbf{Q} + \lambda \mathbf{I} ) \mathbf{p}_u = \mathbf{Q}^T \mathbf{W}^u \mathbf{r}_u \\\\
&\Rightarrow \mathbf{p}_u = ( \mathbf{Q}^T \mathbf{W}^u \mathbf{Q} + \lambda \mathbf{I} )^{-1} \mathbf{Q}^T \mathbf{W}^u \mathbf{r}_u
\end{align} \tag{3}
$$
其中，$\mathbf{I}$是单位矩阵。

给所有的缺失项赋相同的权重$w_0$
$$
\mathbf{Q}^T \mathbf{W}^u \mathbf{Q} = w_0 \mathbf{Q}^T \mathbf{Q} + \mathbf{Q}^T (\mathbf{W}^u - \mathbf{w}^0) \mathbf{Q} \tag{4}
$$
其中，$\mathbf{w}^0$是对角矩阵，其对角元素均为$w_0$。

由于$\mathbf{Q}^T \mathbf{Q}$独立于u，因此，它可以被预先计算好。

Element-wise ALS

令$\hat r_{ui} = \hat r_{ui}^f + p_{uf} q_{if}$，则公式（2）可重写为
$$
L = \sum_{u=1}^M \sum_{i=1}^N w_{ui} (r_{ui} - \hat r_{ui}^f - p_{uf} q_{if})^2 + 
\lambda (
	\sum_{u=1}^M \left \Vert \mathbf{p}_u \right \Vert^2 +
	\sum_{i=1}^N \left \Vert \mathbf{q}_i \right \Vert^2
)
$$
L对$p_{uf}$的的偏导数：
$$
\frac{ \partial L }{ \partial p_{uf} } = -2 \sum_{i=1}^N  (r_{ui} - \hat r_{ui}^f - p_{uf} q_{if}) w_{ui} q_{if} + 2 \lambda p_{uf}
$$
令$\frac{ \partial L }{ \partial p_{uf} } = 0$，得到$p_{uf}$的解：
$$
p_{uf} = \frac{ 
	\sum_{i=1}^N (r_{ui} - \hat r_{ui}^f) w_{ui} q_{if} 
}{ 
	\sum_{i=1}^N w_{ui} q_{if}^2 + \lambda 
} \tag{5}
$$
相似地，我们可以得到$q_{if}$的解：
$$
q_{if} = \frac{ 
	\sum_{u=1}^M (r_{ui} - \hat r_{ui}^f) w_{ui} p_{uf} 
}{ 
	\sum_{u=1}^M w_{ui} p_{uf}^2 + \lambda 
} \tag{6}
$$

$$
L = \sum_{(u,i) \in \mathcal{R}} w_{ui} (r_{ui} - \hat r_{ui})^2 + 
\sum_{u=1}^M \sum_{i \notin \mathcal{R}_u} c_i \hat r_{ui}^2 + \\\\
\lambda (
	\sum_{u=1}^M \left \Vert \mathbf{p}_u \right \Vert^2 +
	\sum_{i=1}^N \left \Vert \mathbf{q}_i \right \Vert^2
) \tag{7}
$$
其中，$c_i$是负反馈的置信度。
$$
c_i = c_0 \frac{ f_i^\alpha }{ \sum_{j=1}^N f_i^\alpha } \tag{8}
$$
其中，$c_0$决定缺失数据的全局权重；$f_i$表示物品i的流行度。
$$
f_i = \frac{
	\left \vert \mathcal{R}_i \right \vert
}{
	\sum_{j=1}^N \left \vert \mathcal{R}_j \right \vert
}
$$
此时，
$$
p_{uf} = \frac{ 
	\sum_{i \in \mathcal{R}_u } (r_{ui} - \hat r_{ui}^f) w_{ui} q_{if} -
	\sum_{i \notin \mathcal{R}_u } \hat r_{ui}^f c_i q_{if}
}{ 
	\sum_{i \in \mathcal{R}_u } + \sum_{i \notin \mathcal{R}_u } c_i q_{if}^2 + \lambda 
} \tag{I}
$$
上式的计算瓶颈在于缺失数据项的相加

首先考虑分子：
$$
\begin{align}
\sum_{i \notin \mathcal{R}_u } \hat r_{ui}^f c_i q_{if}
&= \sum_{i=1}^N \hat r_{ui}^f c_i q_{if} - \sum_{i \in \mathcal{R}_u } \hat r_{ui}^f c_i q_{if} \\\\
&= \sum_{i=1}^N c_i q_{if} \sum_{k \neq f} p_{uk} q_{ik} - \sum_{i \in \mathcal{R}_u } \hat r_{ui}^f c_i q_{if} \\\\
&= \sum_{k \neq f} p_{uk} \sum_{i=1}^N c_i q_{if} q_{ik} - \sum_{i \in \mathcal{R}_u } \hat r_{ui}^f c_i q_{if}
\end{align} \tag{9}
$$
可以看到，上式主要的计算部分$\sum_{i=1}^N c_i q_{if} q_{ik}$独立于u。

令$\mathbf{S}^q = \sum_{i=1}^N c_i \mathbf{q}_i \mathbf{q}_i^T$

则
$$
\sum_{i \notin \mathcal{R}_u } \hat r_{ui}^f c_i q_{if} = \sum_{k \neq f} p_{uk} s_{kf}^q  - \sum_{i \in \mathcal{R}_u } \hat r_{ui}^f c_i q_{if} \tag{10}
$$

相似地，分母中
$$
\begin{align}
\sum_{ i \notin \mathcal{R}_u } c_i q_{if}^2
&= \sum_{i=1}^N c_i q_{if}^2 - \sum_{i \in \mathcal{R}_u } c_i q_{if}^2 \\\\
&= s_{ff}^q  - \sum_{i \in \mathcal{R}_u } c_i q_{if}^2
\end{align} \tag{11}
$$
由式（I）、（10）以及（11）可得：
$$
p_{uf} = \frac{ 
	\sum_{i \in \mathcal{R}_u } [ w_{ui} r_{ui} - (w_{ui} - c_i)\hat r_{ui}^f ] q_{if} -
	\sum_{k \neq f} p_{uk} s_{kf}^q
}{ 
	\sum_{i \in \mathcal{R}_u } (w_{ui} - c_i) q_{if}^2 + s_{ff}^q + \lambda 
} \tag{12}
$$
类似地可以得到
$$
q_{if} = \frac{ 
	\sum_{u \in \mathcal{R}_i } [ w_{ui} r_{ui} - (w_{ui} - c_i)\hat r_{ui}^f ] p_{uf} -
	c_i \sum_{k \neq f} q_{ik} s_{kf}^p
}{ 
	\sum_{u \in \mathcal{R}_i } (w_{ui} - c_i) p_{uf}^2 + c_i s_{ff}^p + \lambda 
} \tag{12}
$$
其中，$\mathbf{S}^p = \mathbf{P}^T \mathbf{P}$


$$
\begin{align}
\sum_{u=1}^M \sum_{i=1}^N c_i \hat r_{ui}^2
&= \sum_{u=1}^M \sum_{i=1}^N c_i (\mathbf{p}_u^T \mathbf{q}_i)(\mathbf{q}_i^T \mathbf{p}_u) \\\\
&= \sum_{u=1}^M \mathbf{p}_u^T \sum_{i=1}^N (c_i \mathbf{q}_i \mathbf{q}_i^T) \mathbf{p}_u \\\\
&= \sum_{u=1}^M \mathbf{p}_u^T \mathbf{S}^q \mathbf{p}_u
\end{align}
$$
因此，式（7）目标函数中
$$
\begin{align}
\sum_{u=1}^M \sum_{i \notin \mathcal{R}_u} c_i \hat r_{ui}^2 
&= \sum_{u=1}^M \sum_{i=1}^N c_i \hat r_{ui}^2 - 
\sum_{u=1}^M \sum_{i \in \mathcal{R}_u} c_i \hat r_{ui}^2  \\\\
&= \sum_{u=1}^M \mathbf{p}_u^T \mathbf{S}^q \mathbf{p}_u - 
\sum_{(u,i) \in \mathcal{R}} c_i \hat r_{ui}^2  
\end{align}
$$
