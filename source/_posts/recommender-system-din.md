---
title: 论文阅读 Deep Interest Network for Click-Through Rate Prediction
date: 2019-12-24 16:34:06
tags: recommender systems
categories: recommender systems
mathjax: true
---

Deep Interest Network for Click-Through Rate Prediction是阿里巴巴发表在KDD 2018上的一篇论文。作者在常见的Embedding&MLP范式中，引入了attention机制，极大地改进了模型的表达能力。

<!--more-->

### Motivation

在Embedding&MLP范式中，各种各样的用户兴趣被压缩到同一个长度固定的向量中，这限制了Embedding&MLP方法的表达能力。此外，将某一用户的全部兴趣压缩到同一个向量中是没有必要的，因为当预测候选广告时，只有部分兴趣会影响他的行为。

### Feature Representation

![](/static/images/din-feature.png)

### Base Model

![](/static/images/din-base-model.png)

损失函数使用negative log-likelihood function：
$$
L = -\frac{1}{N} 
\sum_{(\mathbf{x}, y) \in \mathbf{S}} 
\left( y \log p(\mathbf{x}) + (1 - y) \log (1 - p(\mathbf{x})) \right) \tag{1}
$$
其中，S是大小为N的训练集，$\mathbf{x}$是模型的输入，$y \in \\{ 0, 1 \\}$是类别，$p(\mathbf{x})$是模型的输出。

### Deep Interest Network

![](/static/images/din.png)

$\mathcal{V}_U$为用户表示向量，A为候选广告：
$$
\mathcal{V}_U(A) = f(\mathcal{V}_A, \mathbf{e}_1, \mathbf{e}_2, \cdots, \mathbf{e}_H) = \sum_{j=1}^H a(\mathbf{e}_j, \mathcal{V}_A) \mathbf{e}_j = \sum_{j=1}^H \mathbf{w}_j \mathbf{e}_j \tag{2}
$$
其中，$\\{\mathbf{e}_1, \mathbf{e}_2, \cdots, \mathbf{e}_H\\}$是用户U历史行为的embedding向量构成的集合，$\mathcal{V}_A$表示广告A的embedding向量，$a(\mathbf{e}_j, \mathcal{V}_A)$是attention网络。

如上图所示，在attention网络中，除了用户和物品（广告）embedding向量外，它们的叉积也被喂进之后的网络中。

注意：在传统的attention方法中，$\sum_j \mathbf{w}_j = 1$。

为了保留用户兴趣的强度，这种约束被抛弃了，$a(\cdot)$没有使用softmax。

$\sum_j \mathbf{w}_j$可以看作被激活的用户兴趣强度的估计值。

###  正则项

小批量敏感（mini-batch aware）的正则
$$
L_2(W) \approx \sum_{j=1}^K \sum_{m=1}^B \frac{\alpha_{mj}}{n_j}
\left \Vert \mathbf{w}_j \right \Vert_2^2
$$

### 激活函数

PReLU：
$$
f(s) = 
\begin{cases}
s & \mathrm{if\ s > 0} \\\\
\alpha s & \mathrm{if\ s \le 0}
\end{cases}
= p(s) \cdot s + (1 - p(s)) \cdot \alpha s
$$
其中，$p(s) = I(s > 0)$是指示函数，$\alpha$是一个可学习的参数。

由于PReLU采用了硬整流点（0），当每层的输入服从不同的分布时，可能不太适用。

作者提出了Dice
$$
f(s) = p(s) \cdot s + (1 - p(s)) \cdot \alpha s \\\\
p(s) = \frac{1}{
	1 + e^{- \frac{
		s - E[s]
	}{
		\sqrt{Var[s] + \epsilon}
	}}
}
$$
其中，$\epsilon$是一个很小的常量，作者将其设置为$10^{-8}$。

在训练阶段，E[s]和Var[s]是每个小批量输入的均值和方差；

在测试阶段，E[s]和Var[s]是通过在数据上移动E[s]和Var[s]的平均值来计算。

### 参考文献

Guorui Zhou, Xiaoqiang Zhu, Chenru Song, Ying Fan, Han Zhu, Xiao Ma, Yanghui Yan, Junqi Jin, Han Li, and Kun Gai. 2018. Deep Interest Network for Click-Through Rate Prediction. In *Proceedings of the 24th ACM SIGKDD International Conference on Knowledge Discovery & Data Mining* (KDD '18). ACM, New York, NY, USA, 1059-1068. DOI: https://doi.org/10.1145/3219819.3219823