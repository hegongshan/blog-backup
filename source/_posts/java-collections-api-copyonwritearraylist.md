---
title: Java容器探秘之旅 CopyOnWriteArrayList
date: 2020-03-07 18:20:55
tags: java collections api
categories: java
---

CopyOnWriteArrayList使用重入锁和写时复制（Copy On Write，COW）的读写分离策略，保证了线程安全。

<!--more-->

###  存储结构

```java
/** The lock protecting all mutators */
final transient ReentrantLock lock = new ReentrantLock();

// 只能通过getter和setter方法访问该数组
/** The array, accessed only via getArray/setArray. */
private transient volatile Object[] array;
```

### 实现原理

1.每当执行写操作（如add、set、remove等）时，都按照如下流程进行：

首先，加锁；

接着，将原数组array复制一份，得到新数组newElements（newElements.length = array.length + 1）；

然后，在新数组newElements中执行写操作；

接下来，改变原数组，将新数组赋给它，即执行setArray(newElements)；

最后，释放锁。

2.每当执行读操作（如get）时，总是在原数组中进行。

### 构造方法

```java
public CopyOnWriteArrayList() {
    setArray(new Object[0]);
}
public CopyOnWriteArrayList(Collection<? extends E> c) {
    Object[] elements;
    if (c.getClass() == CopyOnWriteArrayList.class)
        elements = ((CopyOnWriteArrayList<?>)c).getArray();
    else {
        elements = c.toArray();
        // c.toArray might (incorrectly) not return Object[] (see 6260652)
        if (elements.getClass() != Object[].class)
            elements = Arrays.copyOf(elements, elements.length, Object[].class);
    }
    setArray(elements);
}
public CopyOnWriteArrayList(E[] toCopyIn) {
    setArray(Arrays.copyOf(toCopyIn, toCopyIn.length, Object[].class));
}
```

### 添加元素

#### 在尾部添加

```java
public boolean add(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
        // 1.拷贝数组
        Object[] newElements = Arrays.copyOf(elements, len + 1);
        // 2.在新的数组中执行添加操作
        newElements[len] = e;
        // 3.添加完以后，改变原来的数组
        setArray(newElements);
        return true;
    } finally {
        // 释放锁，在return之前执行
        lock.unlock();
    }
}
```

#### 在指定位置添加

```java
public void add(int index, E element) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
        // 1.如果给定的index不合法（index可以等于len）
        if (index > len || index < 0)
            throw new IndexOutOfBoundsException("Index: "+index+
                                                ", Size: "+len);
        Object[] newElements;
        int numMoved = len - index;
        // 2.是否在尾部添加
        if (numMoved == 0)
            newElements = Arrays.copyOf(elements, len + 1);
        else {
            newElements = new Object[len + 1];
            System.arraycopy(elements, 0, newElements, 0, index);
            System.arraycopy(elements, index, newElements, index + 1,
                             numMoved);
        }
        // 3.执行添加操作
        newElements[index] = element;
        // 4.改变原来的数组
        setArray(newElements);
    } finally {
        lock.unlock();
    }
}
```

#### 不存在时才添加

```java
public boolean addIfAbsent(E e) {
    Object[] snapshot = getArray();
    return indexOf(e, snapshot, 0, snapshot.length) >= 0 ? false :
        addIfAbsent(e, snapshot);
}
```

indexOf方法用于查找某元素在[index, fence)中首次出现的位置。

```java
private static int indexOf(Object o, Object[] elements,
                           int index, int fence) {
    if (o == null) {
        for (int i = index; i < fence; i++)
            if (elements[i] == null)
                return i;
    } else {
        for (int i = index; i < fence; i++)
            if (o.equals(elements[i]))
                return i;
    }
    return -1;
}
```

根据数组的快照版本和给定的值，执行添加操作。

```java
private boolean addIfAbsent(E e, Object[] snapshot) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] current = getArray();
        int len = current.length;
        // 若其他线程修改了数组
        if (snapshot != current) {
            // Optimize for lost race to another addXXX operation
            int common = Math.min(snapshot.length, len);
            // 1.在[0, common)内查找
            for (int i = 0; i < common; i++)
                if (current[i] != snapshot[i] && eq(e, current[i]))
                    return false;
            // 2.在[common, len)内查找
            if (indexOf(e, current, common, len) >= 0)
                    return false;
        }
        Object[] newElements = Arrays.copyOf(current, len + 1);
        newElements[len] = e;
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
```

这里调用了eq方法，用于判断二者是否相等。

```java
private static boolean eq(Object o1, Object o2) {
    return (o1 == null) ? o2 == null : o1.equals(o2);
}
```

### 查询元素

所有的查询操作都在原数组中进行。由于get方法没有加锁，因此，可能会出现**脏读（dirty read）**。

```java
public E get(int index) {
    return get(getArray(), index);
}
@SuppressWarnings("unchecked")
private E get(Object[] a, int index) {
    return (E) a[index];
}
```

### 修改元素

```java
public E set(int index, E element) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        E oldValue = get(elements, index);

        if (oldValue != element) {
            int len = elements.length;
            Object[] newElements = Arrays.copyOf(elements, len);
            newElements[index] = element;
            setArray(newElements);
        } else {
            // Not quite a no-op; ensures volatile write semantics
            setArray(elements);
        }
        return oldValue;
    } finally {
        lock.unlock();
    }
}
```

### 删除元素

#### 删除指定位置的元素

```java
public E remove(int index) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
        E oldValue = get(elements, index);
        int numMoved = len - index - 1;
        // 若待删除的元素为最后一个元素
        if (numMoved == 0)
            setArray(Arrays.copyOf(elements, len - 1));
        else {
            Object[] newElements = new Object[len - 1];
            System.arraycopy(elements, 0, newElements, 0, index);
            System.arraycopy(elements, index + 1, newElements, index,
                             numMoved);
            setArray(newElements);
        }
        return oldValue;
    } finally {
        lock.unlock();
    }
}
```

#### 按值删除

删除数组中值为o（字母）的首个元素。

```java
public boolean remove(Object o) {
    Object[] snapshot = getArray();
    int index = indexOf(o, snapshot, 0, snapshot.length);
    return (index < 0) ? false : remove(o, snapshot, index);
}
```

根据数组的快照版本，以及待删除元素的值和索引，执行删除操作。

```java
private boolean remove(Object o, Object[] snapshot, int index) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] current = getArray();
        int len = current.length;
        // 若数组已经被其他线程修改，则在当前数组中寻找该元素首次出现的位置
        if (snapshot != current) findIndex: {
            // 1.判断该元素是否在当前数组的[0, prefix)中
            int prefix = Math.min(index, len);
            for (int i = 0; i < prefix; i++) {
                if (current[i] != snapshot[i] && eq(o, current[i])) {
                    index = i;
                    break findIndex;
                }
            }
            // 该元素不在[0, prefix)中
            // 2.若该元素已经被其他线程删除了
            if (index >= len)
                return false;
            // 3.若该元素仍在index处
            if (current[index] == o)
                break findIndex;
            // 4.查找该元素在[index, len)中首次出现的位置
            index = indexOf(o, current, index, len);
            // 5.若该元素不在当前数组中（已被其他线程删除）
            if (index < 0)
                return false;
        }
        Object[] newElements = new Object[len - 1];
        System.arraycopy(current, 0, newElements, 0, index);
        System.arraycopy(current, index + 1,
                         newElements, index,
                         len - index - 1);
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
```

### 迭代器

```java
public Iterator<E> iterator() {
    // COWIterator使用的是数组的快照版本
    return new COWIterator<E>(getArray(), 0);
}
```

COWIterator使用的是原数组的快照，因此，COWIterator只支持访问操作，不允许在迭代时更新数组。

```java
static final class COWIterator<E> implements ListIterator<E> {
    /** Snapshot of the array */
    private final Object[] snapshot;
    /** Index of element to be returned by subsequent call to next.  */
    private int cursor;

    private COWIterator(Object[] elements, int initialCursor) {
        cursor = initialCursor;
        snapshot = elements;
    }
    ...
     
    // 不支持删除操作
    public void remove() {
        throw new UnsupportedOperationException();
    }

    // 不支持修改操作
    public void set(E e) {
        throw new UnsupportedOperationException();
    }

    // 不支持添加操作
    public void add(E e) {
        throw new UnsupportedOperationException();
    }
    ...
}
```



