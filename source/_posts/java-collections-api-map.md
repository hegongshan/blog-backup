---
title: Java集合类之Map
date: 2020-02-17 18:41:26
tags: java collections api
categories: java
---

Map是一种键-值对(key-value)集合，Map 集合中的每一个元素都包含一个键对象和一个值对象。

<!--more-->

### Map家族

![Map家族](/static/images/java-map-family.png)

图中省略了部分不常见的实现类和接口。

###  Map源码

下面是Map接口的源码（删除了在1.8中添加的default方法以及Entry中的static方法）。

```java
public interface Map<K,V> {
    // Query Operations
    int size();

    boolean isEmpty();

    boolean containsKey(Object key);
    
    boolean containsValue(Object value);
    
    V get(Object key);

    // Modification Operations   
    V put(K key, V value);
    
    V remove(Object key);

    // Bulk Operations    
    void putAll(Map<? extends K, ? extends V> m);
    
    void clear();

    // Views    
    Set<K> keySet();

    Collection<V> values();

    Set<Map.Entry<K, V>> entrySet();

    interface Entry<K,V> {
        K getKey();

        V getValue();

        V setValue(V value);

        boolean equals(Object o);
       
        int hashCode();
    }
    
    // Comparison and hashing   
    boolean equals(Object o);

    int hashCode();
}
```

### 遍历Map

以`Map<String, String>`为例：

#### 使用for-each循环

```java
for (Map.Entry<String, String> entry : map.entrySet()) {
	System.out.println(entry.getKey() + ":" + entry.getValue());
}
```

#### 使用迭代器

```java
Iterator<Map.Entry<String, String>> iter = map.entrySet().iterator();
while (iter.hasNext()) {
	Map.Entry<String, String> entry = iter.next();
	System.out.println(entry.getKey() + ":" + entry.getValue());
}
```

#### 遍历键-然后取值

```java
for (String key : map.keySet()) {
  	System.out.println(key + ":" + map.get(key));
}
```

#### 分开遍历键和值

```java
for (String key : map.keySet()) {
  	System.out.println(key);
}
for (String value : map.values()) {
  	System.out.println(value);
}
```

#### forEach方法

```java
map.forEach((k, v) -> {
  	System.out.println(k + ":" + v);
});
```

### 实现类一览表

|      实现类       |         数据结构          |                      是否允许为null                      | 是否线程安全 | 默认初始容量 | 扩容机制 |
| :---------------: | :-----------------------: | :------------------------------------------------------: | :----------: | :----------: | :------: |
|      TreeMap      |          红黑树           |  不允许任何记录的键为null，但可以有多条记录的值为null。  |  线程不安全  |      —       |    —     |
|      HashMap      |    数组+单链表+红黑树     | 最多允许一个记录的键为null，但可以有多条记录的值为null。 |  线程不安全  |      16      |    2n    |
|   LinkedHashMap   | 数组+单链表+红黑树+双链表 | 最多允许一个记录的键为null，但可以有多条记录的值为null。 |  线程不安全  |      16      |    2n    |
|     Hashtable     |        数组+单链表        |             不允许任何记录的键或者值为null。             |   线程安全   |      11      |  2n + 1  |
| ConcurrentHashMap |    数组+单链表+红黑树     |             不允许任何记录的键或者值为null。             |   线程安全   |      16      |    2n    |

