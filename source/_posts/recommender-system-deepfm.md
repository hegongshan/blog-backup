---
title: 论文阅读 DeepFM&#58 A Factorization-Machine based Neural Network for CTR Prediction
date: 2020-01-08 20:45:24
tags: recommender systems
categories: recommender systems
mathjax: true
---

DeepFM一文发表在IJCAI 2017上，作者在wide & deep的基础上，使用分解机代替线性回归，从而避免了特征工程。

<!--more-->

### 问题陈述

点击率（Click Through Rate，简称CTR）预测：

构建一个预测模型$\hat y = model(x)$，估计某个用户在给定的背景下点击特定应用的概率。

### 研究动机

现有的点击率预测方法

1. 要么只学习低阶特征交互，如FM
2. 要么只学习高阶特征交互，如FNN和PNN
3. 要么依赖于特征工程，如wide & deep

DeepFM能同时学习各种层次的特征交互，且不需要特征工程。

### 模型结构

![DeepFM](/static/images/deepfm-architecture.png)

FM和deep模块使用相同的embedding向量。

预测模型：
$$
\hat y = \mathrm{sigmoid}(y_{FM} + y_{DNN}) \tag{1}
$$
其中，$\hat y \in (0,1)$是预测的点击率，$y_{FM}$是分解机模块的输出，$y_{DNN}$是深度模块的输出。

#### 分解机模块

![FM Component](/static/images/deepfm-fm.png)

表达式：
$$
y_{FM} = <w,x> + \sum_{i=1}^d \sum_{j=i+1}^d <V_i, V_j> x_i \cdot x_j \tag{2}
$$
其中，$w \in R^d$，$V_i \in R^k$。

#### 深度模块

![Deep Component](/static/images/deepfm-deep.png)



论文地址：https://www.ijcai.org/proceedings/2017/0239.pdf