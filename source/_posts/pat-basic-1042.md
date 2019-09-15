---
title: PAT乙级 1042.字符统计 (20 分)
date: 2019-07-11 16:47:01
tags: pat
categories: pat乙级
---

请编写程序，找出一段给定文字中出现最频繁的那个英文字母。

<!--more-->

### 输入格式：

输入在一行中给出一个长度不超过 1000 的字符串。字符串由 ASCII 码表中任意可见字符及空格组成，至少包含 1 个英文字母，以回车结束（回车不算在内）。

### 输出格式：

在一行中输出出现频率最高的那个英文字母及其出现次数，其间以空格分隔。如果有并列，则输出按字母序最小的那个字母。统计时不区分大小写，输出小写字母。

### 输入样例：

```in
This is a simple TEST.  There ARE numbers and other symbols 1&2&3...........
```

### 输出样例：

```out
e 7
```

### 分析：

本题考察哈希表的应用。

用数组hash表示哈希表，其下标表示字母，对应值为该字母出现的次数，初始值为0。

遍历输入字符串中的每一个字符，当该字符为小写字母时，其在hash中的值加一；若为大写字母，则其小写形式的hash值加一。

最后，遍历数组hash，输出其中的最大值及其对应的最小下标（字母序最小的那个字母）。

```c++
#include <cstdio>

int main() {
	char temp;
	// 'z' = 122
	char hash[123] = { 0 };
	while ((temp = getchar()) != '\n') {
		if ('A' <= temp && temp <= 'Z') {
			hash[temp + 32]++;
		} else if ('a' <= temp && temp <= 'z') {
			hash[(int) temp]++;
		}
	}
	int count = 0;
	for (int i = 97; i < 123; i++) {
		if (hash[i] > count) {
			temp = i;
			count = hash[i];
		}
	}
	printf("%c %d\n", temp, count);
	return 0;
}
```

