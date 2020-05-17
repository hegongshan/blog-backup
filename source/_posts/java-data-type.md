---
title: Java中的数据类型
date: 2020-04-06 19:06:45
tags: java
categories: java
mathjax: true
---

在Java中，共有8种基本数据类型和3种引用数据类型。

<!--more-->

![Java数据类型](/static/images/java-data-type.png)

### 整型

#### byte型

byte型数据，占1个字节，其数据范围为-128~127，即$[-2^7,2^7-1]$，主要用于IO（输入输出）操作。 

#### short型

short型数据，占2个字节，其数据范围为-32768~32767，即$[-2^{15},2^{15}-1]$，基本不会被使用。

#### int型

int型数据，占4个字节，其数据范围为$[-2^{31},2^{31}-1]$。

#### long型

long型数据，占8个字节，其数据范围为$[-2^{63},2^{63}-1]$，主要用于表示日期、时间等。

在对long型变量进行赋值时，结尾必须加上“L”或者“l”，否则将不被认为是long型。如：

 ```java
long x = 12341234L; 
// long y = 12341234l;
 ```

"L"理论上不区分大小写，但是若写成“l”容易与数字“1”混淆，所以推荐用大写。

### 浮点型

#### float型

float型数据，即单精度浮点型，占4个字节。

在对float型进行赋值时，必须在结尾添加“F”或者“f”，如

```java
float x = 1.25F;
// float y = 1.25f; 
```

如果不加后缀，系统会自动将其定义为double型变量。

#### double型

double型数据，即双精度浮点型，占8个字节。

在对double型赋值时，可以添加后缀“D”或者“d”（没有硬性规定，但建议加上）。相对来说，double比float更常用。

### 字符型

char型数据，占2个字节。在定义时，要用单引号括起来，如

```java
char c = 'h';
```

### 布尔型

boolean类型，又称逻辑类型。它只有true和false两个值，分别代表布尔逻辑中的“真”和“假”，主要用在流程控制中作为判断条件。

### 默认值

| 数据类型 |  默认值   | 数据类型 |  默认值  |
| :------: | :-------: | :------: | :------: |
|   byte   | (byte) 0  |  float   |   0.0f   |
|  short   | (short) 0 |  double  |   0.0d   |
|   int    |     0     |   char   | '\u0000' |
|   long   |    0L     | boolean  |  false   |

下面我们来验证下：

```java
public class Main {
    public static void main(String[] args) {
        int[] iArr = new int[1];
        double[] dArr = new double[1];
        char[] cArr = new char[1];
        boolean[] booleanArr = new boolean[1];

        System.out.println("整型的默认值为:" + iArr[0]);
        System.out.println("浮点型的默认值为:" + dArr[0]);
        if (cArr[0] == '\u0000') {
            System.out.println("字符型的默认值为:'\\u0000'");
        }
        System.out.println("布尔型的默认值为:" + booleanArr[0]);
    }
}
```

输出结果如下：

```java
整型的默认值为:0
浮点型的默认值为:0.0
字符型的默认值为:'\u0000'
布尔型的默认值为:false
```

