---
title: JVM常用参数
date: 2020-07-18 01:06:31
tags: java
categories: java
---

JVM（Java Virtual Machine）是Java开发绕不过去的话题，熟悉JVM常用参数是每个Java工程师的基本功。

<!--more-->

### 查看JVM参数

#### 查看所有-X参数

```java
java -X
```

#### 查看所有-XX参数

```java
// 打印-XX参数的最终值
java -XX:+PrintFlagsFinal
```

### 堆

-Xmx：设置堆的最大容量

-Xms：设置堆的初始容量

-Xmn：设置新生代的大小

* 示例

```java
java Main.java -Xmx400M -Xms400M
```

注：以字节为单位，如：K、M、G，不区分大小写。

### 栈

-Xss：设置Java 线程堆栈大小

* 示例

```java
java Main.java -Xss20K
```

### 其他参数

-XX:+HeapDumpOnOutOfMemoryError：发生OOM时，保存堆快照

-XX:+PrintGCDetails：打印GC详情

