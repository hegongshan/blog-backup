---
title: 论文阅读 CFM&#58 Convolutional Factorization Machines for Context-Aware Recommendation
date: 2020-01-14 20:00:43
tags: recommender systems
categories: recommender systems
mathjax: true
---

Convolutional Factorization Machine（CFM）一文发表在IJCAI 2019上，作者使用叉积对二阶交互进行建模，利用3D CNN来学习高阶交互。

<!--more-->

### 研究动机

1. 分解机无法对高阶和非线性的特征交互进行充分建模
2. 现有的使用神经网络增强分解机的方法，均假定嵌入的维度彼此独立，并以相对隐式的方式对高阶交互进行建模

### 模型结构

![CFM](/static/images/cfm.png)

### 损失函数

作者使用BPR损失函数
$$
L = \sum - \ln \sigma(\hat y_{CFM} (\mathbf{x}^+) - \hat y_{CFM} (\mathbf{x}^-))
$$
