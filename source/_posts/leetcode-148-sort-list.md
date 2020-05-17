---
title: LeetCode 148.排序链表
date: 2019-04-26 18:39:59
tags: linked-list
categories: leetcode
---

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

### 问题分析

在八大排序算法中，只有快速排序、堆排序以及归并排序的时间复杂度为O(n log n)。

而在这三种排序算法中，归并排序是最适合用于对链表进行排序的算法。

### 方法一：递归

通过快慢指针，仅遍历一次链表就可以找到中间位置，将链表一分为二。

然后对得到的两个链表递归执行sortList方法，最后对两个有序链表进行二路归并。

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    // 合并两个有序链表
    public ListNode merge(ListNode p, ListNode q) {
        ListNode head = new ListNode(-1);
        ListNode r = head;
        while (p != null && q != null) {
            if (p.val < q.val) {
                r.next = p;
                r = p;
                p = p.next;
            } else {
                r.next = q;
                r = q;
                q = q.next;
            }
        }
        if (p != null) {
            r.next = p;
        }
        if (q != null) {
            r.next = q;
        }
        return head.next;
    }
    
    public ListNode sortList(ListNode head) {
        if (head == null || head.next == null) {
            return head;
        }
        // 通过快慢指针，寻找中间位置，将链表一分为二
        ListNode slow = head;
        ListNode fast = head.next;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }
        fast = slow.next;
        slow.next = null;
        return merge(sortList(head), sortList(fast));
        
        // ListNode pre = null;
        // ListNode slow, fast;
        // slow = fast = head;
        // while (fast != null && fast.next != null) {
        //     pre = slow;
        //     slow = slow.next;
        //     fast = fast.next.next;
        // }
        // pre.next = null;
        // return merge(sortList(head), sortList(slow));
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(n)。其中，n为链表的长度。

### 方法二：迭代

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode sortList(ListNode head) {
        if (head == null || head.next == null) {
            return head;
        }

        ListNode dummy = new ListNode(-1);
        dummy.next = head;

        ListNode node, pre;
        int len = getLength(head);
        for (int i = 1; i < len; i <<= 1) {
            // pre指向当前正在处理的子链表的前一个结点
            pre = dummy;
            node = dummy.next;
            while (node != null) {
                ListNode first = node;
                ListNode firstTail = split(first, i);

                ListNode second = firstTail.next;
                firstTail.next = null;

                // 如果没有另一部分与first配对
                if (second == null) {
                    break;
                }

                ListNode secondTail = split(second, i);
                node = secondTail.next;
                secondTail.next = null;

                // 合并first与second
                ListNode cur = merge(first, second);
                // 获取合并后的子链表cur的尾结点
                ListNode tail = cur;
                while (tail != null && tail.next != null) {
                    tail = tail.next;
                }
                // 将cur与之前的链表连接在一起
                pre.next = cur;
                tail.next = node;

                pre = tail;
            }
        }
        return dummy.next;
    }

    public int getLength(ListNode node) {
        int len = 0;
        while (node != null) {
            len++;
            node = node.next;
        }
        return len;
    }

    // 当剩余部分的长度不足len时，返回剩余部分的尾结点；
    // 否则，返回从node开始，长度为len的子链表的尾结点。
    private ListNode split(ListNode node, int len) {
        int i = 1;
        while (i < len && node != null && node.next != null) {
            node = node.next;
            i++;
        }
        return node;
    }

    private ListNode merge(ListNode node1, ListNode node2) {
        ListNode dummy = new ListNode(-1);
        ListNode tail = dummy;
        while (node1 != null && node2 != null) {
            if (node1.val <= node2.val) {
                tail.next = node1;
                tail = node1;
                node1 = node1.next;
            } else {
                tail.next = node2;
                tail = node2;
                node2 = node2.next;
            }
        }
        tail.next = node1 != null ? node1 : node2;
        return dummy.next;
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(1)。其中，n为链表的长度。

<hr/>

2020年3月9日，博主在面试支付宝搜索团队时，遇到了这个题目，可惜当时只写出了O(n^2)的解法=_=。

