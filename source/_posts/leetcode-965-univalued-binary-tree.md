---
title: LeetCode 965.单值二叉树
date: 2019-12-17 20:03:12
tags: binary-tree
categories: leetcode
---

如果二叉树每个节点都具有相同的值，那么该二叉树就是*单值*二叉树。只有给定的树是单值二叉树时，才返回 `true`；否则返回 `false`。

<!--more-->

**示例 1：**

```
    1
   / \
  1   1
 / \   \
1   1   1
输入：[1,1,1,1,1,null,1]
输出：true
```

**示例 2：**

```
    2
   / \
  2   2
 / \
5   2	
输入：[2,2,2,5,2]
输出：false
```

**提示：**

1. 给定树的节点数范围是 `[1, 100]`。
2. 每个节点的值都是整数，范围为 `[0, 99]` 。

### 方法一：递归

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:

    def isUnivalTree(self, root: TreeNode) -> bool:
        if not root:
            return True
        if root.left and root.left.val != root.val:
            return False
        if root.right and root.right.val != root.val:
            return False
        return self.isUnivalTree(root.left) and self.isUnivalTree(root.right)
```

时间复杂度为O(N)，空间复杂度为O(H)。其中，N为二叉树的节点个数，H为二叉树的高度。

### 方法二：迭代

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:

    def isUnivalTree(self, root: TreeNode) -> bool:
        stack = [root]
        while stack:
            node = stack.pop()
            if not node:
                continue
            if node.left and node.left.val != node.val:
                return False
            if node.right and node.right.val != node.val:
                return False 
            stack.append(node.left)
            stack.append(node.right)
        return True
```

时间复杂度为O(N)，空间复杂度为O(1)。其中，N为二叉树的节点个数。