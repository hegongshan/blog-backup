---
title: LeetCode 889.根据前序和后序遍历构造二叉树
date: 2019-05-29 19:10:27
tags: binary-tree
categories: leetcode
---

返回与给定的前序和后序遍历匹配的任何二叉树。

<!--more-->

 `pre` 和 `post` 遍历中的值是不同的正整数。

**示例：**

```
输入：pre = [1,2,4,5,3,6,7], post = [4,5,2,6,7,3,1]
输出：[1,2,3,4,5,6,7]
```

 **提示：**

- `1 <= pre.length == post.length <= 30`
- `pre[]` 和 `post[]` 都是 `1, 2, ..., pre.length` 的排列
- 每个输入保证至少有一个答案。如果有多个答案，可以返回其中一个。

### 解决方案

* **思路：**仅知道先序遍历和后序遍历的结果，满足条件的二叉树并不唯一。一种直观的方法是：按照先序遍历和后序遍历的特点，先构造根结点root，然后找出左子树left和右子树right的起止范围，对它们递归执行该过程即可。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public TreeNode constructFromPrePost(int[] pre, int[] post) {
        return constructFromPrePost(pre, post, 
                                    0, pre.length-1, 0, post.length-1);
    }
    
    public TreeNode constructFromPrePost(int[] pre, int[] post, 
                                 int preFrom, int preTo, int postFrom, int postTo) {
        // 1.范围判断，当给定的范围不合法时，返回null
        if(preFrom > preTo || postFrom > postTo) {
            return null;
        }
        // 2.构造根结点root
        TreeNode root = new TreeNode(pre[preFrom]);
        // 3.若仅有一个元素，则直接返回，避免再次执行递归操作
        if(preFrom == preTo) {
            return root;
        }
        // 4.计算左子树的元素个数,i=左子树元素个数-1
        int i = 0;
        while(pre[preFrom+1] != post[postFrom + i]) {
            i++;
        }
        // 5.递归构造左右子树
        root.left = constructFromPrePost(pre, post,
                                     preFrom+1, preFrom+i+1, postFrom, postFrom+i);
        root.right = constructFromPrePost(pre,post,
                                     preFrom+i+2, preTo, postFrom+i+1, postTo-1);
        return root;
    }
}
```

