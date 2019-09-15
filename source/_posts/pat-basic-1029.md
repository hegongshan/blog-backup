---
title: PAT乙级 1029.旧键盘/PAT甲级 1084.Broken Keyboard (20 分)
date: 2019-07-03 13:12:21
tags: pat
categories: [pat乙级,pat甲级]
---

旧键盘上坏了几个键，于是在敲一段文字的时候，对应的字符就不会出现。现在给出应该输入的一段文字、以及实际被输入的文字，请你列出肯定坏掉的那些键。

<!--more-->

### 输入格式：

输入在 2 行中分别给出应该输入的文字、以及实际被输入的文字。每段文字是不超过 80 个字符的串，由字母 A-Z（包括大、小写）、数字 0-9、以及下划线 `_`（代表空格）组成。题目保证 2 个字符串均非空。

### 输出格式：

按照发现顺序，在一行中输出坏掉的键。其中英文字母只输出大写，每个坏键只输出一次。题目保证至少有 1 个坏键。

### 输入样例：

```in
7_This_is_a_test
_hs_s_a_es
```

### 输出样例：

```out
7TI
```

### 分析：

设应该输入的文字为s1，实际被输入的文字为s2。

使用**哈希表**hash（用数组表示），记录下s1中各字符的出现次数。数组hash以字符为下标，出现次数为值。

由于小写字母`z`的ASCII码值为122，因此，数组hash的长度应申明为123。

然后，遍历s2，对数组hash中相应字符的出现次数，执行自减操作。

最后，遍历s1，若当前字符c在数组hash中的值大于0，则输出该字符。

由于题目要求**相同字符只输出一次**，因此，输出字符c后，其在数组hash中的值应赋值为0，即`hash[c]=0`。

**需要注意的地方：**英文字母只输出大写。因此，在遍历s1（s2）时，若为小写字母，则增加（减少）其大写字母的出现次数。

```c++
#include <cstdio>
#include <cstring>

bool is_lower(char c) {
	return 'a' <= c && c <= 'z';
}

void getline(char s[]) {
	char temp;
	int index = 0;
	while ((temp = getchar()) != '\n') {
		s[index++] = temp;
	}
	s[index] = '\0';
}

int main() {
	char s1[81], s2[81];
	getline(s1);
	// 'z'=122
	int hash[123] = { 0 };
	int len1 = strlen(s1);
	for (int i = 0; i < len1; i++) {
		if (is_lower(s1[i])) {
			hash[s1[i] - 32]++;
		} else {
			hash[s1[i]]++;
		}
	}
	getline(s2);
	for (int i = 0; i < strlen(s2); i++) {
		if (is_lower(s2[i])) {
			hash[s2[i] - 32]--;
		} else {
			hash[s2[i]]--;
		}
	}
	char c;
	for (int i = 0; i < len1; i++) {
		if (is_lower(s1[i])) {
			c = s1[i] - 32;
		} else {
			c = s1[i];
		}
		if (hash[c] > 0) {
			printf("%c", c);
			// 相同字符只输出一次
			hash[c] = 0;
		}
	}
	printf("\n");
}
```

