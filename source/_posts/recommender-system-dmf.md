---
title: 论文阅读 Deep Matrix Factorization Models for Recommender Systems
date: 2019-10-04 12:04:54
tags: recommender systems
categories: recommender systems
mathjax: true
---

作者综合考虑了显式评分和隐式反馈，提出了一个基于深度学习的矩阵分解方法以及一个新的损失函数。

<!--more-->

### 用户-物品交互矩阵

在过去的研究中，大部分的学者采用如下的方式构造交互矩阵：
$$
Y_{ij} = 
\begin{cases}
0, & if\ R_{ij} = unk \\\\
1, & otherwise
\end{cases} \tag{1}
$$
其中，$R_{ij}$表示用户$i$对物品$j$的评分。

作者认为，显式评分表明了用户对物品的偏好程度，因此，在构造交互矩阵时，综合考虑了显式评分和隐式反馈。
$$
Y_{ij} =
\begin{cases}
0, & if\ R_{ij} = unk \\\\
R_{ij}, & otherwise
\end{cases} \tag{2}
$$

### 符号定义

$Y​$表示经过公式(2)转换后得到的用户-物品交互矩阵。

$Y^+$表示已被观察到的交互行为，$Y^-$表示$Y$中的所有零元素，$Y^-_{sampled}$表示负样本集合（从$Y^-$中采样得到）。

$Y_{i\*}$表示$Y$中的第$i$行，$Y_{\*j}$表示$Y$中的第$j$列。

### Deep Matrix Factorization (DMF)

![](/static/images/dmf.png)

作者使用**ReLU**作为输出层和隐含层的激活函数
$$
f(x) = \max(0,x) \tag{6}
$$
在DMF的架构中，作者使用两个多层神经网络分别转换用户u和物品v的表示。
$$
p_i = f_{\theta^U_N}(\cdots f_{\theta^U_3}(W_{U2}\ f_{\theta^U_2}(Y_{i\*} W_{U1}))\cdots) \\\\
q_j = f_{\theta^I_N}(\cdots f_{\theta^I_3}(W_{V2}\ f_{\theta^I_2}(Y^T_{\*j} W_{V1}))\cdots) 
\tag{7}
$$
其中，$W_{U1}$和$W_{V1}$分别是U、I第一层的权重矩阵，$W_{U2}$和$W_{V2}$分别是U、I第二层的权重矩阵...

最后，使用余弦相似度，来得到最终的预测分数。
$$
\hat Y_{ij} = F^{DMF}(u_i,v_j|\Theta)=cosine(p_i,q_j) = \frac{p_i^T q_j}{\left \Vert p_i \right \Vert \left \Vert q_j \right \Vert} \tag{8}
$$

### 损失函数

在过去的研究中，平方损失被大量采用
$$
L_{sqr} = \sum_{(i,j)\in Y^+\ \cup\ Y^-} w_{ij}(Y_{ij} - \hat Y_{ij})^2 \tag{10}
$$
其中，$w_{ij}$表示训练实例$(i,j)$的权重。然而，平方损失并不适用于隐式反馈问题。

在隐式反馈中，目标值$Y_{ij}​$要么是1，要么是0，表示用户$i​$与物品$j​$之间是否存在交互行为。

因此，何向南在Neural Collaborative Filtering中提出采用二元交叉熵作为损失函数：
$$
L = -\sum_{(i,j)\in Y^+\ \cup\ Y^-} Y_{ij} \log \hat Y_{ij}) + (1 - Y_{ij}) \log (1 - \hat Y_{ij}) \tag{11}
$$
作者将显式评分整合进交叉熵损失中，提出了**归一化交叉熵损失**（normalized cross entropy loss, **nce**）：
$$
L = -\sum_{(i,j) \in Y^+ \cup Y^-} (\frac{Y_{ij}}{\max (R)} \log \hat Y_{ij} + (1 - \frac{Y_{ij}}{\max (R)}) \log (1 - \hat Y_{ij})) \tag{12}
$$
其中，$\max(R)$是所有评分中的最大评分（例如，在五星评分系统中，max(R) = 5）。

其目的在于让不同的$Y_{ij}$值对损失产生不同的影响。

### DMF的训练算法

![](/static/images/dmf-training-algorithm.png)

由于$Y_{ij}$的预测评分$\hat Y_{ij}$可能为负，因此，作者使用公式(13)来转换原始预测评分。
$$
\hat Y^\circ_{ij} = \max(\mu,\hat Y_{ij}) \tag{13}
$$
其中，$\mu$是一个非常小的数字。在实验中，作者将其设置为$1.0e^{-6}​$。

### 参考文献

1.Hong-Jian Xue, Xin-Yu Dai, Jianbing Zhang, Shujian Huang, and Jiajun Chen. 2017. Deep matrix factorization models for recommender systems. In Proceedings of the 26th International Joint Conference on Artificial Intelligence (IJCAI'17), Carles Sierra (Ed.). AAAI Press 3203-3209. [[PDF]](https://www.ijcai.org/proceedings/2017/0447.pdf)

2.Xiangnan He, Lizi Liao, Hanwang Zhang, Liqiang Nie, Xia Hu and Tat-Seng Chua (2017). [Neural Collaborative Filtering.](http://dl.acm.org/citation.cfm?id=3052569) In Proceedings of WWW '17, Perth, Australia, April 03-07, 2017.

我的复现（Keras + TensorFlow）：https://github.com/hegongshan/deep_matrix_factorization

