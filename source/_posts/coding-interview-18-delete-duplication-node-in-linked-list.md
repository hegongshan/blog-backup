---
title: 《剑指Offer》18.删除链表中重复的结点
date: 2020-02-25 13:45:36
tags: linked-list
categories: 剑指offer
mathjax: true
---

在一个排序的链表中，存在重复的结点，请删除该链表中重复的结点，重复的结点不保留，返回链表头指针。 例如，链表1->2->3->3->4->4->5 处理后为 1->2->5。

<!--more-->

### 方法一：递归

思路：设f(pHead)为删除重复结点后的链表。递归公式如下：
$$
f(pHead) = 
\begin{cases}
\mathrm{pHead}, & \mathrm{if\ pHead\ = null\ or\ pHead.next = null} \\\\
f(node.next), & \mathrm{if\ pHead.val = pHead.next.val = \cdots = node.val} \\\\
pHead + f(pHead.next), & \mathrm{otherwise}
\end{cases}
$$


1.若链表为空，或者仅有一个结点，则直接返回；

2.若头结点是重复结点，则依次向后寻找与头结点值不相同的结点，对该结点进行递归；

3.若头结点不是重复结点，则对头结点的下一个结点进行递归。

```java
/*
public class ListNode {
   int val;
   ListNode next = null;

   ListNode(int val) {
       this.val = val;
   }
}
*/
class Solution {
    public ListNode deleteDuplication(ListNode pHead) {
        if (pHead == null || pHead.next == null) {
            return pHead;
        }
        if (pHead.val == pHead.next.val) {
            while (pHead.next != null && pHead.val == pHead.next.val) {
                pHead = pHead.next;
            }
            return deleteDuplication(pHead.next);
        }
        pHead.next = deleteDuplication(pHead.next);
        return pHead;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(n)。

### 方法二：迭代

思路：设置一个辅助头结点，便于处理头结点重复的情况。

```java
/*
 public class ListNode {
    int val;
    ListNode next = null;

    ListNode(int val) {
        this.val = val;
    }
}
*/
public class Solution {
    public ListNode deleteDuplication(ListNode pHead) {
        if (pHead == null || pHead.next == null) {
            return pHead;
        }
				
        ListNode head = new ListNode(0);
        head.next = pHead;
        ListNode pre = head, cur = head.next;
        
        while (cur != null && cur.next != null) {
            if (cur.val < cur.next.val) {
                pre = cur;
                cur = cur.next;
            } else {
                while (cur.next != null && cur.val == cur.next.val) {
                    cur = cur.next;
                }
                 pre.next = cur.next;
                 cur = cur.next;
            }
        } 
        return head.next;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(1)。