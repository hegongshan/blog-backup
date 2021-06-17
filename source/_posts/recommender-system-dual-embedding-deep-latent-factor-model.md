---
title: 论文阅读 DELF&#58 A Dual-Embedding based Deep Latent Factor Model for Recommendation
date: 2020-06-08 22:59:34
tags: recommender systems
categories: recommender systems
mathjax: true
---

**D**ual-**E**mbedding based Deep **L**atent **F**actor Model（DELF）一文发表在IJCAI 2018上，作者使用ID和历史记录得到了4类Embedding向量（即User ID、User History、Item ID和Item History），然后将表示用户和物品的Embedding两两组合，分别喂进4个MLP中进行逐对交互。此外，作者采用了Attention机制来区分用户交互过的物品在用户表示中的重要性（对物品采用同样的操作）。

<!--more-->

### 研究动机

大部分现有的方法只使用用户和物品的ID进行Embedding，Embedding的质量存在正反馈不足和负反馈噪声的问题。

> However, all these methods represent each user or item with a single embedding which is learned progressively with the prepared training instances, and hence the quality of the embeddings still suffers from inadequate positive feedback or noisy negative feedback. 

### 模型结构

![DELF](/static/images/delf.png)

### 损失函数

作者使用了binary cross-entropy
$$
L_{log} = - \sum_{(u,i) \in \mathcal{R} \cup \mathcal{R}^-} R_{ui} \log(\hat R_{ui}) + (1 - R_{ui}) \log(1 - \hat R_{ui})
$$
其中，$\mathcal{R}$表示正样本，$\mathcal{R}^-$表示采样得到的负样本。

论文地址：https://www.ijcai.org/Proceedings/2018/0462.pdf