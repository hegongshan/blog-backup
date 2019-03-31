---
title: PAT乙级 1016.部分A+B （15 分)
date: 2019-03-28 15:43:15
tags: pat
categories: pat乙级
mathjax: true
---

正整数 *A* 的“$D_A​$（为 1 位整数）部分”定义为由 *A* 中所有 $D_A​$ 组成的新整数 $P_A​$。例如：给定 *A*=3862767，$D_A​$=6，则 *A*的“6 部分”$P_A​$是66，因为 *A* 中有 2 个 6。

现给定 *A*、$D_A$、*B*、$D_A$，请编写程序计算 $P_A+P_B$。

<!--more-->

### 输入格式：

输入在一行中依次给出 *A*、$D_A​$、*B*、$D_B​$，中间以空格分隔，其中 0<*A*,*B*<$10^{10}​$。

### 输出格式：

在一行中输出$P_A+P_B​$ 的值。

### 输入样例 1：

```in
3862767 6 13530293 3
```

### 输出样例 1：

```out
399
```

### 输入样例 2：

```in
3862767 1 13530293 8
```

### 输出样例 2：

```out
0
```

### 分析：

首先以字符数组（或者字符串）的形式输入A和B，

然后遍历A和B中的每一个字符，

通过减去'0'得到字符的数字形式，

接着，判断其是否等于$D_A$、$D_B$，若等于，则进行进位累加操作。

(1)若从前往后遍历字符数组（或字符串），则累加语句为：

pa = 10 \* pa + da；

(2)若从后往前遍历字符数组（或字符串），则累加语句为

pa += da \* carray; 

carry \*= 10;（carry表示进位，初值为1）。

循环结束后，得到$P_A$和$P_B​$ 。

需要注意的是$10^{10}$超过了int的取值范围，故应使用long long 申明$P_A$和$P_B$。

```c++
#include <cstdio>
#include <cstring>

long long getP(char a[], int da) {
	long long pa = 0;
	long long carry = 1;//进位
	for (int i = strlen(a) - 1; i >= 0; i--) {
		if ((a[i] - '0') == da) {
			pa += da * carry;
			carry *= 10;
		}
	}
	return pa;
}

int main() {
	char a[10], b[10];
	int da, db;
	scanf("%s %d %s %d", a, &da, b, &db);
	printf("%lld\n", getP(a, da) + getP(b, db));
	return 0;
}
```

