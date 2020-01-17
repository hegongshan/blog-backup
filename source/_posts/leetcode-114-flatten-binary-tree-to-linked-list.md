---
title: LeetCode 114.二叉树展开为链表
date: 2020-01-17 19:59:15
tags: linked-list
categories: leetcode
---

给定一个二叉树，原地将它展开为链表。

<!--more-->

例如，给定二叉树

        1
       / \
      2   5
     / \   \
    3   4   6
将其展开为：

```
1
 \
  2
   \
    3
     \
      4
       \
        5
         \
          6
```

### 题意

按照先序遍历的顺序，将给定的二叉树转变为“链表”，即除叶子节点外，其他所有节点均只有右孩子的二叉树。

### 方法一：栈

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def flatten(self, root: TreeNode) -> None:
        """
        Do not return anything, modify root in-place instead.
        """
        if not root:
            return

        stack = [root]
        # 链表中的尾节点
        tail = None
        while stack:
            node = stack.pop()
            if node.right:
                stack.append(node.right)
            if node.left:
                stack.append(node.left)
            
            node.left = None
            if not tail:
                root = tail = node
            else:
                tail.right = node
                tail = node
```

### 方法二：递归

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def flatten(self, root: TreeNode) -> None:
        """
        Do not return anything, modify root in-place instead.
        """
        if not root:
            return       
        self.flatten(root.left)
        self.flatten(root.right)
        
        pre = root.left
        if pre:
            # 寻找左子树中最右边的节点
            while pre.right:
                pre = pre.right
            pre.right = root.right
            root.right = root.left
            root.left = None
```

### 方法三：迭代

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def flatten(self, root: TreeNode) -> None:
        """
        Do not return anything, modify root in-place instead.
        """       
        while root:
            pre = root.left
            if pre:
                # 寻找左子树中最右边的节点
                while pre.right:
                    pre = pre.right
                pre.right = root.right
                root.right = root.left
                root.left = None
            root = root.right
```