---
title: LeetCode 328.奇偶链表
date: 2019-05-10 13:57:39
tags: linked-list
categories: leetcode
---

### 题目描述

给定一个单链表，把所有的奇数节点和偶数节点分别排在一起。请注意，这里的奇数节点和偶数节点指的是节点编号的奇偶性，而不是节点的值的奇偶性。

请尝试使用原地算法完成。你的算法的空间复杂度应为 O(1)，时间复杂度应为 O(nodes)，nodes 为节点总数。

**示例 1:**

```
输入: 1->2->3->4->5->NULL
输出: 1->3->5->2->4->NULL
```

**示例 2:**

```
输入: 2->1->3->5->6->4->7->NULL 
输出: 2->3->6->7->1->5->4->NULL
```

**说明:**

- 应当保持奇数节点和偶数节点的相对顺序。
- 链表的第一个节点视为奇数节点，第二个节点视为偶数节点，以此类推。

<!--more-->

### 解决方案

#### 方法一：复制法

* **思路：**复制原链表head，得到新的链表newList，分别对head的奇数节点、newList的偶数节点进行处理。

* **算法实现**

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode oddEvenList(ListNode head) {
        // 链表为空，或仅含一个节点
        if(head == null || head.next == null) {
            return head;
        }
        ListNode newList = copy(head);
        ListNode root = new ListNode(0);
        ListNode rear = root;
        // 处理奇数节点
        while(newList != null) {
            rear.next = newList;
            rear = newList;
            if(newList.next == null) {
                break;
            }
            newList = newList.next.next;
        }
        // 处理偶数节点
        ListNode node = head.next;
         while(node != null) {
            rear.next = node;
            rear = node;
            if(node.next == null) {
                break;
            }
            node = node.next.next;
        }
        rear.next = null;
        return root.next;
    }
    // 复制链表
    public ListNode copy(ListNode head) {
        ListNode root = new ListNode(0);
        ListNode rear = root;
        ListNode node;
        while(head != null) {
            node = new ListNode(head.val);
            rear.next = node;
            rear = node;
            head = head.next;
        }
        return root.next;
    }
}
```

* **复杂度分析：**

空间复杂度：该方法需要复制原链表，故空间复杂度为O(nodes)

时间复杂度：O(nodes)

#### 方法二：双指针

* **思路：**使用奇偶双指针，同时处理奇偶节点，分别得到两个链表，然后将这两个链表链接在一起。
* **算法实现**

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode oddEvenList(ListNode head) {
        if(head == null || head.next == null) {
            return head;
        }
        ListNode l1 = head;
        ListNode l2 = head.next;
        ListNode odd = l1;
        ListNode even = l2;
        // 使用奇偶双指针，同时处理奇偶节点
        while(even != null && even.next != null) {
            odd.next = even.next;
            even.next = even.next.next;
            
            odd = odd.next;
            even = even.next;
        }
        // 将偶数链表拼接到奇数链表后
        odd.next = l2;
        return l1;
    }
}
```

* **复杂度分析：**

空间复杂度：只使用了常数的额外空间，故空间复杂度为O(1)

时间复杂度：仅对链表执行一次遍历，故时间复杂度为O(nodes)