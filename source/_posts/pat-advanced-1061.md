---
title: PAT甲级 1061.Dating (20 分)
date: 2019-04-30 16:25:05
tags: pat
categories: pat甲级
---

Sherlock Holmes received a note with some strange strings: `Let's date! 3485djDkxh4hhGE 2984akDfkkkkggEdsb s&hgsfdk d&Hyscvnm`. It took him only a minute to figure out that those strange strings are actually referring to the coded time `Thursday 14:04` -- since the first common capital English letter (case sensitive) shared by the first two strings is the 4th capital letter `D`, representing the 4th day in a week; the second common character is the 5th capital letter `E`, representing the 14th hour (hence the hours from 0 to 23 in a day are represented by the numbers from 0 to 9 and the capital letters from `A` to `N`, respectively); and the English letter shared by the last two strings is `s` at the 4th position, representing the 4th minute. Now given two pairs of strings, you are supposed to help Sherlock decode the dating time.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case gives 4 non-empty strings of no more than 60 characters without white space in 4 lines.

### Output Specification:

For each test case, print the decoded time in one line, in the format `DAY HH:MM`, where `DAY` is a 3-character abbreviation for the days in a week -- that is, `MON` for Monday, `TUE` for Tuesday, `WED` for Wednesday, `THU` for Thursday, `FRI` for Friday, `SAT` for Saturday, and `SUN` for Sunday. It is guaranteed that the result is unique for each case.

### Sample Input:

```in
3485djDkxh4hhGE 
2984akDfkkkkggEdsb 
s&hgsfdk 
d&Hyscvnm
```

### Sample Output:

```out
THU 14:04
```

### 分析：

本题（与[PAT乙级 1014.福尔摩斯的约会 (20 分)](/2019/04/30/pat-basic-1014/)是同一道题）有以下四个需要注意的地方：

（1）前面两个字符串中第 1 对相同的**大写英文字母**表示星期。一个星期7天，故其取值范围为**A-G**，而不是A-Z。

（2）前面两个字符串中第 2 对相同的**字符**（第 1 对相同的大写英文字母出现之后）表示钟点（小时）。一天的 0 点到 23 点由数字 0 到 9、以及大写字母 `A` 到 `N` 表示。

（3）后面两个字符串中第 1 对相同的**英文字母**出现的位置（从 0 开始计数）表示分钟。

（4）小时和分钟不足两位数时，需要在前面添0。

```c++
#include <cstdio>
#include <cstring>

int main() {
	char week[7][4] = { "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN" };
	char str[4][61];
	for (int i = 0; i < 4; i++) {
		scanf("%s", str[i]);
	}
	int len0 = strlen(str[0]), len1 = strlen(str[1]);
	int len2 = strlen(str[2]), len3 = strlen(str[3]);
	int i = 0, j = 0;
	while (i < len0 && i < len1) {
		// 第一对相同的大写英文字母，取值范围为A-G
		if (str[0][i] == str[1][i] && 'A' <= str[0][i] && str[0][i] <= 'G') {
			printf("%s ", week[str[0][i] - 'A']);
			break;
		}
		i++;
	}
	i += 1;
	while (i < len0 && i < len1) {
		// 第二对相同的字符，取值范围为0-9及A-N
		if (str[0][i] == str[1][i]
				&& (('A' <= str[0][i] && str[0][i] <= 'N')
						|| ('0' <= str[0][i] && str[0][i] <= '9'))) {
			if ('A' <= str[0][i] && str[0][i] <= 'N') {
				printf("%d:", str[0][i] - 'A' + 10);
			} else {
				printf("%02d:", str[0][i] - '0');
			}
			break;
		}
		i++;
	}
	while (j < len2 && j < len3) {
		// 第一对相同的英文字母
		if (str[2][j] == str[3][j]
				&& (('A' <= str[2][j] && str[2][j] <= 'Z')
						|| ('a' <= str[2][j] && str[2][j] <= 'z'))) {
			printf("%02d\n", j);
			break;
		}
		j++;
	}
	return 0;
}
```