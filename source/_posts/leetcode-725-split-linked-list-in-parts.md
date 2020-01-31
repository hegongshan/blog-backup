---
title: LeetCode 725.分隔链表
date: 2020-01-26 22:10:42
tags: linked-list
categories: leetcode
mathjax: true
---

给定一个头结点为 root 的链表, 编写一个函数以将链表分隔为 k 个连续的部分。

每部分的长度应该尽可能的相等: 任意两部分的长度差距不能超过 1，也就是说可能有些部分为 null。

这k个部分应该按照在链表中出现的顺序进行输出，并且排在前面的部分的长度应该大于或等于后面的长度。

返回一个符合上述规则的链表的列表。

<!--more-->

举例： 1->2->3->4, k = 5, 结果 [ [1], [2], [3], [4], null ]

**示例 1：**

```
输入: 
root = [1, 2, 3], k = 5
输出: [[1],[2],[3],[],[]]
解释:
输入输出各部分都应该是链表，而不是数组。
例如, 输入的结点 root 的 val= 1, root.next.val = 2, root.next.next.val = 3, 且 root.next.next.next = null。
第一个输出 output[0] 是 output[0].val = 1, output[0].next = null。
最后一个元素 output[4] 为 null, 它代表了最后一个部分为空链表。
```

**示例 2：**

```
输入: 
root = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], k = 3
输出: [[1, 2, 3, 4], [5, 6, 7], [8, 9, 10]]
解释:
输入被分成了几个连续的部分，并且每部分的长度相差不超过1.前面部分的长度大于等于后面部分的长度。
```

**提示:**

- `root` 的长度范围： `[0, 1000]`.
- 输入的每个节点的大小范围：`[0, 999]`.
- `k` 的取值范围： `[1, 50]`.

### 方法

步骤：

1.统计原链表的长度n；

2.计算分隔后每个部分的长度$\mathrm{length_i}（0 \le i < k）$，令$r = n\ \%\ k$
$$
\mathrm{length_i = 
  \begin{cases}
  	\frac{n}{k} + 1, & 0 \le i < r \\\\
  	\frac{n}{k}, & r \le i < k
  \end{cases}
}
$$
3.分隔链表。

分隔链表可以采用以下两种方式：

* 遍历链表，将链表分隔为k个部分。如果k>n，则在返回的列表末尾补k-n个空链表；

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def splitListToParts(self, root: ListNode, k: int) -> List[ListNode]:
        if k == 1:
            return [root]

        # 1.统计原链表的长度
        n = 0
        node = root
        while node:
            node = node.next
            n += 1
        
        # 2.计算分隔后每个部分的长度
        length = n // k
        r = n % k
        
        # 3.分隔链表
        parts = []
        count = 0 # 第几部分
        part_length = 0
        node = head = root
        while node:
            part_length += 1

            temp = node.next
            if part_length == length + (count < r):
                node.next = None
                parts.append(head)

                head = temp
                count += 1
                part_length = 0
            node = temp
        
        # 4.若n < k，则在末尾补k - n个空链表
        if n < k:
            parts.extend([None] * (k - n))
        return parts
```

* 循环K次，每次分隔出一部分。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def splitListToParts(self, root: ListNode, k: int) -> List[ListNode]:
        if k == 1:
            return [root]

        # 1.统计原链表的长度
        n = 0
        node = root
        while node:
            node = node.next
            n += 1
        
        # 2.计算分隔后每个部分的长度
        length = n // k
        r = n % k
        
        # 3.分隔链表
        parts = []
        node = root
        for i in range(k):
            head = node
            for j in range(length + (i < r) - 1):
                if node:
                    node = node.next
            if node:
                temp = node.next
                node.next = None   
                node = temp
            parts.append(head)
        return parts
```

时间复杂度：O(n + k)

空间复杂度：O(k)