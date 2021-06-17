---
title: 论文阅读 Restricted Boltzmann Machines for Collaborative Filtering
date: 2020-10-14 01:10:29
tags: recommender systems
categories: recommender systems
mathjax: true
---

Restricted Boltzmann Machines for Collaborative Filtering发表在ICML 2007上，是推荐系统领域的一篇经典论文（截至本文写作时，累计引用741次）。

作者将受限玻尔兹曼机（Restricted Boltzmann Machines，RBM's）应用于推荐系统中的评分预测任务。

<!--more-->

老实讲，文章确实有点难懂，主要有以下几个难点：

1.RBM模型

2.对比散度算法（Contrastive Divergence，CD）

3.吉布斯采样（GIbbs sampling）

不解决这三个问题，这篇文章可能真的就是天书。下面，我们逐一解决这三个问题。

### 受限玻尔兹曼机（RBM）

### 对比散度算法

### 吉布斯采样

回到文章本身：

假设有M部电影，N个用户，评分范围为[1, K]

假定某个用户评分过m部电影，$V \in \mathbb{R}^{K \times m}$是一个二元评分矩阵，元素值为：
$$
v_i^k = 
\begin{cases}
 1, 如果用户对电影i的评分为k \\\\
 0, 否则
\end{cases}
$$

V的边缘分布为：
$$
p(\mathbf{V}) = \sum_h \frac{\exp(-E(\mathbf{V, h}))}{\sum_{\mathbf{V\prime, h\prime}} \exp(-E(\mathbf{V\prime, h\prime}))}
$$
其中，$E(\mathbf{V,h})$为能量函数：
$$
\begin{aligned}
E(\mathbf{V,h}) 
&= -\sum_{i = 1}^m \sum_{j = 1}^F \sum_{k = 1}^K w_{ij}^k h_j v_i^k + \sum_{i = 1}^m \log Z_i \\\\
& -\sum_{i = 1}^m \sum_{k = 1}^K v_i^k b_i^k - \sum_{j = 1}^F h_j b_j \\\\
\end{aligned}
$$
RBM的训练目标是最小化上述的能量函数





### 参考资料

1. Restricted Boltzmann Machines for Collaborative Filtering http://www.cs.toronto.edu/~amnih/papers/rbmcf.pdf

2. 周志华《机器学习》5.5.6 Boltzmann机
3. 诸葛越《百面机器学习》8.5马尔科夫蒙特卡洛采样法-吉布斯采样法
4. 浅析 Hinton 最近提出的 Capsule 计划，https://zhuanlan.zhihu.com/p/29435406

