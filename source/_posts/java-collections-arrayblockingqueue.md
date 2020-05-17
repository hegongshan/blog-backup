---
title: Java集合框架之ArrayBlockingQueue
date: 2020-03-20 15:08:55
tags: java collections framework
categories: java
---

ArrayBlockingQueue是一个**基于数组实现的有界阻塞队列**，它不允许值为null。

<!--more-->

### 存储结构

```java
/** The queued items */
final Object[] items;

/** items index for next take, poll, peek or remove */
int takeIndex;

/** items index for next put, offer, or add */
int putIndex;

/** Number of elements in the queue */
int count;
```

### 锁

```java
 /** Main lock guarding all access */
final ReentrantLock lock;

/** Condition for waiting takes */
private final Condition notEmpty;

/** Condition for waiting puts */
private final Condition notFull;
```

### 构造方法

```java
// 默认使用非公平锁
public ArrayBlockingQueue(int capacity) {
    this(capacity, false);
}
public ArrayBlockingQueue(int capacity, boolean fair) {
    if (capacity <= 0)
        throw new IllegalArgumentException();
    this.items = new Object[capacity];
    lock = new ReentrantLock(fair);
    notEmpty = lock.newCondition();
    notFull =  lock.newCondition();
}
public ArrayBlockingQueue(int capacity, boolean fair,
                          Collection<? extends E> c) {
    this(capacity, fair);

    final ReentrantLock lock = this.lock;
    lock.lock(); // Lock only for visibility, not mutual exclusion
    try {
        int i = 0;
        try {
            for (E e : c) {
                checkNotNull(e);
                items[i++] = e;
            }
        } catch (ArrayIndexOutOfBoundsException ex) {
            throw new IllegalArgumentException();
        }
        count = i;
        putIndex = (i == capacity) ? 0 : i;
    } finally {
        lock.unlock();
    }
}
```

### 进队

#### put方法

```java
public void put(E e) throws InterruptedException {
    checkNotNull(e);
    final ReentrantLock lock = this.lock;
    // 允许被中断
    lock.lockInterruptibly();
    try {
        // 如果队列已满，则等待
        while (count == items.length)
            notFull.await();
        enqueue(e);
    } finally {
        lock.unlock();
    }
}
// 不允许值为null
private static void checkNotNull(Object v) {
    if (v == null)
        throw new NullPointerException();
}
```

实际的进队操作由enqueue方法实现。

```java
private void enqueue(E x) {
    // assert lock.getHoldCount() == 1;
    // assert items[putIndex] == null;
    final Object[] items = this.items;
    items[putIndex] = x;
    if (++putIndex == items.length)
        putIndex = 0;
    count++;
    // 唤醒一个正在等待执行出队操作的线程
    notEmpty.signal();
}
```

#### offer方法

```java
public boolean offer(E e) {
    checkNotNull(e);
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        // 若队列已满，则不允许插入
        if (count == items.length)
            return false;
        else {
            enqueue(e);
            return true;
        }
    } finally {
        lock.unlock();
    }
}
```

### 出队

#### take方法

```java
public E take() throws InterruptedException {
    final ReentrantLock lock = this.lock;
    // 允许中断
    lock.lockInterruptibly();
    try {
        // 当队列为空时，等待
        while (count == 0)
            notEmpty.await();
        return dequeue();
    } finally {
        lock.unlock();
    }
}
```

实际的出队操作由dequeue方法实现。

```java
private E dequeue() {
    // assert lock.getHoldCount() == 1;
    // assert items[takeIndex] != null;
    final Object[] items = this.items;
    @SuppressWarnings("unchecked")
    E x = (E) items[takeIndex];
    items[takeIndex] = null;
    if (++takeIndex == items.length)
        takeIndex = 0;
    count--;
    if (itrs != null)
        itrs.elementDequeued();
    // 唤醒一个正在等待执行入队操作的线程
    notFull.signal();
    return x;
}
```

#### poll方法

poll方法不允许被中断，如果某个线程正在等待执行poll方法。如果队列为空，则不允许执行出队操作，直接返回null，什么也不发生。

```java
public E poll() {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        return (count == 0) ? null : dequeue();
    } finally {
        lock.unlock();
    }
}
```

### 取队首

```java
public E peek() {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        return itemAt(takeIndex); // null when queue is empty
    } finally {
        lock.unlock();
    }
}
@SuppressWarnings("unchecked")
final E itemAt(int i) {
    return (E) items[i];
}
```

### 方法比较

* 入队操作

put方法：允许被中断。当队列已满时，使当前线程处于等待状态，直到接到notFull的通知，才能执行入队操作。

offer方法：不允许被中断。当队列已满时，则不允许执行入队操作。

* 出队操作

take方法：允许被中断。当队列为空时，使当前线程处于等待状态，直到接到notEmpty的通知，才能执行出队操作。

poll方法：不允许被中断。当队列为空时，则不允许执行出队操作。