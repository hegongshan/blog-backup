---
title: LeetCode 1008.先序遍历构造二叉树
date: 2019-05-27 22:39:01
tags: binary-tree
categories: leetcode
---

返回与给定先序遍历 `preorder` 相匹配的二叉搜索树（binary **search** tree）的根结点。

*(回想一下，二叉搜索树是二叉树的一种，其每个节点都满足以下规则，对于 node.left 的任何后代，值总 < node.val，而 node.right 的任何后代，值总 > node.val。此外，先序遍历首先显示节点的值，然后遍历 node.left，接着遍历 node.right。）*

<!--more-->

**示例：**

```
输入：[8,5,1,7,10,12]
输出：[8,5,10,1,7,null,12]
	    8
           / \
          5  10
         / \   \
        1   7   12
```

**提示：**

1. `1 <= preorder.length <= 100`
2. 先序 `preorder` 中的值是不同的。

### 解决方案

#### 方法一：利用先序遍历

* **思路：**按照先序遍历的顺序，每次将preorder划分为根节点root、左子树left和右子树right三个部分，然后对left和right递归执行该过程。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public TreeNode bstFromPreorder(int[] preorder) {
        if(preorder == null) {
            return null;
        }
        return bstFromPreorder(preorder, 0, preorder.length - 1);
    }
    // 按照先序遍历构造BST
    public TreeNode bstFromPreorder(int[] preorder, int low, int high) {
        TreeNode root = null;
        if(low <= high) {
            root = new TreeNode(preorder[low]);
            // 寻找当前节点的右子树
            int i = low + 1;
            while(i <= high && preorder[i] <= root.val) {
                i++;
            }
            // low 	 low+1 ... i-1 	i ... high
            // root      left 	   	  right
            root.left = bstFromPreorder(preorder, low + 1, i - 1);
            root.right = bstFromPreorder(preorder, i, high);
        }
        return root;
    }
}
```

#### 方法二：直接构造二叉搜索树

- **思路：**按照先序遍历构造**二叉搜索树**，等价于按照给定的顺序，直接构造二叉搜索树。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public TreeNode bstFromPreorder(int[] preorder) {
        if(preorder == null) {
            return null;
        }
        TreeNode root = null;
        // 将所有的元素依次插入到BST中
        for(int val : preorder) {
            root = insert(root, val);
        }
        return root;
    }
    
    // 将元素插入到BST中
    public TreeNode insert(TreeNode root, int val) {
        if(root == null) {
            root = new TreeNode(val);
            return root;
        }
        if(val < root.val) {
            root.left = insert(root.left, val);
        } else if(val > root.val) {
            root.right = insert(root.right, val);
        }
        return root;
    }
}
```

