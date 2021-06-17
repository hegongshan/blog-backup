---
title: 论文阅读 List-wise Learning to Rank with Matrix Factorization for Collaborative Filtering
date: 2020-10-08 21:25:20
tags: recommender systems
categories: recommender systems
mathjax: true
---

List-wise Learning to Rank with Matrix Factorization for Collaborative Filtering一文发表在RecSys 2010上，作者将list-wise排序学习与矩阵分解整合在一起，提出了一种叫作ListRank-MF的排序学习模型。

<!--more-->

### Learing to Rank (LTR)

排序学习（Learning to Rank，LTR）源自于信息检索领域，分为三种类型：

* point-wise LTR
* pair-wise LTR
* list-wise LTR

### PMF

$$
U,V = \mathop{\arg \min}_{U,V} \frac{1}{2} \sum_{i = 1}^M \sum_{j = 1}^N I_{ij} (R_{ij} - g(U_i^T V_j))^2 + \frac{\lambda_U}{2} \lVert U \rVert_F^2 + \frac{\lambda_V}{2} \lVert V \rVert_F^2
$$

* $R_{ij}$为用户i对物品j的评分；

* $I_{ij}$是指示函数，当$R_{ij} > 0$时，结果为1，否则，结果为0；

* $\lambda_U$和$\lambda_V$是正则项系数。简单起见，将它们设置为相同的值，即$\lambda_U = \lambda_V = \lambda$。

* $g(x) = \frac{1}{1 + e^{-x}}$，目的是将$U_i^T V_j$限制在(0,1)范围中。

之前我也很疑惑，为什么不用评分预测模型输出的预测评分来做Top-N推荐呢？

当时的想法很朴素，直接按照预测评分降序排序，然后将前N个物品推荐给用户。

> Note that PMF, and also some other matrix factorization approaches as in [9], are rating prediction oriented. **Although we can use the predicted ratings to rank the items, the quality of ranking is not directly related to the purpose of PMF (minimizing the error of rating prediction)**.

评分预测模型的目的是使评分预测误差最小，并没有对排序直接进行建模，因此，排序质量的好坏与模型本身没有直接关系，不能直接用于Top-N推荐。

### Top One概率

在用户i的排序列表$l_i$中，评分为$R_{ij}$的物品排在首位的概率为
$$
P_{l_i}(R_{ij}) = \frac{\varphi(R_{ij})}{\sum_{k=1}^K \varphi(R_{ik})}
$$
其中，$\varphi(x)$可以是任意的单调递增且大于0的函数。

为简单起见，作者令$ \varphi(x)= e^x$。此时，式就变为**softmax函数**。

> The top one probability indicates the probability of an item being ranked in the top position for a given ranking list. 

### ListRank-MF

损失函数
$$
\begin{aligned}
L(U,V) 
&= \sum_{i = 1}^M \left( -\sum_{j=1}^N P_{l_i}(R_{ij}) \log P_{l_i}(g(U_i^T V_j)) \right) + \frac{\lambda}{2} (\lVert U \rVert_F^2 + \lVert V \rVert_F^2)
\end{aligned}
$$
下面，我们先来推导下softmax函数的导数：


$$
\begin{aligned}
\frac{\partial P(x_i)}{\partial x_i}
&= \frac{\partial}{\partial x_i} \left( \frac{\exp(x_i)}{\sum_{k=1}^K \exp(x_k)} \right) \\\\
&= \frac{\exp(x_i) \left( \sum_{k=1}^K \exp(x_k) \right) - \exp(x_i) \times \exp(x_i)}{\left( \sum_{k=1}^K \exp(x_k) \right)^2} \\\\
&= \frac{\exp(x_i)}{\left( \sum_{k=1}^K \exp(x_k) \right)} \left(1 - \frac{\exp(x_i)}{ \sum_{k=1}^K \exp(x_k)} \right) \\\\
&= P(x_i) (1 - P(x_i))
\end{aligned}
$$
因此，
$$
\begin{aligned}
\frac{\partial L(U,V)}{\partial U_i} 
&= -\sum_{j=1}^N P_{l_i}(R_{ij}) \times \frac{1}{P_{l_i}(g(U_i^T V_j))} 
\times \frac{\partial P_{l_i}(g(U_i^T V_j))}{\partial g(U_i^T V_j)} 
\times g^\prime(U_i^T V_j) V_j + \lambda U_i \\\\
&= -\sum_{j=1}^N P_{l_i}(R_{ij}) \times \left( 1 - P_{l_i}(g(U_i^T V_j)) \right)
\times g^\prime(U_i^T V_j) V_j + \lambda U_i \\\\
&= \sum_{j=1}^N P_{l_i}(R_{ij}) \times \left(P_{l_i}(g(U_i^T V_j) - 1) \right)
\times g^\prime(U_i^T V_j) V_j + \lambda U_i \\\\
&\ne \sum_{j=1}^N \left(P_{l_i}(g(U_i^T V_j)) - P_{l_i}(R_{ij}) \right)
\times g^\prime(U_i^T V_j) V_j + \lambda U_i
\end{aligned}
$$

这里也是让我非常困惑的地方，推导的结果与作者给出的结果不一致。

