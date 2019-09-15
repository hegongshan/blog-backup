---
title: 常见的激活函数
date: 2019-07-26 15:36:40
tags: deep learning
categories: deep learning
mathjax: true
---

常见的激活函数有sigmoid函数、tanh函数和ReLU函数，这里记录下这三者的数学表达式。

<!--more-->

### sigmoid函数

$$
\sigma(x) = \frac{1}{1+e^{-x}} \tag{1}
$$



### tanh函数

$$
tanh(x) = \frac{sinhx}{coshx} = \frac{e^x-e^{-x}}{e^x+e^{-x}} \tag{2}
$$



### ReLU函数

$$
f(x) = max(x,0) \tag{3}
$$



