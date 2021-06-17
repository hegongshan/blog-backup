---
title: 论文阅读 LightGCN&#58 Simplifying and Powering Graph Convolution Network for Recommendation
date: 2020-10-30 20:35:24
tags: recommender systems
categories: recommender systems
mathjax: true
---

LightGCN一文发表在SIGIR 2020上，是NGCF的后续研究。作者发现GCN中的特征转换和非线性激活对提高性能没有太多帮助，还增加了训练的难度，甚至降低了推荐的性能。因此，作者提出了一个只使用GCN的领域聚合部分的推荐模型——LightGCN。

<!--more-->

### LightGCN

![模型图](/static/images/lightgcn.png)

#### Light Graph Convolution（LGC）

$$
\mathbf{e}_u^{(k+1)} = \sum_{i \in \mathcal{N}_u} \frac{1}{\sqrt{\vert \mathcal{N}_u \vert} \sqrt{\vert \mathcal{N}_i \vert}} \mathbf{e}_i^{(k)}, \\\\
\mathbf{e}_i^{(k+1)} = \sum_{u \in \mathcal{N}_i} \frac{1}{\sqrt{\vert \mathcal{N}_i \vert} \sqrt{\vert \mathcal{N}_u \vert}} \mathbf{e}_u^{(k)} \tag{1}
$$

这里，作者遵循标准的GCN设计，使用$\frac{1}{\sqrt{\vert \mathcal{N}_u \vert} \sqrt{\vert \mathcal{N}_i \vert}}$作为归一化项，从而避免embedding的规模随着图卷积操作的增加而不断扩大。

#### 模型预测

作者使用各层embedding的带权和作为最终的embedding。
$$
\mathbf{e}_u = \sum_{k=0}^K \alpha_k \mathbf{e}_u^{(k)} \\\\
\mathbf{e}_i = \sum_{k=0}^K \alpha_k \mathbf{e}_i^{(k)} \tag{2}
$$

其中，$\alpha_k \ge 0$表示第k层embedding的重要程度。在论文中，作者令$\alpha_k = \frac{1}{K + 1}$。

和NGCF一样，作者使用用户和物品embedding的内积作为模型的预测结果。
$$
\hat y_{ui} = \mathbf{e}_u^T \mathbf{e}_i \tag{3}
$$

#### 矩阵形式

邻接矩阵：
$$
\mathbf{A} = 
\begin{bmatrix}
\mathbf{0} & \mathbf{R} \\\\
\mathbf{R}^T & 0
\end{bmatrix} \tag{4}
$$
令第0层的embedding矩阵为$\mathbf{E}^{(0)} \in \mathbb{R}^{(M+N) \times T}$，T为embedding的大小，则LGC的矩阵形式为：
$$
\begin{aligned}
\mathbf{E}^{(k + 1)} 
&= (\mathbf{D}^{-\frac{1}{2}} \mathbf{A} \mathbf{D}^{-\frac{1}{2}}) \mathbf{E}^{(k)} \\\\
&= \mathbf{\tilde A} \mathbf{E}^{(k)}
\end{aligned} \tag{5}
$$
其中，

* $\mathbf{D} \in \mathbb{R}^{(M + N)\times(M + N)}$是一个对角矩阵，对角线上的每个元素$\mathbf{D}_{ii}$表示邻接矩阵$\mathbf{A}$第i个行向量中非零元素的个数，又称度矩阵（degree matrix）；

* $\mathbf{\tilde A} = \mathbf{D}^{-\frac{1}{2}} \mathbf{A} \mathbf{D}^{-\frac{1}{2}}$。

从而，我们得到了最终的embedding矩阵：
$$
\begin{aligned}
\mathbf{E} 
&= \alpha_0 \mathbf{E}^{(0)} + \alpha_1 \mathbf{E}^{(1)} + \cdots + \alpha_K \mathbf{E}^{(K)} \\\\
&= \alpha_0 \mathbf{E}^{(0)} + \alpha_1 \mathbf{\tilde A} \mathbf{E}^{(0)} + \cdots + \alpha_K \mathbf{\tilde A}^K  \mathbf{E}^{(0)}
\end{aligned} \tag{6}
$$

### 补充知识

**ablation study**：在论文中反复出现，翻译为“消融实验”，指的是移除模型或算法中的一些变量或者操作，观察其对性能的影响。

### 参考资料

论文地址：http://staff.ustc.edu.cn/~hexn/papers/sigir20-LightGCN.pdf

实验代码：https://github.com/kuandeng/LightGCN

什么是 ablation study？ - 尼箍纳斯凯奇的回答 - 知乎 https://www.zhihu.com/question/60170398/answer/207709956