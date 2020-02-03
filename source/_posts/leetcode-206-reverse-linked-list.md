---
title: LeetCode 206./《剑指offer》15.反转链表
date: 2020-02-03 17:55:00
tags: linked-list
categories: leetcode
---

反转一个单链表。

<!--more-->

示例:

```
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
```

进阶:
你可以迭代或递归地反转链表。你能否用两种方法解决这道题？

### 方法一：迭代

思路：头插法。

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if head is None or head.next is None:
            return head
        cur = head
        pre = None
        while cur:
            temp = cur.next

            cur.next = pre
            pre = cur

            cur = temp
        return pre
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。其中，n为链表中结点的个数。

### 方法二：递归

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if head is None or head.next is None:
            return head
        pre = self.reverseList(head.next)
        head.next.next = head
        head.next = None
        return pre
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为链表中结点的个数。