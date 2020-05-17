---
title: Java集合类之列表List
date: 2018-03-29 11:00:18
tags: java collections framework
categories: java
---

List是一种有序且允许重复的集合。

<!--more-->

### List家族

![List家族](/static/images/java-list-family.png)

### 遍历List

下面以`List<String>`为例

#### for循环

```java
for (int i = 0; i < list.size(); i++) {
    System.out.println(list.get(i));
}
```

#### for-each遍历循环

```java
for (String str : list) {
    System.out.println(str);
}
```

#### 迭代器

* 使用父接口Collection中定义的iterator方法，它只能从前往后遍历。

```java
Iterator<String> iter = list.iterator();
// 只能从前向后遍历
while (iter.hasNext()) {
    System.out.println(iter.next());
}
```

* 使用List自带的ListIterator，它支持双向遍历。

```java
ListIterator<String> iter = list.listIterator();
// 从前往后遍历
while (iter.hasNext()) {
    System.out.println(iter.next());
}
// 从后往前遍历
while (iter.hasPrevious()) {
    System.out.println(iter.previous());
}
```

#### forEach方法

```java
// list.forEach(System.out::println);
list.forEach(x -> System.out.println(x));
```

### 实现类比较

|        实现类        | 存储结构 | 是否线程安全 | 默认初始容量 | 默认扩容机制（n为原来的容量） |
| :------------------: | :------: | :----------: | :----------: | :---------------------------: |
|        Vector        |   数组   |   线程安全   |      10      |             2 n             |
|      ArrayList       |   数组   |  线程不安全  |      10      |            1.5 n            |
|      LinkedList      |   链表   |  线程不安全  |      -       |               -               |
| CopyOnWriteArrayList |   数组   |   线程安全   |      0       |             n + 1             |

