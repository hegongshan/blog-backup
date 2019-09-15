---
title: PAT乙级 1022.D进制的A+B （20 分)
date: 2019-04-17 10:21:01
tags: pat
categories: pat乙级
---

输入两个非负 10 进制整数 *A* 和 *B* (≤2^30−1)，输出 *A*+*B* 的 *D* (1<*D*≤10)进制数。

<!--more-->

### 输入格式：

输入在一行中依次给出 3 个整数 *A*、*B* 和 *D*。

### 输出格式：

输出 *A*+*B* 的 *D* 进制数。

### 输入样例：

```in
123 456 8
```

### 输出样例：

```out
1103
```

### 分析：

设sum = a + b，采用“除基取余法”，将每次sum % d的结果存储在int数组data中，然后令 sum /= d，直至sum==0成立为止。此时数组data中，倒序保存着sum在d进制下每一位的结果。

```c++
#include <cstdio>

int main() {
	int a, b, d, sum;
	int data[32];
	scanf("%d %d %d", &a, &b, &d);
	sum = a + b;
	int i = 0;
	do {
		data[i++] = sum % d;
		sum /= d;
	} while (sum != 0);
	for (int j = i - 1; j >= 0; j--) {
		printf("%d", data[j]);
	}
	printf("\n");
	return 0;
}
```

