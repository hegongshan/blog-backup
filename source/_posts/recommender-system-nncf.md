---
title: 论文阅读 A Neural Collaborative Filtering Model with Interaction-based Neighborhood
date: 2020-01-06 19:41:00
tags: recommender systems
categories: recommender systems
mathjax: true
---

Neighborhood-based Neural Collaborative Filtering（NNCF）一文发表在CIKM 2017上，作者在Neural Collaborative Filtering的基础上，加入了邻域信息。

<!--more-->

### 模型结构

![NNCF](/static/images/nncf.png)

### 目标函数

给定训练集$\tau = \{ < u, i, y_{ui}>  \}$，作者采用二元交叉熵作为损失函数：
$$
\mathcal{L} = - \sum_{< u, i, y_{u, i}> \in \tau} \left( y_{ui} \log \hat p_{ui} + (1 - y_{ui}) \log (1 - \hat p_{ui}) \right)
$$


