---
title: 《剑指Offer》32-I.从上到下打印二叉树
date: 2020-03-03 17:36:36
tags: binary-tree
categories: 剑指offer
---

从上到下打印出二叉树的每个节点，同一层的节点按照从左到右的顺序打印。

<!--more-->

**例如:**
给定如下的二叉树

```
     8
   /    \
  6      10
 /  \   /  \
5   7  9   11
```

返回：

```
[8,6,10,5,7,9,11]
```

### 问题分析

本题的目的在于考察二叉树的层次遍历，可以使用队列来模拟该操作。

### 算法实现

```java
class Solution {
    public List<Integer> levelOrder(TreeNode root) {
        if(root == null) {
            return new LinkedList<>();
        }

        List<Integer> list = new LinkedList<>();
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);
        while(!queue.isEmpty()) {
            TreeNode node = queue.poll();
            list.add(node.val);
            if(node.left != null) {
                queue.offer(node.left);
            }
            if(node.right != null) {
                queue.offer(node.right);
            }
        }
        return list;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中节点的个数。