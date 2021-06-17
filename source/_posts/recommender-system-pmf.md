---
title: 论文阅读 Probabilistic Matrix Factorization
date: 2019-12-14 11:30:34
tags: recommender systems
categories: recommender systems
mathjax: true
---

为了更好地处理大型数据集以及评分较少的用户，作者提出了概率矩阵分解（PMF）模型。

<!--more-->

### 待解决的问题

传统的协同过滤方法有两个问题：

1. 不能很好地处理大型数据集；
2. 对于那些评分很少的用户，无法做出准确的预测。

### 符号说明

1. N表示用户数量，M表示物品数量。

2. $R_{ij}$表示用户i对物品j的评分，评分的取值范围为$\\{ R_{ij} | 1 \le R_{ij} \le K \cap R_{ij} \mathrm{\ is\ integer} \\}$。

3. $U \in R^{D \times N}$和$V \in R^{D \times M}$分别表示用户和物品的潜在特征矩阵，列向量$U_i$和$V_j$分别表示用户i和物品j的潜在特征向量。

### 模型结构

![PMF](/static/images/pmf.png)

### 模型假设

1. 假设评分服从均值为$U_i^T V_j$，方差为$\sigma^2$的正态分布，即$R_{ij} \sim N(U_i^T V_j, \sigma^2)$。
   $$
   p(R | U, V, \sigma^2) = \prod_{i=1}^N \prod_{j=1}^M \left [ \mathcal{N}(R_{ij} | U_i^T V_j, \sigma^2) \right]^{I_{ij}} \tag{1}
   $$
   其中，$\mathcal{N}(x | \mu, \sigma^2)$为正态分布的概率密度函数；$I_{ij}$为指示函数。
   $$
   I_{ij}(x) =
   \begin{cases}
    1, & \mathrm{if\ user\ i\ rated\ item\ j} \\\\
    0, & \mathrm{otherwise}
   \end{cases} \tag{2}
   $$

2. 假设用户特征向量和物品特征向量都服从均值为0的正态分布，即$U_i \sim N(0, \sigma_U^2 \mathbf{I} ),\ V_j \sim N(0, \sigma_V^2 \mathbf{I})$。

$$
p(U | \sigma_U^2) = \prod_{i=1}^N \mathcal{N} (U_i | 0, \sigma_U^2 \mathbf{I}) \\\\
p(V | \sigma_V^2) = \prod_{j=1}^M \mathcal{N} (V_j | 0, \sigma_V^2 \mathbf{I}) 
\tag{3}
$$

### 目标函数

后验概率：
$$
\begin{align}
p(U, V | R, \sigma^2, \sigma_U^2, \sigma_V^2)
&= \frac{
	p(R | U, V, \sigma^2, \sigma_U^2, \sigma_V^2) \times p(U, V | \sigma^2, \sigma_U^2, \sigma_V^2) \times p(\sigma^2, \sigma_U^2, \sigma_V^2)
}{
	p(R, \sigma^2, \sigma_U^2, \sigma_V^2)
} \\\\
&\propto p(R | U, V, \sigma^2) \times p(U, V | \sigma_U^2, \sigma_V^2) \\\\
&= p(R | U, V, \sigma^2) \times p(U | \sigma_U^2) \times p(V | \sigma_V^2) \\\\
&= \prod_{i=1}^N \prod_{j=1}^M \left [ \mathcal{N}(R_{ij} | U_i^T V_j, \sigma^2) \right ]^{I_{ij}} 
\times 
\prod_{i=1}^N \mathcal{N}(U_i | 0, \sigma_U^2 \mathbf{I}) 
\times 
\prod_{j=1}^M \mathcal{N}(V_j | 0, \sigma_V^2 \mathbf{I})
\end{align} \tag{4}
$$
两边取对数，得到：
$$
\begin{align}
\ln p(U, V | R, \sigma^2, \sigma_U^2, \sigma_V^2) 
= 
& \sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln \mathcal{N}(R_{ij} | U_i^T V_j, \sigma^2) + \\\\
& \sum_{i=1}^N \ln \mathcal{N}(U_i | 0, \sigma_U^2 \mathbf{I})  + 
\sum_{j=1}^M \ln \mathcal{N}(V_j | 0, \sigma_V^2 \mathbf{I})
\end{align} \tag{5}
$$

下面分别求解这三项：
$$
\begin{align}
\sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln \mathcal{N}(R_{ij} | U_i^T V_j, \sigma^2) 
&= \sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln \left( \frac{1}{
	\sqrt{2 \pi} \sigma
} 
\exp \\{ 
	-\frac{
    (R_{ij} - U_i^T V_j)^2
  }{
    2 \sigma^2
	}
\\} \right) \\\\
&= -\frac{1}{
	2 \sigma^2
} \sum_{i=1}^N \sum_{j=1}^M I_{ij} (R_{ij} - U_i^T V_j)^2 - 
\frac{1}{2} \sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln \sigma^2 - 
\frac{1}{2}\sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln (2 \pi)
\end{align} \tag{6}
$$




$$
\begin{align}
\sum_{i=1}^N \ln \mathcal{N}(U_i | 0, \sigma_U^2 \mathbf{I}) 
&= \sum_{i=1}^N \ln  \frac{1}{
	(2 \pi)^\frac{D}{2} 
	\left \vert \sigma_U^2 \mathbf{I} \right \vert^{\frac{1}{2}} 
} \exp \\{ -\frac{1}{2} U_i^T (\sigma_U^2 \mathbf{I})^{-1} U_i \\} \\\\
&= -\frac{1}{2 \sigma_U^2} \sum_{i=1}^N U_i^T U_i - 
\frac{1}{2} N D \ln \sigma_U^2 - 
\frac{1}{2} N D \ln (2 \pi)
\end{align} \tag{7}
$$


$$
\begin{align}
\sum_{j=1}^M \ln \mathcal{N}(V_j | 0, \sigma_V^2 \mathbf{I}) 
&= \sum_{j=1}^M \ln  \frac{1}{
	(2 \pi)^\frac{D}{2} 
	\left \vert \sigma_V^2 \mathbf{I} \right \vert^{\frac{1}{2}} 
} \exp \\{ -\frac{1}{2} V_j^T (\sigma_V^2 \mathbf{I})^{-1} V_j \\} \\\\
&= -\frac{1}{2 \sigma_V^2} \sum_{j=1}^M V_j^T V_j - \frac{1}{2} M D \ln \sigma_V^2 - \frac{1}{2} M D \ln (2 \pi)
\end{align} \tag{8}
$$
将式(6)、(7)、(8)代入(5)中，得到：
$$
\begin{align}
\ln p(U, V | R, \sigma^2, \sigma_U^2, \sigma_V^2) 
= 
&-\frac{1}{
	2 \sigma^2
} \sum_{i=1}^N \sum_{j=1}^M I_{ij} (R_{ij} - U_i^T V_j)^2 -\frac{1}{2 \sigma_U^2} \sum_{i=1}^N U_i^T U_i - \frac{1}{2 \sigma_V^2} \sum_{j=1}^M V_j^T V_j \\\\
&- \frac{1}{2} \sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln \sigma^2 - 
\frac{1}{2} N D \ln \sigma_U^2 - \frac{1}{2} M D \ln \sigma_V^2 \\\\
&- \frac{1}{2}\sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln (2 \pi) - 
\frac{1}{2} N D \ln (2 \pi) - 
\frac{1}{2} M D \ln (2 \pi) \\\\
= 
&- \frac{1}{
	2 \sigma^2
} \sum_{i=1}^N \sum_{j=1}^M I_{ij} (R_{ij} - U_i^T V_j)^2 - 
\frac{1}{2 \sigma_U^2} \sum_{i=1}^N U_i^T U_i -
\frac{1}{2 \sigma_V^2} \sum_{j=1}^M V_j^T V_j \\\\
&- \frac{1}{2} \left( 
	\sum_{i=1}^N \sum_{j=1}^M I_{ij} \ln \sigma^2 + N D \ln \sigma_U^2 + M D \ln \sigma_V^2 \right)+ C
\end{align} \tag{9}
$$
固定超参数，最大化式(9) 等价于最小化式(10)
$$
E = \frac{1}{2} \sum_{i=1}^N \sum_{j=1}^M I_{ij} (R_{ij} - U_i^T V_j)^2 +
\frac{\lambda_U}{2} \sum_{i=1}^N \left \Vert U_i \right \Vert_F^2 +
\frac{\lambda_V}{2} \sum_{j=1}^M \left \Vert V_j \right \Vert_F^2 \tag{10}
$$
其中，$\lambda_U = \frac{\sigma^2}{\sigma_U^2}$，$\lambda_V = \frac{\sigma^2}{\sigma_V^2}$

### 学习算法

下面使用随机梯度下降求解参数更新规则：

令$R_{U_i}^+$表示用户i评分过的物品集合，$R_{V_j}^+$表示与物品j交互过的用户的集合。
$$
\frac{\partial E}{\partial U_i} = - \sum_{j \in R_{U_i}^+} V_j (R_{ij} - U_i^T V_j) + \lambda_U U_i \\\\
\frac{\partial E}{\partial V_j} = - \sum_{i \in R_{V_j}^+} U_i (R_{ij} - U_i^T V_j) + \lambda_V V_j
\tag{11}
$$
令$e_{ij} = R_{ij} - U_i^T V_j$

从而：
$$
U_i \leftarrow U_i - \eta( \sum_{j \in R_{U_i}^+} V_j e_{ij} - \lambda_U U_i) \\\\
V_j \leftarrow V_j - \eta( \sum_{i \in R_{V_j}^+} U_i e_{ij} - \lambda_V V_j) 
\tag{12}
$$
其中，$\eta$为学习率。

### 优化与改进

由于上述模型的预测分数可能会超出有效评分的范围，作者提出使用sigmoid函数，将输出限制在[0,1]区间内
$$
g(x) = \frac{1}{1+ e^{-x}} \tag{13}
$$
为了使输入评分与输出的预测分数相匹配，作者对输入评分$1,\cdots,K$进行了归一化
$$
t(x) = \frac{ x - 1 }{ K - 1 } \tag{14}
$$


