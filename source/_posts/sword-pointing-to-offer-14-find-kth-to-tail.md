---
title: 《剑指offer》14.链表中倒数第k个结点
date: 2020-02-03 17:01:45
tags: linked-list
categories: 剑指offer
commment: false
---

输入一个链表，输出该链表中倒数第k个结点。

<!--more-->

### 方法一：使用数组

思路：设n为链表中结点的个数。

遍历链表，将当前结点存入数组ls中。遍历结束后，若数组ls不为空，且给定的k值合法（1<=k<=n），则返回数组ls的第n-k-1个元素；否则，返回空。

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindKthToTail(self, head, k):
        ls = []
        node = head
        while node:
            ls.append(node)
            node = node.next
        if ls and 1 <= k <= len(ls):
            return ls[-k]
        return None
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。

### 方法二：快慢指针

思路：设n为链表中结点的个数。

首先，设置两个指针slow和fast，均指向链表的第一个结点。

然后，让fast先走k步，指向链表中第k+1个结点。

若fast无法走完k步，则表示链表为空或者k不合法（k < 1或者k > n）。此时，直接返回空。

最后，同时遍历slow和fast，当fast为空时，slow指向的结点即为倒数第k个结点。

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindKthToTail(self, head, k):
        slow = fast = head
        for i in range(k):
            if fast is None:
                return None
            fast = fast.next
        while fast:
            slow = slow.next
            fast = fast.next
        return slow
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

