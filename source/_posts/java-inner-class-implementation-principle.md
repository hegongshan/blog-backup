---
title: Java内部类实现原理分析
date: 2019-01-14 18:09:12
updated: 2019-01-14 18:09:12
tags: java
categories: java
---

​	本文通过分析编译后的class文件，来揭秘Java中内部类的实现原理。

<!--more-->

在解开内部类的神秘面纱之前，让我们先来看如下代码：

```java
public class OuterClass {
	private String name;
	public OuterClass(String name) {
		this.name = name;
		System.out.println("OuterClass初始化");
		System.out.println("name："+this.name);
	}
    class InnerClass {
    	public InnerClass() {
    		System.out.println("InnerClass初始化");
    	}
    	public void print() {
    		if(name.equals("hegongshan.com")) {
    			name = "software engineering";
    			System.out.println("InnerClass.print()");
    			System.out.println("更新后的name："+name);
    		}
    	}
    }
    public static void main(String[] args) {
		OuterClass outer = new OuterClass("hegongshan.com");
		OuterClass.InnerClass inner = outer.new InnerClass();
		inner.print();
	}
}
输出结果：
OuterClass初始化
name：hegongshan.com
InnerClass初始化
InnerClass.print()
更新后的name：software engineering
```

上述程序编译之后生成了如下两个class文件：

```java
OuterClass$InnerClass.class
OuterClass.class
```

可以看到，编译器将内部类InnerClass翻译成了名为`OuterClass$InnerClass.class`的class文件。

下面我们在命令行中使用`javap`命令来查看下编译之后的OuterClass$InnerClass.class文件（关于`javap`的更多描述请参看[《Java中的命令行工具javap》](https://www.hegongshan.com/2019/01/15/java-command-javap/)）

```java
//在UNIX中，需要对$转义，其他系统中不需要加\
javap -p OuterClass\$InnerClass.class
```

输出内容如下：

```java
Compiled from "OuterClass.java"
class OuterClass$InnerClass {
  	final OuterClass this$0;
	public OuterClass$InnerClass(OuterClass);
  	public void print();
}
```

可以清楚地看到，编译器为了引用外部类，生成了一个使用final修饰的外部类变量，命名为`this$0`（名字`this$0`是由编译器合成的，在自己编写的代码中不能够引用它）。

另外，可以看到构造器的参数，在InnerClass中，我们并没有写构造方法，编译器为InnerClass自动生成了一个带参数的构造方法，传入一个外部类对象的引用。

开篇提到，内部类可以访问外围类中的所有方法和变量，即使这些方法和变量声明为private。既然内部类可以被编译器翻译为名字古怪的普通类（虚拟机对此一无所知），内部类如何管理那些额外的访问特权呢？

再次使用**javap**命令查看生成的`Outerclass.class`,结果如下：

```java
Compiled from "OuterClass.java"
public class OuterClass {
  private java.lang.String name;
  public OuterClass(java.lang.String);
  public static void main(java.lang.String[]);
  static java.lang.String access$0(OuterClass);
  static void access$1(OuterClass, java.lang.String);
}
```

我们注意到，编译器在外围类中添加了两个静态方法`access$0`和`access$1`，它们均需要传入一个外围类对象的引用。此外，`access$1`还需要传入一个字符串变量。（方法名可能稍有不同，如`access$00`，这取决于你的编译器。）

内部类通过调用`access$0`方法，从而实现对外围类的私有属性name的访问；通过调用`access$1`方法，从而实现对外围类的私有属性name的修改。

如果编译器能够自动地进行转换，那么我们能不能编写程序实现这种机制呢？

```java
public class Main {
	public static void main(String[] args) {
		Outer outer = new Outer("hegongshan.com");
		Inner inner = new Inner(outer);
		inner.print();
	}
}
class Inner {
	final Outer outer;
	public Inner(Outer outer) {
		this.outer = outer;
		System.out.println("Inner初始化");
	}
	public void print() {
		System.out.println("name:"+Outer.getName(outer));
		if(Outer.getName(outer).equals("hegongshan.com")) {
			Outer.setName(outer, "software engineering");
			System.out.println("更新后的name:"+Outer.getName(outer));
		}
	}
}
class Outer {
	private String name;
	public Outer(String name) {
		this.name = name;
		System.out.println("Outer初始化");
		System.out.println("name:"+name);
	}
	static String getName(Outer outer) {
		return outer.name;
	}
	static void setName(Outer outer,String name) {
		outer.name = name;
	}
}
```

输出结果：

```java
Outer初始化
name:hegongshan.com
Inner初始化
name:hegongshan.com
更新后的name:software engineering
```

可以看到，通过模仿编译后的class文件中的代码，在Outer中添加一些特殊的方法，在Inner类中添加特殊的构造器，我们在Inner类中访问和修改了Outer类中的私有属性。