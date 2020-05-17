---
title: Java集合框架之队列Queue
date: 2020-03-18 13:01:44
tags: java collections framework
categories: java
---

队列是一种先进先出（First In First Out, FIFO）的数据结构。

<!--more-->

### Queue家族

正在绘制中...

### Queue源码

```java
public interface Queue<E> extends Collection<E> {
    // 在队尾添加元素
    boolean add(E e);
    boolean offer(E e);
  
    // 删除队首元素
    E remove();
    E poll();

    // 取队首元素的值（不删除）
    E element();
    E peek();
}
```



Deque源码

```java
public interface Deque<E> extends Queue<E> {
    void addFirst(E e);

    void addLast(E e);

    boolean offerFirst(E e);

    boolean offerLast(E e);

    E removeFirst();

    E removeLast();

    E pollFirst();

    E pollLast();

    E getFirst();

    E getLast();

    E peekFirst();

    E peekLast();

    boolean removeFirstOccurrence(Object o);


    boolean removeLastOccurrence(Object o);

    // *** Queue methods ***

    boolean add(E e);

    boolean offer(E e);

    E remove();

    E poll();

    E element();

    E peek();


    // *** Stack methods ***

    void push(E e);

    E pop();


    // *** Collection methods ***

    boolean remove(Object o);

    boolean contains(Object o);

    public int size();

    Iterator<E> iterator();

    Iterator<E> descendingIterator();

}
```

### 方法比较

|                        |              抛出异常               |     返回特殊值     |
| :--------------------: | :---------------------------------: | :----------------: |
|  入队（当队列已满时）  |   add将抛出IllegalStateException    | offer直接返回false |
|  出队（当队列为空时）  | remove将抛出NoSuchElementException  |    poll返回null    |
| 取队首（当队列为空时） | element将抛出NoSuchElementException |    peek返回null    |

### 实现类比较

|       实现类        | 存储结构 | 是否允许为null | 默认初始容量 |       扩容机制       | 是否线程安全 |
| :-----------------: | :------: | :------------: | :----------: | :------------------: | :----------: |
|     ArrayDeque      |   数组   |     不允许     |      16      |          2n          |  非线程安全  |
|     LinkedList      |  双链表  |    **允许**    |      —       |          —           |  非线程安全  |
|    PriorityQueue    |    堆    |     不允许     |      11      | n < 64 ? 2n +2: 1.5n |  非线程安全  |
| ArrayBlockingQueue  |   数组   |     不允许     |      —       |          —           |   线程安全   |
| LinkedBlockingQueue |  单链表  |     不允许     |   2^31 - 1   |          —           |   线程安全   |

