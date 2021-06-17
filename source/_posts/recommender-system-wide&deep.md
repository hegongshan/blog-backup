---
title: 论文阅读 Wide & Deep Learning for Recommender Systems
date: 2019-11-20 12:00:42
tags: recommender systems
categories: recommender systems
mathjax: true
---

Wide & Deep是Google在2016年发表的一篇论文，自此以后，双塔模型成为了推荐系统研究中的常见模型结构。

<!--more-->

### Memorization & Generalization

论文中对记忆能力（Memorization）和泛化能力（Generalization）作了如下定义：

> Memorization can be loosely defined as learning the frequent co-occurrence of items or features and exploiting the correlation available in the historical data. 
>
> Generalization, on the other hand, is based on transitivity of correlation and explores new feature combinations that have never or rarely occurred in the past. 

### Wide & Deep Learning

#### 模型结构

![wide & deep](/static/images/rs-wide-deep.png)

#### Wide

宽度部分是一个泛化的线性回归：
$$
y = \mathbf{w}^T \mathbf{x} + b
$$

其中，$\mathbf{x} = [x_1,x_2,\cdots,x_d]$是d个特征组成的向量。

特征集合中既包含原始特征，又包含组合特征。其中，一种最重要的组合特征是叉积转换（cross-product transformation ）：
$$
\phi_k(\mathbf{x}) = \prod_{i=1}^d x_i^{c_{ki}} \quad  c_{ki} \in \\{ 0,1 \\}
$$

如果第i个特征在第k个组合中，则$c_{ki} = 1$；否则，$c_{ki} = 0$。

#### Deep

深度部分采用前馈神经网络，对每个隐含层执行如下的计算：
$$
a^{(l + 1)} = f(\mathbf{W}^{(l)} a^{(l)} + b^{(l)})
$$
其中，$l$是层号，$f$是激活函数（通常采用ReLU），$a^{(l)}$、$b^{(l)}$和$W^{(l)}$分别是第$l$层的输入、偏置向量和权重矩阵。

### 参考文献

论文地址：https://arxiv.org/pdf/1606.07792.pdf