---
title: LeetCode 145.二叉树的后序遍历
date: 2019-05-26 16:11:03
tags: binary-tree
categories: leetcode
---

给定一个二叉树，返回它的 *后序* 遍历。

<!--more-->

**示例:**

```
输入: [1,null,2,3]  
   1
    \
     2
    /
   3 

输出: [3,2,1]
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
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root != null) {
            if(root.left != null) {
                list.addAll(postorderTraversal(root.left));
            }
            if(root.right != null) {
                list.addAll(postorderTraversal(root.right));
            }
            list.add(root.val);
        }
        return list;
    }
}
```

#### 方法二：迭代

* **思路：**遇到一个节点，将其进栈，并将其所有左节点一一进栈。变量parent表示上一次访问过的节点。当栈不为空时，循环执行如下操作：将栈顶元素node出栈，若node的右孩子就是parent，表示node没有右孩子或者其右子树已被访问过，此时可以访问node节点，然后让parent指向node；否则，将node重新压入栈中，并让其指向右孩子，跳出循环。然后重新执行上述过程，直至栈空。

```java
/*public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
 }*/
class Solution {
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root != null) {
            Stack<TreeNode> stack = new Stack<>();
            TreeNode node = root;
            do {
                while(node != null) {
                    stack.push(node);
                    node = node.left;
                }
                // 上一次访问的节点
                TreeNode parent = null;
                while(!stack.isEmpty()) {
                    node = stack.pop();
                    if(node.right == parent) {
                        list.add(node.val);
                        parent = node;
                    } else {
                        stack.push(node);
                        node = node.right;
                        break;
                    }
                }
            } while(!stack.isEmpty());
        }
        return list;
    }
}
```

