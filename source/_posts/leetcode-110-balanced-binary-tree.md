---
title: LeetCode 110.平衡二叉树
date: 2019-05-20 14:11:04
tags: binary-tree
categories: leetcode
mathjax: true
---

给定一个二叉树，判断它是否是高度平衡的二叉树。

本题中，一棵高度平衡二叉树定义为：

> 一个二叉树*每个节点* 的左右两个子树的高度差的绝对值不超过1。

<!--more-->

**示例 1:**

给定二叉树 `[3,9,20,null,null,15,7]`

```
    3
   / \
  9  20
    /  \
   15   7
```

返回 `true` 。

**示例 2:**

给定二叉树 `[1,2,2,3,3,null,null,4,4]`

```
       1
      / \
     2   2
    / \
   3   3
  / \
 4   4
```

返回 `false` 。

### 解决方案

本题可以采用递归法，递归表达式如下所示：
$$
isBalanced(root)=
\begin{cases}
true, & root为空 \\\\
isBalanced(root.left) \cap isBalanced(root.right), & root节点是平衡的 \\\\
\end{cases}
$$

```java
/*
 public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }
 */
class Solution {
    public boolean isBalanced(TreeNode root) {
        if(root == null) {
            return true;
        }
        if(Math.abs(getHeight(root.left) - getHeight(root.right)) <= 1) {
            return isBalanced(root.left) && isBalanced(root.right);
        } 
        return false;
    }
    //求树的高度
    public int getHeight(TreeNode root) {
        if(root == null) {
            return 0;
        }
        return Math.max(getHeight(root.left), getHeight(root.right)) + 1;   
    }
}
```



