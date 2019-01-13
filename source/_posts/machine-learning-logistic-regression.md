---
title: 机器学习之logistic回归
date: 2018-07-10 12:34:36
tags: 机器学习
categories: 机器学习
mathjax: true
---

对于二分类任务，其输出标记为y ∈ {0,1}，因此我们需要一个将自变量z转换为0/1值，最理想的是

“单位阶跃函数”（unit-step function），亦称Heaviside函数。
$$
y=
\begin{cases}
0,  & \text{z < 0} \\\
0.5, & \text{z = 0} \\\
1,  & \text{z > 0} 
\end{cases}
$$
![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/15/heaviside.png)

然而，单位阶跃函数的问题在于：该函数是一个不连续的分段函数，它在x=0处从0瞬间跳跃到了1。

我们希望找到一个近似单位阶跃函数的“替代函数”（surrogate function），并希望它单调可微。对数几率函数正是这样一个替代函数。

对数几率函数：
$$
y=\frac{1}{1+e^{-z}}
$$
![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/15/logistic_1.png)

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/07/15/logistic_2.png)

对数几率函数是一种Sigmoid函数（形似S的函数），它将z值转化为一个接近0或1的y值。从上面[-5,5]以及[-60,60]两张局部图可以看出，其在[-5,5]这个区间范围内变化很陡，函数值从0快速跳跃到了1。

<!--more-->

### 算法思想

在每个特征上都乘以一个**回归系数**，然后把所有的结果值相加，将这个总和代入Sigmoid函数中，进而得到一个范围在0~1之间的数值。任何大于0.5的数据被分入1类，小于0.5则被归入0类。

二项logistic回归模型：
$$
P(Y=1|x)=\frac{1}{1+e^{-(w \cdot x + b)}}=\frac{e^{w \cdot x+b}}{1+e^{w \cdot x+b}}=h(x)
$$

$$
P(Y=0|x)=\frac{1}{1+e^{w \cdot x+b}}
$$

其中，x ∈ $R^n$是输入向量，w ∈ $R^n$是权重向量，$w \cdot x$为w和x的内积。

方便起见，将输入向量和权重向量加以扩充，仍记作w，x，即
$$
w = (w^{(1)},w^{(2)},\dots,w^{(n)},b)^T
$$

$$
x=(x^{(1)},x^{(2)},\dots,x^{(n)},1)^T
$$

此时，二项logistic回归模型：
$$
P(Y=1|x)=\frac{e^{w \cdot x}}{1+e^{w \cdot x}}=h(x)
$$

$$
P(Y=0|x)=\frac{1}{1+e^{w \cdot x}}
$$

我们可以通过最大似然估计法（maximum likelihood method）来估计w。

似然函数：
$$
\prod^{n}_{i=1}[{h(x_i)]^{y_i}}[1-h(x_i)]^{1-y_i}
$$
对数似然函数：
$$
L(w)=\sum^n_{i=1} [ {y_i \ln h(x_i)+(1-y_i) \ln (1-h(x_i))}]\\\
=\sum^n_{i=1} [y_i \ln \frac{h(x_i)}{1-h(x_i)}+\ln(1-h(x_i))]\\\
=\sum^n_{i=1}[{y_i ( w \cdot x_i)-\ln(1+\rm e^{w \cdot  x_i})}]
$$
从而
$$
\hat w = argmax_w L(w)
$$

### 求最优回归系数

#### 梯度上升法

##### 算法思想

大学高等数学下册中说，沿梯度方向的方向导数最大，也就是说，梯度方向是函数f(x,y)在某一点(x,y)处增长最快的方向。

要找到某函数的最大值，最好的方法就是沿着该函数的梯度方向探寻。

梯度上升算法的迭代公式：

$$
w=w+\alpha \cdot grad L(w)
$$
其中，$\alpha$为步长，表示每次沿梯度方向移动的距离；grad L(w)表示L(w)的梯度。

梯度公式
$$
grad f(x,y,z) = \frac{\partial f}{\partial x} \cdot \vec i + \frac{\partial f}{\partial y} \cdot \vec j + \frac{\partial f}{\partial z} \cdot \vec k
$$
根据之前求得的对数似然函数，对w求偏导数
$$
\frac{\partial L(w)}{\partial w}=\sum^n_{i=1}[{y_i x_{i}} - \frac{x_{i}e^{w \cdot x_i}}{1+e^{w \cdot x_i}}]\\\
=\sum^n_{i=1}{x_{i}(y_i-h(x_i))}
$$
故
$$
grad L(w_1,w_2,\dots,w_n)
=\sum_{k=1}^n \frac{\partial L(w)}{\partial w_k}\cdot \vec{i_k}\\\
= (  \sum_{i=1}^{n}x_{i1}(y_i-h(\vec{x_i})), \sum_{i=1}^{n}x_{i2}(y_i-h(\vec{x_i})),\dots,\sum_{i=1}^{n}x_{in}(y_i-h(\vec{x_i})))^T
$$

##### 代码实现

```python
import numpy as np

def sigmoid(inputVector):
    return 1.0/(1+np.exp(-inputVector))

def gradientAscent(dataMatrix,classLabels,iterations=500,alpha=0.001):
    """梯度上升算法"""
    dataMatrix = np.mat(dataMatrix)
    # transpose()将矩阵转置
    labelMatrix = np.mat(classLabels).transpose()
    m,n = np.shape(dataMatrix)
    weights = ones((n,1))
    for k in range(iterations):
        h = sigmoid(dataMatrix*weights)
        error = (labelMatrix-h)
        weights = weights + alpha * dataMatrix.transpose() * error
 	return weights

def classifyVector(inputVector,weights):
    """logistic回归分类函数"""
    p = sigmoid(inputVector*weights)
    if p > 0.5:
        return 1
    else:
        return 0
```

##### 随机梯度上升

一次仅用一个样本点来更新回归系数。

```python
def randomGradientAscent(dataMatrix,classLabels,alpha=0.001):
    """随机梯度上升算法"""
    m,n = np.shape(dataMatrix)
    weights = np.ones(n)
    for i in range(m):
        # dataMatrix[i]*weights 逐元素相乘
        h = sigmoid(sum(dataMatrix[i]*weights))
        error = classLabels[i]-h
        weights = weights + alpha*dataMatrix[i]*error
return weights        
```

##### 改进的随机梯度上升

改进

* 动态调整alpha
* 随机选取样本来更新回归系数

代码实现：

```python
def improvedRandomGradientAscent(dataMatrix,classLabels,
                                 iterations=500,alpha=0.001)
	m,n = np.shape(dataMatrix)
    weights = np.ones(n)
    for j in range(iterations):
        dataIndex = range(m)
        for i in range(m):
            alpha = alpha + 4/(1+i+j)
            randomIndex = int(np.random.uniform(0,len(dataIndex)))
            h = sigmoid(sum(dataMatrix[randomIndex]*weights))
            error = classLabels[randomIndex] - h
            weights = weights + alpha * error * dataMatrix[randomIndex]
            del dataIndex[randomIndex]
    return weights
```

#### 梯度下降法

梯度下降法与梯度上升法类似，用于求函数的最小值，其迭代公式如下：
$$
w=w-\alpha \cdot grad L(w)
$$






