---
title: LeetCode 109.有序链表转换二叉搜索树
date: 2019-05-20 16:35:29
tags: binary-tree
categories: leetcode
---

给定一个单链表，其中的元素按升序排序，将其转换为高度平衡的二叉搜索树。

本题中，一个高度平衡二叉树是指一个二叉树*每个节点* 的左右两个子树的高度差的绝对值不超过 1。

<!--more-->

**示例:**

```
给定的有序链表： [-10, -3, 0, 5, 9],

一个可能的答案是：[0, -3, 9, -10, null, 5], 它可以表示下面这个高度平衡二叉搜索树：

      0
     / \
   -3   9
   /   /
 -10  5
```

### 解决方案

#### 方法一：直接构造AVL树

* 思路：遍历链表中的每一个节点，将其插入到AVL树中。

```java
/*
 public class ListNode {
     int val;
     ListNode next;
     ListNode(int x) { val = x; }
 }
 */
/*
 public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }
 */
class Solution {
    public TreeNode sortedListToBST(ListNode head) {
        TreeNode root = null;
        while(head != null) {
            root = insert(root,head.val);
            head = head.next;
        }
        return root;
    }
    // LL型旋转
    public TreeNode leftRotation(TreeNode root) {
        TreeNode node = root.left;
        root.left = node.right;
        node.right = root;
        return node;
    }
    // RR型旋转
    public TreeNode rightRotation(TreeNode root) {
        TreeNode node = root.right;
        root.right = node.left;
        node.left = root;
        return node;
    }
    // LR型旋转
    public TreeNode leftRightRotation(TreeNode root) {
        root.left = rightRotation(root.left);
        return leftRotation(root);
    }
    // RL型旋转
    public TreeNode rightLeftRotation(TreeNode root) {
        root.right = leftRotation(root.right);
        return rightRotation(root);
    }
    
    public TreeNode insert(TreeNode root,int x) {
        if(root == null) {
            root = new TreeNode(x);
        } else if(x < root.val) {
            root.left = insert(root.left,x);
            if(getHeight(root.left) - getHeight(root.right) >= 2) {
                if(x < root.left.val) {
                    root = leftRotation(root);
                }  else {
                    root = leftRightRotation(root);
                }
            }
        } else if(x > root.val) {
            root.right = insert(root.right,x);
            if(getHeight(root.right) - getHeight(root.left) >= 2) {
                if(x > root.right.val) {
                    root = rightRotation(root);
                }  else {
                    root = rightLeftRotation(root);
                }
            }
        }
        return root;
    }
    // 求树的高度
    public int getHeight(TreeNode root) {
        if(root == null) {
            return 0;
        }
        return Math.max(getHeight(root.left),getHeight(root.right)) + 1;
    }
}
```

#### 方法二：快慢指针+递归

* 思路：通过快慢指针，寻找中间节点。以此节点为界，将链表一分为二。然后对这两个部分递归执行该过程。

```java
/*
 public class ListNode {
     int val;
     ListNode next;
     ListNode(int x) { val = x; }
 }
 */
/*
 public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }
 */
class Solution {
	public TreeNode sortedListToBST(ListNode head) {
        // 1.寻找中间节点
        ListNode pre = head;
        ListNode slow = head;
        ListNode fast = head;
        while(fast != null && fast.next != null) {
            pre = slow;
            slow = slow.next;
            fast = fast.next.next;
        }
        
        TreeNode root = null;
        if(slow != null) {
            root = new TreeNode(slow.val);
            // 2.以中间节点为界，将链表一分为二
            pre.next = null;
            fast = slow.next;
            // 3.对左右两个部分递归执行该过程
            if(slow != head) {
                root.left = sortedListToBST(head);
            }
            root.right = sortedListToBST(fast);
        }
        return root;
    }
}
```

