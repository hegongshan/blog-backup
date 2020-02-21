---
title: LeetCode 232.用栈实现队列/《剑指Offer》9.用两个栈实现队列
date: 2020-02-15 15:19:58
tags: [stack, queue]
categories: leetcode
---

使用栈实现队列的下列操作：

* push(x) -- 将一个元素放入队列的尾部。
* pop() -- 从队列首部移除元素。
* peek() -- 返回队列首部的元素。
* empty() -- 返回队列是否为空。

<!--more-->

**示例:**

```java
MyQueue queue = new MyQueue();

queue.push(1);
queue.push(2);  
queue.peek();  // 返回 1
queue.pop();   // 返回 1
queue.empty(); // 返回 false
```

**说明:**

* 你只能使用标准的栈操作 -- 也就是只有 `push to top`, `peek/pop from top`, `size`, 和 `is empty` 操作是合法的。
* 你所使用的语言也许不支持栈。你可以使用 list 或者 deque（双端队列）来模拟一个栈，只要是标准的栈操作即可。
* 假设所有操作都是有效的 （例如，一个空的队列不会调用 pop 或者 peek 操作）。

### 方法一：入队O(1)，出队O(n)

思路：使用两个栈s1和s2来模拟队列，s1负责模拟队列的入队操作，s2负责模拟队列的出队和取队首元素操作。

1.当需要执行入队操作时，直接将该元素压入s1。

2.当需要执行出队（取队首）操作时：

首先，判断s2是否为空，若不为空，则直接弹出s2的栈顶元素；

否则，先将s1中的所有元素逐一出栈，并加入到s2中，然后弹出（取出）s2的栈顶元素。

3.判断队列是否为空：当s1和s2均为空时，队列为空。

```java
class MyQueue {

    private Stack<Integer> s1;
    private Stack<Integer> s2;

    /** Initialize your data structure here. */
    public MyQueue() {
        s1 = new Stack<>();
        s2 = new Stack<>();
    }
    
    /** Push element x to the back of queue. */
    public void push(int x) {
        s1.push(x);
    }
    
    /** Removes the element from in front of queue and returns that element. */
    public int pop() {
        if(!s2.empty()) {
            return s2.pop();
        }
        while(!s1.empty()) {
            s2.push(s1.pop());
        }
        return s2.pop();
    }
    
    /** Get the front element. */
    public int peek() {
        if(!s2.empty()) {
            return s2.peek();
        }
        while(!s1.empty()) {
            s2.push(s1.pop());
        }
        return s2.peek();
    }

    /** Returns whether the queue is empty. */
    public boolean empty() {
        return s1.empty() && s2.empty();
    }
}
```

### 方法二：入队O(n)，出队O(1)

思路：使用两个栈s1和s2来模拟队列。

1.当需要执行入队操作时，

首先，判断s2是否为空，若s2不为空，则将s2中的所有元素逐一出栈，并加入到s1中；

然后，将待添加的元素压入s1；

最后，将s1中的所有元素逐一出栈，并加入到s2中。

2.当需要执行出队（取队首）操作时，直接弹出（返回）s2的栈顶元素。

3.判断队列是否为空：由于所有元素都在s2中，因此，只需要判断s2是否为空即可。

```java
class MyQueue {

    private Stack<Integer> s1;
    private Stack<Integer> s2;

    /** Initialize your data structure here. */
    public MyQueue() {
        s1 = new Stack<>();
        s2 = new Stack<>();
    }
    
    /** Push element x to the back of queue. */
    public void push(int x) {
        while(!s2.empty()) {
            s1.push(s2.pop());
        }
        s1.push(x);
        while(!s1.empty()) {
            s2.push(s1.pop());
        }
    }
    
    /** Removes the element from in front of queue and returns that element. */
    public int pop() {
        return s2.pop();
    }
    
    /** Get the front element. */
    public int peek() {
        return s2.peek();
    }

    /** Returns whether the queue is empty. */
    public boolean empty() {
        return s2.empty();
    }
}
```

