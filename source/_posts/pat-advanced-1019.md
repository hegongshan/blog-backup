---
title: PAT甲级 1019.General Palindromic Number （20 分)
date: 2019-04-20 11:35:38
tags: pat
categories: pat甲级
mathjax: true
---

A number that will be the same when it is written forwards or backwards is known as a **Palindromic Number**. For example, 1234321 is a palindromic number. All single digit numbers are palindromic numbers.

Although palindromic numbers are most often considered in the decimal system, the concept of palindromicity can be applied to the natural numbers in any numeral system. Consider a number *N*>0 in base *b*≥2, where it is written in standard notation with *k*+1 digits $a_i$ as $∑_{i=0}^k(a_i b^i)$. Here, as usual, 0≤$a_i$<*b* for all *i* and $a_k$ is non-zero. Then *N* is palindromic if and only if $a_i=a_{k−i}$ for all *i*. Zero is written 0 in any base and is also palindromic by definition.

Given any positive decimal integer *N* and a base *b*, you are supposed to tell if *N* is a palindromic number in base *b*.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case consists of two positive numbers *N* and *b*, where 0<*N*≤$10^9​$ is the decimal number and 2≤*b*≤$10^9​$ is the base. The numbers are separated by a space.

### Output Specification:

For each test case, first print in one line `Yes` if *N* is a palindromic number in base *b*, or `No` if not. Then in the next line, print *N*as the number in base *b* in the form "$a_k \ a_{k−1} \ ... \ a_0$". Notice that there must be no extra space at the end of output.

### Sample Input 1:

```in
27 2
```

### Sample Output 1:

```out
Yes
1 1 0 1 1
```

### Sample Input 2:

```in
121 5
```

### Sample Output 2:

```out
No
4 4 1
```

### 分析：

题目要求：判断一个给定的十进制数n在b进制下，是否为回文数字（即从左到右与从右到左一样）。

思路：使用除基取余法，将十进制数n转换为b进制，并将结果反序保存在一个整型数组data中(低位在前，高位在后)。设转换后该数的长度为index，判断数组data的第i个元素与第index - i - 1个元素是否相等，若有一组不相等，则说明其不是回文数字。若全部相等，则说明其是回文数字。

```c++
#include <cstdio>

int main() {
	int n, b, index = 0;
	scanf("%d %d", &n, &b);
	int data[32];
	do {
		data[index++] = n % b;
		n /= b;
	} while (n != 0);
	bool flag = true;
	for (int i = 0; i < index; i++) {
		if (data[i] != data[index - i - 1]) {
			flag = false;
			break;
		}
	}
	if (flag) {
		printf("Yes\n");
	} else {
		printf("No\n");
	}
	for (int i = index - 1; i >= 0; i--) {
		printf("%d", data[i]);
		if (i > 0) {
			printf(" ");
		}
	}
	printf("\n");
	return 0;
}
```

