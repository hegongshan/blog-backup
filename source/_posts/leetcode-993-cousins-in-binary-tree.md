---
title: LeetCode 993.二叉树的堂兄弟节点
date: 2020-01-31 22:53:13
tags: binary-tree
categories: leetcode
---

在二叉树中，根节点位于深度 0 处，每个深度为 k 的节点的子节点位于深度 k+1 处。

如果二叉树的两个节点深度相同，但父节点不同，则它们是一对堂兄弟节点。

我们给出了具有唯一值的二叉树的根节点 root，以及树中两个不同节点的值 x 和 y。

只有与值 x 和 y 对应的节点是堂兄弟节点时，才返回 true。否则，返回 false。

<!--more-->

**示例 1：**

```
       1
      / \
     2   3
    /
   4
输入：root = [1,2,3,4], x = 4, y = 3
输出：false
```

**示例 2：**

```
       1
      / \
     2   3
      \   \
       4   5
输入：root = [1,2,3,null,4,null,5], x = 5, y = 4
输出：true
```

**示例 3：**

```
       1
      / \
     2   3
      \     
       4
输入：root = [1,2,3,null,4], x = 2, y = 3
输出：false
```

**提示：**

1. 二叉树的节点数介于 `2` 到 `100` 之间。
2. 每个节点的值都是唯一的、范围为 `1` 到 `100` 的整数。

### 方法一：递归

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isCousins(self, root: TreeNode, x: int, y: int) -> bool:
        if self.getDepth(root,x) == self.getDepth(root,y) and not self.isBrother(root,x,y):
            return True
        return False

    def getDepth(self, root: TreeNode, x: int) -> int:
        if root is None:
            return None
        if root.val == x:
            return 0
        # 若位于左子树中
        left = self.getDepth(root.left, x)
        if left is not None:
            return left + 1
        # 若位于右子树中
        right = self.getDepth(root.right, x)
        if right is not None:
            return right + 1
        return None

    def isBrother(self, root: TreeNode, x: int, y: int) -> bool:
        if root is None:
            return False
        if root.left and root.right:
            if root.left.val == x and root.right.val == y:
                return True
            if root.left.val == y and root.right.val == x:
                return True
        return self.isBrother(root.left, x, y) or self.isBrother(root.right, x, y)
```

时间复杂度：O(n)，n为二叉树中节点的个数。

空间复杂度：O(n)