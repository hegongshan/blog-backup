---
title: ConcurrentHashMap扩容操作的实现原理
date: 2020-04-24 23:13:14
tags: java collections framework
categories: java
---

2020年4月23日晚上，阿里交叉面时，面试官问到了ConcurrentHashMap中扩容操作的实现原理，瞬间懵逼。当初看源码的时候，这块就没看懂。这次仔细研究了很久，终于看明白啦。

<!--more-->

```java
private final void tryPresize(int size) {
    int c = (size >= (MAXIMUM_CAPACITY >>> 1)) ? MAXIMUM_CAPACITY :
        tableSizeFor(size + (size >>> 1) + 1);
    int sc;
    while ((sc = sizeCtl) >= 0) {
        Node<K,V>[] tab = table; int n;
        if (tab == null || (n = tab.length) == 0) {
            n = (sc > c) ? sc : c;
            if (U.compareAndSetInt(this, SIZECTL, sc, -1)) {
                try {
                    if (table == tab) {
                        @SuppressWarnings("unchecked")
                        Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
                        table = nt;
                        // sc = 0.75 n
                        sc = n - (n >>> 2);
                    }
                } finally {
                    sizeCtl = sc;
                }
            }
        }
        else if (c <= sc || n >= MAXIMUM_CAPACITY)
            break;
        else if (tab == table) {
            int rs = resizeStamp(n);
            // 在迁移之前，令SIZECTL = (rs << RESIZE_STAMP_SHIFT) + 2
            if (U.compareAndSetInt(this, SIZECTL, sc,
                                    (rs << RESIZE_STAMP_SHIFT) + 2))
                transfer(tab, null);
        }
    }
}
```



帮助迁移

```java
final Node<K,V>[] helpTransfer(Node<K,V>[] tab, Node<K,V> f) {
    Node<K,V>[] nextTab; int sc;
    if (tab != null && (f instanceof ForwardingNode) &&
        (nextTab = ((ForwardingNode<K,V>)f).nextTable) != null) {
        int rs = resizeStamp(tab.length) << RESIZE_STAMP_SHIFT;
        while (nextTab == nextTable && table == tab &&
               (sc = sizeCtl) < 0) {
            if (sc == rs + MAX_RESIZERS || sc == rs + 1 ||
                transferIndex <= 0)
                break;
            // SIZECTL+1，让当前线程帮助执行迁移操作
            if (U.compareAndSetInt(this, SIZECTL, sc, sc + 1)) {
                transfer(tab, nextTab);
                break;
            }
        }
        return nextTab;
    }
    return table;
}
private static int RESIZE_STAMP_BITS = 16;
static final int resizeStamp(int n) {
    return Integer.numberOfLeadingZeros(n) | (1 << (RESIZE_STAMP_BITS - 1));
}
```

声明nextTable变量的源码如下：

```java
// 只在扩容和迁移数据时被使用
private transient volatile Node<K,V>[] nextTable;
```

### 迁移操作

```java
private final void transfer(Node<K,V>[] tab, Node<K,V>[] nextTab) {
    // stride 步幅
    int n = tab.length, stride;
    // 计算一个线程最少需要处理的桶个数stride，大于等于16
    if ((stride = (NCPU > 1) ? (n >>> 3) / NCPU : n) < MIN_TRANSFER_STRIDE)
        stride = MIN_TRANSFER_STRIDE; // subdivide range
    // 若尚未创建新的哈希表
    if (nextTab == null) {            // initiating
        try {
            // 新的容量是原来容量的2倍
            @SuppressWarnings("unchecked")
            Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n << 1];
            nextTab = nt;
        } catch (Throwable ex) {      // try to cope with OOME
            sizeCtl = Integer.MAX_VALUE;
            return;
        }
        nextTable = nextTab;
        transferIndex = n;
    }
    int nextn = nextTab.length;
    ForwardingNode<K,V> fwd = new ForwardingNode<K,V>(nextTab);
    // 是否继续向前移动
    boolean advance = true;
    // 若为true，表示迁移操作已完成
    boolean finishing = false; // to ensure sweep before committing nextTab
    // 当前线程需要处理的桶下标为[bound, i]
    for (int i = 0, bound = 0;;) {
        Node<K,V> f; int fh;
        // 1.若当前线程尚未分配任务，并且哈希表还有桶没有指定处理线程，
        // 则为当前线程分配需要迁移的桶范围，每次向前移动一个桶。
        // 2.若当前线程已经完成了分配的任务，则继续向前寻找新的迁移任务
        while (advance) {
            int nextIndex, nextBound;
            // 如果i <= bound，则--i >= bound必定为false
            if (--i >= bound || finishing)
                advance = false;
            else if ((nextIndex = transferIndex) <= 0) {
                // transferIndex <= 0，表示所有的桶都有相应的线程在处理
                i = -1;
                advance = false;
            } 
            else if (U.compareAndSetInt
                     (this, TRANSFERINDEX, nextIndex,
                      nextBound = (nextIndex > stride ?
                                   nextIndex - stride : 0))) {
                // 当前线程的迁移任务为[bound, i]
                bound = nextBound;
                i = nextIndex - 1;
                advance = false;
            }
        }
        // 当i<0时，当前线程已经完成了自己的任务，并且没有新的任务需要它去处理
        // i >= n 什么时候成立？nextn=2n，那i + n >= nextn和 i >= n有什么区别？
        if (i < 0 || i >= n || i + n >= nextn) {
            int sc;
            // 若迁移操作已经完成
            if (finishing) {
                nextTable = null;
                // 更新哈希表
                table = nextTab;
                // sizeCtl = 2n - n/2 = 1.5 n = 0.75 (2n)
                sizeCtl = (n << 1) - (n >>> 1);
                return;
            }
            // 线程数减去1
            if (U.compareAndSetInt(this, SIZECTL, sc = sizeCtl, sc - 1)) {
                // 在tryPresize方法中，迁移操作发生前，
                // sc被设置为resizeStamp(n) << RESIZE_STAMP_SHIFT + 2
                // 因此，当下式中的!=成立时，表示还有线程没处理完
                if ((sc - 2) != resizeStamp(n) << RESIZE_STAMP_SHIFT)
                    return;
                // 所有的线程都完成了自己的任务
                finishing = advance = true;
                i = n; // recheck before commit
            }
        }// 第i桶为空，不需要迁移
        else if ((f = tabAt(tab, i)) == null)
            advance = casTabAt(tab, i, null, fwd);
        else if ((fh = f.hash) == MOVED) // 再次检查时才会发生这种情况
            advance = true; // already processed
        else {
            // 锁住桶中的第一个元素
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    Node<K,V> ln, hn;
                    // 若桶中为单链表
                    if (fh >= 0) {
                        // 若runBit == 0，表示该元素仍在当前桶i中；否则，应该放到i + n中
                        int runBit = fh & n;
                        Node<K,V> lastRun = f;
                        // lastRun及之后的结点，runBit值相同
                        for (Node<K,V> p = f.next; p != null; p = p.next) {
                            int b = p.hash & n;
                            if (b != runBit) {
                                runBit = b;
                                lastRun = p;
                            }
                        }
                        // lastRun及之后的结点仍在第i个桶中
                        if (runBit == 0) {
                            ln = lastRun;
                            hn = null;
                        }
                        else {
                            // lastRun及之后的结点应该被转移到第i+n个桶中
                            hn = lastRun;
                            ln = null;
                        }
                        // 按照是否需要移动到新的桶中，将原链表分割为两个子链表
                        for (Node<K,V> p = f; p != lastRun; p = p.next) {
                            int ph = p.hash; K pk = p.key; V pv = p.val;
                            // 头插法
                            if ((ph & n) == 0)
                                ln = new Node<K,V>(ph, pk, pv, ln);
                            else
                                hn = new Node<K,V>(ph, pk, pv, hn);
                        }
                        // 转移到新的哈希表中
                        setTabAt(nextTab, i, ln);
                        setTabAt(nextTab, i + n, hn);
                        // 当第i个桶中的数据迁移完毕时，
                        // 使用ForwardingNode标记原哈希表中的第i个桶
                        setTabAt(tab, i, fwd);
                        advance = true;
                    }
                    else if (f instanceof TreeBin) {
                        TreeBin<K,V> t = (TreeBin<K,V>)f;
                        TreeNode<K,V> lo = null, loTail = null;
                        TreeNode<K,V> hi = null, hiTail = null;
                        int lc = 0, hc = 0;
                        for (Node<K,V> e = t.first; e != null; e = e.next) {
                            int h = e.hash;
                            TreeNode<K,V> p = new TreeNode<K,V>
                                (h, e.key, e.val, null, null);
                            if ((h & n) == 0) {
                                // 尾插法
                                if ((p.prev = loTail) == null)
                                    lo = p;
                                else
                                    loTail.next = p;
                                loTail = p;
                                ++lc;
                            }
                            else {
                                if ((p.prev = hiTail) == null)
                                    hi = p;
                                else
                                    hiTail.next = p;
                                hiTail = p;
                                ++hc;
                            }
                        }
                        // 若红黑树中的结点个数<=不树化阈值，则将红黑树还原为单链表
                        ln = (lc <= UNTREEIFY_THRESHOLD) ? untreeify(lo) :
                            (hc != 0) ? new TreeBin<K,V>(lo) : t;
                        hn = (hc <= UNTREEIFY_THRESHOLD) ? untreeify(hi) :
                            (lc != 0) ? new TreeBin<K,V>(hi) : t;
                        setTabAt(nextTab, i, ln);
                        setTabAt(nextTab, i + n, hn);
                        setTabAt(tab, i, fwd);
                        advance = true;
                    }
                    else if (f instanceof ReservationNode)
                        throw new IllegalStateException("Recursive update");
                }
            }
        }
    }
}
```

