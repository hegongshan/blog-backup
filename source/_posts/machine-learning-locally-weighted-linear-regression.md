---
title: 机器学习之局部加权线性回归
date: 2018-08-17 19:35:13
tags: 机器学习
categories: 机器学习
---

局部加权线性回归（Locally Weighted Linear Regression，LWLR）。

在该算法中，给预测点附近的每个点赋予一定的权重，在这个子集上基于最小均方差来进行普通的回归。

局部加权线性回归的均值误差可用下式表示
$$
\sum_{i=1}^{m} w_i (y_i - x_i^{T} \theta_i)^2
$$
其中，$w_i$是权重，$y_i$是真实值，$x_i$是输入值，$\theta_i$为对应的回归系数。

回归系数$w$为
$$
\hat w = (X^{T} W X )^{-1} X^{T} W y
$$
