---
title: 深度学习常见术语
date: 2020-01-05 21:20:55
tags: deep learning
categories: deep learning
mathjax: true
---

论文读的越多，接触到的深度学习术语也越来越多，诸如one-hot、embedding等。本文是我对这些常见术语的理解与总结。

<!--more-->

### one-hot

为什么要采用one-hot（独热码）呢？

当采用独热码时，输入所有值的距离相等。

举个例子，在推荐系统中，共有N个用户，id [0, N - 1]，则它们的独热码分别为：
$$
1,0,0,\dots,0,0 \\\\
0,1,0,\dots,0,0 \\\\
\cdots \\\\
0,0,0,\dots,0,1
$$

### embedding

将高维稀疏的输入向量映射为低维的致密向量。

等价于将输入向量与一个权重矩阵相乘。
$$
\mathrm{embedding\ vector} = \mathrm{input\ vector \times embedding\ matrix}
$$

### pooling

pooling（池化），源自于计算机视觉。

听起来很高大上，实际上它只是一个很简单的概念。

#### sum pooling

将所有的向量相加，转化为一个向量。

例如，假定$\mathbf{u}_1, \dots, \mathbf{u}_n \in \mathbb{R}^k$，对它们进行sum pooling操作：
$$
\mathbf{u} = \sum_{i=1}^n \mathbf{u}_i
$$

#### average pooling

在sum pooling的基础上，除以向量的个数。

### masking

masking（掩饰）



