---
title: c++中char * a="xxx"引发的警告
date: 2019-03-21 11:50:22
tags: cpp
categories: cpp
---

在c++中，当char * 指向字符常量时（以下面的程序为例）

```c++
#include <cstdio>

int main() {
	char *a = "I love China!";
	printf("%s\n",a);
	return 0;
}
```

编译时，将产生如下warning：

```c++
ProblemC.cpp:4:12: warning: conversion from string literal to 'char *' is
      deprecated [-Wc++11-compat-deprecated-writable-strings]
        char *a = "I love China!";
                  ^
1 warning generated.
```

<!--more-->

* 为什么会产生该warning呢？

因为此时a中存储的是“I love China!”在内存中的首地址，而“I love China!”是字符常量，存放在只读区中。程序员有可能通过a去修改“I love China!”的值，从而导致error。

* 如何解决该warning呢？

在定义a时，使用const修饰，表明a所指地址中的内容不允许被修改。示例如下：

```c++
#include <cstdio>

int main() {
	const char *a = "I love China!";
	printf("%s\n",a);
	return 0;
}
```





