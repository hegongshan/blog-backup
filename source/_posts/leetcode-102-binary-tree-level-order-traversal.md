---
title: LeetCode 102.二叉树的层次遍历
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

* **思路：**使用队列。先将根结点root进队，在队列不为空时循环：

此时队列中的元素个数size即为二叉树中当前层的节点个数，循环执行size次如下操作：将队首元素出队，若其有左孩子，则将其左孩子进队。若其还有右孩子，再将右孩子也进队。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> list = new ArrayList<>();
        if (root != null) {
            Deque<TreeNode> queue = new ArrayDeque<>();
            // 进队
            queue.offer(root);
            while (!queue.isEmpty()) {
                List<Integer> levels = new ArrayList<>();
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

