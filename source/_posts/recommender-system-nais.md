---
title: 论文阅读 NAIS&#58 Neural Attentive Item Similarity Model for Recommendation
date: 2019-10-21 19:22:36
tags: recommender systems
categories: recommender systems
mathjax: true
---

针对基于物品的协同过滤，作者采用注意力机制，提出了一种叫作*Neural Attentive Item Similarity model* (NAIS)的神经网络模型。

<!--more-->

### Standard Item-Based CF

$$
\hat y_{ui} = \sum_{j \in \mathcal{R}_u^+} r_{uj} s_{ij} \tag{1}
$$

其中，$\mathcal{R}_u^+​$表示用户u交互过的物品集合；$s_{ij}​$表示物品$i​$和物品$j​$之间的相似度；

$r_{uj}$表示用户u对物品j的已知偏好（对于显式反馈，$r_{uj}$是用户u对物品j的评分；对于隐式反馈，$r_{uj}​$是1或者0，表示用户u是否与物品j有过交互行为）。

### SLIM

*Sparse LInear Method* (SLIM)的目标函数：
$$
L= \frac{1}{2} \sum_{u=1}^U \sum_{i=1}^I (r_{ui} - \hat y_{ui})^2 + \frac{\beta}{2} \left \Vert \mathbf{S} \right \Vert_F^2 + \lambda \left \Vert \mathbf{S} \right \Vert_1 \\\\
subject\ to\ \mathbf{S} \geq 0, diag(\mathbf{S}) = 0 \tag{2}
$$
其中，$U$和$I$分别表示用户和物品的数量；$\mathbf{S} \in \mathbb{R}^{I \times I}$表示物品相似度矩阵；$\beta$和$\lambda$是正则化参数。

然而，SLIM有两个明显的缺点：

* 时间复杂为$O(I^2)$
* 无法捕捉物品之间的传递关系

### FISM

在*Factored Item Similarity Model* (FISM)中，相似度分数$s_{ij}$被表示为物品i和物品j的embedding向量的内积。
$$
\hat y_{ui} = \mathbf{p}_i^T \left( \frac{1}{\left \vert \mathcal{R}_u^+ - 1 \right \vert^\alpha} \sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} \mathbf{q}_j \right) \\\\
\qquad\qquad \underbrace{\mathrm{user\ u's\ representation}} \tag{3}
$$

其中，$\alpha$是控制归一化效果的超参数；$\mathbf{p}_i$和$\mathbf{q}_j$分别表示物品$i$和物品$j$的embedding向量。

由于FISM只关注隐式反馈，$\forall j \in \mathcal{R}_u^+$，$r_{uj} = 1$，因此，在公式(3)中省略了$r_{uj}$。

时间复杂度：$O(k \left \vert \mathcal{R}_u^+ \right \vert)$。其中，k表示embedding size。

作者认为：在获得用户表示时，FISM对用户交互过的所有历史物品等同处理，这可能限制了模型的性能。

用户的兴趣会随着时间而发生变化，最新交互过的物品应该对用户未来的偏好具有更好的表达能力。

### NAIS

#### 设计一

给每个物品赋予一个权重，使得历史物品对用户表示产生不同的影响。
$$
\hat y_{ui} = \mathbf{p}_i^T \left( \frac{1}{\left \vert \mathcal{R}_u^+ \right \vert^\alpha} \sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} a_j \mathbf{q}_j \right) \tag{4}
$$

其中，$a_j​$表示物品j的注意力权重（attention weight）。

然而，不管预测哪个物品i，对于同一用户的所有历史物品j来说，$a_j​$都是不变的，这显然是不合理的。

从用户表示的角度来看，该方法假定每个用户各有一个对应的静态向量，可以表示他的兴趣，这可能限制了模型的表示能力。

#### 设计二

为了解决设计一的问题，作者提出为每个物品对$(i,j)$赋予不同的权重
$$
\hat y_{ui} = \mathbf{p}_i^T \left( \frac{1}{\left \vert \mathcal{R}_u^+ \right \vert^\alpha} \sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} a_{ij} \mathbf{q}_j \right) \tag{5}
$$
其中，$a_{ij}​$表示物品j在预测用户u对目标物品i的偏好时的注意力权重。

如果物品对$(i,j)​$没有在训练数据中同时出现过（没有一个用户同时和物品i、j交互过），那么无法估计该物品对的注意力权重$a_{ij}​$。

#### 设计三

为了解决设计二的泛化问题，作者将$a_{ij}$与embedding向量$\mathbf{p}_i$和$\mathbf{q}_j​$联系在一起。
$$
a_{ij} = f(\mathbf{p}_i,\mathbf{q}_j) \tag{6}
$$
作者使用MLP来表示attention函数
$$
\begin{cases}
f_{concat}(\mathbf{p}_i,\mathbf{q}_j) = \mathbf{h}^T ReLU \left( \mathbf{W}
\begin{bmatrix}
\mathbf{p}_i \\\\
\mathbf{q}_j
\end{bmatrix} + \mathbf{b}
\right) \\\\
f_{prod}(\mathbf{p}_i,\mathbf{q}_j) = \mathbf{h}^T ReLU \left( \mathbf{W} (\mathbf{p}_i \odot \mathbf{q}_j) + \mathbf{b}
\right)
\end{cases} \tag{7}
$$
作者将隐含层的大小称之为注意力因子（*attention factor*），并使用softmax函数将注意力权重转化为概率分布。
$$
\hat y_{ui} = \mathbf{p}_i^T \left( \sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} a_{ij}\mathbf{q}_j \right) \\\\
a_{ij} = \frac{\exp(f(\mathbf{p}_i, \mathbf{q}_j))} {\sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} \exp(f(\mathbf{p}_i, \mathbf{q}_j))} \tag{8}
$$
然而，softmax函数可能过度地惩罚了活跃用户的权重，从而导致上述设计的性能显著低于FISM。

为了解决这个问题，作者提出对softmax函数的分母进行平滑：
$$
\hat y_{ui} = \mathbf{p}_i^T \left( \sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} a_{ij}\mathbf{q}_j \right) \\\\
a_{ij} = \frac{\exp(f(\mathbf{p}_i, \mathbf{q}_j))} {[\sum_{j \in \mathcal{R_u^+ \setminus \\{i\\}}} \exp(f(\mathbf{p}_i, \mathbf{q}_j))]^\beta} \tag{9}
$$
其中，$\beta$是平滑指数。

时间复杂度：$O(a k \left \vert \mathcal{R}_u^+ \right \vert)$。其中，$a$表示注意力因子，k表示embedding size。

![](/static/images/nais.png)

### 损失函数

作者采用了常见的二元交叉熵损失
$$
\begin{align}
L &= -\frac{1}{N} \left( \sum_{(u,i) \in \mathcal{R^+}} \log \sigma(\hat y_{ui}) + \sum _{(u,i) \in \mathcal{R^-}}  \log(1 - \sigma(\hat y_{ui})) \right) + \lambda \left \Vert \Theta \right \Vert^2 \\\\
&= -\frac{1}{N} \left( \sum_{(u,i) \in \mathcal{R^+} \cup \mathcal{R^-}} y_{ui} \log \sigma(\hat y_{ui}) + (1 - y_{ui}) \log(1 - \sigma(\hat y_{ui})) \right) + \lambda \left \Vert \Theta \right \Vert^2
\end{align} \tag{10}
$$
其中，
$$
y_{ui}=
\begin{cases}
0, & \mathrm{for\ unknown\ ratings} \\\\
1, & \mathrm{otherwise}
\end{cases}
$$

### 实验设置

采用留一法作为评估方法，HR和NDCG作为评估指标。

在训练时，为每个正样本随机选择4个负样本；在测试时，为每个测试物品随机选择99个负样本。

注意力因子a和embedding size k相等，$\beta=0.5, k = a = 16,\lambda = 0$。

推荐数量N设置为10。

采用Adagrad作为优化器，学习率设置为0.01。

使用FISM学到的物品embeddings初始化NAIS。

由于不同的用户交互过的物品数目也不同，为了解决这个问题，作者提出将某一用户的全部训练实例作为一个mini-batch，从而不需要设置batch_size。

### 参考文献

[1] He, Xiangnan , et al. "NAIS: Neural Attentive Item Similarity Model for Recommendation." *IEEE Transactions on Knowledge and Data Engineering* (2018):1-1. [[PDF]](http://staff.ustc.edu.cn/~hexn/papers/tkde18-neural-attentive-itemCF.pdf)  [[Code]](https://github.com/AaronHeee/Neural-Attentive-Item-Similarity-Model) 

[2] B. Sarwar, G. Karypis, J. Konstan, and J. Riedl, “Item-based collaborative filtering recommendation algorithms,” in Proc. 10th Int. Conf. World Wide Web, 2001, pp. 285–295.

[3] X. Ning and G. Karypis, “SLIM: Sparse linear methods for top-n recommender systems,” in Proc. IEEE 11th Int. Conf. Data Mining, 2011, pp. 497–506.

[4] S. Kabbur, X. Ning, and G. Karypis, “FISM: Factored item similar- ity models for top-n recommender systems,” in Proc. 19th ACM SIGKDD Conf. Knowl. Discovery Data Mining, 2013, pp. 659–667.

我的复现 Keras：Neural Attentive Item Similarity