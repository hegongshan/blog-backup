---
title: 常见的激活函数
date: 2019-07-26 15:36:40
tags: deep learning
categories: deep learning
mathjax: true
---

常见的激活函数有sigmoid函数、tanh函数和ReLU函数，本文对这三者进行了分析和比较。

<!--more-->

### sigmoid函数

$$
\sigma(x) = \frac{1}{1+e^{-x}} \tag{1}
$$

![](/static/images/sigmoid.png)

sigmoid函数的导数为
$$
\begin{align}
\sigma^\prime (x)
&= \frac{-e^{-x}}{(1+e^{-x})^2} \\\\
&= \frac{1}{1+e^{-x}} \times \left( 1-\frac{1}{1+e^{-x}} \right) \\\\
&= \sigma(x) (1-\sigma(x))
\end{align} \tag{2}
$$

### tanh函数

$$
tanh(x) = \frac{sinhx}{coshx} = \frac{e^x-e^{-x}}{e^x+e^{-x}} \tag{3}
$$

![](/static/images/tanh.png)

tanh函数的导数为
$$
\begin{align}
tanh^\prime(x) 
&= \frac{(e^x + e^{-x})(e^x + e^{-x}) - (e^x - e^{-x})(e^x - e^{-x})}{(e^x + e^{-x})^2} \\\\
&= 1 - tanh^2 (x)
\end{align} \tag{4}
$$

### ReLU函数

线性整流函数（Rectified Linear Unit, ReLU），其数学表达式为
$$
f(x) = max(0,x) \tag{5}
$$

![](/static/images/relu.png)

ReLU的导数为
$$
f^\prime (x) = 
\begin{cases}
0, & x \leq 0 \\\\
1, & x > 0
\end{cases} \tag{6}
$$

### 对比

（1）sigmoid函数将值限制在区间(0,1)中，这可能会限制模型的性能。当值趋近于0或者1时，曲线趋于饱和。

（2）由于
$$
\begin{align}
tanh(\frac{x}{2}) &= \frac{e^{\frac{x}{2}}-e^{-\frac{x}{2}}}{e^{\frac{x}{2}}+e^{-\frac{x}{2}}} \\\\
&= \frac{1 - e^{-x}}{1 + e^{-x}} \\\\
&= \frac{2 - (1 + e^{-x})}{1 + e^{-x}} \\\\
&= 2 \sigma(x) - 1
\end{align} \tag{7}
$$
因此，tanh函数也只是在一定程度上缓解了sigmoid函数的问题。

（3）ReLU函数并不会产生饱和问题，能够很好地适应稀疏数据。

### 参考文献

Xiangnan He, Lizi Liao, Hanwang Zhang, Liqiang Nie, Xia Hu and Tat-Seng Chua (2017). [Neural Collaborative Filtering.](http://dl.acm.org/citation.cfm?id=3052569) In Proceedings of WWW ‘17, Perth, Australia, April 03-07, 2017.