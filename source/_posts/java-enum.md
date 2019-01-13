---
title: Java中的枚举类型
date: 2018-08-20 12:15:33
tags: java
categories: java
---

枚举类的主要作用是便捷地定义静态常量，替代public static final xxx。

所有的枚举类型都是java.lang.Enum类的子类，java.lang.Enum的类结构如下：

```java
public abstract class Enum<E extends Enum<E>> 
implements Comparable<E>, Serializable
```

方法列表：

```java
public final String name();
public String toString();
public static Enum valueOf(Class enumClass,String name);
public final int ordinal();
```

<!--more-->

枚举类型的一个简单的例子：

```java
enum Week {
	MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY;
}
```

事实上，上面定义了一个类，它只有七个实例，这些实例**只能在其他代码之前定义**，并以封号结束。

如果需要的话，可以在枚举类型中添加一些构造器、方法和域。不过，**枚举类型只能包含私有构造**，且构造器只在构造枚举常量的时候被调用。

```java
enum Week {
    //只能在其他代码之前定义
    MONDAY(1),TUESDAY(2),WEDNESDAY(3),
    THURSDAY(4),FRIDAY(5),SATURDAY(6),SUNDAY(7); 
    private int day;
    //只在构造枚举常量的时候被调用
    private Week(int day) {
        this.day = day;
    }
    public int getDay() {
        return day;
    }
}
```

### name()

方法描述：返回枚举常量名。

```java
enum Week {
	MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY;
}
public class Main {
    public static void main(String[] args) {
        System.out.println(Week.MONDAY.name());
    }
}
```

输出结果：

```java
MONDAY
```

### toString()

方法描述：返回枚举常量名。

```java
enum Week {
	MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY;
}
public class Main {
    public static void main(String[] args) {
        System.out.println(Week.MONDAY.toString());
    }
}
```

输出结果：

```java
MONDAY
```

通过查看源码，可以看到，toString()方法返回的是name属性。

```java
public String toString() {
    return name;
}
```

### valueOf()

```java
public static Enum valueOf(Class enumClass,String name);
```

方法描述：返回指定名字、给定类的枚举常量

```java
enum Week {
	MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY;
}
public class Main {
    public static void main(String[] args) {
        Week week = Enum.valueOf(Week.class,"FRIDAY");
        System.out.println(week);
    }
}
```

输出结果：

```java
FRIDAY
```

### ordinal()

方法描述：返回枚举常量在enum中声明的位置，位置从0开始计数。

```java
enum Week {
	MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY;
}
public class Main {
    public static void main(String[] args) {
        System.out.println(Week.THURSDAY.ordinal());
    }
}
```

输出结果：

```java
3
```

正如这个方法注释中描述的那样，

```html
Most programmers will have no use for this method. 
It is designed for use by sophisticated enum-based data structures,
such as java.util.EnumSet and java.util.EnumMap.
```

大多数程序员**用不到这个方法**，它是为EnumSet和EnumMap这些基于枚举的复杂数据结构设计的。

### values()

每个枚举类都有一个静态方法values()，它返回一个包含全部枚举值的数组。

示例：

```java
enum Week {
	MONDAY(1),TUESDAY(2),WEDNESDAY(3),
    THURSDAY(4),FRIDAY(5),SATURDAY(6),SUNDAY(7);
	private int day;
	private Week(int day) {
		this.day = day;
	}
    public int getDay() {
        return day;
    }
}
public class Main {
    public static void main(String[] args) {
        Week[] weeks = Week.values();
        StringBuilder sb = new StringBuilder();
        for(Week week : weeks) {            
        	sb.append(week.getDay()+" ");
        }
        System.out.println(sb);
    }
}
```

输出结果：

```java
1 2 3 4 5 6 7 
```

### equals()和==

在比较两个枚举类型的值时，不需要调用equals，可以直接使用“==”。

查看源码，可以知道，Enum类的equals也是直接使用的"=="来比较。

```java
public final boolean equals(Object other) {
    return this==other;
}
```