---
title: LeetCode 138.复制带随机指针的链表/《剑指Offer》35.复杂链表的复制
date: 2020-01-24 19:54:59
tags: linked-list
categories: leetcode
mathjax: true
---

给定一个链表，每个节点包含一个额外增加的随机指针，该指针可以指向链表中的任何节点或空节点。

要求返回这个链表的 深拷贝。 

<!--more-->

我们用一个由 n 个节点组成的链表来表示输入/输出中的链表。每个节点用一个 [val, random_index] 表示：

* val：一个表示 Node.val 的整数。
* random_index：随机指针指向的节点索引（范围从 0 到 n-1）；如果不指向任何节点，则为  null 。

**示例 1：**

![](/static/images/leetcode-138-example1.png)

```
输入：head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
输出：[[7,null],[13,0],[11,4],[10,2],[1,0]]
```

**示例 2：**

![](/static/images/leetcode-138-example2.png)

```
输入：head = [[1,1],[2,1]]
输出：[[1,1],[2,1]]
```

**示例 3：**

![](/static/images/leetcode-138-example3.png)

```
输入：head = [[3,null],[3,0],[3,null]]
输出：[[3,null],[3,0],[3,null]]
```

**示例 4：**

```
输入：head = []
输出：[]
解释：给定的链表为空（空指针），因此返回 null。
```

### 方法一：哈希表

时间复杂度：O(n)

空间复杂度：O(n)

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None, random: 'Node' = None):
        self.val = int(x)
        self.next = next
        self.random = random
"""
class Solution:
    def copyRandomList(self, head: 'Node') -> 'Node':
        if head is None:
            return None

        hash_table = {}
        node = head
        # 1.新建节点，并存储哈希表中
        while node:
            new_node = Node(node.val, None, None)
            hash_table[node] = new_node 
            node = node.next
        
        # 2.复制链表
        node = head
        while node:
            hash_table[node].next = hash_table.get(node.next)
            hash_table[node].random = hash_table.get(node.random)
            node = node.next
        return hash_table[head]
```

### 方法二：原地复制

步骤：

1.遍历原链表，依次复制每个节点，并将复制得到的新节点插入到原节点后面。

假如原链表为$A \rightarrow B \rightarrow C$，遍历结束后，得到的新链表为$A \rightarrow A^\prime \rightarrow B \rightarrow B^\prime \rightarrow C \rightarrow C^\prime$

2.复制random指针，例如$\mathrm{A^\prime.random = A.random.next}$；

3.遍历新链表，分离出原链表的深拷贝。

时间复杂度：O(n)

空间复杂度：O(1)

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None, random: 'Node' = None):
        self.val = int(x)
        self.next = next
        self.random = random
"""
class Solution:
    def copyRandomList(self, head: 'Node') -> 'Node':
        if head is None:
            return None

        # 1.复制节点
        cur = head
        while cur:
            node = Node(cur.val, None, None)
            node.next = cur.next
            cur.next = node
            cur = cur.next.next
        
        # 2.复制random指针
        cur = head
        while cur:
            if cur.random:
                cur.next.random = cur.random.next
            cur = cur.next.next

        # 3.分离链表
        cur = head
        root = tail = head.next
        while cur:
            cur.next = cur.next.next
            tail.next = tail.next.next if tail.next else None
            cur = cur.next
            tail = tail.next
        return root
```

