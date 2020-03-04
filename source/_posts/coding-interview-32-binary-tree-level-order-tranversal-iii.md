---
title: 《剑指Offer》32-III.从上到下打印二叉树
date: 2020-03-03 17:36:52
tags: binary-tree
categories: 剑指offer
---

请实现一个函数按照之字形顺序打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右到左的顺序打印，第三行再按照从左到右的顺序打印，其他行以此类推。

<!--more-->

**例如:**
给定如下的二叉树

```
     8
   /    \
  6      10
 /  \   /  \
5   7  9   11
```

返回其层次遍历结果：

```
[
  [8],
  [10,6],
  [5,7,9,11]
]
```

### 方法一：两个栈

分析：题目要求奇数层按照从左到右的顺序打印，偶数层按照从右到左的顺序打印。

思路：设置两个栈odd和even，odd用于存储奇数层，even用于存储偶数层。

1.如果当前层为奇数层，那么，当odd不为空时，循环执行如下操作：

将栈顶元素出栈。若该节点有左孩子，则将其左孩子压入even中。若该节点还有右孩子，则将右孩子也压入even中。

2.如果当前层为偶数层。那么，当even不为空时，循环执行如下操作：

将栈顶元素出栈。若该节点有右孩子，则将其右孩子压入odd中。若该节点还有左孩子，则将左孩子也压入odd中。

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
    public List<List<Integer>> levelOrder(TreeNode root) {
        if(root == null) {
            return new LinkedList<>();
        }

        List<List<Integer>> res = new LinkedList<>();

        Stack<TreeNode> odd = new Stack<>();
        Stack<TreeNode> even = new Stack<>();
        odd.push(root);

        int level = 1;
        while(!odd.isEmpty() || !even.isEmpty()) {            
            List<Integer> list = new LinkedList<>(); 
            // 若当前层是奇数层
            if((level & 0x1) == 1) {
                while(!odd.isEmpty()) {
                    TreeNode node = odd.pop();
                    list.add(node.val);
                    if(node.left != null) {
                        even.push(node.left);
                    }
                    if(node.right != null) {
                        even.push(node.right);
                    }
                }                       
            } else {
                while(!even.isEmpty()) {
                    TreeNode node = even.pop();
                    list.add(node.val);
                    if(node.right != null) {
                        odd.push(node.right);
                    }
                    if(node.left != null) {
                        odd.push(node.left);
                    }
                }          
            }
            level++;
            res.add(list);
        }
        return res;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中节点的个数。

### 方法二：双端队列

双端队列可以看做是将两个栈的底部拼接在一起构成的。因此，我们也可以使用双端队列来实现方法一。

队首用于存储偶数层，队尾用于存储奇数层。

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
    public List<List<Integer>> levelOrder(TreeNode root) {
        if (root == null) {
            return new LinkedList<>();
        }

        List<List<Integer>> res = new LinkedList<>();
        Deque<TreeNode> queue = new LinkedList<>();
        queue.offerLast(root);
        int level = 1;
        while (!queue.isEmpty()) {
            List<Integer> list = new LinkedList<>();
            
            // 若当前层是奇数层
            if ((level & 0x1) == 1) {
                for (int size = queue.size(); size > 0; size--) {
                    TreeNode node = queue.pollLast();
                    list.add(node.val);
                    if (node.left != null) {
                        queue.offerFirst(node.left);
                    }
                    if (node.right != null) {
                        queue.offerFirst(node.right);
                    }
                }
            } else {
                for (int size = queue.size(); size > 0; size--) {
                    TreeNode node = queue.pollFirst();
                    list.add(node.val);
                    if (node.right != null) {
                        queue.offerLast(node.right);
                    }
                    if (node.left != null) {
                        queue.offerLast(node.left);
                    }
                }
            }
            level++;
            res.add(list);
        }
        return res;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为二叉树中节点的个数。