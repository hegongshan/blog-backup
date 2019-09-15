---
title: PAT甲级 1041.Be Unique (20 分)
date: 2019-07-13 17:14:34
tags: pat
categories: pat甲级
---

Being unique is so important to people on Mars that even their lottery is designed in a unique way. The rule of winning is simple: one bets on a number chosen from [1,10^4]. The first one who bets on a unique number wins. For example, if there are 7 people betting on { 5 31 5 88 67 88 17 }, then the second one who bets on 31 wins.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case contains a line which begins with a positive integer *N* (≤10^5) and then followed by *N* bets. The numbers are separated by a space.

### Output Specification:

For each test case, print the winning number in a line. If there is no winner, print `None` instead.

### Sample Input 1:

```in
7 5 31 5 88 67 88 17
```

### Sample Output 1:

```out
31
```

### Sample Input 2:

```in
5 888 666 666 888 888
```

### Sample Output 2:

```out
None
```

### 分析：

**题目要求：**给定N个数，输出第一个不重复的数字。若不存在这样的数字，则输出`None`。

**思路：**本题考察哈希表的运用。

用数组hash表示哈希表，下标表示待输入的数，取值范围为[1,10^4]，对应值为该数出现的次数，初始值为0。

设置bool型变量exists，表示是否存在不重复的数字，初始值为false。

对输入的N个数执行两次遍历，第一次遍历，统计每个数出现的次数；第二次遍历，寻找第一个出现次数为1的数字并输出。若存在这样的数字，则将exists设置为true。

第二次遍历结束以后，若exists仍为false，表示不存在这样的数字，则输出`None`。

```c++
#include <cstdio>

int main() {
	int n;
	scanf("%d", &n);

	int hash[10001] = { 0 };
	int data[n];
	for (int i = 0; i < n; i++) {
		scanf("%d", &data[i]);
		hash[data[i]]++;
	}

	// 是否存在赢家
	bool exists = false;
	for (int i = 0; i < n; i++) {
		if (hash[data[i]] == 1) {
			exists = true;
			printf("%d\n", data[i]);
			break;
		}
	}
	if (!exists) {
		printf("None\n");
	}
	return 0;
}
```



