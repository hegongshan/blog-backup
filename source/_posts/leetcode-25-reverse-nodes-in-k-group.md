---
title: LeetCode 25.k个一组翻转链表
date: 2019-04-04 21:02:05
tags: linked-list
categories: leetcode
---

### 题目描述

给出一个链表，每 *k* 个节点一组进行翻转，并返回翻转后的链表。

*k* 是一个正整数，它的值小于或等于链表的长度。如果节点总数不是 *k* 的整数倍，那么将最后剩余节点保持原有顺序。

**示例 :**

给定这个链表：`1->2->3->4->5`

当 *k* = 2 时，应当返回: `2->1->4->3->5`

当 *k* = 3 时，应当返回: `3->2->1->4->5`

**说明 :**

- 你的算法只能使用常数的额外空间。
- **你不能只是单纯的改变节点内部的值**，而是需要实际的进行节点交换。

<!--more-->

### 算法思路

首先，为需要返回的链表设置一个头结点list以及尾节点rear。

然后，使用整数count记录链表的节点个数，每当满足条件`count % k == 0`时，翻转这k个节点组成的部分链表。

使用start表示需要翻转的部分链表的第一个节点，用end表示需要翻转的部分链表的最后一个节点。

使用pre表示翻转后的部分链表的第一个节点，采用头插法，翻转部分链表。翻转完毕后，start成为了该部分链表的最后一个节点。

接着，让翻转后的链表成为rear的后继，即`rear.next = pre`，然后让`rear = start`，并将原链表的下一个节点赋给start，开启新一轮的翻转。

最后，待循环执行完毕后，若链表后面还有不足k个节点，即`count % k != 0`，直接让剩余的这部分链表成为rear的后继，即`rear = start`。

### 算法实现

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
		int count = 0;
        ListNode list = new ListNode(0);
        ListNode rear = list;
        rear.next = head;
		
        ListNode node = list.next;
        ListNode start = node,end;
        ListNode p,q,pre=null;
        while(node != null) {
            count++;
            if(count % k == 0) {
                end = node;
                node = node.next;
                
                //1.翻转当前的k个节点
                end.next = null;
                p = start;
                while(p != null) {
                    q = p.next;
                    
                    p.next = pre;
                    pre = p;
                    
                    p = q;
                }
                //2.将翻转后的部分链表链接到原来的链表尾部
                rear.next = pre;
                rear = start;
               
                //3.开启下一轮翻转
                pre=null;
                start = node;
            } else {
                node = node.next; 
            }
        }
        if(count % k != 0) {
            rear.next = start;
        }
        return list.next;
	}
}
```

### 复杂度分析

时间复杂度：该算法只遍历链表一次，故时间复杂度为O(n)。

空间复杂度：该算法只使用了常数的额外空间，故空间复杂度为O(1)

### 算法效率

执行用时 : 2 ms, 在Reverse Nodes in k-Group的Java提交中击败了100.00% 的用户

内存消耗 : 37.6 MB, 在Reverse Nodes in k-Group的Java提交中击败了0.93% 的用户

