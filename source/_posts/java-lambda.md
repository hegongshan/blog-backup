---
title: Java 8之lambda表达式
date: 2020-05-17 23:16:25
tags: java
categories: java
---

假设我们要创建一个线程，用于打印“Hello world!”。在Java 8之前，我们可以通过如下的方式来实现：

```java
new Thread(new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello world!");
    }
}).start();
```

在Java 8以后，可以使用lambda表达式来简写：

```java
new Thread(() -> System.out.println("Hello world!")).start();
```

<!--more-->

### 函数式接口

函数式接口：只有一个抽象方法的接口。

在Java 8中，新增了一个注解@FunctionalInterface，用于标识函数式接口。

java.lang.Runnable就是一个函数式接口，其源码如下：

```java
@FunctionalInterface
public interface Runnable {
    public abstract void run();
}
```

### Lambda表达式

在接受函数式接口的地方可以使用Lambda表达式。语法如下：

```java
(parameters) -> expression
```

或者

```java
(parameters) -> { statements; }
```

**示例：**

1.没有参数

```java
Runnable r = () -> System.out.println("Hello world!");
```

2.一个参数

```java
Predicate<String> p = (String s) -> s.isEmpty();

// 省略参数类型
Predicate<String> p2 = (s) -> s.isEmpty();

// 当仅有一个参数时，参数名称两边的括号可以省略
Predicate<String> p3 = s -> s.isEmpty();
```

3.两个参数

```java
List<User> list = new ArrayList<>();
list.sort((User a, User b) -> a.getMoney() - b.getMoney());

// 省略参数类型
// list.sort((a, b) -> a.getMoney() - b.getMoney());
```

4.方法体多于1行

```java
list.sort((Apple a, Apple b) -> {
    if (a.getWeight() != b.getWeight()) {
        return a.getMoney() - b.getMoney();
    }
    return a.getCountry().compareTo(b.getCountry());
});
```

### 使用局部变量

lambda表达式允许使用外部变量。但局部变量必须显式声明为final，或者事实上是final。

```java
// 显式声明为final
final int x = 33;
Runnable r = () -> System.out.println(x);
```

或者

```java
// 事实上是final：只赋值一次
int x = 33;
Runnable r = () -> System.out.println(x);
```

下面的代码无法编译，将报错误：Local variable x defined in an enclosing scope must be final or effectively final

```java
int x = 33;
Runnable r = () -> System.out.println(x);
x = 44;
```

### 方法引用

当Lambda表达式中只是直接调用一个方法时，我们可以采用方法引用，重用已有的方法定义。

1. 静态方法。语法为`类名::方法名`。例如，`Integer::parseInt`。

2. 实例方法。语法为`类名::方法名`。例如，`String::length`。

3. 现存对象的实例方法。例如，`this::isEmpty`。

4. 构造函数引用。语法：`类名::new`。例如，`String::new`。

**示例：**

1.遍历列表

```java
List<String> list = new ArrayList<>();
list.add("Java");
list.add("is");
list.add("cool!");
// 使用lambda表达式
list.forEach((x) -> System.out.println(x));
// 使用方法引用
list.forEach(System.out::println);
```

2.排序：按照重量对苹果进行升序排序，如果重量相等，则按照原产国排序

```java
list.sort((Apple a, Apple b) -> {
    if (a.getWeight() != b.getWeight()) {
        return a.getMoney() - b.getMoney();
    }
    return a.getCountry().compareTo(b.getCountry());
});
```

采用方法引用重写：

```java
list.sort(Comparator.comparing(Apple::getWeight)
          .thenComparing(Apple::getCountry));
```

