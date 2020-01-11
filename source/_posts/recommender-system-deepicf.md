---
title: 论文阅读 Deep Item-based Collaborative Filtering for Top-N Recommendation
date: 2019-11-13 20:05:31
tags: recommender systems
categories: recommender systems
mathjax: true
---

作者提出了基于深度神经网络的item-based CF（DeepICF），同时学习物品之间的二元关系和高层关系。

<!--more-->

### DeepICF

![DeepICF](/static/images/deepicf.png)

#### Input & Embedding Layer

对于目标物品i，使用其ID表示它，然后将其转换为embedding向量$\mathbf{p}_i \in \mathbb{R}^k$，k表示embedding size。

对于用户u，使用其交互过的物品$\mathcal{R}_u^+$的ID表示它。

然后，将用户u的每一个历史物品$j \in \mathcal{R}_u^+$，转换为embedding向量$\mathbf{q}_j \in \mathbb{R}^k$。

#### Pairwise Interaction Layer

作者使用逐元素相乘来捕获物品之间的二元关系。

该层的输出结果：$\mathcal{V}_{ui} = \\{ \mathbf{q}_j \odot \mathbf{p}_i | j \in \mathcal{R^+_u} \setminus i \\}$

#### Pooling Layer

由于不同用户的历史物品数量并不相同，因此，pairwise interaction层的输出大小会发生变化。对此，作者使用池化层将其转换为固定大小的向量。

* 方法一：加权平均池化

$$
f_{avg}(\mathcal{V}_{ui}) = \frac{1}{
    \left \vert \mathcal{V}_{ui} \right \vert^\alpha 
} \sum_{\mathbf{v} \in \mathcal{V}_{ui}} \mathbf{v}
= \frac{1}{
	(\left \vert \mathcal{R}_u^+ \right \vert - 1)^\alpha	
} (\sum_{j \in \mathcal{R^+_u} \setminus i} \mathbf{q}_j \odot \mathbf{p}_i) \tag{1}
$$

其中，$\alpha$是归一化超参数。

然而，加权平均池化的不足之处在于：假定用户的历史物品对目标物品的预测贡献相同。

* 方法二：基于attention的池化

$$
f_{att}(\mathcal{V}_{ui}) = \frac{1}{
    \left \vert \mathcal{V}_{ui} \right \vert^\alpha 
} \sum_{\mathbf{v} \in \mathcal{V}_{ui}} a(\mathbf{v}) \cdot \mathbf{v}
= \frac{1}{
	(\left \vert \mathcal{R}_u^+ \right \vert - 1)^\alpha	
} \sum_{j \in \mathcal{R^+_u} \setminus i} a(\mathbf{q}_j \odot \mathbf{p}_i) \cdot (\mathbf{q}_j \odot \mathbf{p}_i) \tag{2}
$$

其中，$a(\mathbf{v})$是attention函数。

作者使用包含一个隐含层的MLP作为attention网络。

![Attention Network in DeepICF+a](/static/images/deepicf_attention_network.png)
$$
a(\mathbf{v}) = \mathrm{softmax}^\prime (\mathbf{h}^T ReLU(\mathbf{Wv + b})) \tag{3}
$$
其中，$\mathbf{W} \in \mathbb{R}^{k^\prime \times k}$、$\mathbf{b} \in \mathbb{R}^{k^\prime}$分别表示attention网络的权重矩阵和偏差向量；$k^\prime$表示隐含层的大小；

$\mathbf{h } \in \mathbb{R}^{k^\prime}$表示attention网络输出层的权重；

$\mathrm{softmax}^\prime$是softmax函数的变体：
$$
\mathrm{softmax}^\prime (a(\mathbf{v})) = \frac{
    \exp a(\mathbf{v})
}{
    [\sum_{\mathbf{v} \in \mathcal{V}_{ui}} \exp a(\mathbf{v})]^\beta
} \tag{4}
$$
其中，$\beta$是平滑指数。

![DeepICF+a](/static/images/deepicf+a.png)

#### Deep Interaction Layer

用$\mathbf{e}_{ui}$表示池化层的输出向量。

在池化层之上，作者提出使用MLP对物品之间的高层关系进行建模。
$$
\mathbf{e}_1 = ReLU(\mathbf{W}_1 \mathbf{e}_{ui} + \mathbf{b}_1) \\\\
\mathbf{e}_2 = ReLU(\mathbf{W}_2 \mathbf{e}_1  + \mathbf{b}_2) \\\\
\dots \\\\
\mathbf{e}_L = ReLU(\mathbf{W}_L \mathbf{e}_{L-1}  + \mathbf{b}_L) \tag{5}
$$
其中，$\mathbf{W}_l$、$\mathbf{b}_l$和$\mathbf{e}_l$分别表示第l个隐含层的权重矩阵、偏差向量和输出向量。

#### Prediction Layer

$$
\hat y_{ui} = \mathbf{z}^T \mathbf{e}_L + b_u + b_i \tag{6}
$$

其中，$\mathbf{z}$、$b_u$和$b_i$分别为预测层的权重向量、用户偏差和物品偏差。

### 目标函数

$$
\mathcal{L} = \frac{-1}{\left \vert \mathcal{R}^+\right \vert + \left \vert \mathcal{R}^-\right \vert} 
\left [ 
\sum_{(u,i) \in \mathcal{R}^+} \log \delta(\hat y_{ui}) +  
\sum_{(u,i) \in \mathcal{R}^-} \log ( 1 - \delta(\hat y_{ui}) )
\right ] +
\lambda \left \Vert \Theta \right \Vert^2 \tag{7}
$$

其中，$\delta(\cdot)$是sigmoid函数；$\mathcal{R}^+$是正样本，$\mathcal{R}^-​$是负样本。

### 参考文献

Deep Item-based Collaborative Filtering for Top-N Recommendation Feng Xue, Xiangnan He, Xiang Wang, Jiandong Xu, Kai Liu, & Richang Hong, ACM Transactions on Information Systems (TOIS 2019). [[PDF]](https://arxiv.org/pdf/1811.04392.pdf)  [[Codes]](https://github.com/linzh92/DeepICF)