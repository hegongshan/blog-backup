---
title: Java中的final关键字
date: 2019-01-10 15:28:13
updated: 2019-01-10 15:28:13
tags: java
Categories: java
---

​	在Java中，final关键字可以用于域、方法和类的声明，所处位置不同，其作用也不同。

<!--more-->

### final域

使用final声明的域，在使用前必须被初始化，且一旦被初始化便无法改变。下面是一个简单的例子：

```java
public class Main {
	final int number = 1;
	public static void main(String[] args) {
		Main main = new Main();
		//main.number = 2; 
	}
}
```

当我们想改变number的值时，产生了如下错误：

```java
The final field Main.number cannot be assigned
```

#### 空白final

空白final是指被声明为final但又未给定初始值的域。必须在构造器中对空白final进行赋值，以确保空白final在使用前被初始化。下面是空白final的一个例子：

```java
public class Main {
	final int x = 20;
	final int number;//空白final
	
	public Main(int number) {
		this.number = number;
	}
	public static void main(String[] args) {
		Main main = new Main(2);
	}
}
```

因此，综合空白final和定义时已被初始化的final字段，我们可以说：**final字段必须在域的定义处或者构造器中被初始化。**

#### static final域和final域的区别

当域声明为static final时，表示该字段在类装载时已被初始化，而不是每次创建新对象时都初始化。此外，声明为static final的字段，在该类的所有对象中值是唯一的且不能改变。而final域是在创建对象时才被初始化，每个对象中该字段的值不一定相同，但在同一对象中，该字段的值是唯一的。下面的例子直白地说明了二者的区别：

```java
public class Main {
	public static final int CAPACITY = 10;
	private final int id;

	public Main(int id) {
		this.id = id;
	}

	public String toString() {
		return "id=" + id + ",CAPACITY=" + CAPACITY;
	}

	public static void main(String[] args) {
		Main main = new Main(2);
		System.out.println(main);
		Main main2 = new Main(3);
		System.out.println(main2);
		System.out.println(main);
	}
}
```

输出结果：

```java
id=2,CAPACITY=10
id=3,CAPACITY=10
id=2,CAPACITY=10
```

#### final参数

Java允许在参数列表中以声明的方式将参数指明为final。这一特性主要用来向匿名类传递数据。

```java
public class Main {
	
	public void say(final String name) {
		System.out.println("hello "+name);
		//name = "new"+name;
	}

	public static void main(String[] args) {
		Main main = new Main();
		main.say("hgs");
	}
}
```

当我们想改变name的值时，将产生如下错误：

```java
The final local variable name cannot be assigned. It must be blank and not using a compound assignment
```

### final方法

使用final声明的方法，表示在子类中不允许被覆盖。下面我们尝试下覆盖父类中的final方法

```java
class Parent {
	public final void say(String word) {
		System.out.println(word);
	}
}
class Child extends Parent {
	/*public void say(String word) {
		
	}*/
}
```

产生了如下错误：

```java
Cannot override the final method from Parent
```

#### final和private 关键字

类中所有的private方法都隐式地指定为是final的。可以将private方法声明为final，但这并不会给方法增加任何额外的意义。

### final类

当某个类用final声明时，表明这个类不允许被继承。由于final类禁止继承，所以final类中所有的方法都隐式指定为是final的，但类中的域并不会自动地成为final。

```java
public class Main {

	public static void main(String[] args) {
		FinalClass fc = new FinalClass("final class");
		System.out.println("number="+fc.number);
		System.out.println("name="+fc.getName());
		fc.setName("name");
		System.out.println("name="+fc.getName());
		//fc.number += 1;
        //The final field FinalClass.number cannot be assigned
	}
}
final class FinalClass {
	private String name;
	public final int number = 1; 
	public FinalClass(String name) {
		this.name = name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName() {
		return name;
	}
}
//class ChildFinalClass extends FinalClass{}
//The type ChildFinalClass cannot subclass the final class FinalClass
```

输出结果如下：

```java
number=1
name=final class
name=name
```

在final类中可以给方法添加final修饰符，但这并不会增添任何意义。

