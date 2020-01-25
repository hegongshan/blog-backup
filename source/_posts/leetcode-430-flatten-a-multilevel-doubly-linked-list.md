---
title: LeetCode 430.扁平化多级双向链表
date: 2020-01-25 21:46:55
tags: linked-list
categories: leetcode
---

您将获得一个双向链表，除了下一个和前一个指针之外，它还有一个子指针，可能指向单独的双向链表。这些子列表可能有一个或多个自己的子项，依此类推，生成多级数据结构，如下面的示例所示。

扁平化列表，使所有结点出现在单级双链表中。您将获得列表第一级的头部。

<!--more-->

**示例:**

```
输入:
 1---2---3---4---5---6--NULL
         |
         7---8---9---10--NULL
             |
             11--12--NULL

输出:
1-2-3-7-8-11-12-9-10-4-5-6-NULL
```

**以上示例的说明:**

给出以下多级双向链表:

![](/static/images/leetcode-430-multilevellinkedlist.png)

我们应该返回如下所示的扁平双向链表:

![](/static/images/leetcode-430-multilevellinkedlistflattened.png)

### 方法一：递归

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val, prev, next, child):
        self.val = val
        self.prev = prev
        self.next = next
        self.child = child
"""
class Solution:
    def flatten(self, head: 'Node') -> 'Node':
        node = head
        while node:
            temp = node.next
            if node.child:
                child_head = self.flatten(node.child)
                # 寻找子链表的尾节点
                child_tail = child_head
                while child_tail and child_tail.next:
                    child_tail = child_tail.next

                node.next = child_head
                child_head.prev = node
                child_tail.next = temp
                if temp:
                    temp.prev = child_tail
                
                node.child = None
            node = temp
        return head
```

为了寻找子链表的尾节点，上述方法需要重复遍历子链表。为了解决该问题，递归时可以直接返回尾节点：

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val, prev, next, child):
        self.val = val
        self.prev = prev
        self.next = next
        self.child = child
"""
class Solution:
    def flatten(self, head: 'Node') -> 'Node':
        self.flatten_dfs(head)
        return head
    
    def flatten_dfs(self, head: 'Node') -> 'Node':
        '''
        将双链表拉平，并返回新链表的尾节点
        '''
        pre = node = head
        while node:
            temp = node.next
            if node.child:
                child_head = node.child
                child_tail = self.flatten_dfs(child_head)

                node.next = child_head
                child_head.prev = node
                child_tail.next = temp
                if temp:
                    temp.prev = child_tail
                
                node.child = None
                pre = child_tail
            else:
                pre = node
            node = temp
        return pre
```

该方法的时间复杂度：O(n)，空间复杂度：O(n)。

### 方法二：迭代

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val, prev, next, child):
        self.val = val
        self.prev = prev
        self.next = next
        self.child = child
"""
class Solution:
    def flatten(self, head: 'Node') -> 'Node':
        if head is None:
            return head

        stack = [head]
        pre = None
        while stack:
            node = stack.pop()
            if node.next:
                stack.append(node.next)
            if node.child:
                stack.append(node.child)
                node.child = None
            
            if pre:
                node.prev = pre
                pre.next = node
            pre = node       
        return head  
```

该方法的时间复杂度：O(n)，空间复杂度：O(n)。