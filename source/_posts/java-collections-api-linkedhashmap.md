---
title: Java集合类之LinkedHashMap
date: 2020-02-18 18:42:03
tags: java collections api
categories: java
---

LinkedHashMap继承了HashMap，它使用双链表将表中的所有节点连接在一起。

<!--more-->

### 存储结构

```java
// 头结点
transient LinkedHashMap.Entry<K,V> head;
// 尾节点
transient LinkedHashMap.Entry<K,V> tail;

static class Entry<K,V> extends HashMap.Node<K,V> {
    Entry<K,V> before, after;
    Entry(int hash, K key, V value, Node<K,V> next) {
        super(hash, key, value, next);
    }
}
```

### 构造方法

```java
// accessOrder：是否按照访问顺序排序。若为false，表示按照插入顺序排序
public LinkedHashMap(int initialCapacity,
                     float loadFactor,
                     boolean accessOrder) {
    super(initialCapacity, loadFactor);
    this.accessOrder = accessOrder;
}
```

### 创建节点

LinkedHashMap采用尾插法，每当创建新的节点后，都会将它链接到双链表的尾部。

```java
Node<K,V> newNode(int hash, K key, V value, Node<K,V> e) {
    LinkedHashMap.Entry<K,V> p =
        new LinkedHashMap.Entry<K,V>(hash, key, value, e);
    linkNodeLast(p);
    return p;
}
//link at the end of list
private void linkNodeLast(LinkedHashMap.Entry<K,V> p) {
    LinkedHashMap.Entry<K,V> last = tail;
    tail = p;
    if (last == null)
        head = p;
    else {
        p.before = last;
        last.after = p;
    }
}
```

### 插入操作

每当执行put方法时，如果key已经存在，那么LinkedHashMap将会执行如下方法：

```java
void afterNodeAccess(Node<K,V> e) { // move node to last
    LinkedHashMap.Entry<K,V> last;
    if (accessOrder && (last = tail) != e) {
        LinkedHashMap.Entry<K,V> p =
            (LinkedHashMap.Entry<K,V>)e, b = p.before, a = p.after;
        // 1.删除该节点
        p.after = null;
        if (b == null)
            head = a;
        else
            b.after = a;
        if (a != null)
            a.before = b;
        else
            last = b;
        // 2.将它移动到链表尾部
        if (last == null)
            head = p;
        else {
            p.before = last;
            last.after = p;
        }
        tail = p;
        ++modCount;
    }
}
```

### 删除最老项

每当插入新元素后，LinkedHashMap都将执行如下方法：

```java
void afterNodeInsertion(boolean evict) { // possibly remove eldest
    LinkedHashMap.Entry<K,V> first;
    if (evict && (first = head) != null && removeEldestEntry(first)) {
        K key = first.key;
        removeNode(hash(key), key, null, false, true);
    }
}
```

这里调用了removeEldestEntry方法，用于判断是否删除最老的项。由于LinkedHashMap采用的是尾插法，所以双链表中最老的项就是头结点。

```java
protected boolean removeEldestEntry(Map.Entry<K,V> eldest) {
    return false;
}
```
如果需要使用该功能，必须重写removeEldestEntry方法。

### 实现LRU

LRU（Least Recently Used，最近最少使用）算法，其核心思想是“如果数据最近被访问过，那么将来被访问的几率也更高”。

当缓存容量达到上限时，在写入新数据之前需要删除最近最少使用的数据值，从而为新的数据值留出空间。

```java
class LRUCache extends LinkedHashMap<K, V>{
    private int capacity;
    public LRUCache(int capacity) {
        // 使用accessOrder
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }
    
    public V get(K key) {
        return super.get(key);
    }
    
    public void put(K key, V value) {
        super.put(key, value);
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K,V> eldest) {
        return size() > capacity;
    }
}
```

