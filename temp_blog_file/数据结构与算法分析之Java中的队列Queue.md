---
title: 数据结构与算法分析之Java中的队列Queue
date: 2018-04-03 15:34:34
tags: [数据结构,Java Collections API]
categories: 数据结构与算法分析
---
>什么是队列？
>队列是只能从一端插入，从另一端删除的表，通常情况下，它是一个先进先出（first-in-first-out）表

本文是《数据结构与算法分析》系列的第四篇，今天的主角是java.util.Queue，它是jdk1.5的时候新增的一个接口
源码如下：
```java
public interface Queue<E> extends Collection<E> {

    boolean add(E e);	
	
    boolean offer(E e);

    E remove();

    E poll();

    E element();

    E peek();
}
```
