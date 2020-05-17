---
title: Java注解
date: 2020-04-11 13:29:05
tags: java
categories: java
---

元注解：注解的注解

```java
Documented
Retention
Target
```

Retention策略：

* 源码级别 RetentionPolicy.SOURCE：编译时被丢弃
* 字节码级别 RetentionPolicy.CLASS：编译时记录在字节码中，但运行时不保留。
* 运行时 RetentionPolicy.RUNTIME：记录在字节码中，运行时需要保留。

### 定义注解

语法如下：

```java
@interface 注解名 {}
```

