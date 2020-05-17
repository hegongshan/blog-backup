---
title: Java hashCode与equals
date: 2020-04-10 22:54:27
tags: java
categories: java
mathjax: true
---

大伙一定听说过：“要同时重写hashCode和equals方法”，为什么要这样呢？

<!--more-->

先来看看如下的代码：

```java
public class Main {
    public static void main(String[] args) {
        String str = "10";
        Integer x = 1567;
        System.out.println(str.equals(x));
        System.out.println(str.hashCode() == x.hashCode());	
    }
}
```

输出如下：

```java
false
true
```

两个不同对象的哈希码为什么会相等呢？让我们先看下java.lang.String的hashCode方法

```java
// 空字符串的哈希码为0
public int hashCode() {
    int h = hash;
    if (h == 0 && value.length > 0) {
        char val[] = value;

        for (int i = 0; i < value.length; i++) {
            h = 31 * h + val[i];
        }
        hash = h;
    }
    return h;
}
```

换言之，字符串的哈希码为
$$
\mathrm{hash\ code} = s[0] \times 31^{n-1} + s[1] \times 31^{n-2} + ... + s[n-1]
$$
由于字符‘0’的ASCII码值为48，‘1’的ASCII码值为49。因此，字符串“10”的哈希码为$49 \times 31 + 48 = 1567$。

而java.lang.Integer中hashCode方法如下

```java
@Override
public int hashCode() {
    return Integer.hashCode(value);
}
public static int hashCode(int value) {
    return value;
}
```

> 当两个对象的hashCode相等时，它们不一定相等。但是，当两个对象相等时，它们的hashCode必须相等。

java.util.Arrays

```java
public static int hashCode(Object a[]) {
    if (a == null)
        return 0;

    int result = 1;

    for (Object element : a)
        result = 31 * result + (element == null ? 0 : element.hashCode());

    return result;
}
```



java.lang.Object

```java
public native int hashCode();
public boolean equals(Object obj) {
    return (this == obj);
}
```
