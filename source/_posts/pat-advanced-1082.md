---
title: PAT甲级 1082.Read Number in Chinese (25 分)
date: 2019-05-23 10:44:43
tags: pat
categories: pat甲级
---

Given an integer with no more than 9 digits, you are supposed to read it in the traditional Chinese way. Output `Fu` first if it is negative. For example, -123456789 is read as `Fu yi Yi er Qian san Bai si Shi wu Wan liu Qian qi Bai ba Shi jiu`. Note: zero (`ling`) must be handled correctly according to the Chinese tradition. For example, 100800 is `yi Shi Wan ling ba Bai`.

<!--more-->

### Input Specification:

Each input file contains one test case, which gives an integer with no more than 9 digits.

### Output Specification:

For each test case, print in a line the Chinese way of reading the number. The characters are separated by a space and there must be no extra space at the end of the line.

### Sample Input 1:

```in
-123456789
```

### Sample Output 1:

```out
Fu yi Yi er Qian san Bai si Shi wu Wan liu Qian qi Bai ba Shi jiu
```

### Sample Input 2:

```in
100800
```

### Sample Output 2:

```out
yi Shi Wan ling ba Bai
```

### 分析：

**题目要求：**按照中文数字的读法，输出给定的整数（不超过9位）。

**思路：**将输入的整数当作字符串来处理。

首先，判断首位字符是否为`-`，若为`-`，则输出`Fu`。

然后，设置left、right两个指针，用于标明同一组数字的最高位和最低位，从前向后每次循环只处理一组数字。(字符串从后向前，每四位数字为一组。)

用hasPrint表示在处理该组数字时，是否输出过非零数字，默认为false。

用hasZero表示当前数字的前面是否存在累积的零，默认为false。

若本组输出过至少一个非零数字，且right小于字符串的最大索引，则输出该节数字的单位（万或亿）。

处理完一组数字后，right后移4位，继续下一次循环，直到left大于等于字符串的长度为止。

```c++
#include <cstdio>
#include <cstring>

int main() {
	char digits[10][5] = { "ling", "yi", "er", "san", "si", "wu", "liu", "qi",
			"ba", "jiu" };
	char unit[5][5] = { "Shi", "Bai", "Qian", "Wan", "Yi" };
	char data[11];
	scanf("%s", data);
	int len = strlen(data);
	int left = 0, right = len - 1;
	// 若为负数
	if (len != 0 && data[0] == '-') {
		printf("Fu");
		left = 1;
	}
	// 找到与left在同一节中的right
	while (left + 4 <= right) {
		right -= 4;
	}
	while (left < len) {
		bool hasPrint = false;
		bool hasZero = false;
		// 处理某一组数字
		while (left <= right) {
			if (left > 0 && data[left] == '0') {
				hasZero = true;
			} else {
				if (hasZero == true) {
					printf(" ling");
					hasZero = false;
				}
				hasPrint = true;
				// 若当前数字不是第一个数字，则输出空格
				if (left > 0) {
					printf(" ");
				}
				printf("%s", digits[data[left] - '0']);
				if (right > left) {
					printf(" %s", unit[right - left - 1]);
				}
			}
			left++;
		}
		// 若本组已经输出过至少一个非零数字，则输出该组数字的单位(万/亿)
		if (hasPrint && right < len - 1) {
			printf(" %s", unit[(len - 1 - right) / 4 + 2]);
		}
		right += 4;
	}
	printf("\n");
	return 0;
}
```



