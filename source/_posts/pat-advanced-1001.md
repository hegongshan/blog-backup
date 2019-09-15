---
title: PAT甲级 1001.A+B Format (20 分)
date: 2019-05-07 18:09:31
tags: pat
categories: pat甲级
---

Calculate *a*+*b* and output the sum in standard format -- that is, the digits must be separated into groups of three by commas (unless there are less than four digits).

<!--more-->

### Input Specification:

Each input file contains one test case. Each case contains a pair of integers *a* and *b* where −10^6≤*a*,*b*≤10^6. The numbers are separated by a space.

### Output Specification:

For each test case, you should output the sum of *a* and *b* in one line. The sum must be written in the standard format.

### Sample Input:

```in
-1000000 9
```

### Sample Output:

```out
-999,991
```

### 分析：

题目要求：计算a+b，然后以每三位加一个逗号`,`的格式输出。

```c++
#include <cstdio>

int main() {
	int a, b, sum, index = 0;
	scanf("%d %d", &a, &b);
	sum = a + b;
	char s[30];
	if (sum < 0) {
		printf("-");
		sum = -sum;
	}
	int count = 0;
	// 采用do...while，避免当sum = 0时，字符数组s为空
	do {
		count++;
		// 倒序存储sum
		s[index++] = sum % 10 + '0';
		sum /= 10;
		// 每三位添加一个逗号
		if (count % 3 == 0 && sum != 0) {
			count = 0;
			s[index++] = ',';
		}
	} while (sum != 0);
	for (int i = index - 1; i >= 0; i--) {
		printf("%c", s[i]);
	}
	printf("\n");
	return 0;
}
```

