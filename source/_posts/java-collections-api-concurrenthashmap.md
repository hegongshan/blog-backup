---
title: Java容器探秘之旅 ConcurrentHashMap
date: 2020-03-06 17:15:13
tags: java collections framework
categories: java
---

ConcurrentHashMap使用CAS操作和synchronized关键字，保证了并发安全，它不允许任何记录的键或者值为null。

<!--more-->

此外，虽然ConcurrentHashMap类名中带有HashMap字样，但它并不是HashMap的子类。

> **在JDK 8-11中，ConcurrentHashMap::tryPresize方法存在bug**（[JDK-8214427](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8214427)），该bug在JDK 12中已被修复。此外，JDK12对ConcurrentHashMap进行了部分调整，因此，本文将基于JDK 12来进行分析。

### 存储结构

ConcurrentHashMap的存储结构与HashMap基本相同，都是数组+单链表+红黑树。

#### 数组

与HashMap相比，数组table使用了volatile关键字。

```java
transient volatile Node<K,V>[] table;
```

#### 单链表

与HashMap相比，val和next字段均使用了volatile关键字。

```java
static class Node<K,V> implements Map.Entry<K,V> {
    // hash >= 0
    final int hash;
    final K key;
    // val和next均被volatile修饰
    volatile V val;
    volatile Node<K,V> next;

    Node(int hash, K key, V val, Node<K,V> next) {
        this.hash = hash;
        this.key = key;
        this.val = val;
        this.next = next;
    }
    ...
}
```

#### 红黑树

```java
static final class TreeNode<K,V> extends Node<K,V> {
    TreeNode<K,V> parent;  // red-black tree links
    TreeNode<K,V> left;
    TreeNode<K,V> right;
    TreeNode<K,V> prev;    // needed to unlink next upon deletion
    boolean red;

    TreeNode(int hash, K key, V val, Node<K,V> next,
             TreeNode<K,V> parent) {
        super(hash, key, val, next);
        this.parent = parent;
    }
    ...
}
```

#### 辅助结构

* 特殊hash值

```java
static final int MOVED     = -1; // hash for forwarding nodes
static final int TREEBIN   = -2; // hash for roots of trees
static final int RESERVED  = -3; // hash for transient reservations
```

* 用于扩容

```java
// 当执行扩容操作时，插在桶的头部，hash值为-1
static final class ForwardingNode<K,V> extends Node<K,V> {
    final Node<K,V>[] nextTable;
    ForwardingNode(Node<K,V>[] tab) {
        super(MOVED, null, null, null);
        this.nextTable = tab;
    }
    ...
}
```

* 用于红黑树

```java
// 当桶中为红黑树时，插在桶的根部，hash值为-2
static final class TreeBin<K,V> extends Node<K,V> {
    TreeNode<K,V> root;
    volatile TreeNode<K,V> first;
    volatile Thread waiter;
    volatile int lockState;
    // values for lockState
    static final int WRITER = 1; // set while holding write lock
    static final int WAITER = 2; // set when waiting for write lock
    static final int READER = 4; // increment value for setting read lock
    ...
    TreeBin(TreeNode<K,V> b) {
        super(TREEBIN, null, null, null);
        ...
    }
    ...
}
```

* 占位：用于序列化和

```java
// hash值为-3
static final class ReservationNode<K,V> extends Node<K,V> {
    ReservationNode() {
        super(RESERVED, null, null, null);
    }
    ...
}
```

### 构造方法

```java
public ConcurrentHashMap(int initialCapacity,
                         float loadFactor, int concurrencyLevel) {
    if (!(loadFactor > 0.0f) || initialCapacity < 0 || concurrencyLevel <= 0)
        throw new IllegalArgumentException();
    if (initialCapacity < concurrencyLevel)   // Use at least as many bins
        initialCapacity = concurrencyLevel;   // as estimated threads
    long size = (long)(1.0 + (long)initialCapacity / loadFactor);
    int cap = (size >= (long)MAXIMUM_CAPACITY) ?
        MAXIMUM_CAPACITY : tableSizeFor((int)size);
    this.sizeCtl = cap;
}
```

### 插入操作

#### put方法

```java
public V put(K key, V value) {
    return putVal(key, value, false);
}
```

实际执行插入操作的是putVal方法。该方法内部使用了CAS操作和同步代码块。

```java
// onlyIfAbsent: 若为true，则只有当key不存在时，才会执行插入。
final V putVal(K key, V value, boolean onlyIfAbsent) {
    // 1.key和value都不允许为空
    if (key == null || value == null) throw new NullPointerException();
    // 2.计算键的hash值
    int hash = spread(key.hashCode());
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh; K fk; V fv;
        // 3.若表尚未初始化
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
            // 4.若所在的桶为空，则使用CAS操作设置头结点
            if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value)))
                break;                   // no lock when adding to empty bin
        }
        else if ((fh = f.hash) == MOVED)
            // 5.若在执行迁移操作，则帮助迁移
            tab = helpTransfer(tab, f);
        else if (onlyIfAbsent // check first node without acquiring lock
                 && fh == hash
                 && ((fk = f.key) == key || (fk != null && key.equals(fk)))
                 && (fv = f.val) != null)
            // 6.若给定的key为桶中的第一个节点，并且不允许执行更新操作
            return fv;
        else {
            V oldVal = null;
            // 7.否则，先锁住桶中的第一个结点
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    // 若桶中为单链表
                    if (fh >= 0) {
                        // 统计桶中的元素个数
                        binCount = 1;
                        for (Node<K,V> e = f;; ++binCount) {
                            K ek;
                            // 若找到了该记录
                            if (e.hash == hash &&
                                ((ek = e.key) == key ||
                                 (ek != null && key.equals(ek)))) {
                                oldVal = e.val;
                                if (!onlyIfAbsent)
                                    e.val = value;
                                break;
                            }
                            Node<K,V> pred = e;
                            // 若桶中没有该记录，则将其添加到尾部
                            if ((e = e.next) == null) {
                                pred.next = new Node<K,V>(hash, key, value);
                                break;
                            }
                        }
                    }
                    else if (f instanceof TreeBin) {
                        // 若桶中为红黑树
                        Node<K,V> p;
                        binCount = 2;
                        if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                                       value)) != null) {
                            oldVal = p.val;
                            if (!onlyIfAbsent)
                                p.val = value;
                        }
                    }
                    else if (f instanceof ReservationNode)
                        throw new IllegalStateException("Recursive update");
                }
            }
            // 若桶中为单链表
            if (binCount != 0) {
                // 若桶中的元素个数>=树化阈值，则将单链表转变为红黑树
                if (binCount >= TREEIFY_THRESHOLD)
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    addCount(1L, binCount);
    return null;
}
```

一、循环执行如下过程：

1.若哈希表尚未初始化，则先进行初始化操作；否则，执行2。

2.计算当前项所在的桶下标。若桶为空，则使用CAS操作，将当前项设置为桶中的第一个元素；否则，执行3。

3.若哈希表正在执行迁移操作，则让当前线程帮助执行该过程；否则，执行4。

4.若当前项为桶中的第一个结点，并且不允许执行更新操作，则循环结束；否则，执行5。

5.锁住桶中的第一个结点，然后根据桶中第一个结点的hash值判断桶中的数据结构类型。若为单链表（hash >= 0），则从前往后寻找当前项的插入（或者所在）位置，执行7；否则，执行6。

6.若桶中为红黑树，则根据二叉查找树的性质，寻找当前项的插入（或者所在）位置，执行7。

7.若桶中的元素>=树化阈值（8），则尝试将单链表转变为红黑树。

二、更新哈希表中的元素个数。

#### 重散列

```java
// 返回的值为非负
static final int spread(int h) {
    return (h ^ (h >>> 16)) & HASH_BITS;
}
static final int HASH_BITS = 0x7fffffff;
```

#### 初始化操作

若表为空（延迟初始化）

```java
// 当sizeCtl为负数时，表示哈希表正在被初始化或者正在扩容：-1表示初始化；否则，为-(1+正在扩容的线程数量)；
// 表初始化以后，表示表的阈值（容量×负载因子）
private transient volatile int sizeCtl;
private final Node<K,V>[] initTable() {
    Node<K,V>[] tab; int sc;
    while ((tab = table) == null || tab.length == 0) {
        // 若哈希表正在被其他线程初始化，则让出处理器的使用权
        if ((sc = sizeCtl) < 0)
            Thread.yield(); // lost initialization race; just spin
        else if (U.compareAndSwapInt(this, SIZECTL, sc, -1)) {
            try {
                if ((tab = table) == null || tab.length == 0) {
                    int n = (sc > 0) ? sc : DEFAULT_CAPACITY;
                    @SuppressWarnings("unchecked")
                    Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
                    table = tab = nt;
                    // 阈值：0.75n
                    sc = n - (n >>> 2);
                }
            } finally {
                sizeCtl = sc;
            }
            break;
        }
    }
    return tab;
}
```

#### CAS操作

* 什么是CAS操作

**CAS（Compare And Swap，比较并交换）**是一种无锁算法。CAS操作包含有3个操作数：内存位置V，预期原值E，新值N。当且仅当内存位置V符合预期值E时，才会用N更新V；否则，说明已经有其他线程做了更新，则当前线程什么都不做。

* 当桶为空时，putVal方法使用CAS操作设置桶中的第一个结点，该操作由sun.misc.Unsafe类实现。

```java
private static final sun.misc.Unsafe U;
// 获取第i个桶的头结点
@SuppressWarnings("unchecked")
static final <K,V> Node<K,V> tabAt(Node<K,V>[] tab, int i) {
    return (Node<K,V>)U.getObjectVolatile(tab, ((long)i << ASHIFT) + ABASE);
}
// 使用CAS操作，设置第i个桶的头结点（当第i个桶为空时，才被使用）
static final <K,V> boolean casTabAt(Node<K,V>[] tab, int i,
                                    Node<K,V> c, Node<K,V> v) {
    return U.compareAndSwapObject(tab, ((long)i << ASHIFT) + ABASE, c, v);
}
// 设置第i个桶的头结点（用于删除头结点或者扩容操作中）
static final <K,V> void setTabAt(Node<K,V>[] tab, int i, Node<K,V> v) {
    U.putObjectVolatile(tab, ((long)i << ASHIFT) + ABASE, v);
}
```

### 单链表与红黑树的相互转化

#### 单链表=>红黑树

```java
private final void treeifyBin(Node<K,V>[] tab, int index) {
    Node<K,V> b; int n, sc;
    if (tab != null) {
        // 1.若桶中的结点个数>=树化阈值(8)，但是表的长度<最小树化容量（64），则尝试扩容
        if ((n = tab.length) < MIN_TREEIFY_CAPACITY)
            tryPresize(n << 1);
        else if ((b = tabAt(tab, index)) != null && b.hash >= 0) {
            // 2. b.hash>=0 确保桶中依然是单链表
            synchronized (b) {
                // 3.再次检查，确保头结点未发生变化
                if (tabAt(tab, index) == b) {
                    TreeNode<K,V> hd = null, tl = null;
                    // 4.将单链表（普通结点）转变为双链表（树结点）
                    for (Node<K,V> e = b; e != null; e = e.next) {
                        TreeNode<K,V> p =
                            new TreeNode<K,V>(e.hash, e.key, e.val,
                                              null, null);
                        if ((p.prev = tl) == null)
                            hd = p;
                        else
                            tl.next = p;
                        tl = p;
                    }
                    // 5.红黑树的构建由TreeBin的构造方法完成
                    // 6.将桶的首结点设置为TreeBin（hash=-2），表示桶中为红黑树
                    setTabAt(tab, index, new TreeBin<K,V>(hd));
                }
            }
        }
    }
}
```

#### 红黑树=>单链表

```java
static <K,V> Node<K,V> untreeify(Node<K,V> b) {
    Node<K,V> hd = null, tl = null;
    for (Node<K,V> q = b; q != null; q = q.next) {
        Node<K,V> p = new Node<K,V>(q.hash, q.key, q.val, null);
        if (tl == null)
            hd = p;
        else
            tl.next = p;
        tl = p;
    }
    return hd;
}
```

### 按键取值

由于Node的val和next属性均使用了volatile关键字修饰，因此，get方法没有加锁。

```java
public V get(Object key) {
    Node<K,V>[] tab; Node<K,V> e, p; int n, eh; K ek;
    int h = spread(key.hashCode());
    if ((tab = table) != null && (n = tab.length) > 0 &&
        (e = tabAt(tab, (n - 1) & h)) != null) {
        // 1.若为桶中的第一个结点
        if ((eh = e.hash) == h) {
            if ((ek = e.key) == key || (ek != null && key.equals(ek)))
                return e.val;
        }
        else if (eh < 0)
            // 2.若正在扩容（hash = -1），或者桶中为红黑树（hash = -2）
            return (p = e.find(h, key)) != null ? p.val : null;
        // 3.若桶中为单链表
        while ((e = e.next) != null) {
            if (e.hash == h &&
                ((ek = e.key) == key || (ek != null && key.equals(ek))))
                return e.val;
        }
    }
    return null;
}
```

### 删除操作

```java
public V remove(Object key) {
    return replaceNode(key, null, null);
}
```

实际执行删除操作的是replaceNode方法。

```java
// value表示待设置的新值，若为null，表示删除该记录；cv表示key原来的值
final V replaceNode(Object key, V value, Object cv) {
    int hash = spread(key.hashCode());
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        // 1.如果表尚未初始化，或者桶为空
        if (tab == null || (n = tab.length) == 0 ||
            (f = tabAt(tab, i = (n - 1) & hash)) == null)
            break;
        else if ((fh = f.hash) == MOVED)
            // 2.如果正在扩容，则先帮助扩容
            tab = helpTransfer(tab, f);
        else {
            V oldVal = null;
            boolean validated = false;
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    // 3.1若桶中为单链表
                    if (fh >= 0) {
                        validated = true;
                        for (Node<K,V> e = f, pred = null;;) {
                            K ek;
                            if (e.hash == hash &&
                                ((ek = e.key) == key ||
                                 (ek != null && key.equals(ek)))) {
                                V ev = e.val;
                                if (cv == null || cv == ev ||
                                    (ev != null && cv.equals(ev))) {
                                    oldVal = ev;
                                    // 若新的值value不为null，则更新key对应的值
                                    if (value != null)
                                        e.val = value;
                                    else if (pred != null)
                                        // 若新的值value为null，但不是第一个结点，则删除该结点
                                        pred.next = e.next;
                                    else
                                        // 删除第一个结点
                                        setTabAt(tab, i, e.next);
                                }
                                break;
                            }
                            pred = e;
                            // 如果key不在表中
                            if ((e = e.next) == null)
                                break;
                        }
                    }
                    // 3.2若桶中为红黑树
                    else if (f instanceof TreeBin) {
                        validated = true;
                        TreeBin<K,V> t = (TreeBin<K,V>)f;
                        TreeNode<K,V> r, p;
                        if ((r = t.root) != null &&
                            (p = r.findTreeNode(hash, key, null)) != null) {
                            V pv = p.val;
                            if (cv == null || cv == pv ||
                                (pv != null && cv.equals(pv))) {
                                oldVal = pv;
                                if (value != null)
                                    p.val = value;
                                else if (t.removeTreeNode(p))
                                    setTabAt(tab, i, untreeify(t.first));
                            }
                        }
                    }
                }
            }
            if (validated) {
                if (oldVal != null) {
                    if (value == null)
                        addCount(-1L, -1);
                    return oldVal;
                }
                break;
            }
        }
    }
    return null;
}
```
