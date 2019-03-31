---
title: PAT乙级 1046.划拳 （15 分)
date: 2019-03-31 17:14:30
tags: pat
categories: pat乙级
---

划拳是古老中国酒文化的一个有趣的组成部分。酒桌上两人划拳的方法为：每人口中喊出一个数字，同时用手比划出一个数字。如果谁比划出的数字正好等于两人喊出的数字之和，谁就赢了，输家罚一杯酒。两人同赢或两人同输则继续下一轮，直到唯一的赢家出现。

<!--more-->

下面给出甲、乙两人的划拳记录，请你统计他们最后分别喝了多少杯酒。

### 输入格式：

输入第一行先给出一个正整数 *N*（≤100），随后 *N* 行，每行给出一轮划拳的记录，格式为：

```
甲喊 甲划 乙喊 乙划
```

其中`喊`是喊出的数字，`划`是划出的数字，均为不超过 100 的正整数（两只手一起划）。

### 输出格式：

在一行中先后输出甲、乙两人喝酒的杯数，其间以一个空格分隔。

### 输入样例：

```in
5
8 10 9 12
5 10 5 10
3 8 5 12
12 18 1 13
4 16 12 15
```

### 输出样例：

```out
1 2
```

### 分析:

设aCount和bCount分别表示甲、乙两人喝酒的杯数，aSay和bSay分别表示甲、乙喊出的数字，aGive和bGive分别表示甲、乙划出的数字。

本题共有四种情况，对应三种结果：

1.甲、乙同赢(aGive == aSay + bSay && bGive == aSay + bSay)或同输(aGive != aSay + bSay && bGive != aSay + bSay)：继续下一轮；

2.甲赢(aGive == aSay + bSay)：乙喝酒，即bCount++；

3.乙赢(bGive == aSay + bSay)：甲喝酒，即aCount++。

```c++
#include <cstdio>

int main() {
	int n, aCount, bCount;
	aCount = bCount = 0;
	scanf("%d", &n);
	while (n--) {
		int aSay, aGive, bSay, bGive;
		scanf("%d %d %d %d", &aSay, &aGive, &bSay, &bGive);
		//1.同赢或同输
		if ((aGive == aSay + bSay && bGive == aSay + bSay)
				|| (aGive != aSay + bSay && bGive != aSay + bSay)) {
			continue;
		}
		//2.甲赢
		if (aGive == aSay + bSay) {
			bCount++;
		} else if (bGive == aSay + bSay) {
			//3.乙赢
			aCount++;
		}
	}
	printf("%d %d\n", aCount, bCount);
	return 0;
}
```

