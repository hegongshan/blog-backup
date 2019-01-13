---
title: 机器学习之PageRank算法
date: 2018-08-25 13:25:16
tags: 链接挖掘
categories: 机器学习
updated: 2018-08-25 13:25:16
mathjax: true
---

PageRank是一个搜索排名算法，由Sergey Brin和Larry Page在1998年第七届国际万维网大会上提出的。基于这一算法，他们创建了Google搜索引擎。

在介绍PageRank之前，先来了解一些主要概念。

页面i的入链（In-links of page i）：从其他网页链接到网页$i$的超链接数，通常不包括来自同一站点内网页的链接。

网页i的出链（Out-links of page i）：从网页$i$链接到其他网页的超链接数，通常不包括链接到同一站点内网页的超链接。
<!--more-->

### 算法

根据社交网络的排序声望原理，页面$i$的重要程度（页面$i$的PageRank分数），由所有指向页面i的所有页面的PageRank分数之和决定。因为一个页面可能指向很多其他的页面，它的声望分数应该被所有它指向的页面所共享。

将网络看做一个有向图G = (V , E)，其中V是所有顶点或结点的集合，例如，所有网页的集合，E是图中有向边的集合，例如，超链接。

设网络中的网页总数为n，网页i的PageRank分数为P(i)，
$$
P(i) = \sum_{(j,i) \in E} \frac{P(j)}{O_{j}} \tag{1}
$$
其中，$O_{j}$是网页$j$的出链数。

设P是一个由PageRank值组成的n维列向量（n-dimensional column vector）。
$$
P = (P(1),P(2),\dots,P(n))^{T} \tag{2}
$$
设A是图的邻接矩阵（adjacency matrix），
$$
A_{ij} = 
\begin{cases}
\frac{1}{O_{j}},& (i,j) \in E \\\\
0, & 其他
\end{cases} \tag{3}
$$
由公式(1)~(3)，可以得到如下n阶方程组
$$
P = A^{T}P \tag{4}
$$
显然，P是一个特征值为1的特征向量（eigenvector）。

如果满足以下条件：

1.A是一个随机矩阵；2.A是不可约的；3.A是非周期的。

那么PageRank向量P就是对应矩阵A的最大特征值1的那个主特征向量。

实际上，公式(4)也可基于马尔科夫链（Markov chain）推导出来。

### 模型修正

然而，Web图并不满足以上三个条件。

1.Web图中，A不是一个随机矩阵。

* 原因

有限马尔科夫链的状态转移矩阵是随机矩阵，它要求每个元素都是非负实数，且每行元素之和为1。这要求每一个网页至少要有一个出链，但实际上，很多网页根本就没有出链，从而导致状态转移矩阵A某些行全为0。这样的网页称为悬挂网页。

* 解决办法

从每个悬挂网页$i$向其他各个网页添加一条出链，将网页$i$到其他网页的转换概率均设为$\frac{1}{n}$。也就是说，将A中全为0的行用$\frac{\mathbf{ e}}{n}$（$\mathbf{e}$是元素全为1的n维向量）来替换。

2.Web图在一般情况下是可约的。

* 原因：Web图G不是强连通的。通常存在一些节点对<u, v>，没有从u到v的路径。

强连通图：若图G中的任意两个顶点$i$和$j$都连通，即从顶点$i$到顶点$j$和从顶点$j$到顶点$i$都存在路径，则图G是强连通图。

* 解决办法：同问题三

3."A是非周期的"，并不一定成立。

周期图：状态$i$是周期的，并且具有周期$k>1$，是指存在一个最小的正整数$k$，使得所有从状态$i$出发又回到状态$i$的路径长度都是$k$的整数倍。

如果一个状态不是周期的（或者$k=1$），那么它就是非周期的。如果一个马尔科夫链的所有状态都是非周期的，那么就说这个马尔科夫链是非周期的。

* 解决办法

从任一页面出发，到每个页面都加上一条链接，并给这一链接分配一个由参数$d$控制的微小转换概率。

通过以上修正，状态转换矩阵A满足之前的三个条件，从而得到了一个改进后的PageRank模型：
$$
P = \left[(1-d) \frac{E}{n} + d A^{T}\right]P \tag{5}
$$
其中，$E=ee^{T}$（e是元素全为1的列向量，从而E是一个nxn的元素全为1的矩阵），n是Web图中的节点总数。

公式（5）化简后，得到
$$
P = (1-d)e + dA^{T}P \tag{6}
$$
其中，e是全为1的列向量。

从而，可以得到
$$
P(i) = (1-d) + d \sum_{j=1}^{n} A_{ji} P(j) \tag{7}
$$
上式等价于
$$
P(i) = (1-d) + d \sum_{(j,i) \in E} \frac{P(j)}{O_{j}} \tag{8}
$$
其中，$d$称之为阻尼系数（damping factor），且$0 \leq d  \leq 1$。一些论文中认为，$d = 0.85$是一个不错的选择。

可以使用幂迭代（power iteration）求解特征向量P，算法如下
$$
\begin{align}
& PageRank-Iterate(G) \\\\
& \quad P_{0} \leftarrow \frac{e}{n} \\\\
& \quad k \leftarrow 1 \\\\
& \quad repeat \\\\
& \qquad P_{k} \leftarrow (1-d)e+dA^{T}P_{k-1}; \\\\
& \qquad k \leftarrow k+1; \\\\
& \quad until\ \Vert P_{k} - P_{k-1} \Vert_{1} < \epsilon \\\\
& \quad return\ P_{k}
\end{align}
$$

<hr>

参考资料

1. Xindong Wu，[Top 10 algorithms in data mining](https://link.springer.com/content/pdf/10.1007%2Fs10115-007-0114-2.pdf)，Knowledge and Information Systems，2008

2. （美）吴信东，库玛尔编著；李文波，吴素研译.数据挖掘十大算法，清华大学出版社，2013.5