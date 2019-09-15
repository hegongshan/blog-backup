---
title: PAT甲级 1009.Product of Polynomials （25 分)
date: 2019-04-08 17:29:30
tags: pat
categories: pat甲级
mathjax: true
---

This time, you are supposed to find *A*×*B* where *A* and *B* are two polynomials.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case occupies 2 lines, and each line contains the information of a polynomial:

$K N_1 a_{N1} N_2 a_{N2} ... N_K a_{NK}$

where *K* is the number of nonzero terms in the polynomial, $N_i​$ and $a_{Ni}​$ (*i*=1,2,⋯,*K*) are the exponents and coefficients, respectively. It is given that 1≤*K*≤10，$0≤N_K<⋯<N_2<N_1≤1000​$.

### Output Specification:

For each test case you should output the product of *A* and *B* in one line, with the same format as the input. Notice that there must be NO extra space at the end of each line. Please be accurate to 1 decimal place.

### Sample Input:

```in
2 1 2.4 0 3.2
2 2 1.5 1 0.5
```

### Sample Output:

```out
3 3 3.6 2 6.0 1 1.6
```

### 分析：

题目要求：计算两个多项式A、B的乘积。

思路：多项式的乘法运算可以转换为多项式的加法运算（多项式加法运算请参看[PAT甲级 1002.A+B for Polynomials （25 分)](/2019/04/08/pat-advanced-1002/)）。

用double型的数组polynomial存储输入的第一个多项式A，用double型数组polynomial2表示多项式A、B的乘积。

可以采用**哈希表**的思想，数组polynomial的下标表示指数，值表示系数，如polynomial[n]表示一个指数为n、系数为polynomial[n]的单项式，数组polynomial2亦如此。

在输入第二个多项式B时，每输入一项（指数exponent和系数coefficient）时，用该项乘以多项式A，即乘以数组polynomial中值不为零的项。当B中的一项乘以A中的第j项时，将数组polynomial2对应下标为 j + exponent的值增加polynomial[j] ×coefficient，即polynomial2[j+exponent] += polynomial[j] ×coefficient。

需要注意的是，指数N≤1000，两个多项式相乘得到的结果中，指数最大为2000，故polynomial2的长度应设置为2001。

```c++
#include <cstdio>

int main() {
	//指数不超过1000
	const int MAX = 1000;
	int k, exponent;
	double coefficient;
	double polynomial[MAX + 1] = { 0 }, polynomial2[2 * MAX + 1] = { 0 };
	scanf("%d", &k);
	for (int i = 0; i < k; i++) {
		scanf("%d %lf", &exponent, &coefficient);
		polynomial[exponent] = coefficient;
	}
	scanf("%d", &k);
	for (int i = 0; i < k; i++) {
		scanf("%d %lf", &exponent, &coefficient);
		for (int j = 0; j < MAX + 1; j++) {
			if (polynomial[j] != 0) {
				polynomial2[j + exponent] += polynomial[j] * coefficient;
			}
		}
	}
	int count = 0;
	for (int i = 0; i < 2 * MAX + 1; i++) {
		if (polynomial2[i] != 0) {
			count++;
		}
	}
	printf("%d", count);
	for (int i = 2 * MAX; i >= 0; i--) {
		if (polynomial2[i] != 0) {
			printf(" %d %.1f", i, polynomial2[i]);
		}
	}
	printf("\n");
	return 0;
}
```



