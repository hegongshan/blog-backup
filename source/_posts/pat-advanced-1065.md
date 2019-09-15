---
title: PAT甲级 1065.A+B and C (64bit) （20 分)
date: 2019-04-06 12:38:15
tags: pat
categories: pat甲级
---

Given three integers *A*, *B* and *C* in [−2^63,2^63], you are supposed to tell whether *A*+*B*>*C*.

<!--more-->

### Input Specification:

The first line of the input gives the positive number of test cases, *T* (≤10). Then *T* test cases follow, each consists of a single line containing three integers *A*, *B* and *C*, separated by single spaces.

### Output Specification:

For each test case, output in one line `Case #X: true` if *A*+*B*>*C*, or `Case #X: false` otherwise, where *X* is the case number (starting from 1).

### Sample Input:

```in
3
1 2 3
2 3 4
9223372036854775807 -9223372036854775808 0
```

### Sample Output:

```out
Case #1: false
Case #2: true
Case #3: false
```

### 分析：

**在计算机组成原理中，如果两个正数之和等于负数或是两个负数之和等于正数，那么就是溢出。**

A、B、C的取值范围为 [−2^63,2^63]，而long long的取值范围为[-2^63,2^63)（经测试，测试用例中没有出现2^63的情况，怀疑是题目写错了），故可以采用long long 存储A、B和C。

设sum=A+B，

如果A  > 0 , B > 0，则sum可能会发生正溢出。long long可表示的最大值为2^63-1，A+B最大为2^64-2，正溢出后sum的取值范围为[-2^63,-2]（由(2^64-2) % (2^64) = -2可得右边界），此时A+B必定大于C ；

如果A  < 0 , B < 0 ，则sum可能会发生负溢出。负溢出后sum的取值范围[0,2^63)（由(-2^64) % (2^64) = 0可得左边界），此时A+B必定小于C；

如果A  > 0 , B < 0 或者 A  < 0 , B > 0 ，则sum不会溢出，此时直接判断sum > C是否成立即可。

```c++
#include <cstdio>

int main() {
	int t;
	scanf("%d", &t);
	long long a, b, c;
	long long sum;
	for (int i = 0; i < t; i++) {
		scanf("%lld %lld %lld", &a, &b, &c);
		sum = a + b;
		bool flag = false;
		if (a > 0 && b > 0 && sum < 0) {
			flag = true;
		} else if (a < 0 && b < 0 && sum >= 0) {
			flag = false;
		} else if (sum > c) {
			flag = true;
		}
		if (flag) {
			printf("Case #%d: true\n", i + 1);
		} else {
			printf("Case #%d: false\n", i + 1);
		}
	}
	return 0;
}
```



