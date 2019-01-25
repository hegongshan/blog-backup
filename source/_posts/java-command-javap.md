---
title: Java中的命令行工具javap
date: 2019-01-15 18:11:43
updated: 2019-01-15 18:11:43
tags: java
categories: java
---

`javap`，全称`java printer`，是JDK中的一个基础命令行工具，用于反编译一个或多个class文件。其输出取决于使用的选项。如果未使用任何选项，则`javap`命令将打印具有包，protected和public权限的字段和方法，并将其输出打印到标准输出`stdout`。

<!--more-->

关于`javap`的详细用法如下：

```java
用法: javap <options> <classes>
其中, 可能的选项包括:
  -help  --help  -?        输出此用法消息
  -version                 版本信息
  -v  -verbose             输出附加信息
  -l                       输出行号和本地变量表
  -public                  仅显示公共类和成员
  -protected               显示受保护的/公共类和成员
  -package                 显示程序包/受保护的/公共类
                           和成员 (默认)
  -p  -private             显示所有类和成员
  -c                       对代码进行反汇编
  -s                       输出内部类型签名
  -sysinfo                 显示正在处理的类的
                           系统信息 (路径, 大小, 日期, MD5 散列)
  -constants               显示最终常量
  -classpath <path>        指定查找用户类文件的位置
  -cp <path>               指定查找用户类文件的位置
  -bootclasspath <path>    覆盖引导类文件的位置
```

其中，常用的选项有

```java
-public
-protected
-package
-p -private
-c 
-s
```

以下面的程序为例，Main类包含了private、default(缺省)、protected和public四种访问权限的字段和方法。

```java
public class Main {	
	private int number = 1;
	
	int UID = 1234;
	
	protected String name = "Main";
	
	public String javaVersion = "1.8";
	
	public Main() {
		printNumber();
	}
	
	private void printNumber() {
		System.out.println("number:"+number);
	}
	
	void printUID() {
		System.out.println("UID:"+UID);
	}
	
	protected void printName() {
		System.out.println("name:"+name);		
	}	
	
	public void printVersion() {
		System.out.println("javaVersion:"+javaVersion);
	}
	
	public static void main(String[] args) {
		Main main = new Main();
		main.printUID();
		main.printName();
		main.printVersion();
	}
}
```

编译Main.java，得到Main.class文件

1.`javap`的默认选项为`-package`，只输出具有包、protected和public的字段和方法。在命令行中使用`javap`或者`javap -package`查看Main.class，输出的内容如下：

```java
hgs:~ hegongshan$ javap Main.class 
Compiled from "Main.java"
public class Main {
  int UID;
  protected java.lang.String name;
  public java.lang.String javaVersion;
  public Main();
  void printUID();
  protected void printName();
  public void printVersion();
  public static void main(java.lang.String[]);
}
```

2.使用`javap -public`将只输出class文件中的public字段和方法。以Main.class为例，输出内容如下：

```java
hgs:~ hegongshan$ javap -public Main.class
Compiled from "Main.java"
public class com.hegongshan.Main {
  public java.lang.String javaVersion;
  public com.hegongshan.Main();
  public void printVersion();
  public static void main(java.lang.String[]);
}
```

3.`javap -protected`将输出类中的public和protected的字段和方法。以Main.class为例，输出内容如下：

```java
hgs:~ hegongshan$ javap -protected Main.class
Compiled from "Main.java"
public class com.hegongshan.Main {
  protected java.lang.String name;
  public java.lang.String javaVersion;
  public com.hegongshan.Main();
  protected void printName();
  public void printVersion();
  public static void main(java.lang.String[]);
}
```

4.`javap -p`或者`javap -private`将输出类中的所有字段和方法。以Main.class为例，输出内容如下：

```java
hgs:~ hegongshan$ javap -p Main.class
Compiled from "Main.java"
public class com.hegongshan.Main {
  private int number;
  int UID;
  protected java.lang.String name;
  public java.lang.String javaVersion;
  public com.hegongshan.Main();
  private void printNumber();
  void printUID();
  protected void printName();
  public void printVersion();
  public static void main(java.lang.String[]);
}
```

5.`javap -c`将对class文件进行反编译。以Main.class为例，输出内容如下：

```java
hgs:~ hegongshan$ javap -c Main.class
Compiled from "Main.java"
public class com.hegongshan.Main {
  int UID;

  protected java.lang.String name;

  public java.lang.String javaVersion;

  public com.hegongshan.Main();
    Code:
       0: aload_0
       1: invokespecial #14                 // Method java/lang/Object."<init>":()V
       4: aload_0
       5: iconst_1
       6: putfield      #16                 // Field number:I
       9: aload_0
      10: sipush        1234
      13: putfield      #18                 // Field UID:I
      16: aload_0
      17: ldc           #20                 // String Main
      19: putfield      #22                 // Field name:Ljava/lang/String;
      22: aload_0
      23: ldc           #24                 // String 1.8
      25: putfield      #26                 // Field javaVersion:Ljava/lang/String;
      28: aload_0
      29: invokespecial #28                 // Method printNumber:()V
      32: return

  void printUID();
    Code:
       0: getstatic     #35                 // Field java/lang/System.out:Ljava/io/PrintStream;
       3: new           #41                 // class java/lang/StringBuilder
       6: dup
       7: ldc           #62                 // String UID:
       9: invokespecial #45                 // Method java/lang/StringBuilder."<init>":(Ljava/lang/String;)V
      12: aload_0
      13: getfield      #18                 // Field UID:I
      16: invokevirtual #48                 // Method java/lang/StringBuilder.append:(I)Ljava/lang/StringBuilder;
      19: invokevirtual #52                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      22: invokevirtual #56                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      25: return

  protected void printName();
    Code:
       0: getstatic     #35                 // Field java/lang/System.out:Ljava/io/PrintStream;
       3: new           #41                 // class java/lang/StringBuilder
       6: dup
       7: ldc           #65                 // String name:
       9: invokespecial #45                 // Method java/lang/StringBuilder."<init>":(Ljava/lang/String;)V
      12: aload_0
      13: getfield      #22                 // Field name:Ljava/lang/String;
      16: invokevirtual #67                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      19: invokevirtual #52                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      22: invokevirtual #56                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      25: return

  public void printVersion();
    Code:
       0: getstatic     #35                 // Field java/lang/System.out:Ljava/io/PrintStream;
       3: new           #41                 // class java/lang/StringBuilder
       6: dup
       7: ldc           #71                 // String javaVersion:
       9: invokespecial #45                 // Method java/lang/StringBuilder."<init>":(Ljava/lang/String;)V
      12: aload_0
      13: getfield      #26                 // Field javaVersion:Ljava/lang/String;
      16: invokevirtual #67                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      19: invokevirtual #52                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      22: invokevirtual #56                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      25: return

  public static void main(java.lang.String[]);
    Code:
       0: new           #1                  // class com/hegongshan/Main
       3: dup
       4: invokespecial #75                 // Method "<init>":()V
       7: astore_1
       8: aload_1
       9: invokevirtual #76                 // Method printUID:()V
      12: aload_1
      13: invokevirtual #78                 // Method printName:()V
      16: aload_1
      17: invokevirtual #80                 // Method printVersion:()V
      20: return
}
```

6.`javap -s`将输出内部类型签名。以Main.class为例，输出内容如下：

```java
hgs:~ hegongshan$ javap -s Main.class
Compiled from "Main.java"
public class com.hegongshan.Main {
  int UID;
    descriptor: I
  protected java.lang.String name;
    descriptor: Ljava/lang/String;
  public java.lang.String javaVersion;
    descriptor: Ljava/lang/String;
  public com.hegongshan.Main();
    descriptor: ()V

  void printUID();
    descriptor: ()V

  protected void printName();
    descriptor: ()V

  public void printVersion();
    descriptor: ()V

  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
}
```

上述输出内容中，对于字段，`descriptor:`后的字符，表示字段的类型，对应关系如下：

```java
B      : byte
C      : char
D      : double
F      : float
I      : int
J      : long
L类名;  : 引用类型,如Ljava/lang/String; 表示 String类型
S      : short
Z      : boolean
[      : 数组,如[Ljava/lang/String; 表示String[]
```

对于方法，`descriptor:`后的字符`(参数类型描述)返回值类型描述`，表示方法的参数及其返回值的类型。

```java
V : void,表示没有返回值
```





