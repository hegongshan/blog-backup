---
title: 论文阅读 Wide & Deep Learning for Recommender Systems
date: 2019-11-20 12:00:42
tags: recommender systems
categories: recommender systems
mathjax: true
---



Memorization

Generalization

impression feature

cross-product transformation





> Memorization can be loosely defined as learning the frequent co-occurrence of items or features and exploiting the correlation available in the historical data. Generalization, on the other hand, is based on transitivity of correlation and explores new feature combinations that have never or rarely occurred in the past. 



### Wide & Deep Learning

#### Wide

$$
y = \mathbf{w}^T \mathbf{x} + b
$$

其中，$\mathbf{x} = [x_1,x_2,\cdots,x_d]$

既包含原始特征，又包含转换特征。
$$
\phi_k(\mathbf{x}) = \prod_{i=1}^d x_i^{c_{ki}} \quad  c_{ki} \in \\{ 0,1 \\}
$$

