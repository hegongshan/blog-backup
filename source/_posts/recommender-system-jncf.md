---
title: 论文阅读 Joint Neural Collaborative Filtering for Recommender Systems
date: 2019-10-14 21:38:16
tags: recommender systems
categories: recommender systems
mathjax: true
---

作者使用一个联合神经网络将用户和物品的深度特征学习、用户与物品之间的深度交互建模整合在一起。此外，作者综合考虑了显式反馈和隐式反馈、pointwise和pairwise损失，提出了一种新的损失函数。

<!--more-->

### Joint Neural Collaborative Filtering (J-NCF)

![](/static/images/jncf.png)

J-NCF包含两个主要的网络：DF网络用于对用户和物品的特征进行建模，而DI网络则用于对用户和物品之间的交互进行建模。

DF网络包含两个并行的神经网络，一个是抽取用户特征的$Net_{user}​$，另一个是抽取物品特征的$Net_{item}​$。

$Net_{user}$和$Net_{item}$分别以用户的评分向量$\mathbf{v_u} = <y_{u1},\cdots,y_{uN}>$和物品的评分向量$\mathbf{v_i} = <y_{1i},\cdots,y_{Mi}>$作为输​入。
$$
y_{ui} = 
\begin{cases}
0, & \mathrm{for\ unknown\ ratings}, \\\\
R_{ui}, & \mathrm{when\ explicit\ feedback\ is\ available}
\end{cases} \tag{3}
$$
其中，$R_{ui}$是用户u对物品i的评分。

可以看到，对于用户物品交互矩阵，作者遵循了DMF中的做法，综合考虑了显式反馈和隐式反馈。

在DF网络中，作者使用MLP将用户和物品的高维评分向量映射为更低维度的向量。

由于$Net_{user}$和$Net_{item}$只有输入不同，因此，下面仅描述$Net_{user}$的流程。
$$
\mathbf{z_u^1} = f_u^1(\mathbf{W_u^1 v_u + b_u^1}) \\\\
\mathbf{z_u^2} = f_u^2(\mathbf{W_u^2 z_u^1 + b_u^2}) \\\\
\vdots \\\\
\mathbf{z_u} = f_u^X(\mathbf{W_u^X z_u^{X-1} + b_u^X}) \tag{4}
$$
其中，$\mathbf{W_{u}^x}$、$\mathbf{b_{u}^x}$、$f_{u}^x$分别表示DF网络中第x层的权重矩阵、偏置向量和激活函数；X表示DF网络的层数。

在DF网络中，作者采用ReLU作为激活函数。

为了研究非线性函数和线性函数在对用户和物品之间的交互进行建模的差异，作者提出使用以下两种方式来得到用户和物品的融合特征向量$a_{ui}​$，并将其作为DI网络的输入：
$$
a_{ui} = 
\begin{cases}
\begin{bmatrix}
z_u \\\\
z_i
\end{bmatrix},
 & \mathrm{concatenation,\ or} \\\\
 z_u \odot z_i, & \mathrm{multiplication}
\end{cases} \tag{5}
$$
DI网络的处理流程如下：
$$
z_{ui}^1 = f_{ui}^1(\mathbf{W_{ui}^1} a_{ui} + \mathbf{b_{ui}^1}) \\\\
z_{ui}^2 = f_{ui}^2(\mathbf{W_{ui}^2} z_{ui}^1 + \mathbf{b_{ui}^2}) \\\\
\vdots \\\\
z_{ui}^Y = f_{ui}^Y(\mathbf{W_{ui}^Y} z_{ui}^{Y-1} + \mathbf{b_{ui}^Y}) \tag{6}
$$
其中，$\mathbf{W_{ui}^y}$、$\mathbf{b_{ui}^y}$、$f_{ui}^y$分别表示DI网络中第y层的权重矩阵、偏差向量和激活函数；Y表示DI网络的层数。

在DI网络中，作者亦采用ReLU作为激活函数。

DI网络的输出是用户u和物品i之间交互的预测分数$\hat y_{ui}$:
$$
\hat y_{ui} = \sigma(\mathbf{h^T}z_{ui}) \tag{7}
$$
其中，$\sigma$是sigmoid函数，它将输出限制在区间(0,1)中；$\mathbf{h}$为DI网络输出层的权重向量。

### 损失函数

NCF和DMF均采用了基于pointwise的对数损失函数
$$
\ell_{log} = - \sum_{u \in U} \sum_{i \in I} y_{ui} \log \hat y_{ui} + (1-y_{ui}) \log(1-\hat y_{ui}) \tag{10}
$$
常见的基于pairwise的损失函数有：TOP1、BPR-max以及TOP1-max。
$$
\ell_{TOP1} = \frac{1}{\left \vert N_S \right \vert} \sum_{j \in N_S} \sigma(\hat y_{uj} - \hat y_{ui}) + \sigma(\hat y_{uj}^2) \tag{11}
$$
其中，$\hat y_{uj}$和$\hat y_{ui}$分别为负样本j和正样本i的预测分数；$N_S$为负样本集合。

为了克服随着负样本数量的增加而产生的梯度消失问题，Hidasi和Karatzoglou提出了BPR-max和TOP1-max
$$
\ell_{TOP1-max} = \sum_{j \in N_S} s_j \left( \sigma(\hat y_{uj} - \hat y_{ui}) + \sigma(\hat y_{uj}^2) \right) \tag{12}
$$
BPR-max
$$
\ell_{BPR-max} = -\log \sum_{j \in N_S} s_j \sigma(\hat y_{ui} - \hat y_{uj}) \tag{13}
$$
其中，$s_j$为相应的softmax分数。

至于listwise损失函数，许多基于深度学习的方法将交叉熵与softmax整合在一起，作者称之为softmax+cross-entropy (XE)

$$
\ell_{XE} = -\log s_i = -\log \frac{e^{\hat y_{ui}}}{\sum_{j \in N_S} e^{\hat y_{uj}}} \tag{14}
$$
作者认为，pointwise损失只使用了评分信息，忽略了物品对之间相对顺序所包含的信息；而pairwise则刚好相反，它忽略了用户对某一物品的个人偏好信息。

因此，作者综合考虑了pointwise和pairwise，提出了一种新的损失函数：
$$
L = \alpha L_{pair-wise} + (1 - \alpha) L_{point-wise} \tag{15}
$$
其中，$\alpha$是一个权衡参数，用于控制两者的权重。

在pointwise部分，作者采用了DMF中提出的归一化对数损失函数，从而
$$
L = \alpha L_{pair-wise} + (1 - \alpha) (- Y_{ui} \log \hat y_{ui} - (1-Y_{ui}) \log(1-\hat y_{ui})) \tag{16}
$$
其中，$Y_{ui} = \frac{y_{ui}}{\max(R_u)}$，$R_u​$为用户u给出的最大评分。

作者将公式(16)称之为hybrid loss function。

### 训练算法

![](/static/images/jncf-training-algorithm.png)

### 实验设置

作者采用留一法作为评估方法，使用Hit Ratio（HR）和NDCG作为评估指标。

在训练的时候，为每个正样本随机选择5个负样本；在测试的时候，为每个测试物品随机选择100个负样本。

使用高斯分布（均值为0、方差为0.01的正态分布）随机初始化模型参数，优化器为mini-batch Adam。

batch_size设置为256，学习率设置为0.0001。

迭代100次，推荐数量N设置为10。

DF网络使用三层结构，每层的神经元数量为[256,128,64]；DI网络使用两层结构，每层的神经元数量为[128,8]。

### 参考文献

[1] Wanyu Chen, Fei Cai, Honghui Chen, and Maarten De Rijke. 2019. Joint Neural Collaborative Filtering for Recommender Systems. *ACM Trans. Inf. Syst.* 37, 4, Article 39 (August 2019), 30 pages. DOI: https://doi.org/10.1145/3343117

[2] Xiangnan He, Lizi Liao, Hanwang Zhang, Liqiang Nie, Xia Hu and Tat-Seng Chua (2017). [Neural Collaborative Filtering.](http://dl.acm.org/citation.cfm?id=3052569) In Proceedings of WWW ‘17, Perth, Australia, April 03-07, 2017.

[3] Hong-Jian Xue, Xin-Yu Dai, Jianbing Zhang, Shujian Huang, and Jiajun Chen. 2017. Deep matrix factorization models for recommender systems. In Proceedings of the 26th International Joint Conference on Artificial Intelligence (IJCAI'17), Carles Sierra (Ed.). AAAI Press 3203-3209. 