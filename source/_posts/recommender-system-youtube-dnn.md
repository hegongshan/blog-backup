---
title: 论文阅读 Deep Neural Networks for YouTube Recommendations
date: 2019-12-02 18:53:08
tags: recommender systems
categories: recommender systems
mathjax: true
---

深度学习在工业界推荐系统中的典型实例。

<!--more-->

### YouTube推荐系统架构

![System architecture](/static/images/youtube-dnn-overview.png)

第一阶段：candidate generation model。从数百万的视频库中筛选出数百的候选项。

第二阶段：ranking model。对数百候选视频进行排序。

### Candidate generation

![Deep candidate generation model](/static/images/youtube-dnn-candidate-generation.png)

候选生成模型利用了用户的观看历史、搜索历史、人口统计学特征以及简单的二元和连续特征（如性别、视频存在的时间等）。

平均池化。

候选生成模型使用用户最近一次的观看作为测试集，而没有采用传统的随机留一法（random hold-out）。因为随机留一法泄露了未来的信息，忽略了那些不对称的消费模式。

候选生成模型的网络结构遵循常见的塔型结构，即网络的底部最宽，之后每个隐含层的单元数量减半。

### Ranking

![Deep rank model](/static/images/youtube-dnn-rank.png)

深度排序模型利用了更多的特征，如

目标：预测预期的观看时长。

深度排序模型使用加权logistic回归作为输出层的激活函数。正样本的权重为观看时长，而负样本的权重为1。

一个事件的几率（odds）是指该事件发生的概率与该事件不发生的概率的比值。

如果事件发生的概率为p，那么该事件的几率为$\frac{p}{1-p}$，该事件的对数几率或logit函数为：
$$
\ln (odds) = \ln \frac{p}{1 - p}
$$
logistic回归模型：
$$
P(Y=1|x) = \frac{1}{1 + e^{-(Wx+b)}}
$$
Y=1的对数几率为：
$$
\ln odds = \ln \frac{P(Y=1|x)}{1-P(Y=1|x)} = Wx + b
$$
对两边进行变换，可以得到：
$$
odds = \frac{p}{1-p} = e^{W x + b}
$$
采用加权logistic回归，视频i被观看的几率为
$$
\mathrm{odds(i)} = \frac{
	T_i p
}{
	1 - T_i p
}
= \frac{
	E(T_i)
}{
	1 - T_i p
}
$$
其中，p是样本i被点击的概率，$T_i$表示样本i的观看时长，$E(T_i)$是样本i观看时长的期望。

假定$T_i p$很小，根据泰勒公式
$$
\frac{1} {1-x} = 1 + x + O(x^2)
$$
从而：
$$
\begin{align}
\mathrm{odds(i)} 
&\approx E(T_i) (1 + T_i p) \\\\
&\overset{p\ is\ small}{\approx} E(T_i)
\end{align}
$$
由于p很小，因此，odds(i)近似等于$E(T_i)$。

在serving阶段，使用指数函数$e^{Wx+b}$作为最终的激活函数，得到的结果就是预期的观看时长。