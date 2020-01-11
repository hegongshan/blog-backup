---
title: 《推荐系统实践》3.基于物品的协同过滤算法
date: 2019-03-13 11:31:32
tags: recommender systems
categories: recommender systems
mathjax: true
---

基于物品的协同过滤算法（item-based collaborative filtering，以下简称ItemCF）**算法思想**：给用户推荐那些和他们之前喜欢的物品相似的物品。

不过，ItemCF算法**并不利用物品的内容属性计算物品之间的相似度**，它主要**通过分析用户的行为记录计算物品之间的相似度**。该算法认为，物品A和物品B具有很大的相似度是因为喜欢物品A的用户大都也喜欢物品B。

基于物品的协同过滤算法可以**利用用户的历史行为给推荐结果提供推荐解释**，比如给用户推荐《天龙八部》的解释可以是因为用户之前喜欢《射雕英雄传》。 

ItemCF算法主要分为两步。
(1) 计算物品之间的相似度。
(2) 根据物品的相似度和用户的历史行为给用户生成推荐列表。

<!--more-->

### 计算物品相似度

可以用下面的公式定义物品的相似度:
$$
w_{ij} = \frac {|N(i) \cap N(j)|} {|N(i)|}
$$
这里，分母|N(i)|是喜欢物品i的用户数，而分子 $|N(i) \cap N(j)|​$ 是同时喜欢物品i和物品j的用户数。因此，上述公式可以理解为**喜欢物品i的用户中有多少比例的用户也喜欢物品j**。

如果物品j很热门，很多人都喜欢， 那么$w_{ij}​$就会很大，接近1。因此，该公式会造成任何物品都会和热门的物品有很大的相似度。为了避免推荐出热门的物品，可以用下面的公式:
$$
w_{ij} = \frac{|N(i) \cap N(j)|}{\sqrt{|N(i)||N(j)|}}
$$
这个公式惩罚了物品j的权重，因此减轻了热门物品会和很多物品相似的可能性。

计算物品相似度时可以首先建立**用户—物品倒排表**(即对每个用户建立一个包含他喜欢的物品的列表)，然后对于每个用户，将他物品列表中的物品两两在共现矩阵C中加1。

```python
import math
from collections import defaultdict

def item_similarity(self, trainset):
    # 物品相似度矩阵
    item_similarity_matrix = {}
    # 物品流行度
    item_popularity = {}

    for user, items in trainset.items():
        for item1 in items:
            # 构造物品相似度矩阵，计算物品共现次数
            item_similarity_matrix.setdefault(item1, defaultdict(int))
            for item2 in items:
                if item1 == item2:
                    continue
                    item_similarity_matrix[item1][item2] += 1

                    # 统计喜欢item1的用户数
                    if item1 not in item_popularity:
                        item_popularity[item1] = 0
                        item_popularity[item1] += 1

                        # 计算最终的相似度矩阵
                        for item1, releated_items in item_similarity_matrix.items():
                            for item2, count in releated_items.items():
                                self.item_similarity_matrix[item1][item2] = count / \
                                math.sqrt(item_popularity[item1] * item_popularity[item2])
return item_similarity_matrix
```

### 产生推荐列表

在得到物品之间的相似度后，ItemCF通过如下公式计算用户u对一个物品j的兴趣:
$$
Interestingness_{uj} = \sum_{i \in N(u) \cap S(j,K)} w_{ji}r_{ui}
$$
这里N(u)是用户喜欢的物品的集合，S(j,K)是和物品j最相似的K个物品的集合,$w_{ji}​$是物品j和i的相似度，$r_{ui}​$是用户u对物品i的兴趣(对于隐反馈数据集，如果用户u对物品i有过行为，即可令 $r_{ui}=1​$。)该公式的含义是，和用户历史上感兴趣的物品越相似的物品，越有可能在用户的推荐列表中获得比较高的排名。

### 关于物品相似度的一些改进

* 用户活跃度对物品相似度的影响

John S. Breese在论文“Empirical Analysis of Predictive Algorithms for Collaborative Filtering ”中提出了一个称为**IUF(Inverse User Frequence)**，即用户活跃度对数的倒数的参数，他认为**活跃用户对物品相似度的贡献应该小于不活跃的用户**，他提出应该增加IUF参数来修正物品相似度的计算公式：
$$
w_{ij} = \frac{\sum_{u \in N(i) \cap N(j)} \frac{1}{\log{(1+|N(u)|)}}}{\sqrt{|N(i)||N(j)|}}
$$
当然，上面的公式只是对活跃用户做了一种软性的惩罚，但对于很多过于活跃的用户，为了避免相似度矩阵过于稠密，我们在实际计算中一般直接忽略他的兴趣列表，而不将其纳入到相似度计算的数据集中。

* 物品相似度归一化

研究发现，如果将ItemCF的相似度矩阵按最大值归一化，可以提高推荐的准确率。如果已经得到了物品相似度矩阵w，那么可以用如下公式得到归一化之后的相似度矩阵w':
$$
w_{ij}^{'} = \frac{w_{ij}}{\max_j {w_{ij}}}
$$
归一化的好处不仅仅在于增加推荐的准确度，它还可以提高推荐的覆盖率和多样性。