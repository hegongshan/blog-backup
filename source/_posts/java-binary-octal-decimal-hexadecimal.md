---
title: Java中的进制表示
date: 2018-06-10 16:25:39
tags: java
categories: java
mathjax: true
---

平时做题也好，写程序或算法也罢，我们经常会见到诸如0Xfff、0b1000等数据，那么它们到底是什么意思呢？

其实0x、0b等是不同进制的前缀，旨在告诉编译器后面的数字是几进制的数据，而非默认的十进制数据。

<!--more-->

**二进制（binary）**：**以0b或者0B为前缀**，例如0b1000，等价于十进制的$1\*2^3$=8

**需要注意的是**，0b（0B）这种写法是从jdk1.7才有的

**八进制（octal）**：**以0为前缀**，例如：070，等价于十进制的$7\*8^1+0\*8$=56

**十进制（decimal）**：没有前缀，默认情况下数字均为十进制表示

**十六进制（hexadecimal）**：**以0x或者0X为前缀**，例如算法中很常见的0xfff

上面的0是数字0，而不是字母o

```java
public class Main {
	public static void main(String[] args) {
		int binary1 = 0b1000;//8
		System.out.println(binary1);
        
		int binary2 = 0B111;//7
		System.out.println(binary2);
        
		int octal = 070;//56
		System.out.println(octal);
        
		int hexadecimal = 0xfff;//4095
		System.out.println(hexadecimal);
	}
}
```

输出结果：

```java
8
7
56
4095
```

