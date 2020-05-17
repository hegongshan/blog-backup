---
title: Java集合框架之LinkedBlockingQueue
date: 2020-03-21 16:11:33
tags: java collections framework
categories: java
---

LinkedBlockingQueue是**基于单链表实现的有界阻塞队列**，它不允许值为null。

<!--more-->

### 存储结构

* 单链表

```java
static class Node<E> {
    E item;

    Node<E> next;

    Node(E x) { item = x; }
}
```

* 头尾结点

注意头结点head和尾结点last的不同之处：

1.head是一个辅助头结点，它的值为null，即head.item == null；

2.last是一个真实的尾结点，它的后继为null，即last.next == null。

```java
/**
 * Head of linked list.
 * Invariant: head.item == null
 */
transient Node<E> head;

/**
 * Tail of linked list.
 * Invariant: last.next == null
 */
private transient Node<E> last;

/** The capacity bound, or Integer.MAX_VALUE if none */
private final int capacity;

/** Current number of elements */
private final AtomicInteger count = new AtomicInteger();
```

### 锁

```java
/** Lock held by take, poll, etc */
private final ReentrantLock takeLock = new ReentrantLock();

/** Wait queue for waiting takes */
private final Condition notEmpty = takeLock.newCondition();

/** Lock held by put, offer, etc */
private final ReentrantLock putLock = new ReentrantLock();

/** Wait queue for waiting puts */
private final Condition notFull = putLock.newCondition();
```

### 构造方法

```java
// 默认的容量为2^31 - 1
public LinkedBlockingQueue() {
    this(Integer.MAX_VALUE);
}
public LinkedBlockingQueue(int capacity) {
    if (capacity <= 0) throw new IllegalArgumentException();
    this.capacity = capacity;
    // 头尾节点的值均为null
    last = head = new Node<E>(null);
}
```

### 入队操作

#### put方法

```java
public void put(E e) throws InterruptedException {
    // 不允许值为null
    if (e == null) throw new NullPointerException();
    // Note: convention in all put/take/etc is to preset local var
    // holding count negative to indicate failure unless set.
    int c = -1;
    Node<E> node = new Node<E>(e);
    final ReentrantLock putLock = this.putLock;
    final AtomicInteger count = this.count;
    // 允许被中断
    putLock.lockInterruptibly();
    try {
        /*
         * Note that count is used in wait guard even though it is
         * not protected by lock. This works because count can
         * only decrease at this point (all other puts are shut
         * out by lock), and we (or some other waiting put) are
         * signalled if it ever changes from capacity. Similarly
         * for all other uses of count in other wait guards.
         */
        // 若队列已满，则使当前线程处于等待状态
        while (count.get() == capacity) {
            notFull.await();
        }
        // 进队
        enqueue(node);
        // 先返回，再加1
        c = count.getAndIncrement();
        // 如果队列未满，则通知某个正在等待执行入队操作的线程
        if (c + 1 < capacity)
            notFull.signal();
    } finally {
        putLock.unlock();
    }
    // 如果原先队列为空，成功执行入队操作后，则通知某个正在等待执行出队操作的线程
    if (c == 0)
        signalNotEmpty();
}
```

实际的进队操作由enqueue方法完成

```java
private void enqueue(Node<E> node) {
    // assert putLock.isHeldByCurrentThread();
    // assert last.next == null;
    last = last.next = node;
}
```

enqueue方法采用了**链式赋值**，如果对Java链式赋值的顺序不太了解，可能会看不懂。它可以分解成以下两步：

```java
last.next = node;
last = last.next;
```

如果执行入队操作前，队列是空的，那么等到成功执行入队操作后，通知一个等待执行出队操作的线程。

```java
// 通知某个线程：队列不为空，可以执行出队操作
private void signalNotEmpty() {
    final ReentrantLock takeLock = this.takeLock;
    takeLock.lock();
    try {
        // 通知某个正在等待执行出队操作的线程
        notEmpty.signal();
    } finally {
        takeLock.unlock();
    }
}
```

#### offer方法

```java
public boolean offer(E e) {
    // 不允许值为null
    if (e == null) throw new NullPointerException();
    final AtomicInteger count = this.count;
    // 如果队列已满，则不允许入队
    if (count.get() == capacity)
        return false;
    int c = -1;
    Node<E> node = new Node<E>(e);
    final ReentrantLock putLock = this.putLock;
    putLock.lock();
    try {
        if (count.get() < capacity) {
            enqueue(node);
            c = count.getAndIncrement();
            // 如果队列未满
            if (c + 1 < capacity)
                notFull.signal();
        }
    } finally {
        putLock.unlock();
    }
    // 如果成功入队，则通知一个删除线程
    if (c == 0)
        signalNotEmpty();
    return c >= 0;
}
```

### 出队操作

#### take方法

```java
// 出队，并返回队首元素
public E take() throws InterruptedException {
    E x;
    int c = -1;
    final AtomicInteger count = this.count;
    final ReentrantLock takeLock = this.takeLock;
    // 允许被中断
    takeLock.lockInterruptibly();
    try {
        // 若队列已空，则使当前线程处于等待状态
        while (count.get() == 0) {
            notEmpty.await();
        }
        x = dequeue();
        c = count.getAndDecrement();
        // 如果队列仍不为空，则通知一个等待执行出队操作的线程
        if (c > 1)
            notEmpty.signal();
    } finally {
        takeLock.unlock();
    }
    // 若原来队列已满，则成功执行出队操作后，通知一个等待执行入队操作的线程
    if (c == capacity)
        signalNotFull();
    return x;
}
```

实际的出队操作由dequeue方法实现

```java
private E dequeue() {
    // assert takeLock.isHeldByCurrentThread();
    // assert head.item == null;
    Node<E> h = head;
    Node<E> first = h.next;
    h.next = h; // help GC
    head = first;
    E x = first.item;
    first.item = null;
    return x;
}
```

如果执行出队操作前，队列已经满了，那么等到成功执行出队操作后，通知一个等待执行入队操作的线程。

```java
// 通知某个线程：队列不满，可以执行入队操作
private void signalNotFull() {
    final ReentrantLock putLock = this.putLock;
    putLock.lock();
    try {
        notFull.signal();
    } finally {
        putLock.unlock();
    }
}
```

#### poll方法

```java
public E poll() {
    final AtomicInteger count = this.count;
    // 如果队列为空，则什么也不做
    if (count.get() == 0)
        return null;
    E x = null;
    int c = -1;
    final ReentrantLock takeLock = this.takeLock;
    takeLock.lock();
    try {
        // 再次判断队列是否为空，避免在加锁前，其他线程执行出队操作导致队列为空
        if (count.get() > 0) {
            x = dequeue();
            c = count.getAndDecrement();
            // 若队列仍不为空
            if (c > 1)
                notEmpty.signal();
        }
    } finally {
        takeLock.unlock();
    }
    if (c == capacity)
        signalNotFull();
    return x;
}
```

### 取队首元素

```java
public E peek() {
    if (count.get() == 0)
        return null;
    final ReentrantLock takeLock = this.takeLock;
    takeLock.lock();
    try {
        Node<E> first = head.next;
        if (first == null)
            return null;
        else
            return first.item;
    } finally {
        takeLock.unlock();
    }
}
```

