---
title: 机器学习之朴素贝叶斯
date: 2018-07-02 17:11:33
tags: 机器学习
categories: 机器学习
mathjax: true
---

在讲朴素贝叶斯之前，我们先来回顾一下大学二年级概率论中的相关知识．

条件概率公式：

$$P(A|B) = \frac{P(AB)}{P(B)}$$ 

$$=> P(AB) = P(A|B)P(B)$$

全概率公式：

$$P(A)=\sum_{i=1}^{\infty}{P(B_i)P(A|B_i)}$$

贝叶斯公式：

$$P(B_i|A)=\frac{P(AB_i)}{P(A)}=\frac{P(A|B_i)P(B_i)}{\sum_{i=1}^{\infty}{P(B_i)P(A|B_i)}}$$

<!--more-->

### 算法思想

朴素贝叶斯是贝叶斯决策理论的一部分，而贝叶斯决策理论的核心思想是**选择具有最高概率的决策**．

举个很简单的例子，一般网站评论或者游戏聊天都会对侮辱性词汇进行屏蔽过滤．

假设现在存在一条评论，如何判断它是否包含侮辱性词汇？我们用P1(w)表示评论w包含侮辱性词汇的概率，用p2(w)表示评论w不包含侮辱性词汇的概率，那么对于评论w，可以用下面的规则来判断它的类别：

* 如果P1(w) &gt; P2(w) ，那么w为包含侮辱性词汇的评论．
* 如果P2(w) &gt; P1(w)，那么w为不包含侮辱性词汇的评论．

### 假设前提

朴素贝叶斯是用于文档分类的常用算法，它是基于以下假设对贝叶斯分类器的一个扩展．

* 特征之间相互独立，即一个特征出现的可能性与其他特征没有关系．比如，如果文档中一个词出现的概率不依赖于文档中的其他词，那么文档中词与词之间相互独立．
* 每个特征同等重要．

我们知道这两个假设过于简单，这也是之所以称之为朴素（navie）贝叶斯的原因．

### 理论模型

$$P(c|\mathbf{x})=\frac{P(c)P(\mathbf{x}|c)}{P(\mathbf{x})}$$

其中，P(c)是类＂先验＂(prior)概率，$P(\mathbf{x}|c)$是样本x相对于类标记c的类条件概率，或称为＂似然＂，$P(\mathbf{x})$是用于归一化的＂证据＂因子．

对于给定样本x，证据因子$P(\mathbf{x})$与类标记无关，因此估计$P(c|\mathbf{x})$的问题就转化为如何基于训练数据D来估计先验概率P(c)和条件概率$P(\mathbf{x}|c)$

根据大数定律，当训练集包含充足的独立同分布样本时，P(c)可通过各类样本出现的频率来进行估计．

对于条件概率$P(\mathbf{x}|c)$来说，由于假设x的各个属性相互独立，因此

$$P(\mathbf{x}|c) = P(x_1x_2...x_n|c) = P(x_1|c)P(x_2|c) \cdot\cdot\cdot P(x_n|c) = \prod_{i=1}^{n}{P(x_i|c)}$$ 

其中，n为**x**的属性个数

由于连乘操作易造成下溢出，即太多很小的数相乘导致结果四舍五入后得到0，通常使用对数进行处理，将连乘变为累加，从而避免下溢出．因此，

令$$L = P(c)P(\mathbf{x}|c)$$

则$$log L = log P(c) + log P(\mathbf{x}|c) = log P(c) + \sum_{i=1}^{n}{log P(x_i|c)}$$

### 拉普拉斯修正

为了避免其他属性（特征）携带的信息被训练集中未出现的属性值＂抹去＂，即为了避免多个条件概率相乘时某个概率值为0，导致最后的乘积为0，在估计概率值时通常要进行＂平滑＂，常用＂拉普拉斯修正＂．

具体来说，令N表示训练集D中可能的类别数，$N_i$表示第i个属性可能的取值数，则

$$P(c)=\frac{|D_c|+1}{|D|+N}$$

$$P(w_i|c)=\frac{|D_{c,x_i}|+1}{|D_c|+N_i}$$

### 示例：文本分类

朴素贝叶斯分类器通常有以下两种实现方式

- 词集模型：将每个词的出现与否作为一个特征，值为1表示词条出现在文档中，0表示词条未出现
- 词袋模型：将每个词在文档中出现的次数作为一个特征

下面我们用词集模型，来实现一个区分某一评论是否包含侮辱性词汇的朴素贝叶斯分类器．

创建一个bayes.py文件，

* 将训练集转化为词汇列表

```python
from numpy import *
def createVocabularyList(dataset):
    """
    从数据集中抽取不重复的词汇列表
    dataset: 给定的数据集
    """
    vocabularySet = set([])　#　创建一个空集合 
    for document in dataset:
        # 操作符｜表示求两个集合的并集
        vocabularySet = vocabulary | set(document)
    return list(vocabularySet)
```

* 将训练集中的某一条数据转化为向量

```python
def setOfWords2Vector(vocabularyList,inputSet):
    """
    根据词汇列表，将输入的数据集转化为与词汇列表维度相同的向量
    """
    # 创建一个长度为len(vocabularyList)，所含元素都为0的向量
    # 等价于 
    # returnVector = []
    # for i in range(len(vocabularyList)):
    #     returnVector[i] = 0
    returnVector = [0]*len(vocabularyList)
    for word in inputSet:
        if word in vocabularyList:
            returnVector[vocabularyList.index(word)] = 1
    return returnVector
```

* 创建朴素贝叶斯分类器训练函数

```python
def trainNavieBayes(trainMatrix,trainCategory):
    """
    贝叶斯分类器训练函数
    trainMatrix: numpy中array类型，是由训练集转化的所有向量组成的矩阵
    trainCategory: 由矩阵中每一向量的所属类别组成的列表
    """
    numTrainDocs = len(trainMatrix)
    numWords = len(trainMatrix[0])
    # pAbusive = sum(trainCategory)/float(numTrainDocs)
    # 拉普拉斯修正
    pAbusive = (sum(trainCategory) + 1)/(float(numTrainDocs) + 2)
    p0Vector = zeros(numWords);p1Vector = zeros(numWords)
    # 计算某一类别下的总词数
    # p0NumWords = 0.0;p1NumWords = 0.0
    # 使用拉普拉斯修正后
    p0NumWords = 2.0;p1NumWords = 2.0
    for i in range(numTrainDocs):
        if trainCategory[i] == 1:
            p1Vector += trainMatrix[i]
            p1NumWords += sum(trainMatrix[i])
        else:
            p0Vector += trainMatrix[i]
            p0NumWords += sum(trainMatrix[i])
    # 用某个类别下某个词出现的次数除以该类别下的总词数，
    # 即求得某一类别c在每一个属性上的概率p(ci)
    # p0Vector = p0Vector/p0NumWords
    # p1Vector = p1Vector/p1NumWords
    p0Vector = log(p0Vector/p0NumWords)
    p1Vector = log(p1Vector/p1NumWords)
    return p0Vector,p1Vector,pAbusive
```

* 创建朴素贝叶斯分类函数

```python
def classifyNavieBayes(vector2Classify,p0Vector,p1Vector,pc1):
    p1 = sum(vector2Classify*p1Vector) + log(pc1)
    p0 = sum(vector2Classify*p0Vector) + log(1.0-pc1)
    if p1 > p0:
        return 1
    else:
        return 0
```

上面程序的第2行，就是在求

$$log L = log P(c) + log P(\mathbf{x}|c) = log P(c) + \sum_{i=1}^{n}{log P(x_i|c)}$$

接下来我们测试一下刚才的分类器是否有效

```python
def loadDataSet():
    postingList = [['my','dog','has','flea','problems','help','please'],
                  ['maybe','not','take','him','to','dog','park','stupid'],
                  ['my','dalmation','is','so','cute','I','love','him'],
                  ['stop','posting','stupid','worthless','garbage'],
                  ['mr','licks','ate','my','steak','how','to','stop','him'],
                  ['quit','buying','worthless','dog','food','stupid']]
    # 0表示正常言论，１表示包含侮辱性词汇的评论
    categoryVector = [0,1,0,1,0,1]
    return postingList,categoryVector
def testNavieBayes():
    listOfPosts,listClasses = loadDataSet()
    vocabularyList = createVocabularyList(listOfPosts)
    trainMatrix = []
    for post in listOfPosts:
        trainMatrix.append(setOfWords2Vector(vocabularyList,post))
    p0Vector,p1Vector,pc1 = trainNavieBayes(array(trainMatrix),array(listClaasses))
    testPost = ['love','my','dalmation']
    testVector = array(setOfWords2Vector(vocabularyList,testPost))
    print(str(testPost)+" 被分类为:"+
          classifNavieBayes(testVector,p0Vector,p1Vector,pc1))
    
    testPost = ['stupid','garbage']
    testVector = array(setOfWords2Vector(vocabularyList,testPost))
    print(str(testPost)+" 被分类为:"+
          classifNavieBayes(testVector,p0Vector,p1Vector,pc1))
```

<hr>

参考资料

* 机器学习实战, Peter Harrington, 人民邮电出版社
* 机器学习, 周志华, 清华大学出版社

