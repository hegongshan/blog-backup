---
title: LeetCode 94.二叉树的中序遍历
date: 2019-05-25 21:10:26
tags: binary-tree
categories: leetcode
---

给定一个二叉树，返回它的*中序* 遍历。

<!--more-->

**示例:**

```
输入: [1,null,2,3]
   1
    \
     2
    /
   3

输出: [1,3,2]
```

**进阶:** 递归算法很简单，你可以通过迭代算法完成吗？

### 解决方案

#### 方法一：递归

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root != null) {
            list.addAll(inorderTraversal(root.left));
            list.add(root.val);
            list.addAll(inorderTraversal(root.right));
        }
        return list;
    }
}
```

#### 方法二：迭代

* **思路：**遇到一个节点，将其进栈，并将其所有左节点一一进栈。此时，栈顶节点node没有左孩子或者左子树均已访问过。然后出栈并访问node，让node指向其右孩子，对右子树进行同样的处理。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root != null) {
            Stack<TreeNode> stack = new Stack<>();
            TreeNode node = root;
            // 刚开始循环或者左子树（包括根结点）已经遍历过时，栈为空，
            // 此时需要使用node != null保证循环执行
            while(!stack.isEmpty() || node != null) {
                // 将当前节点的所有左节点一一进栈
                while(node != null) {
                    stack.push(node);
                    node = node.left;
                }
                // 此时，栈顶节点没有左孩子或左子树均已访问过
                if(!stack.isEmpty()) {
                    node = stack.pop();
                    list.add(node.val);
                    // 处理右孩子
                    node = node.right;
                }
            }
        }
        return list;
    }
}
```

