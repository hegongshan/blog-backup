---
title: 机器学习之Apriori算法
date: 2018-08-23 18:58:22
tags: 关联分析
categories: 机器学习
updated: 2018-08-23 21:38:20
mathjax: true
---

支持度(support)：数据集中包含该项集的记录所占的比例。

可信度或置信度（confidence）：

$A \rightarrow B$的置信度为
$$
confidence（A\rightarrow B） = \frac{support(A , B)}{support(A)}
$$
Apriori原理：如果一个项集是非频繁的，那么它的所有超集也是非频繁的。

<blockquote class="blockquote-center">
    If an itemset is not frequent, any of its superset is never frequent.     
</blockquote>

Apriori算法

1.从大小为k的频繁项集中生成大小为k+1的候选频繁项集$C_{k+1}$

2.扫描数据库，计算每一个候选频繁项集的支持度

3.将满足最小支持度的频繁项集加到$F_{k+1}$中
$$
\begin{align}
\hline 
& 算法\ Apriori \\\\
\hline \\\\
& F_1 = (大小为1的频繁项集); \\\\
& for(k = 1; F_k \neq \varnothing; k++)\ do\ begin \\\\
& \qquad C_{k+1} = apriori-gen(F_k);//新的候选频繁集 \\\\
& \qquad for\ 所有的交易记录t \in 数据集\ do\ begin \\\\
& \qquad \qquad C_{t}^{'}= subset(C_{k+1},t);\ //包含在t中的候选集 \\\\
& \qquad \qquad for\ 所有的候选c \in C_{t}^{'}\ do \\\\
& \qquad \qquad \qquad c.count ++; \\\\
& \qquad \qquad end \\\\
& \qquad \qquad F_{k+1} = \\{C \in C_{k+1} |\ c.count \geq 最小的支持度 \\} \\\\
& \qquad end \\\\
& end \\\\
& Answer \cup_{k} F_k;
\end{align}
$$
算法第三行中的apriori-gen函数经过下面两步，从$F_k$生成$C_{k+1}$

1.连接

通过合并两个大小为k，且前$k-1$项相同的频繁项集$P_k$和$Q_k$，生成大小为k+1的频繁项集$R_{k+1}$
$$
\begin{align}
& R_{k+1} = P_{k} \cup Q_{k} = \\{items_{1},\dots ,items_{k-1},items_{k},items_{k^{'}}\\} \\\\
& P_{k} = \\{items_{1},\dots ,items_{k-1},items_{k}\\} \\\\
& Q_{k} = \\{items_{1},\dots ,items_{k-1},items_{k^{'}}\\}
\end{align}
$$
其中，$items_1 < \dots < items_k < items_{k^{'}}$

2.剪枝

检查$R_{k+1}$中的所有大小为的项集中的所有大小为的项集是不是频繁的，删除中的所有大小为的项集中的所有大小为k的项集是不是频繁的，删除$R_{k+1}$中那些非频繁的项集，从而得到中那些非频繁的项集，从而得到$C_{k+1}$。因为$C_{k+1}$中大小为且非频繁的所有子集不是大小为中大小为k且非频繁的所有子集不是大小为k+1的频繁项集的子集。

示例：

假设最小支持度为2

数据库D

| TID  |             Items              |
| :--: | :----------------------------: |
| 100  |      $1 \quad 3 \quad 4$       |
| 200  |      $2 \quad 3 \quad 5$       |
| 300  | $1 \quad 2  \quad  3 \quad  5$ |
| 400  |          $2 \quad 5$           |

$C_1$

|      |      |
| :--: | :--: |
| {1}  |  2   |
| {2}  |  3   |
| {3}  |  3   |
| {4}  |  1   |
| {5}  |  3   |

$F_1$

| 项集 | 支持度 |
| :--: | :----: |
| {1}  |   2    |
| {2}  |   3    |
| {3}  |   3    |
| {5}  |   3    |

$C_2$

|   项集   | 支持度 |
| :------: | :----: |
| { 1, 2 } |   1    |
| { 1, 3 } |   2    |
| { 1, 5 } |   1    |
| { 2, 3 } |   2    |
| { 2, 5 } |   3    |
| { 3, 5 } |   2    |

$F_2$

|   项集   | 支持度 |
| :------: | :----: |
| { 1, 3 } |   2    |
| { 2, 3 } |   2    |
| { 2, 5 } |   3    |
| { 3, 5 } |   2    |

$C_3$

|     项集      | 支持度 |
| :-----------: | :----: |
| { 1 , 2 , 3 } |   1    |
| { 1 , 2 , 5 } |   1    |
| { 1 , 3 , 5 } |   1    |
| { 2 , 3 , 5 } |   2    |

$F_3$

|     项集      | 支持度 |
| :-----------: | :----: |
| { 2 , 3 , 5 } |   2    |

