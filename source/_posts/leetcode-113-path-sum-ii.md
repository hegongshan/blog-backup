---
title: LeetCode 113.路径总和 II
date: 2020-04-08 22:34:05
tags: binary-tree
categories: leetcode
---

> 晚上面腾讯的时候，面试官给我出了6道编程题，本题为6道题的最后一道。

给定一个二叉树和一个目标和，找到所有从根节点到叶子节点路径总和等于给定目标和的路径。

<!--more-->

**说明:** 叶子节点是指没有子节点的节点。

**示例:**
给定如下二叉树，以及目标和 sum = 22，

```
              5
             / \
            4   8
           /   / \
          11  13  4
         /  \    / \
        7    2  5   1
```

返回:

```
[
   [5,4,11,2],
   [5,8,4,5]
]
```

### 方法一：回溯

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
    public List<List<Integer>> pathSum(TreeNode root, int sum) {
        List<List<Integer>> result = new ArrayList<>();
        pathSum(root, sum, 0, new ArrayList<>(), result);
        return result;
    }

    public void pathSum(TreeNode root, int target, int currentSum, List<Integer> list, List<List<Integer>> result) {
        if (root == null) {
            return ;
        }
        currentSum += root.val;
        list.add(root.val);

        // 若为叶子结点
        if (root.left == null && root.right == null) {
            if (currentSum == target) {
                result.add(new ArrayList(list));
            }
        } else {
            // 继续对左右子树执行递归操作
            pathSum(root.left, target, currentSum, list, result);
            pathSum(root.right, target, currentSum, list, result);
        }
        // 回溯
        list.remove(list.size() - 1);
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(log n)。其中，n为二叉树中节点的个数。