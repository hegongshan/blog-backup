---
title: PAT甲级 1002.A+B for Polynomials （25 分)
date: 2019-04-08 10:36:21
tags: pat
categories: pat甲级
mathjax: true
---

This time, you are supposed to find *A*+*B* where *A* and *B* are two polynomials.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case occupies 2 lines, and each line contains the information of a polynomial:

$K N_1 a_{N1} N_2 a_{N2} ... N_K a_{NK}$

where *K* is the number of nonzero terms in the polynomial, $N_i​$ and $a_{Ni}​$ (*i*=1,2,⋯,*K*) are the exponents and coefficients, respectively. It is given that 1≤*K*≤10，$0≤N_K<⋯<N_2<N_1≤1000​$.

### Output Specification:

For each test case you should output the sum of *A* and *B* in one line, with the same format as the input. Notice that there must be NO extra space at the end of each line. Please be accurate to 1 decimal place.

### Sample Input:

```in
2 1 2.4 0 3.2
2 2 1.5 1 0.5
```

### Sample Output:

```out
3 2 1.5 1 2.9 0 3.2
```

### 分析：

题目要求：计算两个多项式A、B的和。

可以采用**哈希表**的思想来实现，使用一个double型的数组polynomial（长度为1001，指数N≤1000）来存储多项式，其下标表示指数，值表示该指数对应的系数，如polynomial[n]表示一个指数为n、系数为polynomial[n]的单项式。

经过两次输入的累加操作后，polynomial中存储着两个多项式的和。

输出前，先遍历一次polynomial得到其中非零项的个数。然后从后往前遍历数组polynomial，输出值不为零的下标（指数）及其对应值（系数）。

```c++
#include <cstdio>

int main() {
	int k, exponent;
	int line = 2;
	const int MAX = 1001;
	double coefficient;
	double polynomials[MAX] = { 0 };
	while (line--) {
		scanf("%d", &k);
		for (int i = 0; i < k; i++) {
			scanf("%d %lf", &exponent, &coefficient);
			polynomials[exponent] += coefficient;
		}
	}
	int len = 0;
	for (int i = 0; i < MAX; i++) {
		if (polynomials[i] != 0) {
			len++;
		}
	}
	printf("%d", len);
	for (int i = MAX - 1; i >= 0; i--) {
		if (polynomials[i] != 0) {
			printf(" %d %.1f", i, polynomials[i]);
		}
	}
}
```

