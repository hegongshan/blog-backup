---
title: LeetCode 1290.二进制链表转整数
date: 2020-01-07 23:34:31
tags: linked-list
categories: leetcode
mathjax: true
---

给你一个单链表的引用结点 head。链表中每个结点的值不是 0 就是 1。已知此链表是一个整数数字的二进制表示形式。请你返回该链表所表示数字的**十进制值** 。

 <!--more-->

示例 1：

```
1->0->1
输入：head = [1,0,1]
输出：5
解释：二进制数 (101) 转化为十进制数 (5)
```

示例 2：

```
输入：head = [0]
输出：0
```

示例 3：

```
输入：head = [1]
输出：1
```

示例 4：

```
输入：head = [1,0,0,1,0,0,1,1,1,0,0,0,0,0,0]
输出：18880
```

示例 5：

```
输入：head = [0,0]
输出：0
```


提示：

* 链表不为空。

* 链表的结点总数不超过 30。
* 每个结点的值不是 0 就是 1。

### 方法：一次迭代

假定单链表中存储的二进制数字为$x_1 x_2 \cdots x_n$，其十进制值为
$$
\begin{align}
\mathrm{data} 
&= x_1 \times 2^{n-1} + x_2 \times 2^{n-2} + \cdots + x_{n-1} \times 2 + x_n \\\\
&= 2 \times (x_1 \times 2 ^{n-2} + x_2 \times 2^{n-3} + \cdots + x_{n-1}) + x_n\\\\
&\cdots \\\\
&= 2 \times ( \cdots 2 \times (2 \times x_1 + x_2) + x_3 \cdots ) + x_n
\end{align}
$$
因此：

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getDecimalValue(self, head: ListNode) -> int:
        data = 0
        while head:
            data = 2 * data + head.val
            head = head.next
        return data
```

