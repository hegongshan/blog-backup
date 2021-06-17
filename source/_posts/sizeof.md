---
title: 由sizeof引发的面试惨案
date: 2020-05-20 14:16:42
tags: c
categories: c
---

上午，面试华为的数字通信部门，面试官给我出了一道题，考察sizeof的使用，以及C语言中各个数据类型所占的字节。

然而，我对sizeof并不熟悉，本科C语言就没学好，面试结果可想而知。（老实讲，我是来面Java的...）

<!--more-->

### 问题描述

求如下代码的输出结果：

```c
#include <stdio.h>

int main()
{
	char str[] = "abcde";
	char * p = str;

	printf("%lu %lu\n", sizeof(p), sizeof(str));
	return 0;
}
```

输出：

```c
8 6
```

### 结果分析

1.sizeof：用于判断变量或数据类型的字节大小。

2.在C语言中，char占1个字节；

3.在C语言中，使用双引号为char数组赋初值时，将自动在末尾补上结束符号`\0`；

换言之，char str[] = "abcde"等价于

```c
char str[6];
str[0] = 'a';
str[1] = 'b';
str[2] = 'c';
str[3] = 'd';
str[4] = 'e';
str[5] = '\0';
```

所以，sizeof(str)等于6。

4.在32位系统中，指针占4个字节；而在64位系统中，指针占8个字节。因此，sizeof(p)为8。

### 补充知识

|   长度    | 32位操作系统 | 64位操作系统 |
| :-------: | :----------: | :----------: |
| **指针**  |      4       |      8       |
|    int    |      4       |      4       |
| **long**  |      4       |      8       |
| long long |      8       |      8       |
|   float   |      4       |      4       |
|  double   |      8       |      8       |
|   char    |      1       |      1       |