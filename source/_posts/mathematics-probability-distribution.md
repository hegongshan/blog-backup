---
title: 数学基础——常见概率分布
date: 2020-09-16 18:48:58
tags: mathematics
categories: mathematics
mathjax: true
---

本文回顾了常见的概率分布（probability distribution）及其期望和方差。

<!--more-->

### 伯努利分布

伯努利分布（Bernoulli distribution），又称两点分布（Two points Distribution），0-1分布。
$$
P(X=k) = p^k (1-p)^{1-k}, k \in \\{0, 1\\}
$$

### 二项分布

二项分布（Binomial Distribution），$X \sim B(n,p)$。
$$
P(X=k) = C_n^k p^k (1-p)^{n-k}
$$


### 泊松分布

泊松分布（Poisson Distribution），$X \sim P(\lambda)$。
$$
P(X = k) = \frac{\lambda^k}{k!} e^{-\lambda}, k = 0, 1, \cdots
$$

其中，$\lambda > 0$。

* 期望和方差

根据泰勒公式，
$$
e^x = 1 + x + \frac{x^2}{2!} + \cdots + \frac{x^n}{n!} + \cdots = \sum_{k=0}^{\infty} \frac{x^k}{k!} = \sum_{k=1}^{\infty} \frac{x^{k - 1}}{(k - 1)!}
$$

根据期望的定义：
$$
\begin{aligned}
E(X) 
&= \sum_{k=0}^\infty k \frac{\lambda^k}{k!} e^{-\lambda} \\\\
&= \sum_{k=1}^\infty k \frac{\lambda^k}{k!} e^{-\lambda} \\\\
&= \lambda e^{-\lambda} \sum_{k=1}^\infty \frac{\lambda^{k - 1}}{(k - 1)!} \\\\
&= \lambda e^{-\lambda} e^{\lambda} \\\\
&= \lambda
\end{aligned}
$$

$$
\begin{aligned}
E(X^2) 
&= \sum_{k=0}^\infty k^2 \frac{\lambda^k}{k!} e^{-\lambda} 
= \lambda e^{-\lambda} \sum_{k=1}^\infty k \frac{\lambda^{k - 1}}{(k - 1)!} \\\\
&= \lambda e^{-\lambda} \sum_{k=1}^\infty (k - 1 + 1) \frac{\lambda^{k - 1}}{(k - 1)!} \\\\
&= \lambda e^{-\lambda} (\sum_{k=1}^\infty (k - 1) \frac{\lambda^{k - 1}}{(k - 1)!} + \sum_{k=1}^\infty \frac{\lambda^{k - 1}}{(k - 1)!}) \\\\
&= \lambda e^{-\lambda} (\lambda \sum_{k=2}^\infty \frac{\lambda^{k - 2}}{(k - 2)!} + \sum_{k=1}^\infty \frac{\lambda^{k - 1}}{(k - 1)!}) \\\\
&= \lambda e^{-\lambda} (\lambda e^\lambda + e^\lambda) \\\\
&= \lambda (\lambda + 1)
\end{aligned}
$$



$$
D(X) = E(X^2) - E(X)^2 = \lambda^2 + \lambda - \lambda^2 = \lambda
$$


### 均匀分布

均匀分布（Uniform Distribution），概率密度为：
$$
f(x) = 
\begin{cases}
\frac{1}{b - a}, & a < x < b \\\\
0, & 其他
\end{cases}
$$

期望
$$
\begin{aligned}
E(X) 
&= \int_{-\infty}^{+\infty} x f(x) \mathrm{d}x = \int_a^b  \frac{x}{b - a} \mathrm{d}x \\\\
&= \frac{x^2}{2(b - a)} |_a^b \\\\
&= \frac{a + b}{2}
\end{aligned}
$$

$$
\begin{aligned}
E(X^2) 
&= \int_{-\infty}^{+\infty} x^2 f(x) \mathrm{d}x = \int_a^b  \frac{x^2}{b - a} \mathrm{d}x \\\\
&= \frac{x^3}{3(b - a)} |_a^b \\\\
&= \frac{a^2 + ab + b^2}{3}
\end{aligned}
$$

$$
D(X) = E(X^2) - E(X)^2 = \frac{a^2 + ab + b^2}{3} - (\frac{a + b}{2})^2=\frac{(b - a)^2}{12}
$$


补充：
$$
a^3 - b^3 = (a - b)(a^2 + ab + b^2)
$$

### 指数分布

指数分布（Exponential Distribution），$X \sim E(\lambda)$概率密度：
$$
f(x)=
\begin{cases}
\lambda e^{-\lambda x}, & x > 0\\\\
0, & x \le 0
\end{cases}
$$

其中，$\lambda > 0$。

期望
$$
\begin{aligned}
E(X) &= \int_{-\infty}^{+\infty} x f(x) \mathrm{d}x = \int_{0}^{+\infty} x \lambda e^{-\lambda x} \mathrm{d}x \\\\
&=-(x + \frac{1}{\lambda}) e^{-\lambda x} |_{0}^{+\infty} \\\\
&=\frac{1}{\lambda}
\end{aligned}
$$
方差
$$
\begin{aligned}
E(X^2) &= \int_{-\infty}^{+\infty} x^2 f(x) \mathrm{d}x = \int_{0}^{+\infty} x^2 \lambda e^{-\lambda x} \mathrm{d}x \\\\
&=-(x^2 + \frac{2 x}{\lambda}  + \frac{2}{\lambda^2}) e^{-\lambda x} |_{0}^{+\infty} \\\\
&=\frac{2}{\lambda^2}
\end{aligned}
$$

$$
D(X) = E(X^2) - E(X)^2 = \frac{2}{\lambda^2} - \frac{1}{\lambda^2} = \frac{1}{\lambda^2}
$$

### 正态分布

正态分布（Normal Distribution），又称**高斯分布（Gaussian Distribution）**。

#### 一元正态分布

$X \sim N(\mu, \sigma^2)$，概率密度为
$$
f(x) = \frac{1}{\sqrt{2 \pi} \sigma} \exp(-\frac{(x - \mu)^2}{2 \sigma^2})
$$

$$
\begin{aligned}
E(X) 
&= \int_{-\infty}^{+\infty} x f(x) \mathrm{d}x = \int_{-\infty}^{+\infty} x \frac{1}{\sqrt{2 \pi} \sigma} \exp(-{\frac{(x - \mu)^2}{2 \sigma^2}}) \mathrm{d}x \\\\
&= \sqrt {\frac{2}{\pi}} \sigma \int_{-\infty}^{+\infty} \frac{x - \mu + \mu}{\sqrt{2} \sigma} \exp \left(-(\frac{x - \mu}{\sqrt{2} \sigma})^2 \right) \mathrm{d} \frac{x - \mu}{\sqrt{2} \sigma} \\\\
&= \sqrt {\frac{2}{\pi}} \int_{-\infty}^{+\infty} y e^{-y^2} \mathrm{d}y + \frac{\mu}{\sqrt \pi} \int_{-\infty}^{+\infty} e^{-y^2} \mathrm{d}y \\\\
&=\mu
\end{aligned}
$$
其中，$y e^{-y^2}$是奇函数，其积分值为0；$\int_{-\infty}^{+\infty} e^{-y^2} \mathrm{d}y = \sqrt{\pi}$。

当$\mu = 0, \sigma = 1$时，称之为**标准正态分布（Standard Normal Distribution）**。
$$
f(x) = \frac{1}{\sqrt{2 \pi}} e^{-\frac{x^2}{2}}
$$

#### 多元正态分布

$X \in N(\mathbf{\mu}, \mathbf{\Sigma})$，概率密度为
$$
f(x_1,x_2,\cdots,x_n) = \frac{1}{\sqrt{(2 \pi)^n \left \vert \mathbf{\Sigma} \right \vert}} \exp(-\frac{1}{2}(\mathbf{x} - \mathbf{\mu})^T \mathbf{\Sigma}^{-1} (\mathbf{x} - \mathbf{\mu}))
$$

其中，$\left \vert \mathbf{\Sigma} \right \vert$为协方差矩阵的行列式。

<!--

### 卡方分布

卡方分布（Chi-square Distribution）：如果n个互相独立的随机变量X

### T分布



### F分布

-->

### 拉普拉斯分布

拉普拉斯分布（Laplace Distribution），概率密度为
$$
f(x) = \frac{1}{2 \lambda} \exp(-\frac{\left \vert x - \mu \right \vert}{\lambda})
$$

其中，$\lambda > 0$。

* 期望

$$
\begin{aligned}
E(X) 
&= \int_{-\infty}^{+\infty} x \frac{1}{2 \lambda} \exp(-\frac{\left \vert x - \mu \right \vert}{\lambda}) \mathrm{d}x \\\\
&= \frac{1}{2} \int_{-\infty}^{+\infty} x \exp(-\frac{\left \vert x - \mu \right \vert}{\lambda}) \mathrm{d}\frac{x - \mu}{\lambda} \\\\
&= \frac{1}{2} \int_{-\infty}^{+\infty} (\lambda y + \mu) e^{-\left \vert y \right \vert} \mathrm{d}y \\\\
&= \frac{\mu}{2} (\int_{-\infty}^{0} e^y \mathrm{d}y + \int_{0}^{+\infty} e^{-y} \mathrm{d}y) \\\\
&= \mu
\end{aligned}
$$

* 方差

$$
\begin{aligned}
D(X) 
&= E(X - E(X))^2 = \int_{-\infty}^{+\infty} (x - \mu)^2 \frac{1}{2 \lambda} \exp(-\frac{\left \vert x - \mu \right \vert}{\lambda}) \mathrm{d}x \\\\
&= \frac{\lambda^2}{2} \int_{-\infty}^{+\infty} (\frac{x - \mu}{\lambda})^2 \exp(-\frac{\left \vert x - \mu \right \vert}{\lambda}) \mathrm{d} \frac{x - \mu}{\lambda} \\\\
&= \frac{\lambda^2}{2} \int_{-\infty}^{+\infty} y^2 e^{-\left \vert y \right \vert} \mathrm{d}y \\\\
&= \frac{\lambda^2}{2} \left( (y^2 - 2y + 2)e^y |_{-\infty}^{0} - (y^2 + 2y +2)e^{-y} |_{0}^{+\infty} \right) \\\\
&= 2 \lambda^2
\end{aligned}
$$

<!--

### 狄利克雷分布

狄利克雷分布（Dirichlet Distribution）

-->