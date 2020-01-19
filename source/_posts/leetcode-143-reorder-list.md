---
title: LeetCode 143.重排链表
date: 2020-01-19 23:41:11
tags: linked-list
categories: leetcode
---

给定一个单链表 L：L0→L1→…→Ln-1→Ln ，将其重新排列后变为： L0→Ln→L1→Ln-1→L2→Ln-2→…

你不能只是单纯的改变节点内部的值，而是需要实际的进行节点交换。

<!--more-->

**示例 1:**

```
给定链表 1->2->3->4, 重新排列为 1->4->2->3.
```

**示例 2:**

```
给定链表 1->2->3->4->5, 重新排列为 1->5->2->4->3.
```

### 思路

1. 首先，将单链表分割为前后两个部分；
2. 然后，使用头插法反转后半部分；
3. 最后，将后半部分节点依次插入到前半部分中。

### 方法一：快慢指针

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reorderList(self, head: ListNode) -> None:
        """
        Do not return anything, modify head in-place instead.
        """
        # 若单链表为空，或者仅有一个节点，或者仅有两个节点
        if not head or not head.next or not head.next.next:
            return

        # 将单链表分割为前后两个部分
        slow = fast = head       
        while fast.next and fast.next.next:
            slow = slow.next
            fast = fast.next.next
        mid = slow.next
        slow.next = None

        # 采用头插法，反转后半部分
        fast = None
        while mid:
            temp = mid.next

            mid.next = fast
            fast = mid

            mid = temp
        
        # 重排链表
        slow = head
        while slow and fast:
            temp1 = slow.next
            temp2 = fast.next

            fast.next = slow.next
            slow.next = fast

            slow = temp1       
            fast = temp2
```

