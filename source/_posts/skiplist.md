---
title: 论文阅读 Skip Lists&#58; A Probabilistic Alternative to Balanced Trees
date: 2021-10-14 15:11:51
tags: skiplist
categories: data structure
mathjax: true
---

Skip List，跳跃链表，简称跳表，最早是由William Pugh在1989年提出。

<!--more-->

### Skip List算法

LeetCode上有一道设计跳表的题目——[1206.设计跳表](https://leetcode-cn.com/problems/design-skiplist/)，下面结合论文给出的算法，分别实现跳表的查找、插入以及删除操作。

首先，跳表的数据结构定义如下：

```java
class Skiplist {
    private static final int MAX_LEVEL = 32;
    private static final double PROBABILITY = 0.25d;
    private Random random;
    private Node head;
    private int level;

    public Skiplist() {
        level = 1;
        random = new Random();
        head = new Node(null, MAX_LEVEL);
    }

    static class Node {
        Integer val;
        Node[] forward;
        public Node(Integer val, int level) {
            this.val = val;
            this.forward = new Node[level];
        }
    }
}
```

#### 查找节点

![](/static/images/skiplist-search.png)

```java
public boolean search(int target) {
    Node x = head;
    for (int i = level - 1; i >= 0; i--) {
        while (x.forward[i] != null && x.forward[i].val < target) {
            x = x.forward[i];
        }
    }
    x = x.forward[0];
    if (x != null && x.val == target) {
        return true;
    }
    return false;
}
```

#### 插入和更新节点

![](/static/images/skiplist-insert.png)

```java
public void add(int num) {
    Node[] update = new Node[MAX_LEVEL];
    Node x = head;
    for (int i = level - 1; i >= 0; i--) {
        while (x.forward[i] != null && x.forward[i].val < num) {
            x = x.forward[i];
        }
        update[i] = x;
    }

    int newLevel = randomLevel();
    if (newLevel > level) {
        for (int i = level; i < newLevel; i++) {
            update[i] = head;
        }
        level = newLevel;
    }
    
    x = new Node(num, newLevel);
    for (int i = 0; i < newLevel; i++) {
        x.forward[i] = update[i].forward[i];
        update[i].forward[i] = x;
    }
}
```

#### 计算随机层数

![](/static/images/skiplist-random-level.png)

```java
private int randomLevel() {
    int newLevel = 1;
    while (random.nextDouble() < PROBABILITY) {
        newLevel ++;
    }
    return Math.min(newLevel, MAX_LEVEL);
}
```

#### 删除节点

![](/static/images/skiplist-delete.png)

```java
public boolean erase(int num) {
    Node[] update = new Node[MAX_LEVEL];
    Node x = head;
    for (int i = level - 1; i >= 0; i--) {
        while (x.forward[i] != null && x.forward[i].val < num) {
            x = x.forward[i];
        }
        update[i] = x;
    }

    x = x.forward[0];
    if (x != null && x.val == num) {
        for (int i = 0; i < level; i++) {
            if (update[i].forward[i] != null && update[i].forward[i] == x) {
                update[i].forward[i] = x.forward[i];
            }
        }
        
        while (level > 1 && head.forward[level - 1] == null) {
            level --;
        }
        return true;
    }
    return false;
}
```

### Redis跳表实现

数据结构如下：

```c
typedef struct zskiplistNode {
    sds ele; // char *
    double score;
    struct zskiplistNode *backward;
    struct zskiplistLevel {
        struct zskiplistNode *forward;
        unsigned long span;
    } level[];
} zskiplistNode;

typedef struct zskiplist {
    struct zskiplistNode *header, *tail;
    unsigned long length;
    int level;
} zskiplist;
```

#### 查找元素

```c
/* Find the rank for an element by both score and key.
 * Returns 0 when the element cannot be found, rank otherwise.
 * Note that the rank is 1-based due to the span of zsl->header to the
 * first element. */
unsigned long zslGetRank(zskiplist *zsl, double score, sds ele) {
    zskiplistNode *x;
    unsigned long rank = 0;
    int i;

    x = zsl->header;
    for (i = zsl->level-1; i >= 0; i--) {
        while (x->level[i].forward &&
            (x->level[i].forward->score < score ||
                (x->level[i].forward->score == score &&
                sdscmp(x->level[i].forward->ele,ele) <= 0))) {
            rank += x->level[i].span;
            x = x->level[i].forward;
        }

        /* x might be equal to zsl->header, so test if obj is non-NULL */
        if (x->ele && x->score == score && sdscmp(x->ele,ele) == 0) {
            return rank;
        }
    }
    return 0;
}
```

#### 添加元素

```c
/* Insert a new node in the skiplist. Assumes the element does not already
 * exist (up to the caller to enforce that). The skiplist takes ownership
 * of the passed SDS string 'ele'. */
zskiplistNode *zslInsert(zskiplist *zsl, double score, sds ele) {
    zskiplistNode *update[ZSKIPLIST_MAXLEVEL], *x;
    unsigned long rank[ZSKIPLIST_MAXLEVEL];
    int i, level;

    serverAssert(!isnan(score));
    x = zsl->header;
    for (i = zsl->level-1; i >= 0; i--) {
        /* store rank that is crossed to reach the insert position */
        rank[i] = i == (zsl->level-1) ? 0 : rank[i+1];
        while (x->level[i].forward &&
                (x->level[i].forward->score < score ||
                    (x->level[i].forward->score == score &&
                    sdscmp(x->level[i].forward->ele,ele) < 0)))
        {
            rank[i] += x->level[i].span;
            x = x->level[i].forward;
        }
        update[i] = x;
    }
    /* we assume the element is not already inside, since we allow duplicated
     * scores, reinserting the same element should never happen since the
     * caller of zslInsert() should test in the hash table if the element is
     * already inside or not. */
    level = zslRandomLevel();
    if (level > zsl->level) {
        for (i = zsl->level; i < level; i++) {
            rank[i] = 0;
            update[i] = zsl->header;
            update[i]->level[i].span = zsl->length;
        }
        zsl->level = level;
    }
    x = zslCreateNode(level,score,ele);
    for (i = 0; i < level; i++) {
        x->level[i].forward = update[i]->level[i].forward;
        update[i]->level[i].forward = x;

        /* update span covered by update[i] as x is inserted here */
        x->level[i].span = update[i]->level[i].span - (rank[0] - rank[i]);
        update[i]->level[i].span = (rank[0] - rank[i]) + 1;
    }

    /* increment span for untouched levels */
    for (i = level; i < zsl->level; i++) {
        update[i]->level[i].span++;
    }

    x->backward = (update[0] == zsl->header) ? NULL : update[0];
    if (x->level[0].forward)
        x->level[0].forward->backward = x;
    else
        zsl->tail = x;
    zsl->length++;
    return x;
}
```

#### 计算随机层数

函数`zslRandomLevel()`的实现如下：

```c
/* Returns a random level for the new skiplist node we are going to create.
 * The return value of this function is between 1 and ZSKIPLIST_MAXLEVEL
 * (both inclusive), with a powerlaw-alike distribution where higher
 * levels are less likely to be returned. */
int zslRandomLevel(void) {
    int level = 1;
    while ((random()&0xFFFF) < (ZSKIPLIST_P * 0xFFFF))
        level += 1;
    return (level<ZSKIPLIST_MAXLEVEL) ? level : ZSKIPLIST_MAXLEVEL;
}
```

其中，random()定义在标准库stdlib.h中，返回类型为long；`ZSKIPLIST_P`和`ZSKIPLIST_MAXLEVEL`定义在[server.h](https://github.com/redis/redis/blob/unstable/src/server.h)中：

```c
#define ZSKIPLIST_MAXLEVEL 32 /* Should be enough for 2^64 elements */
#define ZSKIPLIST_P 0.25      /* Skiplist P = 1/4 */
```

#### 删除元素

```c
/* Delete an element with matching score/element from the skiplist.
 * The function returns 1 if the node was found and deleted, otherwise
 * 0 is returned.
 *
 * If 'node' is NULL the deleted node is freed by zslFreeNode(), otherwise
 * it is not freed (but just unlinked) and *node is set to the node pointer,
 * so that it is possible for the caller to reuse the node (including the
 * referenced SDS string at node->ele). */
int zslDelete(zskiplist *zsl, double score, sds ele, zskiplistNode **node) {
    zskiplistNode *update[ZSKIPLIST_MAXLEVEL], *x;
    int i;

    x = zsl->header;
    for (i = zsl->level-1; i >= 0; i--) {
        while (x->level[i].forward &&
                (x->level[i].forward->score < score ||
                    (x->level[i].forward->score == score &&
                     sdscmp(x->level[i].forward->ele,ele) < 0)))
        {
            x = x->level[i].forward;
        }
        update[i] = x;
    }
    /* We may have multiple elements with the same score, what we need
     * is to find the element with both the right score and object. */
    x = x->level[0].forward;
    if (x && score == x->score && sdscmp(x->ele,ele) == 0) {
        zslDeleteNode(zsl, x, update);
        if (!node)
            zslFreeNode(x);
        else
            *node = x;
        return 1;
    }
    return 0; /* not found */
}
```

其中，函数`zslDeleteNode`的实现如下：

```c
/* Internal function used by zslDelete, zslDeleteRangeByScore and
 * zslDeleteRangeByRank. */
void zslDeleteNode(zskiplist *zsl, zskiplistNode *x, zskiplistNode **update) {
    int i;
    for (i = 0; i < zsl->level; i++) {
        if (update[i]->level[i].forward == x) {
            update[i]->level[i].span += x->level[i].span - 1;
            update[i]->level[i].forward = x->level[i].forward;
        } else {
            update[i]->level[i].span -= 1;
        }
    }
    if (x->level[0].forward) {
        x->level[0].forward->backward = x->backward;
    } else {
        zsl->tail = x->backward;
    }
    while(zsl->level > 1 && zsl->header->level[zsl->level-1].forward == NULL)
        zsl->level--;
    zsl->length--;
}
```

### 参考资料

1. 论文地址：https://dl.acm.org/doi/pdf/10.1145/78973.78977
2. LeetCode 1206.设计跳表，https://leetcode-cn.com/problems/design-skiplist/
3. Redis，https://github.com/redis/redis/

