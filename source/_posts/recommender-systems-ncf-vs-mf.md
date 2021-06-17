---
title: 论文阅读 Neural Collaborative Filtering vs. Matrix Factorization Revisited
date: 2020-09-30 22:22:58
tags: recommender systems
categories: recommender systems
mathjax: true
sticky: 2
---

Neural Collaborative Filtering vs. Matrix Factorization Revisited一文发表在RecSys 2020上，作者重新比较了传统的MF方法和NCF中提出的三种方法（GMF、MLP以及NeuMF）。

<!--more-->

### 论文要点

* 对超参数进行合适的选择后，基于点积的矩阵分解能够超过了NCF中提出的所有方法（GMF、MLP以及NeuMF）
* 使用MLP去学习点积并不是一件容易的事情，需要使用大量的数据去训练
* 在生产环境中，使用MLP去做项目推荐代价过高，而点积可以使用高效的检索算法

### 矩阵分解

作者使用了带偏置项的矩阵分解（BiasSVD）
$$
\hat{y}_{ui} = b + b_u + b_i + \mathbf{p}_u^T \mathbf{q}_i
$$
MF超过GMF，作者认为：

> adding parameters to a simple model is not always a good idea and has to be done carefully

损失函数
$$
l(u,i,y) = -y \ln \sigma(\phi(\mathbf{p_u}, \mathbf{q_i})) - (1-y) \ln (1 - \sigma(\phi(\mathbf{p_u}, \mathbf{q_i}))) + \frac{\lambda}{2} \left( \left \Vert \mathbf{p_u} \right \Vert^2 + \left \Vert \mathbf{q_i} \right \Vert^2 \right)
$$

作者使用随机梯度下降法（SGD）来优化模型

#### 损失计算

在mf_simple.py中，损失计算由[类MFModel的fit方法](https://github.com/google-research/google-research/blob/master/dot_vs_learned_similarity/mf_simple.py#L116)完成，代码片段如下：

```python
  if prediction > 0:
    one_plus_exp_minus_pred = 1.0 + np.exp(-prediction)
    sigmoid = 1.0 / one_plus_exp_minus_pred
    this_loss = (np.log(one_plus_exp_minus_pred) +
                 (1.0 - rating) * prediction)
  else:
    exp_pred = np.exp(prediction)
    sigmoid = exp_pred / (1.0 + exp_pred)
    this_loss = -rating * prediction + np.log(1.0 + exp_pred)
```
说实话，最初看到这段代码的时候，不太理解大佬的想法。化简公式，减少不必要的计算，这我能理解，可为啥要分两种情况来讨论呢？

答案其实很简单：当$x \le 0$时， $e^{-x}$存在溢出的风险（$\lim_{x \to -\infty} e^{-x} = +\infty$）；而$e^x \le 1$。

因此，当$prediction > 0$时，使用$e^{-x}$来计算$\sigma(x)$和损失；而当$prediction \le 0$，则使用$e^x$来计算。

![指数函数](/static/images/exp.png)


$$
\sigma(x) = \frac{1}{1 + e^{-x}} = \frac{e^x}{1 + e^{x}}
$$

$$
\begin{aligned}
this\\_loss
&= -y \ln \sigma(\phi(\mathbf{p_u}, \mathbf{q_i})) - (1-y) \ln (1 - \sigma(\phi(\mathbf{p_u}, \mathbf{q_i}))) \\\\
&= -y \ln \frac{1}{1 + e^{-\hat{y}}} - (1-y) \ln \frac{e^{-\hat{y}}}{1 + e^{-\hat{y}}} \\\\
&= y \ln (1 + e^{-\hat{y}}) - (1 - y) \left( -\hat{y} - \ln (1 + e^{-\hat{y}}) \right) \\\\
&= (1 - y) \hat{y} + \ln (1 + e^{-\hat{y}})
\end{aligned}
$$

上式还可以继续化简：
$$
\begin{aligned}
(1 - y) \hat{y} + \ln (1 + e^{-\hat{y}})
&= (1 - y) \hat{y} + \ln \frac{1 + e^{\hat{y}}}{e^{\hat{y}}} \\\\
&= (1 - y) \hat{y} + \ln (1 + e^{\hat{y}}) - \hat{y} \\\\
&= - y \hat{y} + \ln (1 + e^{\hat{y}})
\end{aligned}
$$

#### 参数更新

$$
\frac{\partial l}{\partial p_{u,1}} 
= -y \frac{1}{\sigma(\hat y_{ui})} \sigma (1 - \sigma) + (1 - y) \frac{1}{1 - \sigma(\hat y_{ui})} \sigma (1 - \sigma) + \lambda p_{u,1} \\\\
= \sigma - y + \lambda p_{u,1}
$$

故
$$
p_{u,1} \leftarrow p_{u,1} - \eta (\sigma (\phi(\mathbf{p_u}, \mathbf{q_i})) - y + \lambda p_{u,1})
$$
同理可得：
$$
q_{i,1} \leftarrow q_{i,1} - \eta (\sigma (\phi(\mathbf{p_u}, \mathbf{q_i})) - y + \lambda q_{i,1}) \\\\
$$

#### 超参数调整

超参数：嵌入维度大小d，正则项系数$\lambda$，学习率$\eta$，负样本个数$m$，迭代次数以及初始化参数的标准差（0.1）。

> The hyperparameters of the dot product model are: embedding dimension d, regularization λ, learning rate η, number of negative samples m, number of training epochs, standard deviation for ini- tialization. 

1.确定迭代次数上限——256

2.令正则项系数$\lambda = 0$，寻找学习率$\eta \in \{0.001, 0.003, 0.01\} $和负样本个数$m = \{4, 8, 16\}$

3.在效果最好的学习率和负样本个数组合下，寻找正则项系数$\lambda \in \{0.001, 0.003, 0.01\}$

### 参考资料

论文地址：https://arxiv.org/pdf/2005.09683.pdf

实验代码：https://github.com/google-research/google-research/tree/master/dot_vs_learned_similarity

知乎提问（何向南教授亲答）：https://www.zhihu.com/question/396722911/answer/1251909703