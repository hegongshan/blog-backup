---
title: ThreadLocal.ThreadLocalMap源码分析
date: 2020-04-18 22:11:38
tags: java
categories: java
---

ThreadLocalMap是ThreadLocal类的静态内部类，用于保存本地线程变量。它采用除留余数法和线性探测法，以ThreadLocal.threadLocalHashCode为键，以本地线程变量为值。

<!--more-->

### 存储结构

当键为null，即entry.get() == null时，表示该键不再被引用。这些键为null的项，被称之为"stale entries"。

```java
// Entry的键被弱引用关联：当下一次垃圾收集发生时，将被回收掉
static class Entry extends WeakReference<ThreadLocal<?>> {
    /** The value associated with this ThreadLocal. */
    Object value;

    Entry(ThreadLocal<?> k, Object v) {
        super(k);
        value = v;
    }
}
// 哈希表
private Entry[] table;
```

### 构造方法

```java
ThreadLocalMap(ThreadLocal<?> firstKey, Object firstValue) {
    table = new Entry[INITIAL_CAPACITY];
    // 计算该元素所在的下标：当n为2的整数次幂时，x % n = x & (n - 1)
    int i = firstKey.threadLocalHashCode & (INITIAL_CAPACITY - 1);
    table[i] = new Entry(firstKey, firstValue);
    size = 1;
    setThreshold(INITIAL_CAPACITY);
}
```

1.声明INITIAL_CAPACITY的源码如下：

```java
// 默认容量为16（容量必须是2的整数次幂）
private static final int INITIAL_CAPACITY = 16;
```

2.声明firstKey.threadLocalHashCode变量的源码如下：

```java
public class ThreadLocal<T> {
    // 每个ThreadLocal实例的哈希码都不相同
    private final int threadLocalHashCode = nextHashCode();
    private static AtomicInteger nextHashCode = new AtomicInteger();
    private static final int HASH_INCREMENT = 0x61c88647;
    private static int nextHashCode() {
        return nextHashCode.getAndAdd(HASH_INCREMENT);
    }
    ...
}
```

3.setThreshold(INITIAL_CAPACITY)的源码如下：

```java
// 阈值 = 容量 * 负载因子，负载因子为2/3
private void setThreshold(int len) {
    threshold = len * 2 / 3;
}
```

### 添加元素

```java
private void set(ThreadLocal<?> key, Object value) {

    // We don't use a fast path as with get() because it is at
    // least as common to use set() to create new entries as
    // it is to replace existing ones, in which case, a fast
    // path would fail more often than not.

    Entry[] tab = table;
    int len = tab.length;
    int i = key.threadLocalHashCode & (len-1);

    for (Entry e = tab[i];
         e != null;
         e = tab[i = nextIndex(i, len)]) {
        // get()方法继承自java.lang.ref.Reference
        ThreadLocal<?> k = e.get();
        // 如果键已存在，则更新对应的值
        if (k == key) {
            e.value = value;
            return;
        }
        // 如果遇到已经被回收的键
        if (k == null) {
            replaceStaleEntry(key, value, i);
            return;
        }
    }

    tab[i] = new Entry(key, value);
    int sz = ++size;
    if (!cleanSomeSlots(i, sz) && sz >= threshold)
        rehash();
}
```

1.nextIndex(i, len)的源码如下：

```java
// i = (i + 1) % len;
private static int nextIndex(int i, int len) {
    return ((i + 1 < len) ? i + 1 : 0);
}
```

2.`e.get()`方法返回当前项的键，其源码如下：

```java
public abstract class Reference<T> {
    ...
    public T get() {
        return this.referent;
    }
    ...
}
```

3.replaceStaleEntry(key, value, i)的源码如下：

```java
// expunge 删掉
// stale 陈腐的；不新鲜的
private void replaceStaleEntry(ThreadLocal<?> key, Object value,
                               int staleSlot) {
    Entry[] tab = table;
    int len = tab.length;
    Entry e;

    // Back up to check for prior stale entry in current run.
    // We clean out whole runs at a time to avoid continual
    // incremental rehashing due to garbage collector freeing
    // up refs in bunches (i.e., whenever the collector runs).
    int slotToExpunge = staleSlot;
    for (int i = prevIndex(staleSlot, len);
         (e = tab[i]) != null;
         i = prevIndex(i, len))
        if (e.get() == null)
            slotToExpunge = i;

    // Find either the key or trailing null slot of run, whichever
    // occurs first
    for (int i = nextIndex(staleSlot, len);
         (e = tab[i]) != null;
         i = nextIndex(i, len)) {
        ThreadLocal<?> k = e.get();

        // If we find key, then we need to swap it
        // with the stale entry to maintain hash table order.
        // The newly stale slot, or any other stale slot
        // encountered above it, can then be sent to expungeStaleEntry
        // to remove or rehash all of the other entries in run.
        if (k == key) {
            e.value = value;

            tab[i] = tab[staleSlot];
            tab[staleSlot] = e;

            // Start expunge at preceding stale entry if it exists
            if (slotToExpunge == staleSlot)
                slotToExpunge = i;
            cleanSomeSlots(expungeStaleEntry(slotToExpunge), len);
            return;
        }

        // If we didn't find stale entry on backward scan, the
        // first stale entry seen while scanning for key is the
        // first still present in the run.
        if (k == null && slotToExpunge == staleSlot)
            slotToExpunge = i;
    }

    // If key not found, put new entry in stale slot
    tab[staleSlot].value = null;
    tab[staleSlot] = new Entry(key, value);

    // If there are any other stale entries in run, expunge them
    if (slotToExpunge != staleSlot)
        cleanSomeSlots(expungeStaleEntry(slotToExpunge), len);
}
```

4.prevIndex(staleSlot, len)的源码如下：

```java
// i = (i - 1 + len) % len;
private static int prevIndex(int i, int len) {
    return ((i - 1 >= 0) ? i - 1 : len - 1);
}
```

5.expungeStaleEntry(slotToExpunge)的源码如下：

```java
// 返回下一个空槽的下标
private int expungeStaleEntry(int staleSlot) {
    Entry[] tab = table;
    int len = tab.length;

    // 1.删除下标为staleSlot的槽(键已经被回收)
    // expunge entry at staleSlot
    tab[staleSlot].value = null;
    tab[staleSlot] = null;
    size--;

    // 2.对位于staleSlot和下一个空槽之间的冲突项，进行重新哈希
    // Rehash until we encounter null
    Entry e;
    int i;
    for (i = nextIndex(staleSlot, len);
         (e = tab[i]) != null;
         i = nextIndex(i, len)) {
        ThreadLocal<?> k = e.get();
        // 3.如果发现键已经被回收，则删除该项
        if (k == null) {
            e.value = null;
            tab[i] = null;
            size--;
        } else {
            int h = k.threadLocalHashCode & (len - 1);
            // 4.如果存在哈希冲突
            if (h != i) {
                tab[i] = null;
                // 从h开始，寻找下一个空槽，将当前项放入其中
                // Unlike Knuth 6.4 Algorithm R, we must scan until
                // null because multiple entries could have been stale.
                while (tab[h] != null)
                    h = nextIndex(h, len);
                tab[h] = e;
            }
        }
    }
    return i;
}
```

.

```java
// 清空已经被回收的槽
private boolean cleanSomeSlots(int i, int n) {
    boolean removed = false;
    Entry[] tab = table;
    int len = tab.length;
    do {
        i = nextIndex(i, len);
        Entry e = tab[i];
        if (e != null && e.get() == null) {
            n = len;
            removed = true;
            i = expungeStaleEntry(i);
        }
    } while ( (n >>>= 1) != 0);
    return removed;
}
```

### 重新哈希

```java
private void rehash() {
    // 删除哈希表中所有已经被回收的项
    expungeStaleEntries();
    // size >= 3/4 threshold = 3/4 * 2/3 len = 1/2 len
    // Use lower threshold for doubling to avoid hysteresis
    if (size >= threshold - threshold / 4)
        resize();
}
```

1.expungeStaleEntries()方法用于删除哈希表中所有已经被回收的项，其源码如下：

```java
private void expungeStaleEntries() {
    Entry[] tab = table;
    int len = tab.length;
    for (int j = 0; j < len; j++) {
        Entry e = tab[j];
        if (e != null && e.get() == null)
            expungeStaleEntry(j);
    }
}
```

resize()用于对哈希表进行扩容，新的容量为原来容量的2倍，源码如下：

```java
private void resize() {
    Entry[] oldTab = table;
    int oldLen = oldTab.length;
    int newLen = oldLen * 2;
    Entry[] newTab = new Entry[newLen];
    int count = 0;

    for (int j = 0; j < oldLen; ++j) {
        Entry e = oldTab[j];
        if (e != null) {
            ThreadLocal<?> k = e.get();
            if (k == null) {
                e.value = null; // Help the GC
            } else {
                // 计算当前项的新下标
                int h = k.threadLocalHashCode & (newLen - 1);
                // 使用线性探测法解决哈希冲突
                while (newTab[h] != null)
                    h = nextIndex(h, newLen);
                newTab[h] = e;
                count++;
            }
        }
    }

    setThreshold(newLen);
    size = count;
    table = newTab;
}
```

### 取值操作

```java
private Entry getEntry(ThreadLocal<?> key) {
    int i = key.threadLocalHashCode & (table.length - 1);
    Entry e = table[i];
    // 若不存在哈希冲突
    if (e != null && e.get() == key)
        return e;
    else
        return getEntryAfterMiss(key, i, e);
}
```

若存在哈希冲突，则调用getEntryAfterMiss方法。

```java
// 采用线性探测法，寻找key所在的项
private Entry getEntryAfterMiss(ThreadLocal<?> key, int i, Entry e) {
    Entry[] tab = table;
    int len = tab.length;

    while (e != null) {
        ThreadLocal<?> k = e.get();
        // 如果找到了指定的键
        if (k == key)
            return e;
        // 若在寻找的过程中，发现某个键已经被回收，则删除这个项
        if (k == null)
            expungeStaleEntry(i);
        else
            i = nextIndex(i, len);
        e = tab[i];
    }
    return null;
}
```

### 删除操作

```java
private void remove(ThreadLocal<?> key) {
    Entry[] tab = table;
    int len = tab.length;
    int i = key.threadLocalHashCode & (len-1);
    for (Entry e = tab[i];
         e != null;
         e = tab[i = nextIndex(i, len)]) {
        if (e.get() == key) {
            // clear方法继承自于java.lang.ref.Reference类
            e.clear();
            expungeStaleEntry(i);
            return;
        }
    }
}
```

clear()方法的源码如下：

```java
public abstract class Reference<T> {
    ...
    public void clear() {
        this.referent = null;
    }
    ...
}
```



