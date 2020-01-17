---
title: LeetCode 160.相交链表
date: 2020-01-15 15:40:51
tags: linked-list
categories: leetcode
mathjax: true
---

编写一个程序，找到两个单链表相交的起始节点。

<!--more-->

如下面的两个链表：

$$
\begin{align}
A: \qquad  a1 \rightarrow a2 &\\\\
						&\searrow \\\\
						& \quad c1 \rightarrow c2 \rightarrow c3 \\\\
						&\nearrow \\\\
B: b1 \rightarrow b2 \rightarrow b3
\end{align}
$$
在节点 c1 开始相交。

**示例 1：**

$$
\begin{align}
A: \qquad 4 \rightarrow 1 & \\\\
												 & \searrow \\\\
												 & \quad 8 \rightarrow 4 \rightarrow 5 \\\\
												 & \nearrow \\\\
B:5 \rightarrow 0 \rightarrow 1
\end{align}
$$

```
输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,0,1,8,4,5], skipA = 2, skipB = 3
输出：Reference of the node with value = 8
输入解释：相交节点的值为 8 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [4,1,8,4,5]，链表 B 为 [5,0,1,8,4,5]。在 A 中，相交节点前有 2 个节点；在 B 中，相交节点前有 3 个节点。
```

**示例 2：**

$$
\begin{align}
A: 0 \rightarrow 9 \rightarrow 1 & \\\\
                                 & \searrow \\\\
                                 & \quad 2 \rightarrow 4 \\\\
                                 & \nearrow \\\\
B: \qquad  \qquad 3
\end{align}
$$

```
输入：intersectVal = 2, listA = [0,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
输出：Reference of the node with value = 2
输入解释：相交节点的值为 2 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [0,9,1,2,4]，链表 B 为 [3,2,4]。在 A 中，相交节点前有 3 个节点；在 B 中，相交节点前有 1 个节点。
```

**示例 3：**
$$
A: 2 \rightarrow 6 \rightarrow 4 \\\\
B: \qquad 1 \rightarrow 5
$$

```
输入：intersectVal = 0, listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
输出：null
输入解释：从各自的表头开始算起，链表 A 为 [2,6,4]，链表 B 为 [1,5]。由于这两个链表不相交，所以 intersectVal 必须为 0，而 skipA 和 skipB 可以是任意值。
解释：这两个链表不相交，因此返回 null。
```

注意：

* 如果两个链表没有交点，返回 null。
* 在返回结果后，两个链表仍须保持原有的结构。
* 可假定整个链表结构中没有循环。
* 程序尽量满足 O(n) 时间复杂度，且仅用 O(1) 内存。

### 方法一：跳过多余节点

$$
\begin{align}
A: \overset{x}{\overbrace{a_1 \rightarrow a_2 \rightarrow \cdots \rightarrow a_x}} &\\\\
						&\searrow \\\\
						& \quad \underset{z}{\underbrace{c_1 \rightarrow \cdots \rightarrow c_z}} \\\\
						&\nearrow \\\\
B: \underset{y}{\underbrace{b_1 \rightarrow b_2 \rightarrow \cdots \rightarrow b_y}}
\end{align}
$$

假设链表A的长度大于B（即x > y），那么，只需要跳过链表A的前x - y个节点，然后再同时遍历链表A和B。当两个链表的当前节点相同时，该节点即为链表A和B相交的起始节点$c_1$。

时间复杂度：O(n)

空间复杂度：O(1)

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:

        if not headA or not headB:
            return None
        
        length1 = 0
        length2 = 0
        node1 = headA
        node2 = headB

        # 获取链表的长度
        while node1:
            node1 = node1.next
            length1 += 1
        
        while node2:
            node2 = node2.next
            length2 += 1
        
        # 跳过多余的节点
        node1 = headA
        node2 = headB
        for i in range(abs(length1-length2)):
            if length1 > length2:
                node1 = node1.next
            else:
                node2 = node2.next
        
        while node1:
            if node1 == node2:
                return node1
            node1 = node1.next
            node2 = node2.next
        return None
```

### 方法二：双指针法

$$
\begin{align}
A: \overset{x}{\overbrace{a_1 \rightarrow a_2 \rightarrow \cdots \rightarrow a_x}} &\\\\
						&\searrow \\\\
						& \quad \underset{z}{\underbrace{c_1 \rightarrow \cdots \rightarrow c_z}} \\\\
						&\nearrow \\\\
B: \underset{y}{\underbrace{b_1 \rightarrow b_2 \rightarrow \cdots \rightarrow b_y}}
\end{align}
$$

由于x + z + y = y + z + x，因此，如果同时遍历链表A和B，到达链表的末尾$c_2$时，再从另一个链表的起始位置$b_1$（$a_1$）开始遍历。当两个指针都走完x + y + z的距离时，下一个节点就是链表A和B相交的起始节点$c_1$。

时间复杂度：O(m + n)

空间复杂度：O(1)

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
        if not headA or not headB:
            return None

        node1 = headA
        node2 = headB
        while node1 != node2:
            if node1:
                node1 = node1.next
            else:
                node1 = headB
            
            if node2:
                node2 = node2.next
            else:
                node2 = headA
        return node1
```

使用Python的三元运算符：

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
        if not headA or not headB:
            return None
        
        node1 = headA
        node2 = headB
        while node1 != node2:
            node1 = node1.next if node1 else headB
            node2 = node2.next if node2 else headA  
        return node1
```

