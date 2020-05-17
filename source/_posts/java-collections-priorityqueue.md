---
title: Java集合框架之优先队列PriorityQueue
date: 2020-03-19 20:00:27
tags: java collections framework
categories: java
---

PriorityQueue是基于堆的无界队列，它不遵循先进先出的原则，队首元素是按照指定顺序排序后的第一个元素。它不允许值为null。

<!--more-->

### 存储结构

```java
// 由于Java使用的是类型擦除式泛型，因此不允许直接定义泛型数组
transient Object[] queue;
```

### 常量

```java
// 默认的初始化容量为11
private static final int DEFAULT_INITIAL_CAPACITY = 11;

// 如果为null，则使用自然顺序（递增）
private final Comparator<? super E> comparator;
```

### 构造方法

```java
public PriorityQueue() {
    this(DEFAULT_INITIAL_CAPACITY, null);
}
public PriorityQueue(int initialCapacity) {
    this(initialCapacity, null);
}
public PriorityQueue(int initialCapacity,
                     Comparator<? super E> comparator) {
    // Note: This restriction of at least one is not actually needed,
    // but continues for 1.5 compatibility
    if (initialCapacity < 1)
        throw new IllegalArgumentException();
    this.queue = new Object[initialCapacity];
    this.comparator = comparator;
}
```

### 插入操作

PriorityQueue要求插入的元素必须是可比较的，即要么实现了Comparable接口，要么在构造方法中指定了Comparator。否则，将抛出类型转换异常。

```java
public boolean offer(E e) {
    // 1.不允许值为null
    if (e == null)
        throw new NullPointerException();
    modCount++;
    int i = size;
    // 2.如果队列已满，则进行扩容
    if (i >= queue.length)
        grow(i + 1);
    size = i + 1;
    // 3.如果队列为空
    if (i == 0)
        queue[0] = e;
    else
        siftUp(i, e); // 寻找插入位置
    return true;
}
```

当队列不为空时，需要向上寻找当前结点的插入位置，该操作由siftUp方法实现。

```java
private void siftUp(int k, E x) {
    if (comparator != null)
        siftUpUsingComparator(k, x);
    else
        siftUpComparable(k, x);
}

@SuppressWarnings("unchecked")
private void siftUpComparable(int k, E x) {
    Comparable<? super E> key = (Comparable<? super E>) x;
    while (k > 0) {
        // 计算父结点的下标（索引从0开始）
        int parent = (k - 1) >>> 1;
        Object e = queue[parent];
        // 如果待插入结点的值“大于”父结点的值
        if (key.compareTo((E) e) >= 0)
            break;
        // 父结点下移
        queue[k] = e;
        k = parent;
    }
    queue[k] = key;
}

@SuppressWarnings("unchecked")
private void siftUpUsingComparator(int k, E x) {
    while (k > 0) {
        int parent = (k - 1) >>> 1;
        Object e = queue[parent];
        if (comparator.compare(x, (E) e) >= 0)
            break;
        queue[k] = e;
        k = parent;
    }
    queue[k] = x;
}
```

由于根结点的下标为0，因此，下标为i的结点，它的左孩子的下标为2i + 1，右孩子的下标为2i + 2。

反过来，如果当前结点的下标为k，那么父结点的下标为(k - 1) / 2。

### 扩容机制

如果原来的容量oldCapacity < 64，则新的容量newCapacity = 2 * oldCapacity + 2；

否则，新的容量newCapacity = 1.5 * oldCapacity。

```java
private void grow(int minCapacity) {
    int oldCapacity = queue.length;
    // Double size if small; else grow by 50%
    int newCapacity = oldCapacity + ((oldCapacity < 64) ?
                                     (oldCapacity + 2) :
                                     (oldCapacity >> 1));
    // overflow-conscious code
    if (newCapacity - MAX_ARRAY_SIZE > 0)
        newCapacity = hugeCapacity(minCapacity);
    queue = Arrays.copyOf(queue, newCapacity);
}
```

这里调用了hugeCapacity方法，用于处理容量溢出。

```java
private static int hugeCapacity(int minCapacity) {
    if (minCapacity < 0) // overflow
        throw new OutOfMemoryError();
    return (minCapacity > MAX_ARRAY_SIZE) ?
        Integer.MAX_VALUE :
        MAX_ARRAY_SIZE;
}
```

### 删除操作

```java
@SuppressWarnings("unchecked")
public E poll() {
    // 1.如果队列为空
    if (size == 0)
        return null;
    int s = --size;
    modCount++;
    E result = (E) queue[0];
    E x = (E) queue[s];
    // 删除最后一个结点
    queue[s] = null;
    // 如果队列中至少有2个结点，则向下寻找插入位置
    if (s != 0)
        siftDown(0, x);
    return result;
}
```

当队列中的元素个数>=2时，需要向下寻找当前结点的插入位置，该操作由siftDown方法实现。

```java
private void siftDown(int k, E x) {
    if (comparator != null)
        siftDownUsingComparator(k, x);
    else
        siftDownComparable(k, x);
}

@SuppressWarnings("unchecked")
private void siftDownComparable(int k, E x) {
    Comparable<? super E> key = (Comparable<? super E>)x;
    // 堆是一棵完全二叉树
    int half = size >>> 1;        // loop while a non-leaf
    while (k < half) {
        int child = (k << 1) + 1; // assume left child is least
        Object c = queue[child];
        int right = child + 1;
        // 如果该结点有右孩子，并且左孩子比右孩子“大”
        if (right < size &&
            ((Comparable<? super E>) c).compareTo((E) queue[right]) > 0)
            c = queue[child = right];
        // 如果该结点的值“小于” 左右孩子中的较小者，则表示找到了它的位置
        if (key.compareTo((E) c) <= 0)
            break;
        // 用左右孩子中的较小者取代该结点的位置，继续向下寻找
        queue[k] = c;
        k = child;
    }
    queue[k] = key;
}

@SuppressWarnings("unchecked")
private void siftDownUsingComparator(int k, E x) {
    int half = size >>> 1;
    while (k < half) {
        int child = (k << 1) + 1;
        Object c = queue[child];
        int right = child + 1;
        if (right < size &&
            comparator.compare((E) c, (E) queue[right]) > 0)
            c = queue[child = right];
        if (comparator.compare(x, (E) c) <= 0)
            break;
        queue[k] = c;
        k = child;
    }
    queue[k] = x;
}
```



