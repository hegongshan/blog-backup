---
title: 机器学习之AdaBoost
date: 2018-08-02 19:21:02
tags: 机器学习
categories: 机器学习
mathjax: true
---

AdaBoost（adaptive boosting）算法是提升（boosting）方法的一个最流行版本，1995年由Freund和Schapire提出。其基本思想是使用多个弱分类器（即分类器的性能并不好，错误率较高）来构建一个强分类器。

<!--more-->

### 运行过程

训练数据集中的每个样本，并赋予其一个权重，这些权重构成了向量D。一开始，这些权重都初始化成相等值。首先在训练数据集上训练出一个弱分类器并计算该分类器的错误率，然后在同一数据集上再次训练弱分类器。在分类器的第二次训练中，将会重新调整每个样本的权重，其中第一次分对的样本的权重将会降低，而第一次分错的样本的权重将会提高。为了从所有弱分类器中得到最终的分类结果，AdaBoost为每个分类器都分配了一个权重值$\alpha$，这些$\alpha$值是基于每个若分类器的错误率进行计算的。

错误率$\epsilon$的定义如下：
$$
\epsilon = \frac{未正确分类的样本数目}{所有样本数目}
$$
$\alpha$的计算公式如下：
$$
\alpha = \frac{1}{2} \ln (\frac{1-\epsilon}{\epsilon})
$$
计算出$\alpha$值后，需要更新权重向量D，以使得那些正确分类的样本的权重降低而错分样本的权重升高。

D的计算方法如下：
$$
D_{i} ^{ ( t+1) } =
\begin{cases}
\frac { D_{i} ^{ (t) } e^{-\alpha} } { sum(D) }, & i分类正确 \\\
\frac{ D_{i} ^{ (t) } e^{\alpha} }{ sum(D) }, & i分类错误
\end{cases}
$$
在计算出D之后，AdaBoost又开始进入下一轮迭代。AdaBoost算法会不断地重复训练分类器和调整权重的过程，直到训练错误率为0或者弱分类器的数目达到用户的指定值为止。

$\alpha$作为每个分类器分类结果$G_{m}(x)$的权重，对所有分类器的加权分类结果进行累加求和，
$$
f(x) = \sum_{m=1}^{N} \alpha_{m} G_{m}(x)
$$
从而得到最终的分类器


$$
G(x) = sign(f(x)) = sign( \sum_{m=1}^{N} \alpha_{m} G_{m}(x) )
$$

### AdaBoost的例子

| 序号 |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |  9   | 10   |
| :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | ---- |
|  x   |  0   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   | 9    |
|  y   |  1   |  1   |  1   |  -1  |  -1  |  -1  |  1   |  1   |  1   | -1   |

可选的阈值有2.5，5.5和8.5

若阈值为2.5，则7、8、9分类错误，分类错误率为$e = \frac {3}{10}$

若阈值为5.5，

a.
$$
G(x) = 
\begin{cases}
1, & x < 5.5 \\\
-1, & x > 5.5
\end{cases}
$$
此时，4、5、６以及7、８、９分类错误，分类误差率为$e = \frac {6}{10}$

b.
$$
G(x) = 
\begin{cases}
1, & x > 5.5 \\\
-1, & x < 5.5
\end{cases}
$$
此时，1、2、3和10分类错误，分类误差率为$e = \frac {4} {10}$

因此，最低误差率为0.4

若阈值为8.5，

a.
$$
G(x) =
\begin{cases}
1, & x < 8.5 \\\
-1, & x > 8.5
\end{cases}
$$
此时，4、5、6分类错误，分类误差率为$e = \frac {3} {10}$

可以看到当阈值为2.5或8.5时，分类误差率最低，因此，我们可任取其中一个阈值，比如2.5。

基本分类器
$$
G(x) =
\begin{cases}
1, & x < 2.5 \\\
-1, & x > 2.5
\end{cases}
$$

### 算法实现

我们可以选择任一分类器作为AdaBoost算法的弱分类器，这里选择单层决策树（decision stump）作为弱分类器。

```python
"""
基于单层决策树的AdaBoost分类器
"""
import numpy as np

class AdaBoost():
    
    def loadDataSet(self,filename):
        """
        从文件中导入数据集
        filename : 文件名
        """
        dataMat = []
        labelMat = []
        with open(filename) as file:
            for line in file.readlines():
                numFeature = len(line.split('\t'))
                lineArr = []
                currentLine = line.strip().split("\t")
                for i in range(numFeature-1):
                    lineArr.append(float(currentLine[i]))
                dataMat.append(lineArr)
                labelMat.append(float(currentLine[-1]))
        return dataMat,labelMat
    
    def _stumpClassify(self,dataMatrix,dimension,threshold,thresholdInequality):
        arr = np.ones((np.shape(dataMatrix)[0],1))
        if thresholdInequality == 'lt':
            arr[dataMatrix[:,dimension] <= threshold] = -1.0
        else:
            arr[dataMatrix[:,dimension] > threshold] = -1.0
        return arr
    
    def _buildStump(self,dataArr,classLabels,D):
        dataMatrix = np.mat(dataArr)
        labelMat = np.mat(classLabels).T
        m,n = np.shape(dataMatrix)
        numSteps = 10.0
        bestStump = {}
        bestClassEst = np.mat(np.zeros((m,1)))
        minError = np.inf
        # 遍历每一个特征
        for i in range(n):
            rangeMin = dataMatrix[:,i].min()
            rangeMax = dataMatrix[:,i].max()
            stepSize = (rangeMax-rangeMin)/numSteps
            for j in range(-1,int(numSteps)+1):
                for inequal in ['lt','gt']:
                    threshold = (rangeMin + float(j) * stepSize)
                    predictedVals = self._stumpClassify(dataMatrix,i,threshold,inequal)
                    errArr = np.mat(np.ones((m,1)))
                    errArr[predictedVals == labelMat] = 0
                    weightedError = D.T * errArr
                    if weightedError < minError:
                        minError = weightedError
                        bestClassEst = predictedVals.copy()
                        bestStump['dimension'] = i
                        bestStump['threshold'] = threshold
                        bestStump['inequal'] = inequal
        return bestStump,minError,bestClassEst
    
    def adaBoostTrainDS(self,dataArr,classLabels,numIter=40):
        """AdaBoost训练过程"""
        weakClassArr = []
        m = np.shape(dataArr)[0]
        D = np.mat(np.ones((m,1))/m)
        aggClassEst = np.mat(np.zeros((m,1)))
        for i in range(numIter):
            bestStump,error,classEst = self._buildStump(dataArr, classLabels, D)
            print("D:",D.T)
            alpha = float(0.5*np.log((1.0-error)/max(error,1e-16)))
            bestStump['alpha'] = alpha
            weakClassArr.append(bestStump)
            print("classEst:",classEst.T)
            expon = np.multiply(-1*alpha*np.mat(classLabels).T,classEst)
            D = np.multiply(D,np.exp(expon))
            D = D/D.sum()
            aggClassEst += alpha*classEst
            print("aggClassEst:",aggClassEst.T)
            aggErrors = np.multiply(np.sign(aggClassEst) != np.mat(classLabels).T,np.ones((m,1)))
            errorRate = aggErrors.sum()/m
            print("total error:",errorRate,"\n")
            if errorRate == 0.0:
                break
        return weakClassArr,aggClassEst
    
    def adaClassify(self,dataToClass,classifierArr):
        """AdaBoost分类函数"""
        dataMatrix = np.mat(dataToClass)
        m = np.shape(dataMatrix)[0]
        aggClassEstimate = np.mat(np.zeros((m,1)))
        for i in range(len(classifierArr)):
            classEstimate = self.stumpClassify(dataMatrix, 
                                          classifierArr[i]['dimension'],
                                          classifierArr[i]['threshold'],
                                          classifierArr[i]['inequal'])
            aggClassEstimate += classifierArr[i]['alpha'] * classEstimate
            print(aggClassEstimate)
        return np.sign(aggClassEstimate)
```

(未完待续)