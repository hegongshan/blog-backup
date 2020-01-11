---
title: 论文阅读 DeepCF&#58 A Unified Framework of Representation Learning and Matching Function Learning in Recommender System
date: 2019-12-30 18:45:39
tags: recommender systems
categories: recommender systems
mathjax: true
---

DeepCF一文发表在AAAI 2019上，作者将基于表示学习的方法与基于匹配函数学习的方法进行了融合，极大地改进了模型性能。

<!--more-->

### 现有方法的不足

1. 在预测匹配分数时， 现有的基于表示学习的方法使用了简单的点积或者余弦相似度，严重地限制了模型的表达能力。

2. 现有的基于匹配函数的方法，常常使用MLP作为匹配函数，而MLP无法对低秩关系进行充分的建模。

### 问题描述

假设有M个用户，N个物品。

根据用户的隐式反馈，构建用户-物品交互矩阵$：\mathbf{Y} \in \mathbb{R}^{M \times N}$
$$
y_{ui} = 
\begin{cases}
1, & \mathrm{if\ interaction\ (user}\ u, \mathrm{item}\ i)\ \mathrm{is\ observed;} \\\\
0, & \mathrm{otherwise}
\end{cases} \tag{1}
$$
假设$y_{ui}$服从伯努利分布（二项分布）：
$$
P(y_{ui} = k | p_{ui}) = 
\begin{cases}
1 - p_{ui}, & k = 0 \\\\
p_{ui}, & k = 1
\end{cases}
=p_{ui}^k (1 - p_{ui})^{1-k} \tag{2}
$$

### 目标函数

似然函数：
$$
\begin{align}
L &= \prod_{(u,i) \in \mathcal{Y}^+ \cup \mathcal{Y}^-} P(y_{ui} | \Theta) \\\\
&= \prod_{(u,i) \in \mathcal{Y}^+ \cup \mathcal{Y}^-} \hat y_{ui}^{y_{ui}} (1 - \hat y_{ui})^{1 - y_{ui}}
\end{align} \tag{3}
$$
其中，$\mathcal{Y}^+$表示$\mathbf{Y}$中的正样本，$\mathcal{Y}^-$表示采集的负样本。

两边取对数：
$$
\ell_{BCE} = - \sum_{(u,i) \in \mathcal{Y}^+ \cup \mathcal{Y}^-} y_{ui} \log \hat y_{ui} + (1 - y_{ui}) \log (1 - \hat y_{ui}) \tag{4}
$$

### DeepCF

#### 处理过程

![General Process](/static/images/deepcf-general-process.png)

#### 模型结构

![CFNet](/static/images/deepcf.png)

论文地址：https://arxiv.org/pdf/1901.04704.pdf

实验代码：https://github.com/familyld/DeepCF