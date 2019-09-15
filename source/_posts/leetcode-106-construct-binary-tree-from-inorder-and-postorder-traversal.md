---
title: LeetCode 106.从中序与后序遍历序列构造二叉树
date: 2019-05-29 18:51:48
tags: binary-tree
categories: leetcode
---

根据一棵树的中序遍历与后序遍历构造二叉树。

<!--more-->

**注意:**
你可以假设树中没有重复的元素。

例如，给出

```
中序遍历 inorder = [9,3,15,20,7]
后序遍历 postorder = [9,15,7,20,3]
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

- **思路：**按照中序遍历和后序遍历的特点，先构造根结点root，然后找出左子树left和右子树right的起止范围，对它们递归执行该过程即可。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public TreeNode buildTree(int[] inorder, int[] postorder) {
        //return buildTree(inorder,postorder,0,postorder.length-1,postorder.length);
        return buildTree(inorder,postorder,0,inorder.length-1,0,postorder.length-1);
    }
    
    /*public TreeNode buildTree(int[] inorder, int[] postorder, 
   			int inStart, int postEnd, int length) {
        if(length == 0) {
            return null;
        }
        TreeNode root = new TreeNode(postorder[postEnd]);
        
        int i=0;
        while(root.val != inorder[inStart + i]) {
            i++;
        }
        
        root.left = buildTree(inorder, postorder, 
        			inStart, postEnd - (length - i), i);
        root.right = buildTree(inorder, postorder, 
        			inStart + i + 1, postEnd-1, length-i-1);
        return root;
    }*/
    
    public TreeNode buildTree(int[] inorder, int[] postorder, 
                              int inFrom, int inTo, int postFrom, int postTo) {
        if(inFrom > inTo || postFrom > postTo) {
            return null;
        }
        // 构造根结点root
        TreeNode root = new TreeNode(postorder[postTo]);
        // 寻找中序遍历中根结点所在的位置，i表示当前状态下左子树的元素个数
        int i=0;
        while(root.val != inorder[inFrom + i]) {
            i++;
        }
        // 对左右子树递归执行该过程
        /*
        -------------------------------------------------------------------------
        inorder    | left			root			right
        index	   | inFrom ... inFrom+i-1    inFrom+i 		inFrom+i+1 ... inTo
        -------------------------------------------------------------------------
        postorder  | left			right 			root
        index 	   | postFrom ... postFrom+i-1  postFrom+i ...postTo-1  postTo
        -------------------------------------------------------------------------
        */
        root.left = buildTree(inorder, postorder, 
                              inFrom, inFrom + i - 1, postFrom, postFrom + i - 1);
        root.right = buildTree(inorder, postorder, 
                              inFrom + i + 1, inTo, postFrom + i, postTo - 1);
        return root;
    }    
}
```

