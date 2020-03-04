---
title: LeetCode 102.二叉树的层次遍历/《剑指Offer》32-II.从上到下打印二叉树
date: 2019-05-26 16:11:29
tags: binary-tree
categories: leetcode
---

给定一个二叉树，返回其按层次遍历的节点值。 （即逐层地，从左到右访问所有节点）。

<!--more-->

例如:
给定二叉树: `[3,9,20,null,null,15,7]`,

```
    3
   / \
  9  20
    /  \
   15   7
```

返回其层次遍历结果：

```
[
  [3],
  [9,20],
  [15,7]
]
```

### 解决方案

* **思路：**使用队列来模拟二叉树的层次遍历。

让根结点root进队，当队列不为空时，循环执行如下操作：

1.获取当前层的节点个数，它等于队列中的元素个数size；

2.遍历当前层的节点。循环执行size次出队操作，每次执行出队操作时，判断当前节点是否有孩子。如果它有左孩子，则将其左孩子进队。若它(还)有右孩子，让右孩子(也)进队。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> list = new LinkedList<>();
        if (root != null) {
            Queue<TreeNode> queue = new LinkedList<>();
            // 进队
            queue.offer(root);
            while (!queue.isEmpty()) {
                List<Integer> levels = new LinkedList<>();
                // 当前层的节点个数
                int size = queue.size();
                for (int i = 0; i < size; i++) {
                    // 出队
                    TreeNode node = queue.poll();
                    levels.add(node.val);
                    if (node.left != null) {
                        queue.offer(node.left);
                    }
                    if (node.right != null) {
                        queue.offer(node.right);
                    }
                }
                list.add(levels);
            }
        }
        return list;
    }
}
```

