---
title: Java中的初始化块
date: 2018-08-23 15:23:11
tags: java
categories: java
---

Java中的初始化代码块用一对**花括号{}**标明，初始化代码块在构造方法之前执行。

<!--more-->

### 普通代码块

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

### 静态代码块

静态代码块用**static{}**来标明。静态代码块在普通代码块之前被调用，且仅在类初始化时，执行一次。

示例：

```java
public class Main {
	static{
        System.out.println("执行静态代码块");
    }
    {
        System.out.println("执行普通代码块");
    }
    public Main() {
        System.out.println("执行构造方法");
    }
    
    public static void main(String[] args) {
    	System.out.println("执行Main方法");
        Main main1 = new Main();
        Main main2 = new Main();
    }
}
```

输出结果：

```java
执行静态代码块
执行Main方法
执行普通代码块
执行构造方法
执行普通代码块
执行构造方法
```

### 执行顺序

1.在没有继承关系的情况下，执行顺序为：**静态代码块 (-> Main方法) -> 普通代码块 -> 构造方法。**

2.若存在继承关系，以下面的代码为例：

```java
public class Main {		
	public static void main(String[] args) {
		Son son = new Son();
	}
}

class Parent{	
	static {
		System.out.println("父类静态代码块");
	}	
	{
		System.out.println("父类普通代码块");
	}
	
	public Parent() {
		System.out.println("父类构造器");
	}
}
class Son extends Parent{	
	static {
		System.out.println("子类静态代码块");
	}	
	{
		System.out.println("子类普通代码块");
	}
	
	public Son() {
		System.out.println("子类构造器");
	}
}
```

执行结果：

```
父类静态代码块
子类静态代码块
父类普通代码块
父类构造器
子类普通代码块
子类构造器
```

从上面的例子可知，存在继承的情况下，执行顺序为：

父类静态代码块 -> 子类静态代码块 -> 父类普通代码块 ->  父类构造方法 -> 子类普通代码块 -> 子类构造方法