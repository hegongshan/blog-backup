---
title: LeetCode 101./《剑指Offer》28.对称二叉树
date: 2019-12-06 13:44:42
tags: binary-tree
categories: leetcode
---

给定一个二叉树，检查它是否是镜像对称的。

<!--more-->

例如，二叉树 [1,2,2,3,4,4,3] 是对称的。

        1
       / \
      2   2
     / \ / \
    3  4 4  3

但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:

        1
       / \
      2   2
       \   \
       3    3
**说明:**

如果你可以运用递归和迭代两种方法解决这个问题，会很加分。

### 方法一：递归

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSymmetric(self, root: TreeNode) -> bool:
        if not root:
            return True
        return self.isSymmetric2(root.left, root.right)
    
    def isSymmetric2(self, node1: TreeNode, node2: TreeNode) -> bool:
        if not node1 and not node2:
            return True
        if not node1 or not node2:
            return False
        if node1.val != node2.val:
            return False
        return self.isSymmetric2(node1.left, node2.right) and self.isSymmetric2(node1.right, node2.left)
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。

### 方法二：迭代（深度优先）

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSymmetric(self, root: TreeNode) -> bool:
        if not root:
            return True
        stack = [root.left, root.right]
        while stack:
            node1 = stack.pop()
            node2 = stack.pop()
            if not node1 and not node2:
                continue
            if not node1 or not node2:
                return False
            if node1.val != node2.val:
                return False
            stack.append(node1.left)
            stack.append(node2.right)
            stack.append(node1.right)
            stack.append(node2.left)
        return True
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。

### 方法三：迭代（广度优先）

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public boolean isSymmetric(TreeNode root) {
        if(root == null) {
            return true;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root.left);
        queue.add(root.right);

        while(!queue.isEmpty()) {
            TreeNode node1 = queue.poll();
            TreeNode node2 = queue.poll();
            if(node1 == null && node2 == null) {
                continue;
            }
            if(node1 == null || node2 == null) {
                return false;
            }
            if(node1.val != node2.val) {
                return false;
            }
            queue.offer(node1.left);
            queue.offer(node2.right);
            queue.offer(node1.right);
            queue.offer(node2.left);           
        }
        return true;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。