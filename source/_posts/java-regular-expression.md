---
title: 正则表达式及Java对其的支持
date: 2018-04-11 15:19:46
updated: 2018-04-11 15:19:46
tags: java
categories: 正则表达式
---

### 简述正则表达式

​	今天我们来讲下正则表达式，先来看下正则表达式中的数量表示

| 字符  |                         说明                          |             举例              |
| :---: | :---------------------------------------------------: | :---------------------------: |
|   ?   | 零次或一次匹配？前的字符或子表达式，***等价于{0,1}*** | gong(shan)?匹配gong或gongshan |
|   *   | 零次或多次匹配*前的字符或子表达式，****等价于{0,}**** |        sm*匹配sm或者s         |
|   +   | 一次或多次匹配*前的字符或子表达式，****等价于{1,}**** |     zoo+匹配zoo或者zooo等     |
|  {n}  |               n为非负整数，正好匹配n次                |         zo{2}匹配zoo          |
| {n,}  |               n为非负整数，至少匹配n次                |  zo{1,}可匹配zo，zoo，zooo等  |
| {n,m} |    n和m均为非负整数，表示至少匹配n次，至多匹配m次     |   zo{1,2}则只匹配zo或者zoo    |

<!--more-->

常用特殊字符

|  字符  |                          说明                          |             举例              |
| :----: | :----------------------------------------------------: | :---------------------------: |
| [xyz]  |               字符集。匹配包含的任一字符               |     [abc] 匹配 java 中的a     |
| [^xyz] |            反字符集。匹配未被包含的任一字符            |  [^abc] 匹配 java 中的 j和v   |
| [x-y]  |      字符范围。匹配从x到y（指定范围内）的所有字符      | [a-z]匹配从a到z的所有小写字母 |
|   \d   |            匹配一个数字，***等价于[0-9]***             |       he\d{2} 匹配 he33       |
|   \D   |          匹配一个非数字，***等价于\[^0-9]***           |      he\D{4} 匹配 heyang      |
|   \s   |                    匹配任何空白字符                    |                               |
|   \S   |                   匹配任何非空白字符                   |                               |
|   \w   | 匹配任何字类字符，包括下划线，***等价于[a-zA-Z0-9_]*** |                               |
|   \W   |     匹配任何非字类字符，***等价于\[^a-zA-Z0-9_]***     |                               |

常用逻辑操作

| 字符 |      说明       |        举例        |
| :--: | :-------------: | :----------------: |
|  xy  |      x并y       |       [xy]         |
| x&#124;y |      x或y   |      [x&#124;y]|
| (X)  | 将X定义为一个组 | [xy(bc)]，(x&#124;y)|

其他预定义字符以及不是特别常用的字符，详见 [java正则表达式](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html  "正则表达式")

### java对正则表达式的支持

在java中要想使用正则表达式，有三种方式：

* String类对正则表达式的支持

```java
public boolean matches(String regex)
```

* 单独使用java.util.regex.Pattern

```java
public static boolean matches(String regex, CharSequence input)
```

* java.util.regex包下的Pattern类配合Matcher类使用（***推荐采用此方式***）

下面我们依次来使用这三种方式：

第一种：String类对正则表达式的支持 matches(String regex)

```java
public void testString() {
    String str = "Java";
    boolean flag = str.matches("(J|x)ava");
    System.out.println(flag);
}
输出结果：true
```

这种方式虽然也能实现正则匹配，但是功能单一，只能返回是否匹配，而且字符串必须***整体匹配***才能返回true，以下面的代码来说明这个问题

```java
public void testString2() {
    String str = "Java is a programming language.";
    boolean flag = str.matches("Java");
    System.out.println(flag);
}
输出结果：false
```
查看String类的源码可以发现，String类的matches方法实际上就是调用的下面要讲的第二种方式Pattern.matches(String regex,CharSequence input)

```java
public boolean matches(String regex) {
	return Pattern.matches(regex, this);
}
```

第二种：单独使用Pattern进行正则匹配

```java
public void testPattern() {
    String str = "Java is a programming language.";
    String regex = "Java";
    boolean flag = Pattern.matches(regex, str);
    System.out.println(flag);
}
输出结果：false
```

这里为什么也返回了false？原因和第一种方式一样，因为Pattern的静态方法matches(String regex,CharSequence input)也是***整体匹配***。
实际上，如果我们去查看Pattern的源码的话，可以发现：
```java
public static boolean matches(String regex, CharSequence input) {
    Pattern p = Pattern.compile(regex);
    Matcher m = p.matcher(input);
    return m.matches();
}
```
这种方式实际上使用的是下面的第三种方式

第三种：Pattern和Matcher的结合使用

```java
public void testPatternAndMatcher() {
    String str = "I love Java and xava.";
    String regex = "(J|x)ava";
    Pattern p = Pattern.compile(regex);
    Matcher m = p.matcher(str);
    System.out.println(m.matches());
    while(m.find()) {
        System.out.println(m.group());
	}
}
输出结果：
false
Java
xava
```

通过以上分析，我们可以发现，第一种方式是对第二种方式的调用，而第二种方式的实现又是采用的第三种方式。

因此，在以后的使用中，推荐直接使用第三种方式，其功能远强于第一种和第二种方式。

### 详解Pattern和Matcher

Pattern的常用方法如下：

```java
public static Pattern compile(String regex)
public Matcher matcher(CharSequence input)
```

由于Pattern只有私有构造方法，我们不能直接实例化它，故每次必须通过其compile方法取得Pattern对象，继而通过matcher方法获取Matcher对象。

Matcher的常用方法

①索引方法：

```java
public int start()//返回之前匹配的起始索引
public int start(int group)
public int end()//返回最后匹配字符之后的偏移量，例如用\d{4}匹配he2018，则end()返回6
public int end(int group)
```

实例如下：

```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexTest {
	public static void main(String[] args) {
		String regex = "\\d{4}";
		String str = "he2018shan0423yang11gong456shan";
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(str);
		while(matcher.find()) {
			System.out.println("匹配字段："+matcher.group());
			System.out.println("开始索引："+matcher.start());
			System.out.println("结束索引："+matcher.end());
		}
	}
}
```

输出结果：

```java
匹配字段：2018
开始索引：2
结束索引：6
匹配字段：0423
开始索引：10
结束索引：14
```

②研究方法

```java
public boolean find()
public boolean find(int start)
public boolean lookingAt()
public boolean matches()
```

③替换方法

```java
public static String quoteReplacement(String s)
public Matcher appendReplacement(StringBuffer sb, String replacement)
public StringBuffer appendTail(StringBuffer sb)
public String replaceAll(String replacement)
public String replaceFirst(String replacement)
```

### 附录

常用的正则表达式

| 规则     | 正则表达式语法                                               |
| :------- | :----------------------------------------------------------- |
| 电子邮箱 | [\\w!#$%^&`+=/(&#124;)'?,~*-]+@([a-z0-9]+\\.)+[a-z]+         |
| 中文字符 | [\u4e00-\u9fa5]                                              |
| QQ号     | \[1-9\]\[0-9\]{4,}                                           |
| 身份证号 | \\d{6}(19&#124;20)\\d{2}((0[1-9])&#124;(1[0-2]))(([0-2]\\d)&#124;(3[0-1]))\\d{3}(\\d&#124;x&#124;X){1} |

