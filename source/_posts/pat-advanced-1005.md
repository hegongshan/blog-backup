---
title: PAT甲级 1005.Spell It Right (20 分)
date: 2019-05-08 18:02:11
tags: pat
categories: pat甲级
mathjax: true
---

Given a non-negative integer *N*, your task is to compute the sum of all the digits of *N*, and output every digit of the sum in English.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case occupies one line which contains an *N* (≤$10^{100}$).

### Output Specification:

For each test case, output in one line the digits of the sum in English words. There must be one space between two consecutive words, but no extra space at the end of a line.

### Sample Input:

```in
12345
```

### Sample Output:

```out
one five
```

### 分析：

题目要求：给定一个非负数N，计算其各位数字之和，并输出和的每一位的英文表示。

思路：以字符串的形式读入n，计算其各位数字之和sum，将sum转换为字符串result，输出result每一位对应的英文表示。

1.纯c风格（不使用c++的string）

```c++
#include <cstdio>
#include <cstring>

int main() {
	char n[102];
	scanf("%s", n);
	int sum = 0;
	char digits[10][6] = { "zero", "one", "two", "three", "four", "five", "six",
			"seven", "eight", "nine" };
	for (int i = 0; i < strlen(n); i++) {
		sum += (n[i] - '0');
	}
	char result[102], index = 0;
	// 倒序存储sum的每一位，使用do...while是为了处理sum为0的情况
	do {
		result[index++] = sum % 10 + '0';
		sum /= 10;
	} while (sum != 0);
	for (int i = index - 1; i >= 0; i--) {
		if (i != index - 1) {
			printf(" ");
		}
		printf("%s", digits[result[i] - '0']);
	}
	printf("\n");
	return 0;
}
```

2.c++风格（使用string）

```c++
#include <iostream>
#include <string>
using namespace std;

int main() {
	string n;
	cin >> n;
	int sum = 0;
	string digits[10] = { "zero", "one", "two", "three", "four", "five", "six",
			"seven", "eight", "nine" };
	for (int i = 0; i < n.size(); i++) {
		sum += (n[i] - '0');
	}
	string result = to_string(sum);
	for (int i = 0; i < result.size(); i++) {
		if (i != 0) {
			cout << " ";
		}
		cout << digits[result[i] - '0'];
	}
	cout << endl;
	return 0;
}
```

