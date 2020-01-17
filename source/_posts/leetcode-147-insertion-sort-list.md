---
title: LeetCode 147.对链表进行插入排序
date: 2020-01-11 23:26:17
tags: linked-list
categories: leetcode
---

对链表进行插入排序。

<!--more-->

![插入排序](https://upload.wikimedia.org/wikipedia/commons/0/0f/Insertion-sort-example-300px.gif)

插入排序的动画演示如上。从第一个元素开始，该链表可以被认为已经部分排序（用黑色表示）。
每次迭代时，从输入数据中移除一个元素（用红色表示），并原地将其插入到已排好序的链表中。

 插入排序算法：

1. 插入排序是迭代的，每次只移动一个元素，直到所有元素可以形成一个有序的输出列表。
2. 每次迭代中，插入排序只从输入数据中移除一个待排序的元素，找到它在序列中适当的位置，并将其插入。
3. 重复直到所有输入数据插入完为止。

示例 1：

```
输入: 4->2->1->3
输出: 1->2->3->4
```

示例 2：

```
输入: -1->5->3->4->0
输出: -1->0->3->4->5
```

### 解法一：带头结点

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def insertionSortList(self, head: ListNode) -> ListNode:
      	# 若链表为空或只有一个结点
        if not head or not head.next:
            return head

        cur = head.next
        root = ListNode(-1)
        root.next = head
        head.next = None

        while cur:
            pre = root
            node = root.next
            # 存储下一个结点
            temp = cur.next

            # 寻找插入的位置
            while node and node.val < cur.val:
                pre = node
                node = node.next           
            cur.next = node
            pre.next = cur

            cur = temp
        return root.next
```

### 解法二：带头结点和尾结点

解法一可能会遇到：当前结点的值大于有序区中的最大值。

此时，为了寻找该结点的插入位置，解法一将遍历有序区中的所有结点。

针对这种情况，可以考虑为有序区添加尾结点。

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:

    def insertionSortList(self, head: ListNode) -> ListNode:
      	# 若链表为空或只有一个结点	
        if not head or not head.next:
            return head

        cur = head.next
        root = ListNode(-1)
        root.next = tail = head
        tail.next = None

        while cur:
            pre = root
            node = root.next    
            # 存储下一个结点
            temp = cur.next

            # 若当前结点的值大于有序区最后一个结点的值
            if tail.val < cur.val:
                cur.next = None
                tail.next = cur
                tail = cur
            else:
              	# 寻找插入的位置	
                while node and node.val < cur.val:
                    pre= node
                    node = node.next           
                cur.next = node
                pre.next = cur

            cur = temp
        return root.next
```



