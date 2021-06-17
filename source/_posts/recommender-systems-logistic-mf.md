---
title: 论文阅读 Logistic Matrix Factorization for Implicit Feedback Data
date: 2020-10-01 15:41:13
tags: recommender systems
categories: recommender systems
mathjax: true
---

Logistic Matrix Factorization (Logistic MF)一文发表在NIPS 2014上，作者提出了一种新的用于处理隐式反馈的矩阵分解模型。

<!--more-->

> The goal of collaborative filtering with implicit feedback data is to analyze a user’s past behavior in order to predict how they will act in the future. 

令$l_{ui}$表示用户$u$喜欢项目$i$这一事件，作者一上来就给出了l_{ui}$的概率公式，看得我一脸懵逼
$$
p(l_{ui} | x_u, y_i, \beta_i, \beta_j) = \frac{\exp(x_u y_i^T + \beta_u + \beta_i)}{1 + \exp(x_u y_i^T + \beta_u + \beta_i)} \tag{1}
$$
我们知道，sigmoid函数的定义如下：
$$
\sigma(x) = \frac{1}{1 + e^{-x}} = \frac{e^x}{e^x + 1} \tag{2}
$$
现在，再回过头来看，是不是就一目了然了：上式其实就是使用sigmoid函数将带偏置的矩阵分解得到的值映射成一个概率值，它表示用户$u$喜欢项目$i$的可能性，即
$$
p(l_{ui} | x_u, y_i, \beta_i, \beta_j) = \sigma(x_u y_i^T + \beta_u + \beta_i) \tag{3}
$$

### 损失函数

作者假设$R$中的所有项相互独立，从而得到如下的似然函数：
$$
\mathcal{L}(R|X,Y,\beta) = \prod_{u,i} p(l_{ui} | x_u, y_i, \beta_u, \beta_i)^{\alpha r_{ui}} (1 - p(l_{ui}|x_u, y_i, \beta_u, \beta_i)) \tag{4}
$$
假设$x_u$和$y_i$服从均值为0的球形高斯先验（zero-mean spherical Gaussian priors），即
$$
x_u \sim N(0, \sigma_u^2 \mathbf{I}) \\\\
y_i \sim N(0, \sigma_i^2 \mathbf{I}) \tag{5}
$$
从而：
$$
p(X|\sigma^2) = \prod_u \mathcal{N} (x_u | 0, \sigma_u^2 \mathbf{I}) \\\\
p(Y|\sigma^2) = \prod_i \mathcal{N} (y_i | 0, \sigma_i^2 \mathbf{I}) \tag{6}
$$
文章写到这里，作者直接给出了待求解的目标函数：
$$
\begin{aligned}
\log p(X, Y, \beta | R) 
&= \sum_{u, i} \alpha r_{ui} (x_u y_i^T + \beta_u + \beta_i) - (1 + \alpha r_{ui}) \log(1 + \exp(x_u y_i^T + \beta_u + \beta_i)) \\\\
&- \frac{\lambda}{2} \lVert x_u \rVert^2 - \frac{\lambda}{2} \lVert y_i \rVert^2 
\end{aligned}
\tag{7}
$$
目标函数：
$$
\mathop{\arg\max}_{X, Y, \beta}\ \log p(X, Y, \beta | R) \tag{8}
$$
这对于“推公式党"来说，并不友好。下面，我们来推导下公式(7)。首先，根据贝叶斯公式，我们可以得到：
$$
\begin{aligned}
p(X, Y, \beta | R) 
&= \frac{p(R | X, Y, \beta) p(X, Y, \beta)}{p(R)} \\\\
&\propto p(R | X, Y, \beta) p(X) p(Y)
\end{aligned} \tag{9}
$$
两边取对数，得到：
$$
\begin{aligned}
\log p(X, Y, \beta | R) 
&= \log p(R | X, Y, \beta) + \log p(X) + \log p(Y)
\end{aligned} \tag{10}
$$
下面分别求解这三项：
$$
\begin{aligned}
\log p(R | X, Y, \beta) 
&= \sum_{u, i} \alpha r_{ui} \log p(l_{ui} | x_u, y_i, \beta_u, \beta_i) + \log (1 - p(l_{ui}|x_u, y_i, \beta_u, \beta_i)) \\\\
&= \sum_{u, i} \alpha r_{ui} \left( (x_u y_i^T + \beta_u + \beta_i) - \log (1 + \exp(x_u y_i^T + \beta_u + \beta_i) )\right) \\\\
& - \log (1 + \exp(x_u y_i^T + \beta_u + \beta_i)) \\\\
&= \sum_{u, i} \alpha r_{ui} (x_u y_i^T + \beta_u + \beta_i) - (1 + \alpha r_{ui}) \log (1 + \exp(x_u y_i^T + \beta_u + \beta_i))
\end{aligned} \tag{11}
$$

$$
\begin{aligned}
\log p(X) 
&= \sum_u^n \log (\lvert 2 \pi \sigma_u^2 \mathbf{I} \rvert^{-\frac{1}{2}} \exp (-\frac{1}{2} x_u^T (\sigma_u^2 \mathbf{I})^{-1}x_u)) \\\\
&= - \frac{nf}{2} \log (2 \pi \sigma_u^2) - \sum_u^n \frac{1}{2\sigma_u^2} \lVert x_u \rVert^2
\end{aligned} \tag{12}
$$
类似地可以得到，
$$
\log p(Y) = - \frac{mf}{2} \log (2 \pi \sigma_i^2) - \sum_i^m \frac{1}{2\sigma_i^2} \lVert y_i \rVert^2 \tag{13}
$$
将式子(11)、(12)、(13)代入(10)中，得到：
$$
\begin{aligned}
\log p(X, Y, \beta | R) 
&= \sum_{u, i} \alpha r_{ui} (x_u y_i^T + \beta_u + \beta_i) - (1 + \alpha r_{ui}) \log (1 + \exp(x_u y_i^T + \beta_u + \beta_i)) \\\\
&- \frac{1}{2\sigma_u^2} \lVert x_u \rVert^2 - \frac{1}{2\sigma_i^2} \lVert y_i \rVert^2 + C 
\end{aligned}
\tag{14}
$$
令$\sigma_u = \sigma_i$并且$ \lambda = \frac{1}{\sigma_u^2}$，则可以由式(14)得到式(7)。

ps：个人感觉作者将$\beta$给忘记了，按理说，损失函数中应该加上$\beta$的L2正则。

### 参数更新

$$
\frac{\partial \ell}{\partial x_u} = \sum_i \alpha r_{ui} y_i - \frac{y_i (1 + \alpha r_{ui}) \exp(x_u y_i^T + \beta_u + \beta_i)}{1 + \exp(x_u y_i^T + \beta_u + \beta_i)} - \lambda x_u
$$


$$
\frac{\partial \ell}{\partial \beta_u} = \sum_i \alpha r_{ui} - \frac{(1 + \alpha r_{ui}) \exp(x_u y_i^T + \beta_u + \beta_i)}{1 + \exp(x_u y_i^T + \beta_u + \beta_i)}
$$

$$
\frac{\partial \ell}{\partial y_i} = \sum_u \alpha r_{ui} x_u - \frac{x_u (1 + \alpha r_{ui}) \exp(x_u y_i^T + \beta_u + \beta_i)}{1 + \exp(x_u y_i^T + \beta_u + \beta_i)} - \lambda y_i
$$

$$
\frac{\partial \ell}{\partial \beta_i} = \sum_u \alpha r_{ui} - \frac{(1 + \alpha r_{ui}) \exp(x_u y_i^T + \beta_u + \beta_i)}{1 + \exp(x_u y_i^T + \beta_u + \beta_i)}
$$

### 并行



### 参考资料

论文地址：http://stanford.edu/~rezab/nips2014workshop/submits/logmat.pdf

实验代码：https://github.com/MrChrisJohnson/logistic-mf