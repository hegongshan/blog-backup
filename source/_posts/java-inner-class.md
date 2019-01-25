---
title: Java中的内部类
date: 2019-01-12 15:52:48
updated: 2019-01-12 15:52:48
tags: java
categories: java
---

将一个类的定义放在另一个类的定义内部，这就是内部类。如下所示

```java
class OuterClass {
    ...
    class InnerClass {
        ...
    }
}
```

从总体上来讲，Java中的内部类可以分为：

* 静态内部类（static inner class）：声明为static的内部类
* 非静态内部类（non-static inner class）

```java
class OuterClass {
    ...
    static class StaticInnerClass {
        ...
    }
    class InnerClass {
        ...
    }
}
```

其中，非静态内部类又可细分为以下三种：

* 成员内部类：作为外部类的成员定义
* 局部内部类（local inner class）：在外部类的方法中定义
* 匿名内部类（anonymous inner class）：没有名字的内部类

内部类是一种编译器现象，与虚拟机无关。它可以访问外部类中定义的所有方法和域，即使这些方法和域声明为private。此外，内部类可以使用访问说明符public、protected和private修饰。

<!--more-->

### 非静态内部类

**非静态内部类中不能声明static方法，声明的所有静态域都必须是final**。

#### 内部类的特殊语法

要想实例化一个非静态内部类，需要使用一种特殊的语法`.new`，就像下面这样：

```java
public class OuterClass {
    class InnerClass {}
    public static void main(String[] args) {
		OuterClass outer = new OuterClass();
		InnerClass inner = outer.new InnerClass();
	}
}
```

在外部类的作用域之外，可以这样引用内部类：

```java
OuterClass.InnerClass
```

下面是示例展示了如何在外部类的作用域之外，实例化它的内部类。

```java
public class Main {
	public static void main(String[] args) {
		OuterClass outer = new OuterClass();
		OuterClass.InnerClass inner = outer.new InnerClass();
	}
}
class OuterClass {
	class InnerClass {
		public InnerClass() {
			System.out.println("InnerClass实例化");
		}
	}
}
输出结果：
InnerClass实例化
```

在内部类中，如果需要使用外部类对象的引用，可以使用外部类的名字后紧跟圆点和***this***，就像这样`OuterClass.this​`,下面是一个简单的示例：

```java
public class OuterClass {
	public void print() {
		System.out.println("OuterClass.print()");
	}
    class InnerClass {
    	public OuterClass getOuter() {
    		return OuterClass.this;
    	}
	}
    public static void main(String[] args) {
		OuterClass outer = new OuterClass();
		InnerClass inner = outer.new InnerClass();
		inner.getOuter().print();
	}
}
输出结果：
OuterClass.print()
```

#### 成员内部类

成员内部类是最常见的内部类，也称为普通内部类。成员内部类作为外部类的成员来定义，如下所示：

```java
public class OuterClass {
	class InnerClass {
		
	}
}
```

#### 局部内部类

在外围类的方法中声明的类，称为局部内部类。下面是一个简单的例子

```java
public class Outer {
	private int count = 0;

	public void start() {
		class LocalInnerClass {
			public void service() {
				System.out.println(count);
				count++;
			}
		}
		LocalInnerClass inner = new LocalInnerClass();
		for (int i = 0; i < 5; i++) {
			inner.service();
		}
	}

	public static void main(String[] args) {
		Outer main = new Outer();
		main.start();
	}
}
输出结果：
0
1
2
3
4
```

**局部内部类不能用public、protected或private访问说明符声明**。它的优势是对外部世界可以完全地隐藏起来，除了start方法之外，Outer的其他地方均不能访问它。

#### 匿名内部类

匿名内部类，顾名思义，就是没有命名的内部类。语法格式如下

```java
new SuperType(construction parameters) {
    方法和属性
}
```

下面是匿名内部类的一个示例。

```java
interface Counter {
	int next();
}
public class Outer {
	private int count = 0;
	Counter getCounter(final String name) {
        return new Counter() {
            {
                System.out.println("Counter()");
            }
            public int next() {
                System.out.print(name);
                return count++;
            }
        };
    }
    public static void main(String[] args) {
    	Outer outer = new Outer();
        Counter c = outer.getCounter();
        for (int i = 0; i < 5; i++) {
			System.out.println(c.next());
        }
    }
}
输出结果：
Counter()
0
1
2
3
4
```

在上面的程序中，由于getCounter方法中的name这个变量不是外围类中定义的属性，所以必须声明为final类型，才能在匿名内部类中使用（对于局部内部类，情况也是一样的），否则，将产生如下的语法错误：

```java
Cannot refer to the non-final local variable name defined in an enclosing scope
```

由于构造器的名字必须与类名相同，而匿名类没有类名，所以匿名类不能有构造器。因此，将参数传递给超类（父类）构造器。在匿名内部类实现接口的时候，不能有任何构造参数。

### 静态内部类

静态内部类，就是声明为static的内部类。**实例化静态内部类，不需要其外围类对象**。下面是一个静态内部类的示例：

```java
public class Outer {
	private int count = 0;
	private static String className = "OUTER";
	
	public static class StaticInnerClass {
		public StaticInnerClass(String name) {
			System.out.println(name);
			System.out.println("outer class name:"+className);
		}
	}
	public static void main(String[] args) {
		Outer main = new Outer();
        //下面两种实例化方法是等价的
		StaticInnerClass inner = new StaticInnerClass("inner");
		Outer.StaticInnerClass inner2 = new Outer.StaticInnerClass("inner2");
	}
}
输出结果：
inner
outer class name:OUTER
inner2
outer class name:OUTER
```

值得一提的是，**静态内部类不能访问外围类中的非静态的域和方法**。以上面的程序为例，StaticInnerClass类可以访问到Outer类的className属性，因为className声明为static，但StaticInnerClass类不能访问count。

**什么时候使用静态内部类？**在内部类不需要访问外围类对象的时候，应该使用静态内部类。

### 内部类标识符

对于成员内部类和静态内部类，编译器将会把它编译成文件名为`外围类名$内部类名.class`的class文件。

对于匿名内部类，编译器会将它编译名为`外围类名$n.class`的class文件；对于局部内部类，则被编译为`外围类名$n内部类名`的class文件。（n是由编译器简单生成的一个数字）

下面通过一个简单的例子来展示这四种内部类的字节码文件的命名规则

```java
interface Counter {
	int next();
}
public class Outer {
	private int count = 0;
    class NormalCounter implements Counter {
        public int next() {
            return count++;
        }
    }
	Counter getCounter(final String name) {
		class LocalCounter implements Counter {
			static final String name = "";
			public LocalCounter() {
				System.out.println("LocalCounter()");
			}

			public int next() {
				System.out.print(name);
				return count++;
			}

		}
		return new LocalCounter();
	}

	Counter getCounter2(final String name) {
		return new Counter() {
			{
				System.out.println("Counter()");
			}
			public int next() {
				System.out.print(name);
				return count++;
			}
		};
	}
	static class StaticInnerClass{
		
	}
	public static void main(String[] args) {
		Outer lic = new Outer();
		Counter c1 = lic.getCounter("Local inner class ");
		Counter c2 = lic.getCounter2("Anonymous inner class ");
		for (int i = 0; i < 5; i++) {
			System.out.println(c1.next());
		}
		for (int i = 0; i < 5; i++) {
			System.out.println(c2.next());
		}
	}
}
```

Outer.java编译之后，生成了如下几个class文件：

```java
Counter.class
Outer$1.class
Outer$1LocalCounter.class
Outer$NormalCounter.class
Outer$StaticInnerClass.class
Outer.class
```
