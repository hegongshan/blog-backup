---
title: LeetCode 144.二叉树的前序遍历
date: 2019-05-25 20:35:03
tags: binary-tree
categories: leetcode
---

给定一个二叉树，返回它的 *前序* 遍历。

<!--more-->

 **示例:**

```
输入: [1,null,2,3]  
   1
    \
     2
    /
   3 

输出: [1,2,3]
```

**进阶:** 递归算法很简单，你可以通过迭代算法完成吗？

### 解决方案

#### 方法一：递归

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
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root != null) {
            list.add(root.val);
            list.addAll(preorderTraversal(root.left));
            list.addAll(preorderTraversal(root.right));
        }
        return list;
    }
}
```

#### 方法二：迭代

* **思路：**先将根结点root进栈，在栈不空时循环：出栈并访问node，若其右孩子节点不为空，则将右孩子节点进栈，若其左孩子节点不为空，再将其左孩子节点进栈。

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
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root != null) {
            Stack<TreeNode> stack = new Stack<>();
            stack.push(root);
            while(!stack.isEmpty()) {
                // 1.栈顶元素出栈
                TreeNode node = stack.pop();
                list.add(node.val);
                // 2.若其右孩子节点不为空
                if(node.right != null) {
                    stack.push(node.right);
                }
                // 3.若其左孩子节点不为空
                if(node.left != null) {
                    stack.push(node.left);
                }
            }
        }
        return list;
    }
}
```

