---
title: Java中的异常处理
date: 2019-01-17 19:24:16
tags: java
categories: java
---

Java异常处理
<!--more-->

### 异常分类

​	在Java中，所有的异常都是继承自Throwable。

Java中的异常层次结构

```java
Throwable
├── Error
└── Exception
    ├── IOException
    └── RuntimeException
```

派生于Error类或RuntimeException类的所有异常称为非受查（unchecked）异常，所有其他异常称为受查（check）异常。

### 声明异常

方法应该在其首部声明所有可能抛出的异常。语法如下：

```java
public FileInputStream(String name) throws FileNotFoundException
```



### 抛出异常

```java
throw new FileNotFoundException();
```



### 创建异常



### 捕获异常



### finally子句

return

### 带资源的try语句



未完待续...

 