---
title: 论文阅读 Outer Product-based Neural Collaborative Filtering
date: 2020-01-18 16:46:42
tags: recommender systems
categories: recommender systems
mathjax: true
---

Outer Product-based Neural Collaborative Filtering（ONCF）一文发表在IJCAI 2018上，作者使用外积对嵌入空间中各个维度之间的相互关系进行显式建模。

<!--more-->

> The key to design a CF model is in 1) how to represent a user and an item, and 2) how to model their interaction based on the representation.  

### 模型结构

![ONCF](/static/images/oncf.png)

### 目标函数

作者使用了BPR损失函数：
$$
L = \sum_{(u,i,j) \in \mathcal{D}} - \ln \sigma(\hat y_{ui} - \hat y_{uj}) + \lambda_{\Delta} \left \Vert \Delta \right \Vert^2
$$


论文地址：https://www.ijcai.org/Proceedings/2018/0308.pdf

代码地址：https://github.com/duxy-me/ConvNCF

