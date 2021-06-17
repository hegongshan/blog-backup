---
title: 论文阅读 Neural Graph Collaborative Filtering
date: 2020-10-27 19:59:25
tags: recommender systems
categories: recommender systems
mathjax: true
---

NGCF一文发表在SIGIR 2019上，作者使用图卷积网络（Graph Convolutional Networks，GNNs）对用户-物品二部图中的高阶连通性（high order connectivity）进行建模，将协同信号（collaborative signal）显式地注入到用户和物品的嵌入表示中。

<!--more-->

### 研究动机

现有的方法不足以生成令人满意的用户（物品）嵌入表示，因为它们只使用描述性特征（如ID和属性）来构建嵌入函数，没有显式地考虑协同信号。

协同信号隐含在用户-物品的交互中，揭示了用户（物品）之间的行为相似性。

> The key reason is that the embedding function lacks an explicit encoding of the crucial **collaborative signal**, which is latent in user-item interactions to reveal the behavioral similarity between users (or items).

从而，只能依赖于交互函数去弥补嵌入表示的不足。

> As a result, when the embeddings are insufficient in capturing CF, the methods have to rely on the interaction function to make up for the deficiency of suboptimal embeddings.

### 高阶连通性

![高阶连通性](/static/images/ngcf-high-order-connectivity.png)

高阶连通性表示从任意结点出发，能够到达结点u1并且长度l > 1的路径。

> **The high-order connectivity** denotes the path that reaches u1 from any node with the path length l larger than 1.

### NGCF

#### 模型图

![NGCF](/static/images/ngcf.png)

#### 嵌入传播

##### 一阶传播

* 消息构造

$$
\mathbf{m}_{u \leftarrow i} = \frac{1}{\sqrt{\vert \mathcal{N}_u \vert \vert \mathcal{N}_i \vert}} \left( \mathbf{W}_1 \mathbf{e}_i + \mathbf{W}_2 (\mathbf{e}_i \odot \mathbf{e}_u) \right)
$$

其中，$\mathbf{W}_1, \mathbf{W}_2 \in \mathbb{R}^{d \times d^\prime}$为权重矩阵，用于对有用信息进行蒸馏，$d^\prime$是转换大小；

$\mathcal{N}_u, \mathcal{N}_i$表示用户u和物品i的一阶（first-hop）邻居，即直接相连的结点。

* 消息聚合

$$
\mathbf{e}_u^{(1)} = \mathrm{LeakyReLU}(\mathbf{m}_{u \leftarrow u} + \sum_{i \in \mathcal{N}_u} \mathbf{m}_{u \leftarrow i})
$$

其中，$\mathbf{e}_u^{(1)}$表示经过一次传播后的用户表示；
$$
\mathrm{LeakyReLU} =
\begin{cases}
x, & x > 0 \\\\
\lambda x, & x \le 0
\end{cases}
$$
其中，$\lambda > 0$。

### 参考资料

论文地址：http://staff.ustc.edu.cn/~hexn/papers/sigir19-NGCF.pdf

实验代码：https://github.com/xiangwang1223/neural_graph_collaborative_filtering