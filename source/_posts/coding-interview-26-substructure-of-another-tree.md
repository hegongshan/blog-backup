---
title: 《剑指Offer》26.树的子结构/（相关）LeetCode 572.另一个树的子树
date: 2020-02-29 19:38:33
tags: binary-tree
categories: 剑指offer
---

输入两棵二叉树A，B，判断B是不是A的子结构。（ps：我们约定空树不是任意一个树的子结构）

<!--more-->

### 问题分析

首先，在A中寻找与B的根结点的值相等的结点C；

然后，判断树A中以C为根结点的子树是否包含和树B相同的子结构。

### 算法实现

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
    public boolean isSubStructure(TreeNode A, TreeNode B) {
        // 1.若树A或者树B为空，则B不是A的子结构
        if(A == null || B == null) {
            return false;
        }
        // 2.若以A为根结点的子树包含树B
        if(isSubStructure0(A, B)) {
            return true;
        }
        // 3.否则，继续在左右子树中搜索
        return isSubStructure(A.left, B) || isSubStructure(A.right, B);
    }

    public boolean isSubStructure0(TreeNode A, TreeNode B) {
        // 1.若树B已经遍历完
        if(B == null) {
            return true;
        }  
        // 2.若树B不为null，而树A为null，则表示以A为根结点的子树不包含树B
        if(A == null) {
            return false;
        }
        // 3.若二者根结点的值不相等
        if(A.val != B.val) {
            return false;
        }
        // 4.否则，依次比较A和B的左右子树
        return isSubStructure0(A.left, B.left) && isSubStructure0(A.right, B.right);
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。

### 相关题目：LeetCode 572.另一个树的子树

给定两个非空二叉树 s 和 t，检验 s 中是否包含和 t 具有相同结构和节点值的子树。s 的一个子树包括 s 的一个节点和这个节点的所有子孙。s 也可以看做它自身的一棵子树。

示例 1:
给定的树 s:

```
     3
    / \
   4   5
  / \
 1   2
```

给定的树 t：

```
   4 
  / \
 1   2
```

返回 **true**，因为 t 与 s 的一个子树拥有相同的结构和节点值。

**示例 2:**
给定的树 s：

```
     3
    / \
   4   5
  / \
 1   2
    /
   0
```

给定的树 t：

```
   4
  / \
 1   2
```

#### 问题分析

该问题与“判断树B是不是树A的子结构”十分类似，主要的区别在于：子结构可以在树中的任意处出现，可以在树的头部，也可以在树的中间，亦可能在树的尾部；而子树必须从树中的某一节点出发，一直延伸到叶子结点。

#### 算法实现

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
    public boolean isSubtree(TreeNode s, TreeNode t) {
        if(s == null && t == null) {
            return true;
        }
        if(s == null || t == null) {
            return false;
        }
        if(equals(s, t)) {
            return true;
        }
        return isSubtree(s.left, t) || isSubtree(s.right, t);
    }

    public boolean equals(TreeNode s, TreeNode t) {
        if(s == null && t == null) {
            return true;
        }
        if(s == null || t == null) {
            return false;
        }
        if(s.val != t.val) {
            return false;
        }
        return equals(s.left, t.left) && equals(s.right, t.right);
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。

