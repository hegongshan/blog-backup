---
title: Java集合框架之延时队列DelayQueue
date: 2020-03-22 13:14:38
tags: java collections framework
categories: java
---

DelayQueue是一个**基于优先队列实现的无界阻塞队列**，它不允许值为null。只有当DelayQueue中的元素已经过期时，这个元素才能被删除。

<!--more-->

### 继承结构

```java
public class DelayQueue<E extends Delayed> extends AbstractQueue<E>
    implements BlockingQueue<E>
```

DelayQueue中的元素必须实现Delayed接口，该接口中只有一个方法：

```java
// 如果返回值<=0，表示该对象已经过期
long getDelay(TimeUnit unit);
```

### 存储结构

```java
private final PriorityQueue<E> q = new PriorityQueue<E>();
```

关于排序顺序，在DelayQueue的注释中有如下描述：

> The <em>head</em> of the queue is that {@code Delayed} element whose delay expired furthest in the past.

这句话不太好直译，大概意思是：队首元素是距离过期时间最短的元素。

### 锁与条件

```java
private final transient ReentrantLock lock = new ReentrantLock();
private final Condition available = lock.newCondition();
```

### Leader与Follower

```java
private Thread leader = null;
```

leader表示一个等待删除队首元素的线程。如果leader不为空，则表示已经有线程在等待删除队首元素。此时，如果当前线程也想删除队首元素，则必须等待leader执行完出队操作。

### 入队操作

由于DelayQueue是无界的，因此，入队操作不会被阻塞。

```java
public void put(E e) {
    offer(e);
}
public boolean offer(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        q.offer(e);
        // 若本次插入操作改变了队首元素
        if (q.peek() == e) {
            leader = null;
            available.signal();
        }
        return true;
    } finally {
        lock.unlock();
    }
}
```

### 出队操作

#### take方法

如果队首元素没有到达规定的延时时间（过期），那么让当前线程处于等待状态，即阻塞当前线程。

```java
// 一直等到队首元素过期，并被删除为止
public E take() throws InterruptedException {
    final ReentrantLock lock = this.lock;
    // 允许被中断
    lock.lockInterruptibly();
    try {
        // 自旋
        for (;;) {
            E first = q.peek();
            // 若队列为空，则让当前线程处于等待状态
            if (first == null)
                available.await();
            else {
                long delay = first.getDelay(NANOSECONDS);
                // 如果队首元素已经过期
                if (delay <= 0)
                    return q.poll();
                first = null; // don't retain ref while waiting
                // 如果已经有其他线程在等待删除队首元素，则让当前线程处于等待状态
                if (leader != null)
                    available.await();
                else {
                    Thread thisThread = Thread.currentThread();
                    leader = thisThread;
                    try {
                        available.awaitNanos(delay);
                    } finally {
                        // 若在等待期间，队首元素未被改变
                        if (leader == thisThread)
                            leader = null;
                    }
                }
            }
        }
    } finally {
        // 如果leader为空，并且队首元素出队后，队列仍不为空
        // 则通知某个线程，可以继续执行出队操作
        if (leader == null && q.peek() != null)
            available.signal();
        lock.unlock();
    }
}
```

#### poll方法

```java
public E poll() {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        E first = q.peek();
        // 如果队列为空，或者队首元素的延迟时间未到，则什么也不做
        if (first == null || first.getDelay(NANOSECONDS) > 0)
            return null;
        else
            return q.poll();
    } finally {
        lock.unlock();
    }
}
```

