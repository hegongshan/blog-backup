---
title: LeetCode 105.从前序与中序遍历序列构造二叉树/《剑指offer》7.重建二叉树
date: 2019-05-29 11:33:01
tags: binary-tree
categories: leetcode
---

根据一棵树的前序遍历与中序遍历构造二叉树。

<!--more-->

**注意:**
你可以假设树中没有重复的元素。

例如，给出

```
前序遍历 preorder = [3,9,20,15,7]
中序遍历 inorder = [9,3,15,20,7]
```

返回如下的二叉树：

```
    3
   / \
  9  20
    /  \
   15   7
```

### 解决方案

* **思路：**按照先序遍历和中序遍历的特点，先构造根结点root，然后找出左子树left和右子树right的起止范围，对它们递归执行该过程即可。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public TreeNode buildTree(int[] preorder, int[] inorder) {
        return buildTree(preorder,inorder,0,preorder.length-1,
                         0,inorder.length-1);
    }
    
    /*public TreeNode buildTree(int[] preorder, int[] inorder,
    	int preStart,int inStart,int length) {
        if(length == 0) {
            return null;
        }
        TreeNode root = new TreeNode(preorder[preStart]);
        if(length == 1) {
            return root;
        }
        
        int i=0;
        while(root.val != inorder[inStart + i]) {
            i++;
        }
        
        root.left = buildTree(preorder,inorder,preStart+1,inStart,i);
        root.right = buildTree(preorder,inorder,preStart+i+1,inStart+i+1,length-i-1);
        return root;
    }*/
    
    public TreeNode buildTree(int[] preorder, int[] inorder, 
                              int preFrom, int preTo, int inFrom, int inTo) {
        if(preFrom > preTo || inFrom > inTo) {
            return null;
        }
        // 构造根结点root
        TreeNode root = new TreeNode(preorder[preFrom]);
        if(preFrom == preTo) {
            return root;
        }
        // 寻找中序遍历中根结点所在的位置，i表示当前状态下左子树的元素个数
        int i=0;
        while(root.val != inorder[inFrom + i]) {
            i++;
        }
        // 对左右子树递归执行该过程
        /*
        -------------------------------------------------------------------------
        preorder   | root			left		right
        index	   | preFrom     preFrom+1 ... preFrom+i   preFrom+i+1 ... preTo
        -------------------------------------------------------------------------
        inorder    | left			root		right
        index 	   | inFrom ... inFrom+i-1  inFrom+i    inFrom+i+1 ... inTo
        -------------------------------------------------------------------------
        */
        root.left = buildTree(preorder,inorder,
                              preFrom+1,preFrom+i,inFrom,inFrom+i-1);
        root.right = buildTree(preorder,inorder,
                               preFrom+i+1,preTo,inFrom+i+1,inTo);
        return root;
    }
}
```

