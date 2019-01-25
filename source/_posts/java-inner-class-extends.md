---
title: Java中的内部类继承
date: 2019-01-13 18:09:54
tags: java
categories: java
---

由于Java中的匿名内部类不能被继承，而局部内部类和静态内部类的继承，与普通类继承没有区别。故本文主要描述成员内部类的继承问题。

<!--more-->

成员内部类的继承可分为以下三种情况：

* 内部类及其子类在同一个外围类中
* 内部类及其子类在不同的外围类中
* 内部类的子类不是内部类

下面对这三种情况逐一分析

#### 内部类及其子类在同一个外围类中

在这种情况下，内部类和子类都是同一个外围类的内部类，此时成员内部类的继承与普通类的继承没有区别。下面通过一个示例来说明这个问题：

```java
class WithInner {
	class Inner{
		public Inner() {
			System.out.println("Inner");
		}		
	}
	
	class InheritInner extends Inner {
		public InheritInner() {
			System.out.println("InheritInner");
		}
	}
}

public class Main {
	public static void main(String[] args) {
		WithInner wi = new WithInner();
		WithInner.InheritInner ii = wi.new InheritInner();
	}
}
输出如下：
Inner
InheritInner
```

上述程序编译后，生成了如下的class文件

```java
Main.class
WithInner$InheritInner.class
WithInner$Inner.class
WithInner.class
```

在[《Java内部类实现原理分析》](https://www.hegongshan.com/2019/01/14/java-inner-class-implementation-principle/)中，我们已经知道编译器会为内部类自动添加一个声明为final的外围类字段，并为内部类自动生成一个带参数的构造方法，就像下面这样：

```java
Compiled from "Main.java"
class WithInner$InheritInner extends WithInner$Inner {
	final WithInner this$0;
	public WithInner$InheritInner(WithInner);
}
```

由于`WithInner$InheritInner`类和`WithInner$Inner`类都在`WithInner`类中，编译器会为`WithInner$InheritInner`类自动添加声明为final的WithInner，故`WithInner$InheritInner`类继承`WithInner$Inner`类时，我们并不需要做什么额外的工作，就像普通类继承一样。

#### 内部类及其子类在不同的外围类中

先来看下面的程序

```java
class WithInner {
	class Inner{
		public Inner() {
			System.out.println("Inner");
		}		
	}
}
class Outer {
	class InheritInner extends WithInner.Inner {
		public InheritInner(WithInner wi) {
			wi.super();
			System.out.println("InheritInner");
		}
	}
}
public class Main {
	public static void main(String[] args) {
		WithInner wi = new WithInner();
		Outer outer = new Outer();
		Outer.InheritInner ii = outer.new InheritInner(wi);
	}
}
输出如下：
Inner
InheritInner
```

InheritInner继承自内部类WithInner.Inner，由于InheritInner不在WithInner中，编译器不会为其自动添加具有WithInner参数的构造器，当要生成一个构造器时，必须传入一个指向外围类对象的引用。此外，还必须在构造器内使用如下语法，显式地调用其父类WithInner.Inner的构造器：

```java
enclosingClassReference.super();
```

否则，将会产生如下错误：

```java
No enclosing instance of type WithInner is accessible to invoke the super constructor. 
Must define a constructor and explicitly qualify its super constructor invocation
with an instance of WithInner (e.g. x.super() where x is an instance of WithInner).
```

翻译过来就是

```java
没有外围类WithInner的实例，无法调用父类构造器。
必须定义一个构造器，并且用WithInner的实例显式地调用父类构造器。
（如，x.super(),其中x是WithInner的一个实例）
```

上述程序编译后，生成了如下的class文件

```java
Main.class
Outer$InheritInner.class
Outer.class
WithInner$Inner.class
WithInner.class
```

使用`javap -p`查看`Outer$InheritInner.class`,输出内容如下：

```java
Compiled from "Main.java"
class Outer$InheritInner extends WithInner$Inner {
  final Outer this$0;
  public Outer$InheritInner(Outer, WithInner);
}
```

不难想到，编译之后的`Outer$InheritInner`应该是下面这个样子:

```java
class Outer$InheritInner extends WithInner$Inner {
	final Outer this$0;
  	public Outer$InheritInner(Outer outer, WithInner wi) {
//先初始化父内部类，从而初始化父内部类中的final WithInner this$0，继而通过继承得到对WithInner的引用
		wi.super(wi);
		this$0 = outer;
        ...
 	}
}
```

#### 内部类的子类不是内部类

下面通过一个示例来说明这个问题：

```java
class WithInner {
	class Inner{}
}
class InheritInner extends WithInner.Inner{
	public InheritInner(WithInner wi) {
		wi.super();
	}
}
public class Main {
	public static void main(String[] args) {
		WithInner wi = new WithInner();
		InheritInner ii = new InheritInner(wi);
	}
}
```

和“内部类及其子类在不同的外围类中”的情况一样，当内部类的子类不是一个内部类时，我们也必须显式地添加一个带外围类对象的构造器，并在构造器内使用如下语法：

```java
enclosingClassReference.super();
```

否则，会产生如下错误：

```java
No enclosing instance of type WithInner is available due to some intermediate constructor invocation
```

翻译过来就是

```java
由于一些中间构造器的调用，没有外围类WithInner的实例可用
```

