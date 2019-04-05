---
title: LeetCode 21.合并两个有序链表
date: 2019-04-05 11:16:42
tags: linked-list
categories: leetcode
---

### 题目描述

将两个有序链表合并为一个新的有序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。 

**示例：**

```
输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4
```

<!--more-->

### 算法思想

已知两个有序链表`L1`和`L2`，用p和q分别表示`L1`和`L2`的当前节点，用`L`表示合并后的链表，rear表示合并后的链表的最后一个节点。

当`p != null && q != null`时，循环比较p和q的val值，若p大，则将p添加到新链表的末尾，然后p后移；否则将q添加到新链表的末尾，q后移。

上述循环结束后，p、q至少有一个已经为null。

若`p != null`，则将p添加到新链表的末尾。若`q != null`，则将q添加到新链表的末

g

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
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        
        ListNode l = new ListNode(0);
        ListNode p = l1,q = l2,r = l;
        ListNode newNode ;
        while(p != null && q != null) {
            
            if(p.val <= q.val) {
                newNode = p;
                p = p.next;
            } else {
                newNode = q;
                q = q.next;
            }
            r.next = newNode;
            r = newNode;
        }
        if(p != null) {
            r.next = p;
        }
        if(q != null) {
            r.next = q;
        }
        return l.next;
    }
}
```

### 复杂度分析

设两个有序链表`L1`和`L2`的长度分别为n、m。不妨设 n < m，则

时间复杂度：由于该算法只有一个循环，且循环次数不超过n+m，故时间复杂度为O（n+m）。

空间复杂度：由于该算法只使用了常数的额外空间，故空间复杂度为O（1）。

### 算法效率

执行用时 : 1 ms, 在Merge Two Sorted Lists的Java提交中击败了100.00% 的用户

内存消耗 : 36.8 MB, 在Merge Two Sorted Lists的Java提交中击败了0.97% 的用户