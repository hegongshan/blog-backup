---
title: 论文阅读  HOSLIM&#58 Higher-Order Sparse LInear Method for Top-N Recommender Systems
date: 2019-11-03 16:49:08
tags: recommender systems
categories: recommender systems
mathjax: true
---

HOSLIM在Sparse LInear Method（SLIM）的基础上，考虑了物品之间的高层关系（higher-order）。

<!--more-->

### HOSLIM

#### 预测模型

用户u对物品i的预测分数$\tilde r_{ui}​$
$$
\tilde r_{ui} = \mathbf{r}_u^T \mathbf{s}_i + \mathbf{r^\prime}_u^T \mathbf{s}_i^\prime \tag{1}
$$
因此，HOSLIM的预测模型可以表示为：
$$
\tilde R = RS + R^\prime S^\prime
$$
其中，$R \in \mathbb{R}^{n \times m}​$是用户-物品隐式反馈矩阵，$R^\prime \in \mathbb{R}^{n \times p}​$是用户-物品集合隐式反馈矩阵；

$S \in \mathbb{R}^{m \times m}$是物品-物品相似度矩阵，$S^\prime\in \mathbb{R}^{p \times m} ​$是物品集合-物品相似度矩阵。

#### 目标函数

$$
\mathcal{L} =\min_{\mathbf{s}_i,\mathbf{s}^\prime_i} =\frac{1}{2} \left \Vert \mathbf{r}_i - R \mathbf{s}_i - R^\prime \mathbf{s}^\prime_i \right \Vert_2^2 + \frac{\beta}{2} \left \Vert \mathbf{s}_i \right \Vert_2^2 + \frac{\beta}{2} \left \Vert \mathbf{s}^\prime_i \right \Vert_2^2 + \lambda \left \Vert \mathbf{s}_i \right \Vert_1 + \lambda \left \Vert \mathbf{s}^\prime_i \right \Vert_1 \tag{2} \\\\
\begin{align}
\mathrm{subject\ to}\ 
&\mathbf{s}_i \geq 0 \\\\
&\mathbf{s}^\prime_i \geq 0 \\\\
&s_{ii} = 0 \\\\
&s^\prime_{ji} = 0,\ i \in \mathcal{I}_j
\end{align}
$$

其中，约束条件$s_{ii} = 0​$确保：当计算$\tilde r_{ui}​$时，$r_{ui}​$不会被使用。

$\mathbf{s}^\prime_{ji} = 0$确保：当计算$\tilde r_{ui}$时，物品集合j ($i \in \mathcal{I}_j​$)不会被使用。

### 参考文献

Evangelia Christakopoulou and George Karypis. 2014. Hoslim: Higher-order sparse linear method for top-n recommender systems. In Pacific-Asia Conference on Knowledge Discovery and Data Mining. Springer, 38–49. 