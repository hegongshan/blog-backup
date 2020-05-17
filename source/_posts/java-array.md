---
title: Java数组与可变参数
date: 2020-04-08 13:44:52
tags: java
categories: java
---

本文回顾了Java中数组的相关知识，同时探究了可变参数的实现原理。

<!--more-->

### 申明数组

当申明数组时，Java支持以下两种方式

```java
类型[] 数组名;
类型 数组名[];
```

示例：

```java
int[] arr;
int arr[];
```

如果熟悉C语言，就会发现：第二种写法与C语言中定义数组的写法没有区别。

在Java中，推荐采用第一种写法，它直观地表明了这是一个数组类型。

### 使用数组

在使用前，必须为数组分配空间：

```java
// 此时arr中的元素全为0
int[] arr = new int[3];
```

初始化

```java
arr[0] = 1;
arr[1] = 2;
arr[2] = 3;
```

当然，我们也可以在申明数组的同时，对数组进行赋值。

```java
int[] arr = new int[] {1, 2, 3};
```

上面的写法可以进一步精简为：

```java
int[] arr = {1, 2, 3};
```

### 默认属性

每个数组都有一个length字段，用于记录数组的长度。

```java
int[] arr = {1, 2, 3};
// len等于3
int len = arr.length;
```

该字段是由Java虚拟机自动创建的。在HotSpot虚拟机中，它存储在对象头中。

> 关于对象头，可以参看《深入理解Java虚拟机：JVM高级特性与最佳实践》第2章中“对象的内存布局”一节。

### 多维数组

下面以二维数组为例

```java
// 定长的二维数组
int[][] arr = new int[4][4];

// 不定长
int[][] arr2 = new int[4][];
arr2[0] = new int[2];
arr2[1] = new int[3];
```

虽然Java支持多维数组，但在开发中，一般只使用二维数组。这是因为三维（及以上）数组理解起来并不容易。

### Arrays工具类

为了方便操作数组，JDK中提供了一个工具类java.util.Arrays，它可以用于对数组进行排序、判断两个数组是否相等等操作。

#### 将数组转变为字符串

如果是一维数组

```java
Arrays.toString(xx[] arr);
```

如果是多维数组，可以使用

```java
Arrays.deepToString(Object[] a);
```

#### 判断数组是否相等

如果是一维数组

```java
Arrays.equals(xx[] a, xx[] a2);
```

如果是多维数组，可以使用

```java
Arrays.deepEquals(Object[] a1, Object[] a2);
```

#### 将数组转变为列表

```java
// ...表示可变参数
Arrays.asList(T... a);
```

注意：转换得到的列表支持查询和修改操作，但不支持添加和删除操作。

当执行add或者remove方法时，将抛出java.lang.UnsupportedOperationException。

```java
// 这里的ArrayList是Arrays的一个静态内部类，而不是java.util.ArrayList
public static <T> List<T> asList(T... a) {
    return new ArrayList<>(a);
}
```

java.util.Arrays.ArrayList继承了java.util.AbstractList，但没有重写add和remove方法。

### 可变参数

在Arrays.asList()中，出现了T... a，这叫做可变参数（Variable arguments，简称Varargs），语法如下：

```java
// 三个点...的左右允许有任意多个空格
方法名(类型... 参数名)
```

可变参数可以输入任意多个参数，包括0个。但是，它必须是方法的最后一个参数。

**错误的例子**

```java
// 无法通过编译
public void print(int... arr, String str);
```

#### 实现原理

可变参数本质上就是一个数组，它只是编译器提供的一种语法糖。以下面的代码为例

```java
import java.util.Arrays;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = Arrays.asList("hello", "world!");
        System.out.println(list);
    }
}
```

对Main.class文件进行反编译，得到如下的结果：

```java
import java.util.Arrays;
import java.util.List;

public class Main {
    public static void main(String[] paramArrayOfString) {
        List<String> list = Arrays.asList(new String[] { "hello", "world!" });
        System.out.println(list);
    }
}
```

可以看到：可变参数在调用的时候变成了一个数组类型的参数。