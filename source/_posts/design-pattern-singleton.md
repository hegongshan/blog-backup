---
title: 单例模式
date: 2020-04-26 00:46:02
tags: design pattern
categories: design pattern
---

2020年4月初，网易笔试考到了单例模式；4月22日，阿里总监面又问到了设计模式；几天之后，我同学面拼多多，面试官又让他手写单例模式。在面试过程中，单例模式被考察到的频率实在太高了。

<!--more-->

### 饿汉式

线程安全

```java
class Singleton {
    private static Singleton instance = new Singleton();

    public static Singleton getInstance() {
        return instance;
    }

    private Singleton() {}
}
```

典型示例：java.lang.Runtime

```java
public class Runtime {
    private static Runtime currentRuntime = new Runtime();

    public static Runtime getRuntime() {
        return currentRuntime;
    }

    private Runtime() {}
    // 省略了其他代码
}
```

### 懒汉式

线程不安全。

```java
class Singleton {
    private static Singleton instance;
    
    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }

    private Singleton() {}
}

```

加锁

1.同步方法

```java
class Singleton {
    private static Singleton instance;
    
    public static synchronized Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }

    private Singleton() {}
}
```

2.同步代码块

```java
class Singleton {
    private static Singleton instance;

    public static Singleton getInstance() {
        synchronized (Singleton.class) {
            if (instance == null) {
                instance = new Singleton();
            }
            return instance;
        }
    }

    private Singleton() {}
}
```

### DCL

双重锁定检查（Double Check Locking，简称DCL），线程安全。

```java
class Singleton {
    // volatile保证可见性
    private static volatile Singleton instance;

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }

    private Singleton() {}
}
```

### 静态代码块

```java
class Singleton {
    private static Singleton instance;
    
    static {
        instance = new Singleton();
    }
    
    public static Singleton getInstance() {
        return instance;
    }

    private Singleton() {}
}
```

### 静态内部类

```java
class Singleton {
    private Singleton() {}

    // 私有的静态内部类
    private static class SingletonHolder {
        private static final Singleton INSTANCE = new Singleton();
    }

    public static Singleton getInstance() {
        return SingletonHolder.INSTANCE;
    }
}
```

### 枚举

```java
enum Singleton {
    INSTANCE;
}
```

