---
title: LeetCode 104.二叉树的最大深度/《剑指Offer》55-I.二叉树的深度
date: 2020-03-21 18:35:55
tags: binary tree
categories: leetcode
---

给定一个二叉树，找出其最大深度。

二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。

**说明:** 叶子节点是指没有子节点的节点。

<!--more-->

**示例：**
给定二叉树 `[3,9,20,null,null,15,7]`，

```
    3
   / \
  9  20
    /  \
   15   7
```

返回它的最大深度 3 。

### 方法一：递归（DFS）

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
    public int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }
        // return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
        int left = maxDepth(root.left);
        int right = maxDepth(root.right);
        return 1 + Math.max(left, right);
    }
}
```

复杂度分析：

* 时间复杂度为O(n)；
* 最好的空间复杂度为O(log n)，最坏的空间复杂度为O(n)。

### 方法二：迭代（DFS）

思路：令depth表示二叉树的深度。

对二叉树执行后序遍历，遍历的同时，将depth与当前节点所在的层数h（=父结点所在的层数+1）进行比较，新的depth = max(depth, h)。

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
    public int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int depth = 0;
        Stack<SimpleEntry<TreeNode, Integer>> stack = new Stack<>();
        stack.push(new SimpleEntry<>(root, 1));
        while (!stack.empty()) {
            SimpleEntry<TreeNode, Integer> entry = stack.pop();
            TreeNode node = entry.getKey();
            int h = entry.getValue();
            depth = Math.max(depth, h);
            if (node.right != null) {
                stack.push(new SimpleEntry<>(node.right, h + 1));
            }
            if (node.left != null) {
                stack.push(new SimpleEntry<>(node.left, h + 1));
            }
        }
        return depth;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中结点的个数。

### 方法三：层次遍历（BFS）

思路：参考[《剑指Offer》32-II.从上到下打印二叉树](/2019/05/26/leetcode-102-binary-tree-level-order-traversal/)，对二叉树执行层次遍历，统计二叉树的层数。

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
    public int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);
        int depth = 0;
        while (!queue.isEmpty()) {
            depth ++;           
            for (int size = queue.size(); size > 0; size--) {
                TreeNode node = queue.poll();
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            }
        }
        return depth;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中结点的个数。