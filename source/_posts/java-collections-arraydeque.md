---
title: Java集合类之双端队列ArrayDeque
date: 2020-03-18 13:06:36
tags: java collections framework
categories: java
---

ArrayDeque是使用数组实现的双端队列，同时亦是一个循环队列，它不允许值为null。

<!--more-->

### 存储结构

```java
transient Object[] elements;
// 队首指针
transient int head;
// 队尾指针，指向队尾元素+1
transient int tail;
```

### 构造方法

* 默认的构造方法：**默认容量为16**。

```java
// 默认的容量为16
public ArrayDeque() {
    elements = new Object[16];
}
```

* 指定元素个数

```java
public ArrayDeque(int numElements) {
    allocateElements(numElements);
}
```

1.allocateElements方法用于计算队列的容量并初始化，其源码如下：

```java
private void allocateElements(int numElements) {
    elements = new Object[calculateSize(numElements)];
}
```

2.allocateElements方法调用了calculateSize方法，其与HashMap中的tableSizeFor方法类似，都是用于寻找大于numElements的最小的2的幂数，源码如下：

```java
private static int calculateSize(int numElements) {
    int initialCapacity = MIN_INITIAL_CAPACITY;
    // Find the best power of two to hold elements.
    // Tests "<=" because arrays aren't kept full.
    if (numElements >= initialCapacity) {
        initialCapacity = numElements;
        initialCapacity |= (initialCapacity >>>  1);
        initialCapacity |= (initialCapacity >>>  2);
        initialCapacity |= (initialCapacity >>>  4);
        initialCapacity |= (initialCapacity >>>  8);
        initialCapacity |= (initialCapacity >>> 16);
        initialCapacity++;
        // 如果向上溢出，则让initialCapacity为2 ^ 30
        if (initialCapacity < 0)   // Too many elements, must back off
            initialCapacity >>>= 1;// Good luck allocating 2 ^ 30 elements
    }
    return initialCapacity;
}
```

3.声明MIN_INITIAL_CAPACITY的源码如下：

```java
// 容量必须为2的幂数
private static final int MIN_INITIAL_CAPACITY = 8;
```

### 添加元素

ArrayDeque**不允许值为null**。

#### 在队尾添加

```java
public boolean offer(E e) {
    return offerLast(e);
}
public boolean offerLast(E e) {
    addLast(e);
    return true;
}
public void addLast(E e) {
    // 不允许值为null
    if (e == null)
        throw new NullPointerException();
    elements[tail] = e;
    // 如果队列已满，则扩容
    if ( (tail = (tail + 1) & (elements.length - 1)) == head)
        doubleCapacity();
}
```

注意这里的条件判断：`(tail = (tail + 1) & (elements.length - 1)) == head`

原本应该写成`(tail = (tail + 1) % elements.length == head`，但这里使用位运算代替了取模。

由于人为地规定ArrayDeque的容量必须为2的幂数。

这也是为什么在指定容量的构造方法中调用了calculateSize方法计算大于给定容量的最小的2的幂数。

#### 在队首添加

```java
public boolean offerLast(E e) {
    addLast(e);
    return true;
}
public void addFirst(E e) {
    // 不允许值为null
    if (e == null)
        throw new NullPointerException();
    elements[head = (head - 1) & (elements.length - 1)] = e;
    // 如果队列已满
    if (head == tail)
        doubleCapacity();
}
```

### 扩容操作

当队列已满时，将进行扩容，新的容量为原来的2倍。

```java
private void doubleCapacity() {
    assert head == tail;
    int p = head;
    int n = elements.length;
    int r = n - p; // number of elements to the right of p
    // 新的容量为原来的2倍
    int newCapacity = n << 1;
    // 如果向上溢出
    if (newCapacity < 0)
        throw new IllegalStateException("Sorry, deque too big");
    Object[] a = new Object[newCapacity];
    System.arraycopy(elements, p, a, 0, r);
    System.arraycopy(elements, 0, a, r, p);
    elements = a;
    head = 0;
    tail = n;
}
```

### 查询操作

#### 取队首

```java
public E peek() {
    return peekFirst();
}
@SuppressWarnings("unchecked")
public E peekFirst() {
    // elements[head] is null if deque empty
    return (E) elements[head];
}
```

#### 取队尾

由于tail指向队尾元素的下一个位置，因此，队尾元素的索引 = (tail - 1 + elements.length)  % elements.length。

```java
@SuppressWarnings("unchecked")
public E peekLast() {
    return (E) elements[(tail - 1) & (elements.length - 1)];
}
```

### 删除操作

#### 删除队首

```java
public E poll() {
    return pollFirst();
}
public E pollFirst() {
    int h = head;
    @SuppressWarnings("unchecked")
    E result = (E) elements[h];
    // Element is null if deque empty
    if (result == null)
        return null;
    elements[h] = null;     // Must null out slot
    head = (h + 1) & (elements.length - 1);
    return result;
}
```

#### 删除队尾

```java
public E pollLast() {
    // 计算队尾元素的下标
    int t = (tail - 1) & (elements.length - 1);
    @SuppressWarnings("unchecked")
    E result = (E) elements[t];
    // 若队列为空
    if (result == null)
        return null;
    elements[t] = null;
    tail = t;
    return result;
}
```

### 元素个数

在循环队列，元素的个数 = (tail - head + elements.length) % elements.length。

```java
public int size() {
    return (tail - head) & (elements.length - 1);
}
```

### 判空

```java
public boolean isEmpty() {
    return head == tail;
}
```