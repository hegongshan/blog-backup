---
title: 《剑指Offer》36.二叉搜索树与双向链表
date: 2020-03-05 17:54:42
tags: binary-tree
categories: 剑指offer
---

输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的双向链表。要求不能创建任何新的结点，只能调整树中结点指针的指向。

<!--more-->

### 问题分析

二叉搜索树的中序遍历序列是按照升序排列的，因此，只需要按照中序遍历的顺序，将树中所有的结点连接在一起，就能将二叉搜索树转换成升序的双向链表。

### 方法一：递归

```java
/**
public class TreeNode {
    int val = 0;
    TreeNode left = null;
    TreeNode right = null;
    public TreeNode(int val) {
        this.val = val;
    }
}
*/
import java.util.Stack;

public class Solution {
    public TreeNode Convert(TreeNode root) {
        Stack<TreeNode> stack = new Stack<>();
        // 1.中序遍历
        inorder(root, stack);
        
        // 2.构建双链表
        TreeNode head = null;
        TreeNode tail = null;
        while (!stack.isEmpty()) {
            TreeNode node = stack.pop();
            if (head == null) {
                head = tail = node;
                head.left = null;
            } else {
                tail.right = node;
                node.left = tail;
                
                tail = node;
            }
        }
        return head;
    }

    public void inorder(TreeNode node, Stack<TreeNode> stack) {
        if (node == null) {
            return ;
        }
        if (node.right != null) {
            inorder(node.right, stack);
        }
        stack.push(node);
        if (node.left != null) {
            inorder(node.left, stack);
        }
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉搜索树中节点的个数。

### 方法二：迭代

```java
/**
public class TreeNode {
    int val = 0;
    TreeNode left = null;
    TreeNode right = null;
    public TreeNode(int val) {
        this.val = val;
    }
}
*/
import java.util.Stack;

public class Solution {
    
    public TreeNode Convert(TreeNode root) {
        TreeNode head = null;
        TreeNode tail = null;

        Stack<TreeNode> stack = new Stack<>();
        TreeNode node = root;
        while (!stack.isEmpty() || node != null) {
            while (node != null) {
                stack.push(node);
                node = node.left;
            }
            if (!stack.isEmpty()) {
                node = stack.pop();
                if (head == null) {
                    head = tail = node;
                    head.left = null;
                } else {
                    tail.right = node;
                    node.left = tail;
                    tail = node;
                }
                node = node.right;
            }
        }
        return head;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉搜索树中节点的个数。

