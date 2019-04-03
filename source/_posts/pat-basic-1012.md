---
title: PAT乙级 1012.数字分类 （20 分)
date: 2019-04-01 16:12:50
tags: pat
categories: pat乙级
---

给定一系列正整数，请按要求对数字进行分类，并输出以下 5 个数字：

- *A*1 = 能被 5 整除的数字中所有偶数的和；
- *A*2 = 将被 5 除后余 1 的数字按给出顺序进行交错求和，即计算 *n*1−*n*2+*n*3−*n*4⋯；
- *A*3 = 被 5 除后余 2 的数字的个数；
- *A*4 = 被 5 除后余 3 的数字的平均数，精确到小数点后 1 位；
- *A*5 = 被 5 除后余 4 的数字中最大数字。

<!--more-->

### 输入格式：

每个输入包含 1 个测试用例。每个测试用例先给出一个不超过 1000 的正整数 *N*，随后给出 *N* 个不超过 1000 的待分类的正整数。数字间以空格分隔。

### 输出格式：

对给定的 *N* 个正整数，按题目要求计算 *A*1~*A*5 并在一行中顺序输出。数字间以空格分隔，但行末不得有多余空格。

若其中某一类数字不存在，则在相应位置输出 `N`。

### 输入样例 1：

```in
13 1 2 3 4 5 6 7 8 9 10 20 16 18
```

### 输出样例 1：

```out
30 11 2 9.7 9
```

### 输入样例 2：

```in
8 1 2 4 5 6 7 9 16
```

### 输出样例 2：

```out
N 11 2 N 9
```

### 分析：

按照题目要求，对不同数字执行不同的计算即可。

以下两点需要注意：

1.输出时行末不得有多余空格；

2.若其中某一类数字不存在，则在相应位置输出 `N`。

```c++
#include <cstdio>
#include <cmath>
int main() {
	int n, a1, a2, a3, a5, a2Index, a4Count;
	a1 = a2 = a3 = a5 = a2Index = a4Count = 0;
	double a4 = 0;
	scanf("%d", &n);
	for (int i = 0; i < n; i++) {
		int x;
		scanf("%d", &x);
		if (x % 10 == 0) {
			a1 += x;
		} else if (x % 5 == 1) {
			a2 += pow(-1, a2Index++) * x;
		} else if (x % 5 == 2) {
			a3 += 1;
		} else if (x % 5 == 3) {
			a4 += x;
			a4Count++;
		} else if (x % 5 == 4) {
			if (x > a5) {
				a5 = x;
			}
		}
	}
	if (!a1) {
		printf("N ");
	} else {
		printf("%d ", a1);
	}
	if (!a2Index) {
		printf("N ");
	} else {
		printf("%d ", a2);
	}
	if (!a3) {
		printf("N ");
	} else {
		printf("%d ", a3);
	}
	if (!a4Count) {
		printf("N ");
	} else {
		printf("%.1f ", a4 / a4Count);
	}
	if (!a5) {
		printf("N");
	} else {
		printf("%d", a5);
	}
	printf("\n");
	return 0;
}
```

