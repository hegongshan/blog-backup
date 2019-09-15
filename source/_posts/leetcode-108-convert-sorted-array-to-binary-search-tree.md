---
title: LeetCode 108.将有序数组转换为二叉搜索树
date: 2019-05-20 17:35:46
tags: binary-tree
categories: leetcode
---

将一个按照升序排列的有序数组，转换为一棵高度平衡二叉搜索树。

本题中，一个高度平衡二叉树是指一个二叉树*每个节点* 的左右两个子树的高度差的绝对值不超过 1。

<!--more-->

**示例:**

```
给定有序数组: [-10,-3,0,5,9],

一个可能的答案是：[0,-3,9,-10,null,5]，它可以表示下面这个高度平衡二叉搜索树：

      0
     / \
   -3   9
   /   /
 -10  5
```

### 解决方案

#### 方法一：直接构造AVL树

参看[LeetCode 109.有序链表转换二叉搜索树](/2019/05/20/leetcode-109-convert-sorted-list-to-binary-search-tree/)

#### 方法二：递归

* 思路：以数组的中间元素为界，将数组一分为二。然后对这两个部分递归执行该过程。

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
    
    public TreeNode sortedArrayToBST(int[] nums) {
        if(nums == null || nums.length == 0) {
            return null;
        }
        return createAVL(nums, 0, nums.length-1);
    }
    
    public TreeNode createAVL(int[] nums, int low, int high) {
        if(low > high) {
            return null;
        }
        int mid = (low + high) / 2;
        TreeNode root = new TreeNode(nums[mid]);
        root.left = createAVL(nums, low, mid-1);
        root.right = createAVL(nums, mid+1, high);
        return root;
    }
}
```

