---
title: Java中的初始化块
date: 2018-08-23 15:23:11
tags: java
categories: java
---

Java中的初始化代码块用一对**花括号{}**标明，初始化代码块在构造方法之前执行。

<!--more-->

一个简单的例子：

```java
public class Main {
    public static void main(String[] args) {
        Test test = new Test();
    }
}
class Test {
    {
        System.out.println("Hello 初始化代码块");
    }
    public Test() {
        System.out.println("执行构造方法");
    }
}
```

输出结果：

```java
Hello 初始化代码块
执行构造方法
```

另外，Java中还有一个静态初始化代码块，用**static{}**来标明。静态初始化代码块在普通代码块之前被调用。

示例：

```java
public class Main {
    public static void main(String[] args) {
        Test test = new Test();
    }
}
class Test {
    static{
        System.out.println("执行静态代码块");
    }
    {
        System.out.println("执行普通代码块");
    }
    public Test() {
        System.out.println("执行构造方法");
    }
}
```

输出结果：

```java
执行静态代码块
执行普通代码块
执行构造方法
```

总的来说，执行顺序：静态初始化代码块>普通初始化代码块>构造方法