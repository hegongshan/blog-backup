---
title: 《剑指Offer》33.二叉搜索树的后序遍历序列
date: 2020-03-04 17:30:42
tags: binary-tree
categories: 剑指offer
---

输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历结果。如果是则返回 `true`，否则返回 `false`。假设输入的数组的任意两个数字都互不相同。

<!--more-->

### 问题分析

在二叉搜索树的后序遍历序列中，最后一个数字是根结点的值，序列中前面的数字可以分为两个部分：

1.前半部分为左子树节点的值，它们均小于根节点的值；

2.后半部分为右子树节点的值，它们均大于根结点的值。

如果数组不满足上述性质，那么它不是二叉搜索树的后序遍历结果。

### 方法一：递归

```java
class Solution {
    public boolean verifyPostorder(int[] postorder) {
        if (postorder == null || postorder.length <= 2) {
            return true;
        }
        return verifyPostorder(postorder, 0, postorder.length - 1);
    }

    public boolean verifyPostorder(int[] postorder, int start, int end) {
        if (start >= end) {
            return true;
        }
        // 左子树
        int i=start;
        while (i < end && postorder[i] < postorder[end]) {
            i++;
        }
        // 右子树
        for (int j = i; j < end; j++) {
            if(postorder[j] < postorder[end]) {
                return false;
            }
        }
        return verifyPostorder(postorder, start, i - 1) && verifyPostorder(postorder, i, end - 1);
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(log n)。其中，n为数组的长度。

### 方法二：递归

```java
class Solution {
    public boolean verifyPostorder(int[] postorder) {
        if (postorder == null || postorder.length <= 2) {
            return true;
        }
        for (int idx = postorder.length - 1; idx >= 0; idx--) {
            int i = 0;
            while (i < idx && postorder[i] < postorder[idx]) {
                i++;
            }
            while (i < idx && postorder[i] > postorder[idx]) {
                i++;
            }
            if (i < idx) {
                return false;
            }           
        }
        return true;
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(1)。其中，n为数组的长度。