---
title: 论文阅读 FISM&#58 Factored Item Similarity Models for Top-N Recommender Systems
date: 2019-10-26 19:40:30
tags: recommender systems
categories: recommender systems
mathjax: true
---

针对Top-N推荐问题，作者提出了一种叫作FISM（Factored Item Similarity Models）的推荐算法，用两个低维隐因子矩阵的乘积来表示物品相似度矩阵。

<!--more-->

### 符号说明

1.所有的向量使用**粗体小写字母**表示，例如$\mathbf{p,q}$。

2.所有的矩阵使用**粗体大写字母**表示，例如$\mathbf{R}$。此外，$\mathbf{p_j}$表示矩阵$\mathbf{P}$的第j行。

3.评估时的预测值，在字母上方加波浪号，如$\tilde r_{ui}$；训练时的估计值，在字母上方加估计符号，如$\hat r_{ui}$。

4.$\mathcal{C}$和$\mathcal{D}$分别表示用户和物品集合，$\vert \mathcal{C} \vert=n$，$\vert \mathcal{D} \vert=m$。

5.$\mathbf{R}$表示用户-物品隐式反馈矩阵；$\mathcal{R}_u^+$表示用户u评分过的物品集合；$\mathcal{R}_u^-$表示用户u未评分过的物品集合。

6.$\vert \mathcal{R}_u^+ \vert = n_u^+ $

### SLIM

*Sparse LInear Method* (SLIM)的预测模型：
$$
\mathbf{\tilde r}_u = \mathbf{r_u S} \tag{1}
$$
其中，$\mathbf{r_u}$表示用户u对所有物品的评分组成的向量；$\mathbf{S} \in \mathbb{R}^{m \times m}$表示物品相似度矩阵。

目标函数：
$$
L= \min_{\mathbf{S}} \frac{1}{2} \sum_{(u,i) \in \mathbf{R}}  \left \Vert r_{ui} - \hat r_{ui} \right \Vert_F^2 + \frac{\beta}{2} \left \Vert \mathbf{S} \right \Vert_F^2 + \lambda \left \Vert \mathbf{S} \right \Vert_1 \\\\
subject\ to\ \mathbf{S} \geq 0, diag(\mathbf{S}) = 0 \tag{2}
$$
其中，$\left \Vert \mathbf{S} \right \Vert_F$是矩阵$\mathbf{S}$的Frobenius范数（参见补充知识）；$\beta$和$\lambda$是正则化参数。

**SLIM的不足之处在于**：无法捕捉物品之间的传递关系。

如果物品i和j未被任何用户同时评分过，则$s_{ij} = 0$。

但是，物品i和j可能均和第三个物品k相似，从而使得物品i和j彼此相似。

### NSVD

NSVD用两个低秩矩阵$\mathbf{P} \in \mathbb{R}^{m \times k}$和$\mathbf{Q} \in \mathbb{R}^{m \times k}$（$k \ll m $）的乘积来表示物品相似度。

给定物品i和j，二者的相似度$sim(i,j) = \mathbf{p}_i \cdot \mathbf{q}_j^T$。

预测模型：
$$
\hat r_{ui} = \tilde r_{ui} = b_u + b_i + \sum_{j \in \mathcal{R}_u^+} \mathbf{p}_j \mathbf{q}_i^T \tag{3}
$$
目标函数：
$$
\min_{\mathbf{P,Q}} \frac{1}{2} \sum_{u \in \mathcal{C}} \sum_{i \in \mathcal{R}_u^+} \left \Vert r_{ui} - \hat r_{ui} \right \Vert_F^2 + \frac{\beta}{2} (\left \Vert \mathbf{P} \right \Vert_F^2 + \left \Vert \mathbf{Q} \right \Vert_F^2) \tag{4}
$$
**NSVD的不足之处在于**：在估计评分时，没有排除物品自己对自己的影响。

例如，在训练时，要估计用户u对物品i的评分$\hat r_{ui}$，且$i \in \mathcal{R}_u^+$

根据公式(3)可以得到：
$$
\hat r_{ui} = b_u + b_i + \mathbf{p}_i \mathbf{q}_i^T  + \sum_{j \in \mathcal{R}_u^+ \setminus \\{i\\}} \mathbf{p}_j \mathbf{q}_i^T \tag{5}
$$

### FISM

预测模型：
$$
\tilde r_{ui} = b_u + b_i + \left \vert R_u^+ \right \vert^{- \alpha} \sum_{j \in \mathcal{R_u^+}} \mathbf{p}_j \mathbf{q}_i^T \tag{6}
$$

作者提出了两种版本的FISM模型，它们使用不同的损失函数。

#### FISMrmse

平方误差损失函数：
$$
\mathcal{L(\cdot)} = \sum_{i \in \mathcal{D}} \sum_{u \in \mathcal{C}} (r_{ui} - \hat r_{ui})^2 \tag{7}
$$
估计值$\hat r_{ui}$的计算方法如下：
$$
\hat r_{ui} = b_u + b_i + (\left \vert R_u^+ \right \vert - 1)^{- \alpha} \sum_{j \in \mathcal{R_u^+ \setminus \ \\{i\\}}} \mathbf{p}_j \mathbf{q}_i^T \tag{8}
$$
由于FISM只关注隐式反馈，$\forall j \in \mathcal{R}_u^+$，$r_{uj} = 1$，因此，在公式(8)中省略了$r_{uj}$。

目标函数：
$$
L = \min_{\mathbf{P,Q}} \frac{1}{2} \sum_{(u,i) \in R} \left \Vert r_{ui} - \hat r_{ui} \right \Vert_F^2 + \frac{\beta}{2} (\left \Vert \mathbf{P} \right \Vert_F^2 + \left \Vert \mathbf{Q} \right \Vert_F^2) + \frac{\lambda}{2} \left \Vert \mathbf{b_u} \right \Vert_2^2 + \frac{\gamma}{2} \left \Vert \mathbf{b_i} \right \Vert_2^2 \tag{9}
$$
其中，$\mathbf{b_u}$和$\mathbf{b_i}$分别是用户和物品的偏置向量。

使用用户-物品交互矩阵$\mathbf{R}$中的所有元素来计算损失函数是非常耗时的，因此，作者提出对$\mathbf{R}$中的零元素（负样本）进行采样。每次迭代时，随机选择$\rho \cdot nnz(R)$个零元素。

其中，$\rho$是采样因子（sample factor），$nnz(R)$是$\mathbf{R}$中非零项（non-zero entries）的个数。

实验表明，当采样比$\rho \in [3,15]$时，足够产生最佳的模型。

训练算法：

![](/static/images/fism-rmse-algorithm.png)

#### FISMauc

基于Bayesian Personalized Ranking（BPR）的排序损失函数：
$$
\mathcal{L(\cdot)} = \sum_{u \in \mathcal{C}} \sum_{i \in \mathcal{R}_u^+,\ j \in \mathcal{R}_u^-} ( (r_{ui} - r_{uj}) - (\hat r_{ui} - \hat r_{uj}) )^2 \tag{10}
$$
其中，$R_u^+$表示用户评分过的物品，$R_u^-$表示用户未评分过的物品。

目标函数：
$$
\min_{\mathbf{P,Q}} \frac{1}{2} \sum_{u \in \mathcal{C}} \sum_{i \in \mathcal{R}_u^+,\ j \in \mathcal{R}_u^-} \left \Vert (r_{ui} - r_{uj}) - (\hat r_{ui} - \hat r_{uj}) \right \Vert_F^2 + \frac{\beta}{2} (\left \Vert \mathbf{P} \right \Vert_F^2 + \left \Vert \mathbf{Q} \right \Vert_F^2) + \frac{\gamma}{2} \left \Vert \mathbf{b_i} \right \Vert_2^2 \tag{11}
$$
注意：由于$\hat r_{ui} - \hat r_{uj}$时，$b_u$被消掉了，因此，目标函数的正则项中没有$\mathbf{b}_u$。

此外，FISMauc的采样方式与FISMrmse相似。

训练算法：

![](/static/images/fism-auc-algorithm.png)

### 补充知识

1.矩阵$\mathbf{A} \in \mathbb{R}^{m \times n}$的Frobenius范数$\left \Vert \mathbf{A} \right \Vert_F$定义为：
$$
\left \Vert \mathbf{A} \right \Vert_F = \sqrt{tr(\mathbf{A}^T \mathbf{A})} = \sqrt {\sum_{i=1}^m \sum_{j=1}^n A_{ij}^2} \tag{12}
$$
2.对于矩阵$\mathbf{A}$
$$
\frac{\partial \left \Vert \mathbf{A} \right \Vert_F^2}{\partial \mathbf{A}} = 2 \mathbf{A} \tag{13}
$$
对于向量$\mathbf{x}$
$$
\frac{\partial \left \Vert \mathbf{x} \right \Vert_2^2}{\partial \mathbf{x}} = 2 \mathbf{x} \tag{14}
$$

### 参考文献

1.S. Kabbur, X. Ning, and G. Karypis, “FISM: Factored item similarity models for top-n recommender systems,” in Proc. 19th ACM SIGKDD Conf. Knowl. Discovery Data Mining, 2013, pp. 659–667.

2.https://github.com/guoguibing/librec/blob/3.0.0/core/src/main/java/net/librec/recommender/cf/ranking/FISMrmseRecommender.java

3.https://github.com/guoguibing/librec/blob/3.0.0/core/src/main/java/net/librec/recommender/cf/ranking/FISMaucRecommender.java





