---
title: PAT甲级 1077.Kuchiguse (20 分)
date: 2019-05-16 16:27:56
tags: pat
categories: pat甲级
---

The Japanese language is notorious for its sentence ending particles. Personal preference of such particles can be considered as a reflection of the speaker's personality. Such a preference is called "Kuchiguse" and is often exaggerated artistically in Anime and Manga. For example, the artificial sentence ending particle "nyan~" is often used as a stereotype for characters with a cat-like personality:

- Itai nyan~ (It hurts, nyan~)
- Ninjin wa iyada nyan~ (I hate carrots, nyan~)

Now given a few lines spoken by the same character, can you find her Kuchiguse?

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line is an integer *N* (2≤*N*≤100). Following are *N* file lines of 0~256 (inclusive) characters in length, each representing a character's spoken line. The spoken lines are case sensitive.

### Output Specification:

For each test case, print in one line the kuchiguse of the character, i.e., the longest common suffix of all *N* lines. If there is no such suffix, write `nai`.

### Sample Input 1:

```in
3
Itai nyan~
Ninjin wa iyadanyan~
uhhh nyan~
```

### Sample Output 1:

```out
nyan~
```

### Sample Input 2:

```in
3
Itai!
Ninjinnwaiyada T_T
T_T
```

### Sample Output 2:

```out
nai
```

### 分析：

**题目要求：**给定N个字符串，求其最长公共后缀。

**思路：**设maxLen表示最长公共后缀的长度，初始值为258。从第二个字符串开始，将每一个字符串与前一个字符串进行比较，求其公共后缀长度len。若len小于maxLen，则将len赋给maxLen。

待循环执行完毕后，若maxLen为0，则输出`nai`。否则，输出最长公共后缀。

```c++
#include <cstdio>
#include <cstring>

int main() {
	int n;
	scanf("%d", &n);
	getchar();
	char lines[n][257];
	int len = 0, maxLen = 257;
	for (int i = 0; i < n; i++) {
		char c;
		int j = 0;
 		// 由于字符串中可能包含空格，故不能采用scanf。
		// 且PAT不再支持gets，故采用getchar()逐个字符输入
		while ((c = getchar()) != '\n') {
			lines[i][j++] = c;
		}
		lines[i][j] = '\0';

		if (i > 0) {
			int preIndex = strlen(lines[i - 1]) - 1;
			int currentIndex = strlen(lines[i]) - 1;
			while (preIndex >= 0 && currentIndex >= 0
					&& lines[i][currentIndex--] == lines[i - 1][preIndex--]) {
				len++;
			}
			if (len < maxLen) {
				maxLen = len;
			}
			len = 0;
		}
	}
	if (maxLen == 0) {
		printf("nai");
	} else {
		int len0 = strlen(lines[0]);
		for (int i = len0 - maxLen; i < len0; i++) {
			printf("%c", lines[0][i]);
		}
	}
	printf("\n");
	return 0;
}
```

