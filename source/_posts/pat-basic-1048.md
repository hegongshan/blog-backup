---
title: PAT乙级 1048.数字加密 (20 分)
date: 2019-05-07 17:22:16
tags: pat
categories: pat乙级
---

本题要求实现一种数字加密方法。首先固定一个加密用正整数 A，对任一正整数 B，将其每 1 位数字与 A 的对应位置上的数字进行以下运算：对奇数位，对应位的数字相加后对 13 取余——这里用 J 代表 10、Q 代表 11、K 代表 12；对偶数位，用 B 的数字减去 A 的数字，若结果为负数，则再加 10。这里令个位为第 1 位。

<!--more-->

### 输入格式：

输入在一行中依次给出 A 和 B，均为不超过 100 位的正整数，其间以空格分隔。

### 输出格式：

在一行中输出加密后的结果。

### 输入样例：

```in
1234567 368782971
```

### 输出样例：

```out
3695Q8118
```

### 分析：

题目已知个位为第1位，因此可以考虑先将A、B反转，然后分奇偶位进行相应的操作。

需要注意的是：当正整数B的长度小于A时，B前面的空缺位置，依然需要执行加密操作。

```c++
#include <cstdio>
#include <cstring>

void reverse(char s[]) {
	int len = strlen(s);
	int temp = 0;
	for (int i = 0; i < len / 2; i++) {
		temp = s[i];
		s[i] = s[len - i - 1];
		s[len - i - 1] = temp;
	}
}

int main() {
	char a[101], b[101], c[101];
	scanf("%s %s", a, b);
	reverse(a);
	reverse(b);
	int lenB = strlen(b);
	int lenA = strlen(a);
	int len = lenA > lenB ? lenA : lenB;

	for (int i = 1; i <= len; i++) {
		int numA = i <= lenA ? a[i - 1] - '0' : 0;
		int numB = i <= lenB ? b[i - 1] - '0' : 0;
		// 若为奇数
		if (i % 2 != 0) {
			int result = (numA + numB) % 13;
			if (result < 10) {
				c[i - 1] = result + '0';
			} else {
				if (result == 10) {
					c[i - 1] = 'J';
				} else if (result == 11) {
					c[i - 1] = 'Q';
				} else {
					c[i - 1] = 'K';
				}
			}
		} else {
			int result = numB - numA;
			if (result < 0) {
				c[i - 1] = result + 10 + '0';
			} else {
				c[i - 1] = result + '0';
			}
		}
	}
	for (int i = strlen(c) - 1; i >= 0; i--) {
		printf("%c", c[i]);
	}
	printf("\n");
	return 0;
}
```



