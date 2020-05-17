---
title: LeetCode 146.LRU缓存机制
date: 2020-03-16 17:55:43
tags: linked-list
categories: leetcode
---

运用你所掌握的数据结构，设计和实现一个  LRU (最近最少使用) 缓存机制。它应该支持以下操作： 获取数据 get 和 写入数据 put 。

* 获取数据 get(key) - 如果密钥 (key) 存在于缓存中，则获取密钥的值（总是正数），否则返回 -1。
* 写入数据 put(key, value) - 如果密钥不存在，则写入其数据值。当缓存容量达到上限时，它应该在写入新数据之前删除最久未使用的数据值，从而为新的数据值留出空间。

<!--more-->

**进阶:**

你是否可以在 O(1) 时间复杂度内完成这两种操作？

**示例:**

```java
LRUCache cache = new LRUCache( 2 /* 缓存容量 */ );

cache.put(1, 1);
cache.put(2, 2);
cache.get(1);       // 返回  1
cache.put(3, 3);    // 该操作会使得密钥 2 作废
cache.get(2);       // 返回 -1 (未找到)
cache.put(4, 4);    // 该操作会使得密钥 1 作废
cache.get(1);       // 返回 -1 (未找到)
cache.get(3);       // 返回  3
cache.get(4);       // 返回  4
```

### 方法一：LinkedHashMap

```java
import java.util.LinkedHashMap;
import java.util.Map;

class LRUCache extends LinkedHashMap<Integer, Integer> {

    private int capacity;

    public LRUCache(int capacity) {
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }

    public int get(int key) {
        return super.getOrDefault(key, -1);
    }

    public void put(int key, int value) {
        super.put(key, value);
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > capacity;
    }
}
```

### 方法二：HashMap+双链表

思路：自定义双链表，配合HashMap，实现LRU缓存机制。当采用头插法时，最久未使用的数据为尾节点。

```java
import java.util.HashMap;
import java.util.Map;

class LRUCache {

    private Map<Integer, Node> map;
    private Node head;
    private Node tail;
    private int capacity;

    public LRUCache(int capacity) {
        this.capacity = capacity;
        map = new HashMap<>(capacity);
    }

    public int get(int key) {
        Node node = map.get(key);
        if (node == null) {
            return -1;
        }
        moveToHead(node);
        return node.value;
    }

    public void put(int key, int value) {
        Node node = map.get(key);

        // 若键名已经存在
        if (node != null) {
            node.value = value;
            moveToHead(node);
            return;
        }
        node = new Node(key, value);
        map.put(key, node);
        addFirst(node);

        if (map.size() > this.capacity) {
            Node e = removeLast();
            map.remove(e.key);
        }
    }

    @Override
    public String toString() {
        if (head == null) {
            return "{}";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        Node node = head;
        while (node != null) {
            sb.append(node.key).append('=').append(node.value);
            node = node.next;
            if (node != null) {
                sb.append(", ");
            }
        }
        return sb.append("}").toString();
    }

    private void moveToHead(Node node) {
        if (node == head) {
            return;
        }
        removeNode(node);
        addFirst(node);
    }

    private Node removeLast() {
        Node node = tail;
        removeNode(tail);
        return node;
    }

    private void addFirst(Node node) {
        if (head != null) {
            node.next = head;
            head.prev = node;

            head = node;
        } else {
            head = tail = node;
        }
    }

    private void removeNode(Node node) {
        Node before = node.prev;
        Node after = node.next;

        node.prev = node.next = null;

        if (before == null) {
            head = after;
        } else {
            before.next = after;
        }
        if (after == null) {
            tail = before;
        } else {
            after.prev = before;
        }
    }

    static class Node {
        int key;
        int value;
        Node prev;
        Node next;

        public Node(int key, int value) {
            this.key = key;
            this.value = value;
        }
    }
}
```

