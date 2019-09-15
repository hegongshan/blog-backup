---
title: PAT乙级 1039.到底买不买 (20 分)
date: 2019-07-07 17:01:16
tags: pat
categories: pat乙级
---

小红想买些珠子做一串自己喜欢的珠串。卖珠子的摊主有很多串五颜六色的珠串，但是不肯把任何一串拆散了卖。于是小红要你帮忙判断一下，某串珠子里是否包含了全部自己想要的珠子？如果是，那么告诉她有多少多余的珠子；如果不是，那么告诉她缺了多少珠子。

<!--more-->

为方便起见，我们用[0-9]、[a-z]、[A-Z]范围内的字符来表示颜色。例如在图1中，第3串是小红想做的珠串；那么第1串可以买，因为包含了全部她想要的珠子，还多了8颗不需要的珠子；第2串不能买，因为没有黑色珠子，并且少了一颗红色的珠子。

![](/static/images/pat-basic-1039.jpg)

图 1

### 输入格式：

每个输入包含 1 个测试用例。每个测试用例分别在 2 行中先后给出摊主的珠串和小红想做的珠串，两串都不超过 1000 个珠子。

### 输出格式：

如果可以买，则在一行中输出 `Yes` 以及有多少多余的珠子；如果不可以买，则在一行中输出 `No` 以及缺了多少珠子。其间以 1 个空格分隔。

### 输入样例 1：

```in
ppRYYGrrYBR2258
YrR8RrY
```

### 输出样例 1：

```out
Yes 8
```

### 输入样例 2：

```in
ppRYYGrrYB225
YrR8RrY
```

### 输出样例 2：

```out
No 2
```

### 分析：

本题考察的是**哈希表**的使用。

* 变量设置

使用数组hash表示哈希表，其下标表示某字符，值表示该字符出现的次数。

bool型变量absent，表示是否缺少珠子，初始化为false。

int型变量count，表示缺少或多出的珠子的个数，初始化为0。

* 思路

首先，使用数组hash统计出摊主的珠串中各字符出现的次数。

然后，遍历小红想做的珠串，判断每个字符（这里用temp表示）在hash中的值，

若hash[temp]==0，则表示缺少该字符，count自增，absent设置为true；否则，`hash[temp]--`。

最后，判断absent是否为true，若absent == true，则输出`No`和缺少的珠子个数count；

否则，输出`Yes`和多出的珠子个数。此时数组hash中所有值之和，即为多出的珠子个数。

```c++
#include <cstdio>

int main() {
	char temp;
	// 'z' = 122
	int hash[123] = { 0 };
	while ((temp = getchar()) != '\n') {
		hash[temp]++;
	}
	// 是否缺少珠子
	bool absent = false;
	// 统计多出或者缺少的珠子个数
	int count = 0;
	while ((temp = getchar()) != '\n') {
		// 没有某颗珠子
		if (hash[temp] == 0) {
			// 统计缺少珠子的个数
			count++;
			absent = true;
		} else {
			hash[temp]--;
		}
	}
	if (absent) {
		printf("No ");
	} else {
		printf("Yes ");
		// 计算多余珠子的个数
		for (int i = 0; i < 123; i++) {
			count += hash[i];
		}
	}
	printf("%d\n", count);
	return 0;
}
```



