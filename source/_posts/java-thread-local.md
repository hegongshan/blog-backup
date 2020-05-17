---
title: ThreadLocal源码分析
date: 2020-04-18 23:08:53
tags: java
categories: java
---

通过java.lang.ThreadLocal类，可以实现线程本地存储。

<!--more-->

### 添加操作

```java
public void set(T value) {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    // 如果当前线程的threadLocals属性已经被初始化，则直接添加
    if (map != null)
        map.set(this, value);
    else
        createMap(t, value);
}
```

1.getMap(t)的源码如下：

```java
ThreadLocalMap getMap(Thread t) {
    return t.threadLocals;
}
```

2.声明threadLocals变量的源码如下：

```java
public class Thread implements Runnable {
    // 包访问权限：ThreadLocal与Thread在同一包中（java.lang）
    ThreadLocal.ThreadLocalMap threadLocals = null;
    ...
}
```

3.第一次向当前线程中存放数据时，将执行createMap()方法，创建ThreadLocal.ThreadLocalMap对象。

```java
void createMap(Thread t, T firstValue) {
    t.threadLocals = new ThreadLocalMap(this, firstValue);
}
```

### 取值操作

```java
public T get() {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    // 如果当前线程的threadLocals字段已经被初始化
    if (map != null) {
        ThreadLocalMap.Entry e = map.getEntry(this);
        // 如果能找到该项
        if (e != null) {
            @SuppressWarnings("unchecked")
            T result = (T)e.value;
            return result;
        }
    }
    // 如果map尚未初始化，或者没找到该项，则将默认值插入map中并返回
    return setInitialValue();
}
```

1.如果当前线程中没有存放过数据（实例变量threadLocals尚未初始化），或者在哈希表中没有找到该项，则执行setInitialValue()方法，源码如下：

```java
private T setInitialValue() {
    // 获取默认值
    T value = initialValue();
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
        map.set(this, value);
    else
        createMap(t, value);
    return value;
}
```

2.方法initialValue()的源码如下：

```java
// 默认值为null，如果需要自定义默认值，只需重写该方法即可
protected T initialValue() {
    return null;
}
```

### 删除操作

```java
public void remove() {
     ThreadLocalMap m = getMap(Thread.currentThread());
     if (m != null)
         m.remove(this);
}
```

