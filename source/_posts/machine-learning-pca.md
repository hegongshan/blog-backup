---
title: 机器学习之PCA算法
date: 2018-08-26 14:08:44
tags: 降维
categories: 机器学习
mathjax: true
---

主成分分析（Principal Component Analysis，简称PCA）。


$$
\begin{align}
\hline 
& PCA算法 \\\\
\hline
& 输入：样本集D=\\{x_1,x_2,\dots,x_m\\};低维空间维数d^{'} \\\\
& 过程： \\\\
& 1. 对所有样本进行中心化：x_i \leftarrow x_i - \frac{1}{m} \sum_{i=1}^{m} x_i;\\\\
& 2.计算样本的协方差矩阵XX^{T}; \\\\
& 3.对协方差矩阵XX^{T}做特征值分解; \\\\
& 4.取最大的d^{'}个特征值所对应的特征向量w_1,w_2,\dots,w_{d^{'}}. \\\\
& 输出：投影矩阵W=(w_1,w_2,\dots,w_{d^{'}})
\end{align}
$$
