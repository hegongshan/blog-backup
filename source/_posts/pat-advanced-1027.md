---
title: PAT甲级 1027.Colors in Mars （20 分)
date: 2019-04-21 10:29:39
tags: pat
categories: pat甲级
---

People in Mars represent the colors in their computers in a similar way as the Earth people. That is, a color is represented by a 6-digit number, where the first 2 digits are for `Red`, the middle 2 digits for `Green`, and the last 2 digits for `Blue`. The only difference is that they use radix 13 (0-9 and A-C) instead of 16. Now given a color in three decimal numbers (each between 0 and 168), you are supposed to output their Mars RGB values.

<!--more-->

### Input Specification:

Each input file contains one test case which occupies a line containing the three decimal color values.

### Output Specification:

For each test case you should output the Mars RGB value in the following format: first output `#`, then followed by a 6-digit number where all the English characters must be upper-cased. If a single color is only 1-digit long, you must print a `0` to its left.

### Sample Input:

```in
15 43 71
```

### Sample Output:

```out
#123456
```

### 分析：

**题目大意：**给定三个十进制数，将它们转换为13进制数输出。

已知给定的十进制数x不超过168，转换成13进制后，不超过两位（13进制下CC = 168）。

针对本题，一个比较巧妙的办法如下：

设置一个字符数组radix，将其初始化为“0123456789ABC”，这样，下标0对应字符'0'，下标13对应字符‘A’...转换后的13进制数可以由radix[x / 13]和radix[x % 13]拼接而成。

```c++
#include <cstdio>

int main() {
	char radix[14] = "0123456789ABC";
	int r, g, b;
	scanf("%d %d %d", &r, &g, &b);
	printf("#");
	printf("%c%c", radix[r / 13], radix[r % 13]);
	printf("%c%c", radix[g / 13], radix[g % 13]);
	printf("%c%c\n", radix[b / 13], radix[b % 13]);
}
```

