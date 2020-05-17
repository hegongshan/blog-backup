---
title: 抽象类与接口
date: 2020-04-10 12:20:29
tags: java
categories: java
---

在面试中，抽象类与接口的区别经常会被问到。

<!--more-->

### 抽象类

#### 定义抽象类

定义抽象类需要使用abstract关键字，语法如下：

```java
abstract class 类名 {}
```

#### 定义属性

抽象类中可以定义各种类型的属性。

示例：

```java
public abstract class AbstractList<E> {
    // 局部变量
    private int a = 1;
    int b = 2;
    protected int c = 3;
    public int d = 4;
    final int e = 5;

    // 静态变量
    static int f = 6;
    // 静态常量
    static final int G = 7;
}
```

#### 定义方法

抽象类既可以有抽象方法，也可以有普通方法。

```java
public abstract class AbstractList<E> {
    public abstract E get(int index);
    
    public void set() {
        System.out.println("set");
    }
}
```

#### 继承抽象类

继承抽象类，与继承普通类是一样的，使用extends关键字。

实现抽象方法

```java
public class ArrayList<E> extends AbstractList<E> {
    @Override
    public E get(int index) {
        System.out.println("get");
    }
}
```

由于Java只支持单继承，因此，一个类只能继承一个类。如果要实现多继承，可以使用接口。

### 接口

#### 定义接口

使用关键字interface定义接口，语法如下：

```java
interface List {}
```

#### 实现接口

实现接口需要使用implements关键字。

```java
public class MyList implements List {}
```

一个类可以同时实现多个接口

```java
public class MyList implements List, Queue {}
```

接口也可以继承一个或多个接口

```java
public interface List extends Collection {}
public interface List extends Collection, Serializable {}
```

#### 定义属性

```java
public interface List {
    // int data = 1;
    // final int data = 1;
    // static int data = 1;
    putlic static final int data = 1;
}
```

以上四种方式效果都是一样的，接口中的属性默认使用`putlic static final`修饰，因此，接口中的字段都是静态常量。

#### 定义方法

##### 抽象方法

```java
public interface List {
    // int get();
    // putlic int get();
    // abstract int get();
    putlic abstract int get();
}
```

以上四种方式效果都是一样的，接口中的方法默认使用`putlic abstract`修饰。

##### 普通方法

在Java 7以及之前的版本中，接口中只能定义抽象方法。 Java 8对接口进行了增强，允许有默认实现。

接口中的方法只可能是如下的形式：

```java
// 修饰符没有先后顺序
[public] [default|static] [strictfp] 返回值 方法名
```

接口中的所有方法都是公开方法，默认使用public关键字修饰。

若没有被default或者static这两个关键字修饰，则为抽象方法。

示例：

```java
public interface List {
    // default void testDefault() {}
    public default void testDefault() {
        
    }
    // static void testStatic() {}
    public static void testStatic() {
      
    }
}
```

### 总结

|          |                            抽象类                            |                             接口                             |
| :------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| **定义** |                 使用关键字组合abstract class                 |                     使用关键字interface                      |
| **继承** |                            单继承                            |                            多继承                            |
| **属性** |                    可以定义各种类型的变量                    |                        必须为静态常量                        |
| **方法** | 既可以有抽象方法，也可以有普通方法。可以使用任意类型的权限修饰符。 | 既可以有抽象方法，也可以有普通方法（必须被default或者static修饰）。所有方法只能被public修饰。 |

