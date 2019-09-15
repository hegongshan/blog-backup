---
title: PAT乙级 1043.输出PATest (20 分)
date: 2019-07-11 17:10:05
tags: pat
categories: pat乙级
---

给定一个长度不超过 10^4 的、仅由英文字母构成的字符串。请将字符重新调整顺序，按 `PATestPATest....` 这样的顺序输出，并忽略其它字符。当然，六种字符的个数不一定是一样多的，若某种字符已经输出完，则余下的字符仍按 PATest 的顺序打印，直到所有字符都被输出。

<!--more-->

### 输入格式：

输入在一行中给出一个长度不超过 10^4 的、仅由英文字母构成的非空字符串。

### 输出格式：

在一行中按题目要求输出排序后的字符串。题目保证输出非空。

### 输入样例：

```in
redlesPayBestPATTopTeePHPereatitAPPT
```

### 输出样例：

```out
PATestPATestPTetPTePePee
```

### 分析：

本题考察哈希表的简单运用。

用数组hash表示哈希表，其下标表示字母，对应的值表示该字母的出现次数。

设置一个bool型变量flag，标记是否还需要输出，默认为true。

然后，循环执行如下操作：

按照`PATest`的顺序，输出对应的字母，并减少其在hash中的值。若某种字符已经输出完，则余下的字符仍按 PATest 的顺序打印，直到所有字符都被输出。

当`PATest`这六个字母在数组hash中的值全为0时，表示不再需要输出，flag设置为false，循环结束。

```c++
#include <cstdio>

int main() {
	char temp;
	int hash[123] = { 0 };
	while ((temp = getchar()) != '\n') {
		hash[temp]++;
	}

	char arr[7] = { 'P', 'A', 'T', 'e', 's', 't' };
	// flag表示是否还有字符可以输出
	bool flag = true;
	while (flag) {

		for (int i = 0; i < 6; i++) {
			if (hash[arr[i]] != 0) {
				printf("%c", arr[i]);
				hash[arr[i]]--;
			}
		}
		// 判断是否所有的字符都已被输出
		flag = false;
		for (int i = 0; i < 6; i++) {
			if (hash[arr[i]] != 0) {
				flag = true;
			}
		}
	}
	printf("\n");
	return 0;
}
```

