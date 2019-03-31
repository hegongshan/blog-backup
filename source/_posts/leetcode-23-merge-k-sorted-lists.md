---
title: LeetCode 23.合并K个排序链表
date: 2019-02-22 12:31:13
tags: linked-list
categories: leetcode
mathjax: true
---

### 题目描述

合并 *k* 个排序链表，返回合并后的排序链表。请分析和描述算法的复杂度。

**示例:**

```
输入:
[
  1->4->5,
  1->3->4,
  2->6
]
输出: 1->1->2->3->4->4->5->6
```

<!--more-->

### 算法思路

已知K个有序链表，采用二路归并实现两个链表的合并，在此基础上，按照折半查找的思想，递归执行二路归并。

### 算法实现

```java
public class MergeKSortedLists23 {
	public class ListNode {
    	int val;
     	ListNode next;
     	ListNode(int x) { val = x; }
    }

    public ListNode mergeKLists(ListNode[] lists) {
    	if(lists == null || lists.length == 0) {
    		return null;
    	}
    	if(lists.length == 1) {
    		return lists[0];
    	}

        return merge(lists,0,lists.length-1);
    }
    
    public ListNode merge(ListNode[] lists,int start,int end) {
    	if(start > end) {
    		return null;
    	}
    	if(start == end) {
    		return lists[start];
    	}
    	int mid = (start + end) / 2;
    	ListNode l1 = merge(lists,start,mid);
    	ListNode l2 = merge(lists,mid+1,end);
    	return mergeTwoLists(l1,l2);
    }
    
    public ListNode mergeTwoLists(ListNode l1,ListNode l2) {
    	ListNode head = new ListNode(0);
    	ListNode p = l1, q=l2,node,rear = head;
    	while(p != null && q != null) {
    		if(p.val <= q.val) {
    			node = new ListNode(p.val);
    			p = p.next;
    		} else {
    			node = new ListNode(q.val);
    			q = q.next;
    		}
    		node.next = null;
    		rear.next = node;
			rear = node;
    	}
    	if(p != null) {
    		rear.next = p;
    		rear = p;
    	}
    	if(q != null) {
    		rear.next = q;
    		rear = q;
    	}
    	return head.next;
    }
}
```

### 复杂度分析

时间复杂度：O($n\log_2n​$)

空间复杂度：O($n​$)

### 算法效率

执行用时: 11 ms, 在Merge k Sorted Lists的Java提交中击败了92.02% 的用户

内存消耗: 28.5 MB, 在Merge k Sorted Lists的Java提交中击败了80.66% 的用户