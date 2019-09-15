---
title: PAT乙级 1009.说反话 （20 分)
date: 2019-04-24 11:34:20
tags: pat
categories: pat乙级
---

给定一句英语，要求你编写程序，将句中所有单词的顺序颠倒输出。

<!--more-->

### 输入格式：

测试输入包含一个测试用例，在一行内给出总长度不超过 80 的字符串。字符串由若干单词和若干空格组成，其中单词是由英文字母（大小写有区分）组成的字符串，单词之间用 1 个空格分开，输入保证句子末尾没有多余的空格。

### 输出格式：

每个测试用例的输出占一行，输出倒序后的句子。

### 输入样例：

```in
Hello World Here I Come
```

### 输出样例：

```out
Come I Here World Hello
```

### 分析：

本题有一种很直接的思路：顺序存储每个单词，然后逆序输出即可。

```c++
#include <cstdio>

int main() {
	char str[81][81];
	int index = 0;
	while (scanf("%s", str[index]) != EOF) {
		index++;
	}
	for (int i = index - 1; i >= 0; i--) {
		printf("%s", str[i]);
		if(i > 0) {
			printf(" ");
		}
	}
	printf("\n");
	return 0;
}
```

另一种思路是先获取输入的字符串，然后从后往前，每碰到空格或者当下标为0时，输出一个单词。

```c++
#include <cstdio>

int main() {
	char str[81];
	char c;
	int index = 0;
	// PAT的编译器不支持gets()
	while((c = getchar()) != '\n' && c != EOF) {
		str[index++] = c;
	}
	int end = index;
	for (int i = index - 1; i >= 0; i--) {
		if (i == 0 || str[i] == ' ') {
			int start = i == 0 ? i : i + 1;
			// 输出一个单词
			for (int j = start; j < end; j++) {
				printf("%c", str[j]);
			}
			if (i > 0) {
				printf(" ");
			}
			end = i;
		}
	}
	printf("\n");
	return 0;
}
```

