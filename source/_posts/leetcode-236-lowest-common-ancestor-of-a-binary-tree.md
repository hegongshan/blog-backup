---
title: LeetCode 236./《剑指Offer》68-II.二叉树的最近公共祖先
date: 2020-04-04 21:52:25
updated: 2020-04-04 21:52:25
tags: binary tree
categories: leetcode
---

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

<!--more-->

百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

例如，给定如下二叉树:  root = [3,5,1,6,2,0,8,null,null,7,4]

```
      3
    /    \
  5       1
/  \     /  \
6   2   0    8
   /  \
  7    4
```

**示例 1:**

```
输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
输出: 3
解释: 节点 5 和节点 1 的最近公共祖先是节点 3。
```

**示例 2:**

```
输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
输出: 5
解释: 节点 5 和节点 4 的最近公共祖先是节点 5。因为根据定义最近公共祖先节点可以为节点本身。
```

**说明:**

- 所有节点的值都是唯一的。
- p、q 为不同节点且均存在于给定的二叉树中。

### 方法一：递归

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || p == null || q == null) {
            return null;
        }
        if (root == p || root == q) {
            return root;
        }

        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);
        // 一个在左子树中，另一个在右子树中
        if (left != null && right != null) {
            return root;
        }
        // 都在左子树中
        if (left != null) {
            return left;
        }
        // 都在右子树中，或者不存在这样的结点
        return right;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中结点的个数。

### 方法二：递归求路径

首先，按照先序遍历的顺序，分别寻找从根结点到结点p和q的路径；

然后，求这两条路径的最后一个公共结点，即为p和q的最近公共祖先。

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || p == null || q == null) {
            return null;
        }

        List<TreeNode> list1 = new LinkedList<>();
        List<TreeNode> list2 = new LinkedList<>();
        // 如果p或者q不在树中
        if (!getPath(root, p, list1) || !getPath(root, q, list2)) {
            return null;
        }

        TreeNode ancestor = null;
        int i = 0, j =0;
        int min = Math.min(list1.size(), list2.size());
        while (i < min && j < min && list1.get(i) == list2.get(j)) {
            ancestor = list1.get(i);
            i++;
            j++;
        }
        return ancestor;
    }
    
    // 寻找从根结点到结点p的路径
    public boolean getPath(TreeNode root, TreeNode p, List<TreeNode> list) {
        if (root == null) {
            return false;
        }
        list.add(root);
        if (root == p) {
            return true;
        }

        boolean found = getPath(root.left, p, list) || getPath(root.right, p, list);
        // 如果p不在以root为根结点的子树中
        if (!found) {
            list.remove(root);
        }
        return found;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中结点的个数。

### 方法三：迭代求路径

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || p == null || q == null) {
            return null;
        }

        Stack<TreeNode> stack1 = new Stack<>();
        Stack<TreeNode> stack2 = new Stack<>();
        getPath(root, p, stack1);
        getPath(root, q, stack2);
        int min = Math.min(stack1.size(), stack2.size());
        while (stack1.size() > min) {
            stack1.pop();
        }
        while (stack2.size() > min) {
            stack2.pop();
        }
        while (!stack1.empty() && !stack2.empty() && stack1.peek() != stack2.peek()) {
            stack1.pop();
            stack2.pop();
        }
        return stack1.peek();
    }

    // 求根结点到结点p的路径
    public void getPath(TreeNode root, TreeNode p, Stack<TreeNode> stack) {
        TreeNode node = root;
        // 上一个被访问的结点
        TreeNode prev = null;
        outer: while (node != null || !stack.empty()) {
            while (node != null) {               
                stack.push(node);
                if (node == p) {
                    break outer;
                }
                node = node.left;
            }
            node = stack.peek();
            // 如果node没有右孩子，或者右孩子已经被访问过了，则删除该结点
            if (node.right == null || node.right == prev) {
                stack.pop();
                prev = node;
                node = null;
            } else {
                node = node.right;
            }
        }
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中结点的个数。