---
title: LeetCode 148.排序链表
date: 2019-04-26 18:39:59
tags: linked-list
categories: leetcode
---

### 题目描述

在 *O*(*n* log *n*) 时间复杂度和常数级空间复杂度下，对链表进行排序。

**示例 1:**

```
输入: 4->2->1->3
输出: 1->2->3->4
```

**示例 2:**

```
输入: -1->5->3->4->0
输出: -1->0->3->4->5
```

<!--more-->

### 解决方案

本题可以采用归并排序。

通过快慢指针，仅遍历一次链表就可以找到中间位置，将链表一分为二。

然后对得到的两个链表递归执行sortList方法，最后对两个有序链表进行二路归并。

### 算法实现

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    // 合并两个有序链表
    public ListNode merge(ListNode p,ListNode q) {
        ListNode head = new ListNode(-1);
        ListNode r = head;
        while(p != null && q != null) {
            if(p.val < q.val) {
                r.next = p;
                r = p;
                p = p.next;
            } else {
                r.next = q;
                r = q;
                q = q.next;
            }
        }
        if(p != null) {
            r.next = p;
        }
        if(q != null) {
            r.next = q;
        }
        return head.next;
    }
    
    public ListNode sortList(ListNode head) {
        if(head == null || head.next == null) {
            return head;
        }
        // 通过快慢指针，寻找中间位置，将链表一分为二
        ListNode p = head,q=head,pre=head;
        while(q != null && q.next != null) {
            pre = p;
            p = p.next;
            q = q.next.next;
        }
        pre.next = null;
        return merge(sortList(head),sortList(p));
    }
}
```

### 复杂度分析

设链表的长度为*n*

时间复杂度：*O(n log n)*

空间复杂度：*O*(n)

### 算法效率

执行用时 : 12 ms, 在Sort List的Java提交中击败了37.49% 的用户

内存消耗 : 44.2 MB, 在Sort List的Java提交中击败了63.30% 的用户