---
title: 《剑指Offer》8.二叉树的下一个结点
date: 2020-02-14 22:27:50
tags: binary-tree
categories: 剑指offer
---

给定一个二叉树和其中的一个结点，请找出中序遍历顺序的下一个结点并且返回。注意，树中的结点不仅包含左右子结点，同时包含指向父结点的指针。

<!--more-->

### 问题分析

本题共有以下三种情况：

1.如果该结点有右孩子，那么它的下一个结点就是其右子树中最左边的结点；

2.如果该结点有父结点，且为父结点的左孩子，那么它的下一个结点就是其父结点；

3.如果该结点有父结点，且为父结点的右孩子，那么继续向上寻找，直到找到这样一个结点：它是它的父结点的左孩子。如果这样的结点存在，那么这个结点的父结点就是题目要找的下一个结点。否则，给定的结点为中序遍历的最后一个结点，它没有下一个结点。

### 算法实现

* <strong id="java">Java</strong>

```java
/*
public class TreeLinkNode {
    int val;
    TreeLinkNode left = null;
    TreeLinkNode right = null;
    TreeLinkNode next = null;

    TreeLinkNode(int val) {
        this.val = val;
    }
}
*/
class Solution {
    public TreeLinkNode GetNext(TreeLinkNode pNode) {
        TreeLinkNode node;
        // 1.若该结点有右孩子，则寻找右子树中最左边的结点
        if(pNode.right != null) {
            node = pNode.right;
            while(node.left != null) {
                node = node.left;
            }
            return node;
        }
        // 2.向上寻找
        node = pNode;
        while(node != null && node.next != null && node == node.next.right) {
            node = node.next;
        }
        if(node != null && node.next != null) {
            return node.next;
        }
        return null;
    }
}
```

* <strong id="python">Python</strong>

```python
# class TreeLinkNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
#         self.next = None
class Solution:
    def GetNext(self, pNode):
        # 1.若该结点有右孩子，则寻找右子树中最左边的结点
        if pNode.right:
            node = pNode.right
            while node.left:
                node = node.left
            return node
        # 2.向上寻找
        node = pNode
        while node and node.next and node == node.next.right:
            node = node.next
        if node and node.next:
            return node.next
        return None
```

