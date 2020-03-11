---
title: Java容器探秘之旅 Set/HashSet/TreeSet/CopyOnWriteArraySet
date: 2020-03-08 16:42:43
tags: java collections api
categories: java
---

与List不同，Set中的元素是无序且不重复的。

<!--more-->

### Set家族

类图（正在绘制中，请稍后...）

### Set源码

```java
public interface Set<E> extends Collection<E> {
    // Query Operations
    int size();
    
    boolean isEmpty();

    boolean contains(Object o);

    Iterator<E> iterator();

    Object[] toArray();

    <T> T[] toArray(T[] a);

    // Modification Operations
    boolean add(E e);

    boolean remove(Object o);

    // Bulk Operations
    boolean containsAll(Collection<?> c);

    boolean addAll(Collection<? extends E> c);
    // 只保留包含在c中的元素，即删除不在c中的所有元素
    boolean retainAll(Collection<?> c);

    boolean removeAll(Collection<?> c);

    void clear();

    // Comparison and hashing
    boolean equals(Object o);

    int hashCode();

    @Override
    default Spliterator<E> spliterator() {
        return Spliterators.spliterator(this, Spliterator.DISTINCT);
    }
}
```

### 遍历Set

Set继承了Collection接口，而Collection接口又继承了Iterable接口，因此可以使用for-each循环、迭代器以及forEach方法（JDK1.8新增）三种方式进行遍历。下面以`Set<String>`为例，逐一说明这三种方式。

#### for-each循环

```java
for (String s : set) {
    System.out.println(s);
}
```

#### 迭代器

```java
Iterator<String> iter = set.iterator();
while (iter.hasNext()) {
    System.out.println(iter.next());
}
```

#### forEach方法

```java
set.forEach(e -> {
    System.out.println(e);
});
```

### HashSet

HashSet使用HashMap实现，从而导致存储在其中的元素是**无序且不重复的**，它**允许值为null**（HashMap最多允许一条记录的键为null）。

#### 存储结构

```java
private transient HashMap<E,Object> map;

// HashMap中所有的键对应的值都是该对象
// Dummy value to associate with an Object in the backing Map
private static final Object PRESENT = new Object();
```

#### 构造方法

```java
public HashSet() {
    map = new HashMap<>();
}
```

#### 添加元素

HashSet中的元素实际上就是HashMap中的键，它们对应的值均为同一个对象。

```java
public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```

#### 删除元素

```java
public boolean remove(Object o) {
    return map.remove(o)==PRESENT;
}
```

### TreeSet

与HashSet的实现方式类似，TreeSet使用TreeMap实现，从而导致存储在其中的元素是**有序且不重复的。**此外，它**不允许值为null**（TreeMap不允许任何记录的键为null）。

#### 存储结构

```java
private transient NavigableMap<E,Object> m;

// Dummy value to associate with an Object in the backing Map
private static final Object PRESENT = new Object();
```

#### 构造方法

```java
TreeSet(NavigableMap<E,Object> m) {
    this.m = m;
}
public TreeSet() {
    this(new TreeMap<E,Object>());
}
public TreeSet(Comparator<? super E> comparator) {
    this(new TreeMap<>(comparator));
}
```

由于TreeSet的添加和删除操作也是直接调用TreeMap的相应方法实现的，因此，这里不再一一列出。

### CopyOnWriteArraySet

CopyOnWriteArraySet是基于CopyOnWriteArrayList实现的，存储在其中的元素是**有序且不重复的**，并且它**允许值为null。**

#### 存储结构

```java
private final CopyOnWriteArrayList<E> al;
```

#### 构造方法

```java
public CopyOnWriteArraySet() {
    al = new CopyOnWriteArrayList<E>();
}
```

#### 添加元素

```java
public boolean add(E e) {
    return al.addIfAbsent(e);
}
```

#### 删除元素

```java
public boolean remove(Object o) {
    return al.remove(o);
}
```

### 实现类比较

|       实现类        |             实现机制             | 是否允许为null | 是否有序 |  是否线程安全   |
| :-----------------: | :-------------------------------: | :------------: | :-------------: | :------: |
|       HashSet       | 基于HashMap |      允许      |      **无序**      |   线程不安全    |
|       TreeSet       |       基于TreeMap       |     **不允许**     |     有序     |   线程不安全    |
| CopyOnWriteArraySet | 基于CopyOnWriteArrayList |      允许      |      有序      | **线程安全** |

