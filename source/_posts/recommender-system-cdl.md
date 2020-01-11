---
title: 论文阅读 Collaborative Deep Learning for Recommender Systems
date: 2019-12-10 17:34:36
tags: recommender systems
categories: recommender systems
mathjax: true
---

作者提出了一个分层的贝叶斯模型—— Collaborative Deep Learning（CDL），利用深度表示学习对物品的内容信息进行建模，并将其与针对评分矩阵的协同过滤整合在一起。

<!--more-->

### 符号描述

$\mathbf{X}_c \in \mathbb R^{J \times S}$表示由J个物品组成的矩阵，矩阵中的每一行j是一个词袋向量$\mathbf{X}_{c, j*}$（词汇表的大小为S）。

$\mathbf{R} = [R_{i,j}]_{I \times J}$表示由I个用户、J个物品组成的二元评分矩阵。

### 问题

给定$\mathbf{R}$中的部分评分以及内容信息$\mathbf{X}_c$，预测$\mathbf{R}$中的其他评分。

### CDL

![](/static/images/cdl.png)

CDL的生成过程如下：



### 目标函数

最大化后验概率等价于最大化$\mathbf{U}, \mathbf{V}, \\{\mathbf{X}_l\\}, \mathbf{X}_c, \\{\mathbf{W}_l\\}, \mathbf{b}_l, \mathbf{R}$的联合对数似然。

<!--
$$
\begin{align}
\mathscr{L} =
&-\frac{\lambda_u}{2} 
\sum_i \left \Vert \mathbf{u}_i \right \Vert_2^2 
-\frac{\lambda_w}{2} 
\sum_l (\left \Vert \mathbf{W}_l \right \Vert_F^2 + \left \Vert \mathbf{b}_l \right \Vert_2^2) \\\\ 
&-\frac{\lambda_v}{2} 
\sum_j \left \Vert \mathbf{v}_j - \mathbf{X}_{\frac{L}{2},j*}^T \right \Vert_2^2 
-\frac{\lambda_n}{2} \sum_j \left \Vert \mathbf{X}_{L,j*} - \mathbf{X}_{c,j*} \right \Vert_2^2 \\\\
&-\frac{\lambda_s}{2} \sum_l \sum_j \left \Vert \sigma(\mathbf{X}_{l-1,j*} \mathbf{W}_l + \mathbf{b}_l) - \mathbf{X}_{l,j*} \right \Vert_2^2 \\\\ 
&-\sum_{i,j} \frac{C_{ij}}{2} (\mathbf{R}_{ij} - \mathbf{u}_i^T \mathbf{v}_j)^2
\end{align}
$$
-->

![](/static/images/cdl-objective-function.png)



### 参数更新

![](/static/images/cdl-update-rule.png)

### 预测

$$
{% raw %}
\mathbf{R}^*_{ij} \approx (\mathbf{u}_i^*)^T (f_e (\mathbf{X}_{0,j*}, \mathbf{W}^{+*})^T + \mathbf{\epsilon}^*_j) = (\mathbf{u}_i^*)^T \mathbf{v}_j^*
{% endraw %}
$$

