---
title: LeetCode 226.翻转二叉树/《剑指Offer》27.二叉树的镜像
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
    def invertTree(self, root: TreeNode) -> TreeNode:
        if not root:
            return root;
        stack = [root]
        while stack:
            node = stack.pop()

            temp = node.left
            node.left = node.right
            node.right = temp
            
            if node.left:
                stack.append(node.left)
            if node.right:
                stack.append(node.right)
        return root
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
    public TreeNode invertTree(TreeNode root) {
        if(root == null) {
            return root;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while(!queue.isEmpty()) {
            TreeNode node = queue.poll();

            TreeNode temp = node.left;
            node.left = node.right;
            node.right = temp;

            if(node.left != null) {
                queue.offer(node.left);
            }
            if(node.right != null) {
                queue.offer(node.right);
            }
        }
        return root;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。