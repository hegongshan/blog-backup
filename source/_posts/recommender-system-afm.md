---
title: 论文阅读 Attentional Factorization Machines&#58 Learning the Weight of Feature Interactions via Attention Networks
date: 2019-12-26 21:38:17
tags: recommender systems
categories: recommender systems
mathjax: true
---

Attentional Factorization Machines（AFM）一文发表在IJCAI 2017上，作者在分解机中引入了attention机制，为不同的特征交互赋予不同的权重。

<!--more-->

### 分解机

$$
\hat y_{FM} (\mathbf{x}) = 
\underset{
	\mathrm{linear\ regression}
}{
	\underbrace{w_0 + \sum_{i=1}^n w_i x_i}
} + \underset{
	\mathrm{pair-wise\ feature\ interactions}
}{
	\underbrace{\sum_{i=1}^n \sum_{j=i+1}^n \hat w_{ij} x_i x_j}
} \tag{1}
$$

其中，$w_0$表示全局偏置，$w_i$表示第i个特征的权重，$\hat w_{ij} = \mathbf{v}_i^T \mathbf{v}_j$表示交叉特征$x_i x_j$的权重。

$\mathbf{v}_i = \mathbb{R}^k$表示特征i的embedding向量，k表示embedding向量的大小。

缺点：并非所有的特征都与预测相关，而分解机对所有的特征交互使用了相同的权重。

### 模型结构

![](/static/images/afm.png)

图中省略了线性回归部分。

#### 逐对交互层

{% raw %}

令$\mathcal{X}$为特征向量$\mathbf{x}$中的非零特征集合，embedding层的输出为$\varepsilon = \{ \mathbf{v}_i x_i \}_{i \in \mathcal{x} }$。因此，逐对交互层（Pair-wise Interaction Layer）的输出为：
$$
f_{PI}(\varepsilon) = \{ (\mathbf{v}_i \odot \mathbf{v}_j) x_i x_j \}_{(i,j) \in \mathcal{R}_x} \tag{2}
$$
其中，$\odot$表示逐元素相乘， $\mathcal{R}_x = \{ (i,j) \}_{i \in \mathcal{X}, j \in \mathcal{X}, j > i}$。

{% endraw %}

使用sum pooling将$f_{PI}(\varepsilon)$压缩成一个向量，然后用一个全连接层将其变为预测分数
$$
\hat y = \mathbf{p}^T \sum_{(i,j) \in \mathcal{R}_x} (\mathbf{v}_i \odot \mathbf{v}_j) x_i x_j + b \tag{3}
$$
其中，$\mathbf{p} \in \mathbb{R}^k$和$b \in \mathbb{R}$表示预测层的权重和偏置。

当$\mathbf{p} \equiv [1,1,\dots,1]$和$b \equiv 0$时，上式将退化为FM。

#### Attention池化层

该层的输出为：
$$
f_{Att}(f_{PI}(\varepsilon)) = 
\sum_{(i,j) \in \mathcal{R}_x} a_{ij} (\mathbf{v}_i \odot \mathbf{v}_j) x_i x_j \tag{4}
$$
作者使用一层的MLP当作attention网络：
$$
a_{ij}^\prime = \mathbf{h}^T \mathrm{ReLU}(\mathbf{W} (\mathbf{v}_i \odot \mathbf{v}_j) x_i x_j + \mathbf{b}) \\\\
a_{ij} = \frac{
	\mathrm{exp(a_{ij}^\prime)}
}{
	\sum_{(i,j) \in \mathcal{R}_x} \mathrm{exp(a_{ij}^\prime)}
} \tag{5}
$$
其中，$\mathbf{W} \in \mathbb{R}^{t \times k}$，$\mathbf{b} \in \mathbb{R}^t$，$\mathbf{h} \in \mathbb{R}^t$。

这里的t表示attention网络中隐含层的大小，作者称之为**attention factor**。

### 模型表达式

$$
\hat y_{AFM} (\mathbf{x}) =
w_0 + \sum_{i=1}^n w_i x_i + \mathbf{p}^T \sum_{i=1}^n \sum_{j=i+1}^n a_{ij} (\mathbf{v}_i \odot \mathbf{v}_j) x_i x_j \tag{6}
$$

{% raw %}

模型的参数$\Theta = \{w_0, \{ w_i \}_{i=1}^n, \{ \mathbf{v}_i \}_{i=1}^n, \mathbf{p, W, b, h} \}$。

{% endraw %}

### 目标函数

论文将AFM用于回归任务，因此，作者采用了平方损失：
$$
L = \sum_{x \in \tau} (\hat y_{AFM}(\mathbf{x}) - y(\mathbf{x}))^2 \tag{7}
$$
其中，$\tau$表示训练集。

为了防止过拟合，作者对逐对交互层使用了丢弃法（dropout），对attention网络使用了L2正则项。

因此，实际的目标函数如下：
$$
L = \sum_{x \in \tau} (\hat y_{AFM}(\mathbf{x}) - y(\mathbf{x}))^2 + \lambda \left \Vert \mathbf{W} \right \Vert^2 \tag{8}
$$
论文地址：https://www.ijcai.org/proceedings/2017/0435.pdf

实验代码：https://github.com/hexiangnan/attentional_factorization_machine