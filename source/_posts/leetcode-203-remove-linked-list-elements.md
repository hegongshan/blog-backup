---
title: LeetCode 203.移除链表元素
date: 2019-05-08 20:34:09
tags: linked-list
categories: leetcode
---

### 题目描述

删除链表中等于给定值 **val** 的所有节点。

**示例:**

```
输入: 1->2->6->3->4->5->6, val = 6
输出: 1->2->3->4->5
```

<!--more-->

### 解决方案

#### 方法一：使用头结点

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode removeElements(ListNode head, int val) {
        ListNode root = new ListNode(0);
        root.next = head;
        ListNode node = root;
        while(node.next != null) {
            if(node.next.val == val) {
                node.next = node.next.next;
            } else {
                node = node.next;
            }
        }
        return root.next;
    }
}
```

#### 方法二：不使用头结点

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode removeElements(ListNode head, int val) {
        if(head == null) {
            return head;
        }
        // pre表示node的前驱结点
        ListNode node = head, pre = head;
        while(node != null) {
            if(node.val == val) {
                // 若头结点需要删除
                if(node == head) {
                    head = head.next;
                } else {
                    pre.next = node.next;
                }
            } else {
                pre = node;
            }
            node = node.next;
        }
        return head;
    }
}
```

#### 方法三：递归法

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode removeElements(ListNode head, int val) {
        if(head == null) {
            return head;
        }
        // 若头结点需要删除
        if(head.val == val) {
            return removeElements(head.next, val);
        }
        head.next = removeElements(head.next, val);
        return head;
    }
}
```

