---
title: 论文阅读 Neural Collaborative Filtering
date: 2019-09-17 16:48:49
tags: recommender systems
categories: recommender systems
mathjax: true
---

Neural Collaborative Filtering提出了一种融合模型，将深度学习运用到推荐系统中，在隐式反馈问题上获得了state-of-the-art。

<!--more-->

隐式反馈：
$$
y_{ui} =
\begin{cases}
1, & if\ iteraction\ (user\ u,item\ i)\ is\ observed; \\\\
0, & otherwise.
\end{cases}
$$
### NCF(Neural Collaborative Filtering)

![](/static/images/ncf.png)

似然函数：
$$
p(\mathcal{Y},\mathcal{Y}^{-}|\mathbf{P},\mathbf{Q},\Theta_{f}) = \prod_{(u,i) \in \mathcal{Y}} \hat y_{ui} \prod_{(u,j) \in \mathcal{Y}^{-}} (1-\hat y_{uj})
$$
取负对数，得到目标函数：
$$
\begin{align}
\min L &= - \sum_{(u,i) \in \mathcal{Y}}\log{\hat y_{ui}} - \sum_{(u,j) \in \mathcal{Y}^{-}} \log{(1-\hat y_{uj})} \\\\
 &= - \sum_{(u,i) \in \mathcal{Y} \cup (u,j) \in \mathcal{Y}^{-}}{y_{ui} \log{\hat y_{ui}} + (1-y_{ui}) \log{(1-\hat y_{ui})}}
\end{align}
$$
上式就是二元交叉熵损失。

#### GMF

$$
\hat y_{ui} = a_{out}(\mathbf{h}^T (\mathbf{p_u} \odot \mathbf{q_i}))
$$
其中，$a_{out}$是激活函数，$\mathbf{h}^T$是输出层的边权值，$\odot$表示逐元素相乘，$\mathbf{p_u}$和$\mathbf{q_i}$分别表示用户u和物品i的隐向量。

![](/static/images/ncf-gmf.png)

#### MLP

$$
\mathbf{z_1} = \phi_{1}(\mathbf{p_u}, \mathbf{q_i}) = 
\begin{bmatrix}
\mathbf{p_u} \\\\
\mathbf{q_i}
\end{bmatrix}, \\
\phi_2(\mathbf{z_1}) = a_2 (\mathbf{W_2}^T \mathbf{z_1} + \mathbf{b_2})), \\\\
\cdots \\\\
\phi_L(\mathbf{z_{L-1}}) = a_L(\mathbf{W_L}^T \mathbf{z_{L-1}} + \mathbf{b_L})),\\\\
\hat{y_{ui}} = \sigma(\mathbf{h^T}\phi_L (\mathbf{Z_{L-1}}))
$$

其中，$\mathbf{W}_x$第x层的权重矩阵，$\mathbf{b}_x$是偏置向量，$a_x$是激活函数，$\sigma$是Sigmoid函数。

![](/static/images/ncf-mlp.png)

#### NeuMF（Nerual matrix factorization）

让GMF和MLP分别学习不同的embeddings，将两个模型的最后一个隐含层拼接起来。
$$
\phi^{GMF} = \mathbf{p}_u^G \odot \mathbf{q}_i^G,\\\\
\phi^{MLP}=a_L(\mathbf{W}^T_L(a_{L-1}(\cdots a_2(\mathbf{W_2}^T \mathbf{z_1} + \mathbf{b_2}) \cdots)) + \mathbf{b_L})) \\\\
\hat{y_{ui}} = \sigma (\mathbf{h}^T 
\begin{bmatrix}
\phi^{GMF} \\\\
\phi^{MLP}
\end{bmatrix}
)
$$
其中，$\mathbf{p}_u^G$和$\mathbf{p}_u^M$分别表示GMF和MLP的user embedding，$\mathbf{q}_u^G$和$\mathbf{q}_u^M$亦然。

![](/static/images/ncf-neumf.png)

### 预训练

NeuMF中，将GMF和MLP的最后一个隐含层，按照如下的方式拼接起来。
$$
\mathbf{h} \leftarrow 
\begin{bmatrix}
\alpha \mathbf{h}^{GMF} \\\\
(1-\alpha) \mathbf{h}^{MLP}
\end{bmatrix}
$$
其中，$\mathbf{h}^{GMF}$和$\mathbf{h}^{MLP}$为预训练的GMF和MLP输出层的边权值$\mathbf{h}$。$\alpha$是一个超参数，用于权衡两个预训练模型。

使用Adam对预训练的GMF和MLP进行优化；对NeuMF，使用随机梯度下降SGD进行优化。

### 实验设置

**数据集**：MovieLens-1m和Pinterest

**评估方法**：留一法（使用最后一次交互作为测试集，其他的作为训练集）

随机选取100个用户没有与之发生交互行为的物品，将测试物品与这100个样本混在一起进行排序。

**评测指标**：击中率（Hit Ratio）和NDCG。对这两个指标，采用Top10推荐。

Hit Ratio用于判断测试物品是否在排在前10。

为每个用户计算这两个指标，最后分别求平均值。

**参数设置**：使用高斯分布（均值为0，标准差为0.01）随机初始化模型参数，使用小批量的Adam优化模型。

使用三层的MLP，GMF和MLP的权衡超参数$\alpha$设置为0.5。（个人认为**$\alpha$应该也是可以优化的**，但是作者没有对$\alpha$的不同取值进行对比实验）

在训练集中，为每个正样本随机选择四个负样本。

### 相关资源

Xiangnan He, Lizi Liao, Hanwang Zhang, Liqiang Nie, Xia Hu and Tat-Seng Chua (2017). [Neural Collaborative Filtering.](http://dl.acm.org/citation.cfm?id=3052569) In Proceedings of WWW '17, Perth, Australia, April 03-07, 2017.

论文原文：http://staff.ustc.edu.cn/~hexn/papers/www17-ncf.pdf

论文代码：https://github.com/hexiangnan/neural_collaborative_filtering

作者使用的是keras 1.0.7，在最新版本中，某些函数（或者参数）已被废弃

我的复现（Keras 2.2.5）：https://github.com/hegongshan/neural_collaborative_filtering

