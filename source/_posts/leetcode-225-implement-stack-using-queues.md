---
title: LeetCode 225.用队列实现栈/《剑指offer》9(相关).用两个队列实现栈
date: 2020-02-16 21:49:12
tags: [stack, queue]
categories: leetcode
---

使用队列实现栈的下列操作：

* push(x) -- 元素 x 入栈
* pop() -- 移除栈顶元素
* top() -- 获取栈顶元素
* empty() -- 返回栈是否为空

<!--more-->

**注意:**

* 你只能使用队列的基本操作-- 也就是 push to back, peek/pop from front, size, 和 is empty 这些操作是合法的。
* 你所使用的语言也许不支持队列。 你可以使用 list 或者 deque（双端队列）来模拟一个队列 , 只要是标准的队列操作即可。
* 你可以假设所有操作都是有效的（例如, 对一个空的栈不会调用 pop 或者 top 操作）。

### 方法一：两个队列，入栈O(1)，出栈O(n)

思路：使用两个队列q1和q2。

1.当需要执行进栈操作时，直接将该元素压入q1。

2.当需要执行出栈（取栈顶元素）操作时，

首先，判断q1中的元素个数是否大于1。

如果刚好等于1，则直接弹出（返回）q1的队首元素；

如果大于1，则将q1中的元素逐一弹出，并加到q2中，直到q1中的元素个数等于1，然后弹出（返回）该元素。

最后，交换q1和q2，保证所有的元素均存储在q1中，而q2为空。

3.判断栈是否为空：由于所有的元素都在q1中，因此，只需要判断q1是否为空即可。

```java
class MyStack {
    private Queue<Integer> q1;
    private Queue<Integer> q2;
    /** Initialize your data structure here. */
    public MyStack() {
        q1 = new LinkedList<>();
        q2 = new LinkedList<>();
    }
    
    /** Push element x onto stack. */
    public void push(int x) {
        q1.offer(x);
    }
    
    /** Removes the element on top of the stack and returns that element. */
    public int pop() {
        while(q1.size() > 1) {
            q2.offer(q1.poll());
        }
        int x = q1.poll();
        Queue<Integer> temp = q1;
        q1 = q2;
        q2 = temp;
        return x;
    }
    
    /** Get the top element. */
    public int top() {
        while(q1.size() > 1) {
            q2.offer(q1.poll());
        }
        int x =  q1.poll();
        q2.offer(x);
        Queue<Integer> temp = q1;
        q1 = q2;
        q2 = temp;
        return x;
    }
    
    /** Returns whether the stack is empty. */
    public boolean empty() {
        return q1.isEmpty();
    }
}
```

### 方法二：两个队列，入栈O(n)，出栈O(1)

思路：使用两个队列q1和q2。

1.当需要执行进栈操作时，

首先，将待添加的元素x压入q2（x在q2的队尾）；

然后，将q1中的元素逐一弹出，并加到q2中（x在q2的队首）；

最后，交换q1和q2，保证所有的元素均存储在q1中，而q2为空。

2.当需要执行出栈（取栈顶元素）操作时，直接弹出（返回）q1的队首元素。

3.判断栈是否为空：由于所有的元素都在q1中，因此，只需要判断q1是否为空即可。

```java
class MyStack {
    private Queue<Integer> q1;
    private Queue<Integer> q2;
    /** Initialize your data structure here. */
    public MyStack() {
        q1 = new LinkedList<>();
        q2 = new LinkedList<>();
    }
    
    /** Push element x onto stack. */
    public void push(int x) {
        q2.offer(x);
        while(!q1.isEmpty()) {
            q2.offer(q1.poll());
        }
        Queue<Integer> temp = q1;
        q1 = q2;
        q2 = temp;
    }
    
    /** Removes the element on top of the stack and returns that element. */
    public int pop() {
        return q1.poll();
    }
    
    /** Get the top element. */
    public int top() {     
        return q1.peek();
    }
    
    /** Returns whether the stack is empty. */
    public boolean empty() {
        return q1.isEmpty();
    }
}
```

### 方法三：一个队列，入栈O(n)，出栈O(1)

思路：仅使用一个普通队列q。

1.当需要执行进栈操作时，

首先，将待添加的元素x压入q中（x在队尾）；

然后，将x前面的所有元素逐一弹出，并重新压入q中（x在队首）。

2.当需要执行出栈（取栈顶元素）操作时，直接弹出（返回）q的队首元素。

3.判断栈是否为空：只需要判断q是否为空即可。

```java
class MyStack {
    private Queue<Integer> q;
    /** Initialize your data structure here. */
    public MyStack() {
        q = new LinkedList<>();
    }
    
    /** Push element x onto stack. */
    public void push(int x) {
        q.offer(x);
        for(int size = q.size(); size > 1; size--) {
            q.offer(q.poll());
        }
    }
    
    /** Removes the element on top of the stack and returns that element. */
    public int pop() {
        return q.poll();
    }
    
    /** Get the top element. */
    public int top() {     
        return q.peek();
    }
    
    /** Returns whether the stack is empty. */
    public boolean empty() {
        return q.isEmpty();
    }
}
```

