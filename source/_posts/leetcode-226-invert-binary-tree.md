---
title: LeetCode 226.翻转二叉树
date: 2019-12-11 17:25:43
tags: binary-tree
categories: leetcode
---

翻转一棵二叉树。

<!--more-->

示例：

输入：

         4
       /   \
      2     7
     / \   / \
    1   3 6   9

输出：

```
     4
   /   \
  7     2
 / \   / \
9   6 3   1
```

### 方法一：递归

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def invertTree(self, root: TreeNode) -> TreeNode:
        if not root:
            return root
        node = root.left
        root.left = self.invertTree(root.right)
        root.right = self.invertTree(node)
        return root
```

### 方法二：迭代

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def invertTree(self, root: TreeNode) -> TreeNode:
        stack = [root]
        temp = None
        while stack:
            node = stack.pop()
            if node:
                temp = node.left
                node.left = node.right
                node.right = temp
                stack.append(node.left)
                stack.append(node.right)
        return root
```





