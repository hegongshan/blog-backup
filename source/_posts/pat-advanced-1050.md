---
title: PAT甲级 1050.String Subtraction (20 分)
date: 2019-07-14 17:49:23
tags: pat
categories: pat甲级
---

Given two strings *S*1 and *S*2, *S*=*S*1−*S*2 is defined to be the remaining string after taking all the characters in *S*2 from *S*1. Your task is simply to calculate *S*1−*S*2 for any given strings. However, it might not be that simple to do it **fast**.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case consists of two lines which gives *S*1 and *S*2, respectively. The string lengths of both strings are no more than 10^4. It is guaranteed that all the characters are visible ASCII codes and white space, and a new line character signals the end of a string.

### Output Specification:

For each test case, print *S*1−*S*2 in one line.

### Sample Input:

```in
They are students.
aeiou
```

### Sample Output:

```out
Thy r stdnts.
```

### 分析：

本题考察哈希表的运用。

用int型数组hash表示哈希表，下标表示字符，对应的值表示该字符是否在S1中出现，默认为0，表示没有出现。

首先，遍历S1，将S1中每个字符的hash值设置为1。

然后，遍历S2中的每个字符，将其在数组hash中的值重置为0，表示在S1中减去该字符。

最后，遍历S1中的每个字符，若该字符在数组hash中的值为1，则输出该字符；否则，不输出。

```c++
#include <cstdio>

int main() {
	// 'z' = 122
	int hash[123] = { 0 };
	char temp;
	char s1[10001];

	int index = 0;
	// 输入s1,将s1中每个字符的hash值均设置为1
	while ((temp = getchar()) != '\n') {
		s1[index++] = temp;
		hash[(int) temp] = 1;
	}
	s1[index] = '\0';

	// 凡是s2中出现的字符，其hash值均重置为0
	while ((temp = getchar()) != '\n') {
		hash[(int) temp] = 0;
	}

	for (int i = 0; i < index; i++) {
		if (hash[(int) s1[i]] == 1) {
			printf("%c", s1[i]);
		}
	}
	printf("\n");
	return 0;
}
```

