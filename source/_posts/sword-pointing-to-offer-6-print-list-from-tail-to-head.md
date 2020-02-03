---
title: 《剑指offer》6.从尾到头打印链表
date: 2020-02-03 15:40:29
tags: linked-list
categories: 剑指offer
---

输入一个链表，按链表从尾到头的顺序返回一个ArrayList。

<!--more-->

### 方法一：迭代

思路：遍历链表，将当前节点的值加入到列表中。遍历结束后，翻转该列表。

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        result = []
        node = listNode
        while node:
            result.append(node.val)
            node = node.next
        return result[::-1]
```

### 方法二：递归

```python
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        result = []
        self.__printList(listNode, result)
        return result
        
    def __printList(self, listNode, result):
        if listNode is None:
            return
        self.__printList(listNode.next, result)
        result.append(listNode.val)    
```

