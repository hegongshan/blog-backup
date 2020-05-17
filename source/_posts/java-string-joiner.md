---
title: 详解String::join方法
date: 2020-04-25 13:53:38
tags: java
categories: java
---

在做CCF CSP、PAT等OJ时，经常会遇到这样的问题：输出数组或者集合中的所有元素，元素之间使用空格分隔，但是末尾不能有空格。

<!--more-->

传统的写法如下：

```java
public class Main {
    public static void main(String[] args) {
        String[] arr = { "Java", "is", "cool" };
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arr.length; i++) {
            if (i > 0) {
                sb.append(' ');
            }
            sb.append(arr[i]);
        }
        System.out.println(sb);
    }
}
```

在JDK 8中，String类新增了一个静态方法join，可以按照给定的分隔符拼接多个字符串。

```java
public class Main {
    public static void main(String[] args) {
        String[] arr = { "Java", "is", "cool" };
        System.out.println(String.join(" ", arr));
    }
}
```

String::join内部使用了java.util.StringJoiner类，源码如下：

```java
public static String join(CharSequence delimiter, CharSequence... elements) {
    Objects.requireNonNull(delimiter);
    Objects.requireNonNull(elements);
    // Number of elements not likely worth Arrays.stream overhead.
    StringJoiner joiner = new StringJoiner(delimiter);
    for (CharSequence cs: elements) {
        joiner.add(cs);
    }
    return joiner.toString();
}
```

1.`new StringJoiner(delimiter)`的源码如下：

```java
public StringJoiner(CharSequence delimiter) {
    this(delimiter, "", "");
}
```

2.`this(delimiter, "", "")`的源码如下：

```java
public StringJoiner(CharSequence delimiter,
                    CharSequence prefix,
                    CharSequence suffix) {
    Objects.requireNonNull(prefix, "The prefix must not be null");
    Objects.requireNonNull(delimiter, "The delimiter must not be null");
    Objects.requireNonNull(suffix, "The suffix must not be null");
    // make defensive copies of arguments
    this.prefix = prefix.toString();
    this.delimiter = delimiter.toString();
    this.suffix = suffix.toString();
    this.emptyValue = this.prefix + this.suffix;
}
```

3.`joiner.add(cs)`的源码如下：

```java
public StringJoiner add(CharSequence newElement) {
    prepareBuilder().append(newElement);
    return this;
}
```

4.prepareBuilder方法的源码如下：

```java
private StringBuilder prepareBuilder() {
    if (value != null) {
        value.append(delimiter);
    } else {
        value = new StringBuilder().append(prefix);
    }
    return value;
}
```

5.声明value变量的源码如下：

```java
// value中的内容为：prefix + element + delimiter + ...
// 只有当调用StringJoiner的toString方法时，才会添加suffix
private StringBuilder value;
```

6.`joiner.toString()`的源码如下：

```java
public String toString() {
    if (value == null) {
        return emptyValue;
    } else {
        if (suffix.equals("")) {
            return value.toString();
        } else {
            int initialLength = value.length();
            // 1.先添加后缀
            String result = value.append(suffix).toString();
            // 2.再删除后缀，为之后的插入作准备
            // reset value to pre-append initialLength
            value.setLength(initialLength);
            return result;
        }
    }
}
```

