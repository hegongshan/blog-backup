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

### 方法一：自顶向下递归

递归表达式如下所示：
$$
isBalanced(root)=
\begin{cases}
true, & \mathrm{如果root为null} \\\\
isBalanced(root.left) \land isBalanced(root.right), & \mathrm{如果root节点是平衡的} \\\\
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
        if (root == null) {
            return true;
        }
        if (Math.abs(getHeight(root.left) - getHeight(root.right)) <= 1) {
            return isBalanced(root.left) && isBalanced(root.right);
        } 
        return false;
    }
    //求树的高度
    public int getHeight(TreeNode root) {
        if (root == null) {
            return 0;
        }
        return Math.max(getHeight(root.left), getHeight(root.right)) + 1;   
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(n)。其中，n为二叉树中节点的个数。

### 方法二：自底向上递归

思路：方法一从根节点出发，逐一判断当前节点是否平衡，从而导致每次判断都需要计算左右子树的高度。

如果从叶子节点开始，在递归的同时，就可以将每个节点的高度记录下来，从而避免了方法一中的重复计算。

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
import java.util.AbstractMap.SimpleEntry;

class Solution {
    public boolean isBalanced(TreeNode root) {
        return isBalanced0(root).getValue();       
    }

    // key为当前节点的高度，value表示以当前节点为根结点的子树是否为平衡二叉树
    private SimpleEntry<Integer, Boolean> isBalanced0(TreeNode root) {
        if (root == null) {
            return new SimpleEntry<Integer, Boolean>(0, true);
        }
        SimpleEntry<Integer, Boolean> left = isBalanced0(root.left);
        SimpleEntry<Integer, Boolean> right = isBalanced0(root.right);
        int height = left.getKey() - right.getKey();

        // 如果左右子树均为平衡二叉树，且以当前节点为根结点的子树也是平衡二叉树
        if (left.getValue() && right.getValue() && Math.abs(height) <= 1) {
            return new SimpleEntry<Integer, Boolean>(Math.max(left.getKey(), right.getKey()) + 1, true);
        }
        return new SimpleEntry<Integer, Boolean>(Math.max(left.getKey(), right.getKey()) + 1, false);
    }
}

```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中节点的个数。