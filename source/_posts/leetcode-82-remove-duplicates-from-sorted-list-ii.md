---
title: LeetCode 82.删除排序链表中的重复元素 II
date: 2019-02-27 17:42:40
tags: linked-list
categories: leetcode
---

### 题目描述

给定一个排序链表，删除所有含有重复数字的节点，只保留原始链表中 *没有重复出现* 的数字。

**示例 1:**

```
输入: 1->2->3->3->4->4->5
输出: 1->2->5
```

**示例 2:**

```
输入: 1->1->1->2->3
输出: 2->3
```

<!--more-->

### 解决方案

#### 方法一：递归法

* 思路

按照递归的思想，该题可以分为以下三种情况：

1）待处理的排序链表为空，或者仅含有一个元素。此时，直接返回排序链表的头节点head即可。

2）待处理的排序链表头部节点head的值为重复元素head.val。此时，依次遍历链表，直至找到第一个值不等于head.val的节点node，对node递归执行deleteDuplicates方法。

3）第一个节点head的值不是重复元素。此时，对第二个节点递归执行deleteDuplicates方法即可，产生的新链表成为head的后继。

* 算法实现

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        //1.如果链表为空或者仅含一个节点
        if(head == null || head.next == null) {
			return head;
		}
		//2.如果链表的头部是重复出现的数字
		if(head.val == head.next.val) {
			while(head.next != null && head.val == head.next.val) {
				head = head.next;
			}
			return deleteDuplicates(head.next);
		}
        //3.如果链表首部节点不需要删除
		head.next = deleteDuplicates(head.next);
		return head;
    }
}
```

* 复杂度分析

设链表的长度为*L*

时间复杂度：*O*(*L*)，仅对链表执行一次遍历操作

空间复杂度：*O(1)*，没有使用额外的变量

* 算法效率

执行用时：1ms，战胜 98.69 % 的 java 提交记录

内存消耗：38.6 MB

#### 方法二：非递归法

* 思路

首先我们仍将判断待处理的排序链表是否为空，或仅含有一个节点。

然后，我们将添加一个哑结点list作为辅助，该结点位于列表头部。哑结点用来简化某些极端情况，例如，需要删除链表的头部。

在遍历链表的同时，使用while循环寻找与当前节点node值不相等的第一个节点，若while循环得以成功执行，则让得到的新节点成为head的后继；否则，当前节点node与其后继节点值不相等，while循环未被执行，则该节点不需要被删除，head后移。

* 算法实现

```java
/*public class ListNode {
    int val;
    ListNode next;
    ListNode(int x) { val = x; }
}*/
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        if(head == null || head.next == null) {
			return head;
		}
		ListNode list = new ListNode(0);
		list.next = head;
		head = list;
		ListNode pre,node;
		while(head.next != null) {
			pre = head.next;
			node = pre;
			while(node.next != null && pre.val == node.next.val) {
				node = node.next;
			}
			if(node == pre) {
				head = head.next;
			} else {
				head.next = node.next;
			}
		}
		return list.next;
    }
}
```

* 复杂度分析

设链表的长度为*L*

时间复杂度：*O(L)*，仅对链表执行一次遍历操作

空间复杂度：*O*(1)，我们只用了常量级的额外空间

- 算法效率

执行用时：1ms，战胜 98.69 % 的 java 提交记录

内存消耗：35.2 MB



