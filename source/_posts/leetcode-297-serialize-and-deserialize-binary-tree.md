---
title: LeetCode 297.二叉树的序列化与反序列化/《剑指Offer》37.序列化二叉树
date: 2020-03-06 15:20:59
tags: binary-tree
categories: leetcode
---

序列化是将一个数据结构或者对象转换为连续的比特位的操作，进而可以将转换后的数据存储在一个文件或者内存中，同时也可以通过网络传输到另一个计算机环境，采取相反方式重构得到原数据。

请设计一个算法来实现二叉树的序列化与反序列化。这里不限定你的序列 / 反序列化算法执行逻辑，你只需要保证一个二叉树可以被序列化为一个字符串并且将这个字符串反序列化为原始的树结构。

<!--more-->

**示例:** 

```
你可以将以下二叉树：

    1
   / \
  2   3
     / \
    4   5

序列化为 "[1,2,3,null,null,4,5]"
```

**提示:** 这与 LeetCode 目前使用的方式一致，你并非必须采取这种方式，你也可以采用其他的方法解决这个问题。

**说明:** 不要使用类的成员 / 全局 / 静态变量来存储状态，你的序列化和反序列化算法应该是无状态的。

### 方法一：先序遍历（深度优先）

思路：序列化操作就是对二叉树执行先序遍历，反序列化操作就是根据先序遍历重构二叉树。

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
public class Codec {

    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        serializeTree(root, sb);
        sb.deleteCharAt(sb.length()-1);
        return "[" + sb.toString() + "]";
    }
    // 执行实际的序列化操作
    private StringBuilder serializeTree(TreeNode root, StringBuilder sb) {
        if(root == null) {
            sb.append("null").append(',');
        } else {
            sb.append(root.val).append(',');
            serializeTree(root.left, sb);
            serializeTree(root.right, sb);
        }
        return sb;
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        if(data == null || data.isEmpty()) {
            return null;
        }
        List<String> nodes = new LinkedList<>(Arrays.asList(
          data.substring(1, data.length() - 1).split(",")));
        return deserializeTree(nodes);
    }
    // 执行实际的反序列化操作
    private TreeNode deserializeTree(List<String> nodes) {
        if("null".equals(nodes.get(0))) {
            nodes.remove(0);
            return null;
        }
        TreeNode root = new TreeNode(Integer.parseInt(nodes.get(0)));
        nodes.remove(0);
        root.left = deserializeTree(nodes);
        root.right = deserializeTree(nodes);
        return root;
    }
}
// Your Codec object will be instantiated and called as such:
// Codec codec = new Codec();
// codec.deserialize(codec.serialize(root));
```

### 方法二：层次遍历（广度优先）

思路：序列化操作就是对二叉树执行层次遍历，反序列化操作就是根据层次遍历重构二叉树。

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
public class Codec {

    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder("[");
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            if (node == null) {
                sb.append("null");
            } else {
                sb.append(node.val);
                queue.offer(node.left);
                queue.offer(node.right);
            }
            sb.append(',');
        }
        sb.deleteCharAt(sb.length() - 1);
        return sb.append("]").toString();
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        // 1.若传入的参数不合法
        if(data == null || data.isEmpty()) {
            return null;
        }

        String[] nodes = data.substring(1, data.length() - 1).split(",");
        // 2.若二叉树为空
        if(nodes.length == 1 && "null".equals(nodes[0])) {
            return null;
        }

        Queue<TreeNode> queue = new LinkedList<>();
        int idx = 0;
        TreeNode root = newNode(nodes[idx++]);
        queue.offer(root);

        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            node.left = newNode(nodes[idx++]);
            node.right = newNode(nodes[idx++]);
            if(node.left != null) {
                queue.offer(node.left);
            }
             if(node.right != null) {
                queue.offer(node.right);
            }
        }
        // 垃圾回收
        nodes = null;
        return root;
    }
    
    // 创建节点
    private TreeNode newNode(String data) {
        if("null".equals(data)) {
            return null;
        }
        TreeNode node = new TreeNode(Integer.parseInt(data));
        node.left = node.right = null;
        return node;
    }
}
// Your Codec object will be instantiated and called as such:
// Codec codec = new Codec();
// codec.deserialize(codec.serialize(root));
```

