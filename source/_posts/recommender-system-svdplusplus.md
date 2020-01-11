---
title: SVD++
date: 2019-11-18 19:51:10
tags: recommender systems
categories: recommender systems
mathjax: true
---

<!--

$\mathcal{K} = \\{ (u,i) | r_{ui}\ is\ known \\}$

### 基准估计

$$
b_{ui} = \mu + b_u + b_i \tag{1}
$$

目标函数
$$
\min_{b*} \sum_{(u,i) \in \mathcal{K}} (r_{ui} - \mu - b_u - b_i)^2 + \lambda_1 (\sum_u b_u^2 + \sum_i b_i^2) \tag{2}
$$

### Neighborhood models

常用的相似度计算方法是皮尔逊相关系数（Pearson Correlation Coefficient）。
$$
\rho_{ij} = \frac{
	\sum_{u \in U} (r_{ui} - \bar{r_i}) (r_{uj} - \bar{r_j})
}{
	\sqrt {
		\sum_{u \in U} (r_{ui} - \bar{r_i})^2
	}
	\sqrt {
		\sum_{u \in U} (r_{uj} - \bar{r_j})^2
	}
} \tag{3}
$$
由于具有较大用户支持度的相似度更可信，因此，合适的相似度如下：
$$
s_{ij} \overset{def}{=} \frac{
	n_{ij}
}{
	n_{ij} + \lambda
} \rho_{ij} \tag{4}
$$
其中，$n_{ij}$表示同时评价过物品i和j的用户数量。

$S^k (i;u)$表示用户u评价过的、与物品i最相似的k个物品的集合。
$$
\hat r_{ui} = b_{ui} + \frac{
	\sum_{j \in S^k(i;u)} s_{ij} (r_{uj} - b_{uj})
}{
	\sum_{j \in S^k(i;u)} s_{ij}
} \tag{5}
$$
但该模型存在一些问题，如插值权重的和为1，将迫使该方法完全依赖于邻域，即使是在邻域信息缺失的情况下（用户u没有评价过与i相似的物品）。

为了解决这些问题，作者提出了一种更加准确的邻域模型：
$$
\hat r_{ui} = b_{ui} + \sum_{j \in S^k (i;u)} \theta_{ij}^u (r_{uj} - b_{uj}) \tag{6}
$$
其中，$\\{ \theta_{ij}^u | j \in S^k (i;u) \\}$是插值权重（interpolation weights）。

-->

SVD++源自于Koren在2008年发表在KDD上Factorization Meets the Neighborhood: a Multifaceted Collaborative Filtering Model一文。

### SVD++

$$
\hat r_{ui} = b_{ui} + q_i^T 
\left( 
  p_u + 
  \left \vert N(u) \right \vert^{-\frac{1}{2}} \sum_{j \in N(u)} y_j 
\right) \tag{7}
$$

其中，$p_u$从显式评分中学习，$\left \vert N(u) \right \vert^{-\frac{1}{2}} \sum_{j \in N(u)} y_j $从隐式反馈的角度来考虑，二者互相补充。

在SVD++中，用户被表示为$\left( p_u + \left \vert N(u) \right \vert^{-\frac{1}{2}}
\sum_{j \in N(u)} y_j \right)。$

https://github.com/guoguibing/librec/blob/3.0.0/core/src/main/java/net/librec/recommender/cf/rating/SVDPlusPlusRecommender.java