---
title: ConcurrentHashMap中size()方法的实现原理
date: 2020-04-24 23:13:29
tags: java collections framework
categories: java
---

2020年4月23日晚上，阿里交叉面时，面试官问到了ConcurrentHashMap中size()方法的实现原理，我瞬间懵逼，因为之前只关注了put和get等操作，压根根本没看过size()的源码...

<!--more-->

### size方法

```java
public int size() {
    // 统计哈希表中的元素个数
    long n = sumCount();
    return ((n < 0L) ? 0 :
            (n > (long)Integer.MAX_VALUE) ? Integer.MAX_VALUE : (int)n);
}
```

1.sumCount()的源码如下：

```java
final long sumCount() {
    CounterCell[] cs = counterCells;
    long sum = baseCount;
    if (cs != null) {
        for (CounterCell c : cs)
            if (c != null)
                sum += c.value;
    }
    return sum;
}
```

2.CounterCell的定义如下：

```java
@jdk.internal.vm.annotation.Contended static final class CounterCell {
    volatile long value;
    CounterCell(long x) { value = x; }
}
```

3.声明`CounterCell[] cs = counterCells;`变量的源码如下：

```java
private transient volatile CounterCell[] counterCells;
```

4.声明`long sum = baseCount;`变量的源码如下：

```java
// 记录了哈希表中的元素个数
private transient volatile long baseCount;
```

### mappingCount方法

在JDK 8新增了mappingCount()方法也是用于求键值对的个数，但是其返回值为long。设计者们建议我们使用该方法代替size()方法。

虽然哈希表的长度不会超过int的存储范围，但是每个桶中可以有多个元素，从而导致ConcurrentHashMap中的键值对个数有可能会超出int的存储范围。

此外，mappingCount()返回的是一个估计值，当存在并发插入和删除时，实际的键值对个数可能会有所不同。

```java
public long mappingCount() {
    long n = sumCount();
    return (n < 0L) ? 0L : n; // ignore transient negative values
}
```

### addCount方法

```java
// 当执行插入或者删除操作时，将调用addCount修改baseCount的值
private final void addCount(long x, int check) {
    CounterCell[] cs; long b, s;
    // 1.如果cs == null，则使用CAS操作修改baseCount
    if ((cs = counterCells) != null ||
        !U.compareAndSetLong(this, BASECOUNT, b = baseCount, s = b + x)) {
        CounterCell c; long v; int m;
        boolean uncontended = true;
        // 2.如果修改baseCount的CAS操作失败，则使用CAS操作修改counterCells中的值
        if (cs == null || (m = cs.length - 1) < 0 ||
            (c = cs[ThreadLocalRandom.getProbe() & m]) == null ||
            !(uncontended =
              U.compareAndSetLong(c, CELLVALUE, v = c.value, v + x))) {
            // 3.如果修改counterCells的CAS操作失败
            fullAddCount(x, uncontended);
            return;
        }
        if (check <= 1)
            return;
        s = sumCount();
    }
    // 省略剩下的代码
}
```

1.初始化时，数组counterCells为空。当多个线程并发地执行修改操作时，通过CAS操作修改baseCount的值。

2.如果修改baseCount的CAS操作失败，则使用CAS操作修改counterCells中的值。

3.如果counterCells为空，或者修改counterCells的CAS操作失败，则执行fullAddCount方法。

4.fullAddCount方法的核心操作如下：

1）通过CAS操作修改cellsBusy的值，如果修改成功，则初始化counterCells。

2）如果修改cellsBusy的CAS操作失败，则继续尝试通过CAS操作修改baseCount的值。

```java
// fullAddCount方法的源码很长，核心代码如下
for (;;) {
    // ...
    else if (cellsBusy == 0 && counterCells == cs &&
             U.compareAndSetInt(this, CELLSBUSY, 0, 1)) {
        boolean init = false;
        try {                           // Initialize table
            if (counterCells == cs) {
                // 长度为2
                CounterCell[] rs = new CounterCell[2];
                rs[h & 1] = new CounterCell(x);
                counterCells = rs;
                init = true;
            }
        } finally {
            cellsBusy = 0;
        }
        if (init)
            break;
    }
    else if (U.compareAndSetLong(this, BASECOUNT, v = baseCount, v + x))
        break; 
    // ...
}
```

声明cellsBusy变量的源码如下：

```java
// 用于数组counterCells初始化或扩容时
private transient volatile int cellsBusy;
```



