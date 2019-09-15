---
title: PAT乙级 1014.福尔摩斯的约会 (20 分)
date: 2019-04-30 15:49:49
tags: pat
categories: pat乙级
---

大侦探福尔摩斯接到一张奇怪的字条：`我们约会吧！ 3485djDkxh4hhGE 2984akDfkkkkggEdsb s&hgsfdk d&Hyscvnm`。大侦探很快就明白了，字条上奇怪的乱码实际上就是约会的时间`星期四 14:04`，因为前面两字符串中第 1 对相同的大写英文字母（大小写有区分）是第 4 个字母 `D`，代表星期四；第 2 对相同的字符是 `E` ，那是第 5 个英文字母，代表一天里的第 14 个钟头（于是一天的 0 点到 23 点由数字 0 到 9、以及大写字母 `A` 到 `N` 表示）；后面两字符串第 1 对相同的英文字母 `s` 出现在第 4 个位置（从 0 开始计数）上，代表第 4 分钟。现给定两对字符串，请帮助福尔摩斯解码得到约会的时间。

<!--more-->

### 输入格式：

输入在 4 行中分别给出 4 个非空、不包含空格、且长度不超过 60 的字符串。

### 输出格式：

在一行中输出约会的时间，格式为 `DAY HH:MM`，其中 `DAY` 是某星期的 3 字符缩写，即 `MON` 表示星期一，`TUE` 表示星期二，`WED` 表示星期三，`THU` 表示星期四，`FRI` 表示星期五，`SAT` 表示星期六，`SUN` 表示星期日。题目输入保证每个测试存在唯一解。

### 输入样例：

```in
3485djDkxh4hhGE 
2984akDfkkkkggEdsb 
s&hgsfdk 
d&Hyscvnm
```

### 输出样例：

```out
THU 14:04
```

### 分析：

本题有以下四个需要注意的地方：

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



