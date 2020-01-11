---
title: 论文阅读 Neural Factorization Machines for Sparse Predictive Analytics
date: 2019-12-25 21:57:53
tags: recommender systems
categories: recommender systems
mathjax: true
---

Neural Factorization Machine（NFM）一文发表在SIGIR 2017上，作者将分解机与神经网络整合在一起，利用分解机对二元特征交互进行建模，使用神经网络对高层特征交互进行建模。

<!--more-->

### 分解机

$$
\hat y_{FM}(\mathbf{x}) = w_0 + \sum_{i=1}^n w_i x_i + \sum_{i=1}^n \sum_{j=i+1}^n \mathbf{v}_i^T \mathbf{v}_j \cdot x_i x_j \tag{1}
$$

### 模型结构

![NFM](/static/images/nfm.png)

为了清楚地描述，图中没有显示线性回归部分。

#### 二元交互层


$$
f_{BI}(\mathcal{V}_x) 
= \sum_{i=1}^n \sum_{j=i+1}^n x_i \mathbf{v}_i \odot x_j \mathbf{v}_j
= \sum_{i=1}^n \sum_{j=1}^{i-1} x_i \mathbf{v}_i \odot x_j \mathbf{v}_j \tag{2}
$$

令$\mathbf{v}^2 = \mathbf{v} \odot \mathbf{v}$，则：
$$
2 f_{BI}(\mathcal{V}_x) 
= \sum_{i=1}^n (\sum_{j=1}^n x_i \mathbf{v}_i \odot x_j \mathbf{v}_j - x_i \mathbf{v}_i \odot x_i \mathbf{v}_i)
= (\sum_{i=1}^n x_i \mathbf{v}_i)^2 - \sum_{i=1}^n (x_i \mathbf{v}_i)^2 \tag{3}
$$

从而，可以推出：
$$
\Rightarrow f_{BI}(\mathcal{V}_x) = \frac{1}{2} 
\left [(\sum_{i=1}^n x_i \mathbf{v}_i)^2 - \sum_{i=1}^n (x_i \mathbf{v}_i)^2 \right] \tag{4}
$$

### 模型表达式

$$
\begin{align}
\hat y_{NFM}(\mathbf{x}) 
&= w_0 + \sum_{i=1}^n w_i x_i \\\\
&+\mathbf{h}^T \sigma_L(
	\mathbf{W}_L (
    \dots 
    \sigma_1(\mathbf{W}_1 f_{BI}(\mathcal{V}_x) + \mathbf{b}_1))
    \dots
	) + \mathbf{b}_L
)
\end{align} \tag{5}
$$

{% raw %}

模型参数$\Theta = \{ w_0, \{ w_i, \mathbf{v}_i \}, \mathbf{h}, \{\mathbf{W}_l, \mathbf{b}_l \} \}$

{% endraw %}

### 目标函数

由于该论文聚焦于回归任务，因此，作者采用了平方损失：
$$
L_{reg} = \sum_{\mathbf{x} \in \mathcal{X}} (\hat y(\mathbf{x}) - y(\mathbf{x}))^2 \tag{6}
$$


论文地址：http://staff.ustc.edu.cn/~hexn/papers/sigir17-nfm.pdf

实验代码：https://github.com/hexiangnan/neural_factorization_machine

