---
title: 推荐系统常用评价指标
date: 2019-03-04 16:01:27
tags: recommender systems
categories: recommender systems
mathjax: true
---

<!--

### 推荐系统实验方法

在推荐系统中，主要有3种评测推荐效果的实验方法，即离线实验(offline experiment)、用户调查(user study) 和在线实验(online experiment)。

#### 离线实验

离线实验的方法一般由如下几个步骤构成:

(1) 通过日志系统获得用户行为数据，并按照一定格式生成一个标准的数据集; 

(2) 将数据集按照一定的规则分成训练集和测试集; 

(3) 在训练集上训练用户兴趣模型，在测试集上进行预测; 

(4) 通过事先定义的离线指标评测算法在测试集上的预测结果。

**好处**：不需要真实用户参与，可以直接快速地计算出来，从而方便、快速地测试大量不同的算法  

**缺点**：无法获得很多商业上关注的指标，如点击率、转化率等

#### 用户调查

用户调查需要有一些真实用户，让他们在需要测试的推荐系统上完成一些任务。在他们完成任务时，我们需要观察和记录他们的行为，并让他们回答一些问题。最后，我们需要通过分析他们的行为和答案了解测试系统的性能。

**优点**：可以获得很多体现用户主观感受的指标，相对在线实验风险很低，出现错误后很容易弥补

**缺点**：招募测试用户代价较大，很难组织大规模的测试用户，因此会使测试结果的统计意义不足。

#### 在线实验

在完成离线实验和必要的用户调查后，可以将推荐系统上线做AB测试，将它和旧的算法进行比较。

AB测试是一种很常用的在线评测算法的实验方法。它通过一定的规则将用户随机分成几组，并对不同组的用户采用不同的算法，然后通过统计不同组用户的各种不同的评测指标比较不同算法，比如可以统计不同组用户的点击率，通过点击率比较不同算法的性能。

**AB测试的优点**：可以公平获得不同算法实际在线时的性能指标，包括商业上关注的指标。
**AB测试的缺点**：周期比较长，必须进行长期的实验才能得到可靠的结果。

因此一般不会用AB测试测试所有的算法，而只是用它测试那些在离线实验和用户调查中表现很好的算法。

### 评测指标

在《推荐系统实践》中，作者列举了用户满意度、预测准确度、覆盖率、多样性、新颖性、惊喜度、信任度、实时性、健壮性和商业目标共十种推荐系统的评测指标，这里，我只选取了一部分。

#### 用户满意度

用户作为推荐系统的重要参与者，其满意度是评测推荐系统的最重要指标。但是，用户满意度没有办法离线计算，只能通过用户调查或者在线实验获得。

* 用户调查获得用户满意度主要是通过*调查问卷*的形式。

* 在在线系统中，用户满意度主要通过一些对用户行为的统计得到。比如在电子商务网站中，用户如果购买了推荐的商品，就表示他们在一定程度上满意。因此，我们可以利用购买率度量用户的满意度。此外，有些网站会通过设计一些用户反馈界面收集用户满意度。 更一般的情况下，我们可以用点击率、用户停留时间和转化率等指标度量用户的满意度。

#### 预测准确度

预测准确度度量一个推荐系统或者推荐算法预测用户行为的能力。

在计算该指标时需要有一个离线的数据集，该数据集包含用户的历史行为记录。然后，将该数据集通过时间分成训练集和测试集。最后，通过在训练集上建立用户的行为和兴趣模型预测用户在测试集上的行为，并计算预测行为和测试集上实际行为的重合度作为预测准确度。

由于离线的推荐算法有不同的研究方向，因此下面将针对不同的研究方向介绍它们的预测准确度指标。

 -->

### 评分预测

预测用户对物品评分的行为称为评分预测（rating prediction）。

评分预测的预测准确度一般通过**均方根误差(Root Mean Squared Error，简称RMSE)和平均绝对误差(Mean Absolute Error，简称MAE)**计算。

对于测试集中的一个用户u和物品i，令$r_{ui}$是用户对物品i的实际评分，而$\hat{r}_{ui}$是推荐算法给出的预测评分。

#### RMSE

$$
RMSE = \sqrt{ 
	\frac {
		\sum_{(u,i)\in Test} (r_{ui}-\hat{r}_{ui})^2
	}{
		\left \vert Test \right \vert
	} 
} \tag{1}
$$

#### MAE

MAE采用绝对值计算预测误差，它的定义为:
$$
MAE = \frac {
	\sum_{(u,i) \in Test}{|r_{ui}-\hat{r}_{ui}|}
}{
	\left \vert Test \right \vert
} \tag{2}
$$

### TopN推荐

网站在提供推荐服务时，一般是给用户一个个性化的推荐列表，这种推荐叫做TopN推荐。 

**在推荐系统的论文中，经常可以看到xx@N，它是xx at rank N的缩写。**意为在TopN推荐中，该指标的值。

#### Precision/Recall

TopN推荐的预测准确率一般通过准确率(precision)/召回率(recall)度量。 

令R(u)是根据用户在训练集上的行为给用户作出的推荐列表，而T(u)是用户在测试集上的行为列表。那么，推荐结果的召回率定义为:
$$
\mathrm{Recall}@N = \frac {
	\sum_{u \in U}|R(u) \cap T(u)|
} {
	\sum_{u \in U}|T(u)|
} \tag{3}
$$
推荐结果的准确率定义为：
$$
\mathrm{Precision}@N = \frac {
	\sum_{u \in U}|R(u) \cap T(u)|
} {
	\sum_{u \in U}|R(u)|
} \tag{4}
$$
F1值
$$
\mathrm{F1} = \frac{
    2 \times Precision \times Recall
}{
    Precision + Recall
} \tag{5}
$$

#### AP/MAP

Average Precision (AP)
$$
AP@N = \frac{
    \sum_{k=1}^N 
    \mathrm{Precision@k \times rel(k)}
}{
    \min \\{
    	N, \left \vert C_{\mathrm{adopted}} \right \vert 
    \\}
} \tag{6}
$$
其中，rel(k)是指示函数，表示第k个物品是否被采纳
$$
\mathrm{rel(k)} = 
\begin{cases}
1, & I_k \in C_{\mathrm{adopted}} \\\\
0, & \mathrm{otherwise}
\end{cases}
$$
平均精度均值 Mean Average Precision (MAP)
$$
\mathrm{MAP}@N = \frac{1}{
    \left \vert U \right \vert
} 
\sum_{u \in U} \mathrm{AP}@N \tag{7}
$$

#### Hit Ratio

命中率（Hit Ratio, HR）
$$
\mathrm{HR}@N = \frac{
	 \mathrm{hits}
}{
	\left \vert U \right \vert
} \tag{8}
$$

#### ARHR

平均命中排序倒数 Average Reciprocal Hit Rank (ARHR)
$$
\mathrm{ARHR}@N = \frac{1} {
    \left \vert U \right \vert
}
\sum_{i=1}^{hits} \frac{1}{
    pos_i
} \tag{9}
$$
其中，$pos_i$表示第i次命中时，测试物品在推荐列表中的位置。

#### NDCG

折扣累计收益 Discounted Cumulative Gain (DCG)
$$
\mathrm{DCG}@N = \frac{1}{
    \left \vert U \right \vert
} 
\sum_{u \in U} \sum_{i =1}^N 
\frac{
	g_{u,N_i}
}{
    \log_b (i + 1)
}
$$
归一化折扣累计收益 Normalized Discounted Cumulative Gain (NDCG)
$$
\begin{align}
\mathrm{NDCG}@N &= \frac{\mathrm{DCG}} {\mathrm{DCG}^*} \\\\
&= \frac{1} 
{
    \left \vert y^{test} \right \vert
}
\sum_{j \in y^{test}} \frac{ 
	\log (\hat r + 1)
}{
    \log ( pos_j + 1 )
}
\end{align} \tag{10}
$$
其中，$\hat r$表示在理想情况下，测试物品在TopN中的位置。

在使用留一法进行评估时，$\hat r = 1​$ 。

<!--

#### 信任度

度量推荐系统的信任度只能通过**问卷调查**的方式，询问用户是否信任推荐系统的推荐结果。

提高推荐系统的信任度主要有两种方法。

1.首先需要增加推荐系统的**透明度(transparency)**，而增加推荐系统透明度的主要办法是提供推荐解释。只有让用户了解推荐系统的运行机制，让用户认同推荐系统的运行机制，才会提高用户对推荐系统的信任度。

2.其次是考虑用户的社交网络信息，**利用用户的好友信息给用户做推荐**，并且用好友进行推荐解释。这是因为用户对他们的好友一般都比较信任，因此如果推荐的商品是好友购买过的，那么他们对推荐结果就会相对比较信任。

-->