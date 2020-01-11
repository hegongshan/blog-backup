---
title: 论文阅读 BPR&#58 Bayesian Personalized Ranking from Implict Feedback
date: 2019-09-30 11:15:56
tags: recommender systems
categories: recommender systems
mathjax: true
---

贝叶斯个性化排序（Bayesian Personalized Ranking，BPR）是一种基于pairwise的排序算法，主要利用用户的隐式反馈（如点击、浏览、购买等行为），通过最大化后验概率来对物品进行个性化排序。

<!--more-->

### BPR

#### 符号定义

U表示所有用户构成的集合、I表示所有物品构成的集合，正反馈$S \subseteq U \times I$，用户u的偏好$>_u \subset I^2 ​$

$>_u​$需要满足：

* 完整性：$\forall i,j \in I : i \neq j\ \Rightarrow i >_u j \lor j >_u i\quad$

* 反对称性：$\forall i,j \in I : i >_u j \land j >_u i\ \Rightarrow i = j\quad$

* 传递性：$\forall i,j,k \in I : i >_u j \land j >_u k\ \Rightarrow i >_u k\quad$

$I_u^+$表示用户u交互过的物品集合，$U_i^+​$表示与物品i有过交互的用户集合，即：
$$
I_u^+ := \\{i \in I : (u,i) \in S \\} \\\\
U_i^+ := \\{u \in U : (u,i) \in S \\}
$$
假定相对于所有未被观察到的物品，用户更偏好

从而，训练数据集$D_s$可以表示为
$$
D_s := \\{(u,i,j) | i \in I_u^+ \land j \in I \setminus I_u^+ \\}
$$
其中，$(u,i,j) \in D_s$表示相对于物品j，用户u更偏好物品i；$\setminus$表示两个集合相减。

由于$>_u$是反对称的，因此，负样本也被隐式地考虑了。

#### BPR优化方法

##### 基本假设

（1）每个用户之间的偏好行为相互独立

（2）同一用户对不同物品的偏序相互独立

##### 目标函数的推导

BPR算法的**基本思想**是通过**最大化后验概率**$p(\Theta | >_u)$，为所有物品$i \in I$找到正确的个性化排序。其中，$\Theta​$是任意模型（如矩阵分解）的参数向量。

根据贝叶斯公式
$$
p(\Theta | >_u) \cdot p(>_u) = p(>_u | \Theta) \cdot p(\Theta) \tag{1}
$$
由于BPR算法假设每个用户之间的偏好行为相互独立，从而，对于任意一个用户u，其偏好的概率$p(>_u)​$是一个常数。

因此，$p(\Theta | >_u) ​$正比于$ p(>_u | \Theta) \cdot p(\Theta)​$，即：
$$
p(\Theta | >_u) \propto p(>_u | \Theta) \cdot p(\Theta) \tag{2}
$$
先考虑式(2)右边第一个分量$p(>_u | \Theta)$，其似然函数为
$$
\prod_{u \in U} p(>_u | \Theta) = \prod_{(u,i,j) \in U \times I \times I} p(i >_u j | \Theta)^{\delta ( \ (u,i,j)\ \in\ D_s\ )} \cdot (1 - p(i >_u j | \Theta))^{\delta ( \ (u,i,j)\ \notin\ D_s\ )} \tag{3}
$$
其中，$\delta​$是指示函数
$$
\delta(b) :=
\begin{cases}
1, & if\ b\ is\ true \\\\
0, & else
\end{cases} \tag{4}
$$
根据完整性和反对称性，式(3)可以化简为
$$
\prod_{u \in U} p(>_u | \Theta) = \prod_{(u,i,j) \in D_s} p(i >_u j | \Theta) \tag{5}
$$
对于$p(i >_u j | \Theta)​$这个概率，作者将其定义为
$$
p(i >_u j | \Theta) := \sigma(\hat x_{uij} (\Theta)) \tag{6}
$$
其中，$\sigma​$是sigmoid函数
$$
\sigma (x) = \frac{1}{1+e^{-x}} \tag{7}
$$
当然，这里的$\sigma (x)​$可以是任何满足完整性、反对称性和传递性的函数。

$\hat{x}_{uij}(\Theta)$是关于模型参数向量$\Theta$的任意实值函数，只要该函数能够反映用户u、物品i和物品j之间的关系。

现在，我们来考虑式(2)右边的先验概率$p(\Theta)​$。

由于$\Theta$的分布是未知的，作者假设其服从均值为0，协方差矩阵为$\Sigma_\Theta = \lambda_\Theta I$的正态分布
$$
p(\Theta) \sim N(0, \Sigma_\Theta) \tag{8}
$$
$\Theta​$的概率密度函数为：
$$
f(\Theta) = \frac{1}{(2\pi)^{\frac{n}{2}} \lvert \Sigma_\Theta \rvert^{\frac{1}{2}}} \exp \\{-\frac{1}{2} \Theta^T \Sigma_\Theta^{-1} \Theta \\} \tag{9}
$$
经过计算
$$
\ln p(\Theta) \propto -\lambda_\Theta \lVert \Theta \rVert^2 \tag{10}
$$
于是，最大化$p(\Theta | >_u) ​$变成了求解下式的最大值
$$
\begin{align}
BPR-OPT &:= \ln p(\Theta | >\_u) \\\\
&= \ln p(>\_u | \Theta) p(\Theta) \\\\
&= \ln \prod_{(u,i,j) \in D_s} \sigma(\hat x_{uij}) p(\Theta) \\\\
&= \sum_{(u,i,j) \in D_s} \ln \sigma(\hat x_{uij}) + \ln p(\Theta) \\\\
&= \sum_{(u,i,j) \in D_s} \ln \sigma(\hat x_{uij}) - \lambda_\Theta \lVert \Theta \rVert^2
\end{align} \tag{11}
$$
其中，$\lambda_\Theta​$是模型的正则化参数。

#### BPR学习算法

BPR-OPT对模型参数向量$\Theta$的梯度为：
$$
\begin{align}
\frac{\partial BPR-OPT}{\partial \Theta} 
&= \sum_{(u,i,j) \in D_s} \frac{\partial}{\partial \Theta} \ln \sigma(\hat x_{uij}) - \lambda_\Theta \frac{\partial}{\partial \Theta}\lVert \Theta \rVert^2 \\\\
&= \sum_{(u,i,j) \in D_s} \frac{\partial}{\partial \Theta} \ln \sigma(\hat x_{uij}) - 2\lambda_\Theta \Theta \\\\
&\propto \sum_{(u,i,j) \in D_s} \frac{e^{-\hat x_{uij}}}{1 + e^{-\hat x_{uij}}} \frac{\partial}{\partial \Theta}\hat x_{uij} - \lambda_\Theta \Theta
\end{align}  \tag{12}
$$
由于$\sigma (x)$为sigmoid函数，其导数为
$$
\sigma(x)^\prime = \frac{e^{-x}}{(1 + e^{-x})^2} = \sigma(x) (1 - \sigma(x)) \tag{13}
$$
故
$$
\begin{align}
\frac{\partial}{\partial \Theta} \ln \sigma(\hat x_{uij}) 
&= \frac{1}{\sigma(\hat x_{uij})} \sigma(\hat x_{uij}) (1 - \sigma(\hat x_{uij})) \frac{\partial}{\partial \Theta}\hat x_{uij} \\\\
&= \frac{e^{-\hat x_{uij}}}{1 + e^{-\hat x_{uij}}} \frac{\partial}{\partial \Theta}\hat x_{uij} \\\\
&= \frac{1}{e^{\hat x_{uij}} + 1} \frac{\partial}{\partial \Theta}\hat x_{uij}
\end{align} \tag{14}
$$
作者提出了一个基于自助法(bootstrapping)的随机梯度下降算法LEARN**BPR**来最大化BPR-OPT
$$
\begin{align}
& procedure\ LEARNBPR(D_s, \Theta) \\\\
& \quad initialize\ \Theta \\\\
& \quad \mathbf{repeat} \\\\
& \qquad draw\ (u,i,j)\ from\ D_s \\\\
& \qquad \Theta \leftarrow \Theta + \alpha \left( \frac{e^{-\hat x_{uij}}}{1 + e^{-\hat x_{uij}}} \frac{\partial}{\partial \Theta}\hat x_{uij} - \lambda_\Theta \Theta \right) \\\\
& \quad \mathbf{until}\ convergence \\\\
& \quad \mathbf{return}\ \hat \Theta \\\\
& end procedure
\end{align}
$$
其中，$\alpha$为学习率，$\lambda_\Theta$为正则化参数。

**何为自助法**？从给定训练集中有放回的均匀抽样。

### 应用

对于$\hat x_{uij} (\Theta) $，它需要满足：当$i >_u j$ 时，$\hat x_{uij} > 0$；反之，当$j >_u i$ 时，$\hat x_{uij} < 0$。

为了简化计算，作者将其定义为
$$
\hat x_{uij} := \hat x_{ui} - \hat x_{uj} \tag{15}
$$
最大化BPR-OPT，等价于最小化下式
$$
Loss = \sum_{(u,i,j) \in D_s} -\ln \sigma(\hat x_{ui} - \hat x_{uj}) + \lambda_\Theta \lVert \Theta \rVert^2 \tag{16}
$$

#### 矩阵分解

预测$\hat x_{ui}$，可以看作是估计矩阵X：$U \times I$。目标矩阵X可以用两个低秩矩阵W：$\lvert U \rvert \times k$和H：$\lvert I \rvert \times k$的乘积来估计。
$$
\hat x := W H^T \tag{17}
$$
W中的每一行$w_u$是描述用户u的特征向量，H中的每一行$h_i$是描述物品i的特征向量。
$$
\hat x_{ui} = w_u \cdot h_i^T = \sum_{f=1}^k w_{uf} h_{if} \tag{18}
$$
从而：
$$
\hat x_{uij} = \sum_{f=1}^k w_{uf} (h_{if} - h_{jf}) \tag{19}
$$
矩阵分解的模型参数$\Theta=(W,H)​$
$$
\frac{\partial}{\partial \theta} \hat x_{uij} = 
\begin{cases}
(h_{if} - h_{jf}) & if\ \theta = w_{uf}, \\\\
w_{uf} & if\ \theta = h_{if}, \\\\
-w_{uf} & if\ \theta = h_{jf}, \\\\
0 & else
\end{cases} \tag{20}
$$

此时，损失函数为：
$$
Loss = \sum_{(u,i,j) \in D_s} -\ln \sigma(\hat x_{ui} - \hat x_{uj}) + \lambda_W \cdot w_{uf}^2 + \lambda_{H^+} \cdot h_{if}^2 + \lambda_{H^-} \cdot h_{jf}^2 \tag{21}
$$
其中，$\lambda_W、\lambda_{H^+}、\lambda_{H^-}​$分别为用户特征W、正样本$h_{if}​$、负样本$h_{jf}​$的正则化参数。

模型迭代公式如下：
$$
w_{uf} \leftarrow w_{uf} + \alpha \left(\frac{1}{e^x + 1} \cdot (h_{if} - h_{jf}) - \lambda_W \cdot w_{uf} \right) \\\\
h_{if} \leftarrow h_{if} + \alpha \left(\frac{1}{e^x + 1} \cdot w_{uf} - \lambda_{H^+} \cdot h_{if} \right) \\\\
h_{jf} \leftarrow h_{jf} + \alpha \left(\frac{1}{e^x + 1} \cdot (-w_{uf}) - \lambda_{H^-} \cdot h_{jf}\right)
$$

### 写在最后的话

1.对于式(3)，论文中的原始表述为
$$
\prod_{u \in U} p(>_u | \Theta) = \prod_{(u,i,j) \in U \times I \times I} p(i >_u j | \Theta)^{\delta ( \ (u,i,j)\ \in\ D_s\ )} \cdot (1 - p(i >_u j | \Theta))^{\delta ( \ (u,j,i)\ \notin\ D_s\ )}
$$
笔者认为后一项的指数应该是$\delta ( \ (u,i,j)\ \notin\ D_s\ )$ ，表示 $i >_u j$ 不成立。

2.对于式(12)，论文中的原始表述为
$$
\begin{align}
\frac{\partial BPR-OPT}{\partial \Theta} 
&= \sum_{(u,i,j) \in D_s} \frac{\partial}{\partial \Theta} \ln \sigma(\hat x_{uij}) - \lambda_\Theta \frac{\partial}{\partial \Theta}\lVert \Theta \rVert^2 \\\\
&\propto \sum_{(u,i,j) \in D_s} \frac{-e^{-\hat x_{uij}}}{1 + e^{-\hat x_{uij}}} \frac{\partial}{\partial \Theta}\hat x_{uij} - \lambda_\Theta \Theta 
\end{align}
$$
根据式(14)，第一项的求导结果应该是不带负号的，即$\frac{e^{-\hat x_{uij}}}{1 + e^{-\hat x_{uij}}} \frac{\partial}{\partial \Theta}\hat x_{uij}$，个人认为是作者写错了。

对于上述两个问题，如果是我理解错了，希望大伙不吝赐教。

### 参考文献

1.Steffen Rendle, Christoph Freudenthaler, Zeno Gantner, and Lars Schmidt-Thieme. 2009. BPR: Bayesian personalized ranking from implicit feedback. In *Proceedings of the Twenty-Fifth Conference on Uncertainty in Artificial Intelligence* (UAI '09). AUAI Press, Arlington, Virginia, United States, 452-461. [[PDF]](https://arxiv.org/pdf/1205.2618.pdf)

2.https://github.com/guoguibing/librec/blob/3.0.0/core/src/main/java/net/librec/recommender/cf/ranking/BPRRecommender.java

