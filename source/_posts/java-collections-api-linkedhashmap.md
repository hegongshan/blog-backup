---
title: Java集合类之LinkedHashMap
date: 2020-02-18 18:42:03
tags: java collections api
categories: java
---

LinkedHashMap继承了HashMap，使用双链表将表中的所有节点连接在一起。

<!--more-->

### 存储结构

```java
transient LinkedHashMap.Entry<K,V> head;
transient LinkedHashMap.Entry<K,V> tail;
```



```java
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

### LRU

```java
protected boolean removeEldestEntry(Map.Entry<K,V> eldest) {
    return false;
}
```

