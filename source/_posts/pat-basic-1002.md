---
title: PAT乙级 1002.写出这个数 (20 分)
date: 2019-04-30 15:49:22
tags: pat
categories: pat乙级
mathjax: true
---

读入一个正整数 *n*，计算其各位数字之和，用汉语拼音写出和的每一位数字。

<!--more-->

### 输入格式：

每个测试输入包含 1 个测试用例，即给出自然数 *n* 的值。这里保证 *n* 小于 $10^{100}​$。

### 输出格式：

在一行内输出 *n* 的各位数字之和的每一位，拼音数字间有 1 空格，但一行中最后一个拼音数字后没有空格。

### 输入样例：

```in
1234567890987654321123456789
```

### 输出样例：

```out
yi san wu
```

### 分析：

由于$10^{100}$太大，因此需要以字符串的形式读入n。将字符串n中的每一位转换为整型，然后累加到sum中。

接着将sum转换为字符串str。最后，遍历字符串str中的每一位，输出其对应的汉语拼音。

将整型sum转换为字符串str时，可以采用以下两种方法：

（1）使用C++中的to_string()函数；

（2）使用一个字符数组str倒序存储sum的每一个数字。每次通过sum % 10操作得到sum的最后一位，然后令sum /= 10，重复进行上述操作，直至sum = 0。 

```c++
/*
#include <iostream>
#include <string>
using namespace std;

int main() {
	string digits[10] = { "ling", "yi", "er", "san", "si", "wu", "liu", "qi",
			"ba", "jiu" };
	string n;
	cin >> n;
	int sum = 0;
	for (int i = 0; i < n.size(); i++) {
		sum += n[i] - '0';
	}
	string str = to_string(sum);
	for (int i = 0; i < str.size(); i++) {
		if (i > 0) {
			cout << " ";
		}
		cout << digits[str[i] - '0'];
	}
	cout << endl;
	return 0;
}*/

#include <cstdio>
#include <cstring>

int main() {
	char digits[10][5] = { "ling", "yi", "er", "san", "si", "wu", "liu", "qi",
			"ba", "jiu" };
	char n[102];
	scanf("%s", n);
	int sum = 0;
	for (int i = 0; i < strlen(n); i++) {
		sum += n[i] - '0';
	}
	char str[5];
	int index = 0;
	while (sum != 0) {
		str[index++] = sum % 10 + '0';
		sum /= 10;
	}
	for (int i = index - 1; i >= 0; i--) {
		if (i < index - 1) {
			printf(" ");
		}
		printf("%s", digits[str[i] - '0']);
	}
	printf("\n");
	return 0;
}
```

