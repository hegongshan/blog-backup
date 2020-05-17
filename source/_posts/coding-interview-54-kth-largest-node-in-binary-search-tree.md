---
title: 《剑指Offer》54.二叉搜索树的第k大节点
date: 2020-03-20 17:48:30
tags: binary tree
categories: 剑指offer
---

给定一棵二叉搜索树，请找出其中第k大的节点。

<!--more-->

例如， （5，3，7，2，4，6，8）中，按结点数值大小顺序第三小节点的值为4。

```
     5
   /   \
  3     7
 / \   / \
2   4 6   8
```

### 方法一：小根堆

思路：首先，按照任意一种遍历顺序，对二叉搜索树进行遍历。遍历的同时，将节点依次加入小根堆中。

然后，循环删除堆中的元素，直到元素个数等于k为止。

最后，堆中的根节点即为第k大的节点。

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
    public int kthLargest(TreeNode root, int k) {
        PriorityQueue<TreeNode> heap = new PriorityQueue<>((a, b) -> a.val - b.val);
        inorder(root, heap);
        
        while (heap.size() > k) {
            heap.poll();
        }
        return heap.peek().val;
    }

    private void inorder(TreeNode root, PriorityQueue heap) {
        if (root == null) {
            return ;
        }
        inorder(root.left, heap);
        heap.offer(root);
        inorder(root.right, heap);
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。

### 方法二：递归

思路：二叉搜索树的中序遍历序列是递增排列的。

因此，按照中序遍历的逆顺序对二叉树搜索树进行遍历，遍历的第k个节点就是第k大的节点。

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
    private int val = 0;
    private int cnt = 0;
    public int kthLargest(TreeNode root, int k) {
        inorder(root, k);
        return val;
    }
    private void inorder(TreeNode root, int k) {
        if (root == null) {
            return ;
        }
        inorder(root.right, k);
        if (++cnt == k) {
            val = root.val;
            return ;
        }
        inorder(root.left, k);
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(k)。

### 方法三：迭代

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
    public int kthLargest(TreeNode root, int k) {
        Stack<TreeNode> stack = new Stack<>();
        TreeNode node = root;
        while (!stack.empty() || node != null) {
            while (node != null) {
                stack.push(node);
                node = node.right;
            }
            if (!stack.empty()) {
                node = stack.pop();
                k --;
                if (k == 0) {
                    break;
                }
                node = node.left;
            }
        }
        return node.val;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(k)。

