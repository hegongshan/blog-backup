---
title: 机器学习之k-近邻算法
date: 2018-06-27 17:21:04
tags: 机器学习
categories: 机器学习
mathjax: true
---

k-近邻算法（k-Nearest Neighbor，简称kNN）,工作原理：

存在一个样本数据集合，也称作训练样本集，并且样本集中每个数据都存在标签，即我们知道样本集中每一数据与所属分类的对应关系．

输入没有标签的新数据后，将新数据的每个特征与样本集中数据对应的特征进行比较，然后算法提取样本集中特征最相似的数据（最近邻）的分类标签．一般来说，只选择样本数据集中前k个最相似的数据，这就是k-近邻算法中k的出处，通常k是不大于20的整数．

最后，选择k个最相似数据中**出现次数最多的分类**，作为新数据的分类．

<!--more-->

### 算法实现

创建一个kNN.py文件

```python
from numpy import *
import operator

def classify(inputData,dataSet,labels,k):
    """
    k-近邻算法
    inputData: 需要预测分类的数据
    dataSet: 训练样本集
    labels: 样本集的分类标签
    k: k-近邻算法中k,选择最近邻居的数目
    """
    # 取得样本集合中的样本个数，shape是numpy中用于计算矩阵维度的元组，这里的shape[0]可以理解为求二维矩阵dataSet的行数
    dataSetSize = dataSet.shape[0]
    # 求输入数据与样本集合的差值，tile()是numpy中用于扩展矩阵的函数，这里是将inputData扩展为dataSize行的矩阵，以确保inputData与dataSize同维度，可以相减
    differenceMatrix = tile(inputData,(dataSize,1)) - dataSet
    # 差矩阵的每个元素平方
    sqDifferenceMatrix = sqDifferenceMatrix**2
    # 对平方后的差距阵每一行求和
    sqDistances = sqDifferenceMatrix.sum(axis=1)
    # 求得输入数据与所有样本的距离
    distances = sqDistances**0.5
    # 按照从小到大的顺序对距离列表中的每个距离排序，按排序顺序返回排序之前的索引号
    sortedDistanceIndicies = distances.argsort()
    # kClassData 用于存储最相似的k个数据中出现的所有分类及该分类出现的次数，以分类标签作为键，以频度作为值
    kClassData = {}
    for i in range(k):
        label = labels[sortedDistanceIndicies[k]]
        # 以下三行，书上简写为kClassCount[label] = kClassData.get(label,0) + 1
        # 其中的get()方法，表示若不存在键label，则执行kClassData[label] = 0
        if label not in kClassData:
            kClassData[label] = 0
        kClassData[label] += 1
    # 对kClassData　按出现的频度降序排序
    # 书上这里写的是kClassData.iteritems()，这是python2中字典的方法，python3中只有items()方法
    sortedkClassData = sorted(kClassData.items(),
                              key=operator.itemgetter(1),
                              reverse=True)
    # 返回k个最相似数据中出现频度最高的分类标签
    return sortedkClassData[0][0]    
```

上面的程序使用了**欧式距离公式**，计算两个n维向量A和B之间的距离:

$$d=\sqrt{\sum_{i=1}^n{(A_i- B_i)^2}}$$

例如，点(2,1,5)和(1,2,3)之间的距离计算为：

$$d=\sqrt{(2-1)^2+(1-2)^2+(5-3)^2}$$

### 测试算法

已知6部电影的打斗镜头，接吻镜头及其类型（模拟的数据），判断一部已知打斗镜头和接吻镜头数的新电影，它的类型是动作片，还是爱情片，具体数据如下:

|    电影名称    | 打斗镜头 | 接吻镜头 | 电影类型 |
| :------------: | :------: | :------: | :------: |
|     小时代     |    0     |    50    |  爱情片  |
| 鬼吹灯之寻龙诀 |   100    |    15    |  动作片  |
|      战狼      |   150    |    5     |  动作片  |
|    让子弹飞    |    80    |    2     |  动作片  |
|      左耳      |    6     |    50    |  爱情片  |
|    心花路放    |    5     |    40    |  爱情片  |
|       ?        |    18    |    90    |   待定   |

我们当然可以一眼看出来，这部新电影应该是爱情片，但是，如何让程序自动预测它的类别呢？

创建一个test.py，代码如下:

```python
import kNN
def createDataSet():
    dataSet = array([0,50],[100,15],[150,5],
                   [80,2],[6,50],[5,40])
    labels = ['爱情片','动作片','动作片','动作片','爱情片','爱情片']
    return dataSet,labels

def testKNN():
	inputData = [18,90]
	dataSet,labels = createDataSet()
	return kNN.classify(inputData,dataSet,labels,3)
	    
label = testKNN()
print(label)
```

输出结果：

```python
爱情片
```

可以看到，kNN算法确实准确的预测了新电影的分类．

### 算法改进

欧式距离中，数字差值越大的属性对计算结果的影响也越大．若想消除这种影响，使各属性权重相等，可以**将数值归一化**，如将取值范围处理为0到1，或者-1到1之间．

下面的公式可以将任意取值范围的特征值转化为0到1区间内的值：

$$newValue = \frac{oldValue-min}{max-min}$$

其中，min和max分别是数据集中某一特征（属性）的最小值和最大值

在kNN.py中新增如下代码：

```python
def autoNorm(dataSet):
    """将训练集中的数据归一化"""
    minValues = dataSet.min(0)
    maxValues = dataSet.max(0)
    ranges = maxValues - minValues
    normDataSet = zeros(shape(dataSet))    
    m = dataSet.shape[0]
    normDataSet = dataSet - tile(minVals,(m,1))
    normDataSet = normDataSet/tile(ranges,(m,1))
    return normDataSet
```

接着修改classify()函数

```python
def classify(inputData,dataSet,labels,k):
    """
    k-近邻算法
    inputData: 需要预测分类的数据
    dataSet: 训练样本集
    labels: 样本集的分类标签
    k: k-近邻算法中k,选择最近邻居的数目
    """
    dataSet = autoNorm(dataSet)# 添加这一行
    dataSetSize = dataSet.shape[0]
    differenceMatrix = tile(inputData,(dataSize,1)) - dataSet
    sqDifferenceMatrix = sqDifferenceMatrix**2
    sqDistances = sqDifferenceMatrix.sum(axis=1)
    distances = sqDistances**0.5
    sortedDistanceIndicies = distances.argsort()
    kClassData = {}
    for i in range(k):
        label = labels[sortedDistanceIndicies[k]]
        if label not in kClassData:
            kClassData[label] = 0
        kClassData[label] += 1
    sortedkClassData = sorted(kClassData.items(),
                              key=operator.itemgetter(1),
                              reverse=True)
    return sortedkClassData[0][0]    
```

### 涉及的一些numpy中的函数

