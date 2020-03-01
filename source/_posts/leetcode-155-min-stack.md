---
title: LeetCode 155.最小栈/《剑指Offer》30.包含min函数的栈
date: 2020-03-02 20:05:30
tags: stack
categories: leetcode
---

设计一个支持 push，pop，top 操作，并能在常数时间内检索到最小元素的栈。

* push(x) -- 将元素 x 推入栈中。
* pop() -- 删除栈顶的元素。
* top() -- 获取栈顶元素。
* getMin() -- 检索栈中的最小元素。

<!--more-->

示例:

```java
MinStack minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
minStack.getMin();   --> 返回 -3.
minStack.pop();
minStack.top();      --> 返回 0.
minStack.getMin();   --> 返回 -2.
```

### 方法一：顺序栈

难点：在常数时间内检索到最小元素。

解决方法：使用两个栈，dataStack用于存储数据，minStack用于存储从dataStack对应位置的元素到dataStack底部这一部分元素中的最小值。

![](/static/images/leetcode-155.png)

```java
class MinStack {
    // 成员变量
    private Stack<Integer> dataStack;
    private Stack<Integer> minStack;

    /** initialize your data structure here. */
    public MinStack() {
       dataStack = new Stack<>();
       minStack = new Stack<>();
    }
    
    public void push(int x) {
        dataStack.push(x);
        if(minStack.empty() || x < minStack.peek()) {
            minStack.push(x);
        } else {
            minStack.push(minStack.peek());
        }
    }
    
    public void pop() {
        dataStack.pop();
        minStack.pop();
    }
    
    public int top() {
       return dataStack.peek();
    }
    
    public int getMin() {
        return minStack.peek();
    }
}
```

### 方法二：链栈

```java
import java.util.EmptyStackException;
class MinStack {
    private Node head;
    public MinStack() {}

    public void push(int x) {
        if(head == null) {
            head = new Node(x, x, null);
        } else {
            // 头插法
            Node node = new Node(x, Math.min(x, head.min), head);
            head = node;
        }
    }

    public void pop() {
        if(head == null) {
            return ;
        }
        Node node = head;
        head = head.next;
        // 删除栈顶元素
        node = null;
    }

    public int top() {
        if(head == null) {
            throw new EmptyStackException();
        }
        return head.val;
    }

    public int getMin() {
        if(head == null) {
            throw new EmptyStackException();
        }
        return head.min;
    }

    static class Node {
        int val;
        // 存储从该结点到栈底的最小值
        int min;
        Node next;
        Node(int val, int min, Node next) {
            this.val = val;
            this.min = min;
            this.next = next;
        }
    }
}
```

