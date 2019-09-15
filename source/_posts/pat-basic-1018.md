---
title: PAT乙级 1018.锤子剪刀布 （20 分)
date: 2019-04-01 16:42:25
tags: pat
categories: pat乙级
---

大家应该都会玩“锤子剪刀布”的游戏：两人同时给出手势，胜负规则如图所示：

![FigCJB.jpg](https://images.ptausercontent.com/724da598-b37f-4f1f-99b4-71459654ce3a.jpg)

现给出两人的交锋记录，请统计双方的胜、平、负次数，并且给出双方分别出什么手势的胜算最大。

<!--more-->

### 输入格式：

输入第 1 行给出正整数 *N*（≤10^5），即双方交锋的次数。随后 *N* 行，每行给出一次交锋的信息，即甲、乙双方同时给出的的手势。`C` 代表“锤子”、`J` 代表“剪刀”、`B` 代表“布”，第 1 个字母代表甲方，第 2 个代表乙方，中间有 1 个空格。

### 输出格式：

输出第 1、2 行分别给出甲、乙的胜、平、负次数，数字间以 1 个空格分隔。第 3 行给出两个字母，分别代表甲、乙获胜次数最多的手势，中间有 1 个空格。如果解不唯一，则输出按字母序最小的解。

### 输入样例：

```in
10
C J
J B
C B
B B
B C
C C
C B
J B
B C
J J
```

### 输出样例：

```out
5 3 2
2 3 5
B B
```

### 分析：

设win、draw和defeat分别表示甲赢、平和输的次数，数组aCount[3]和bCount[3]分别表示甲、乙每个手势获胜的次数（下标0表示`B`，1表示`C`，2表示`J`）。

每次交锋，按照结果赢、平和输，分别改变win、draw和defeat，结果为win时，甲相应手势获胜次数加1；结果为defeat（乙win）时，乙相应手势获胜次数加1。

最后按照题目要求输出即可。

```c++
#include <cstdio>

char getMaxGesture(int wins[]) {
	int max, maxIndex;
	max = maxIndex = 0;
	for (int i = 0; i < 3; i++) {
		if (wins[i] > max) {
			max = wins[i];
			maxIndex = i;
		}
	}
	if (maxIndex == 0) {
		return 'B';
	}
	if (maxIndex == 1) {
		return 'C';
	}
	return 'J';
}

int main() {
	int n, win, draw, defeat;
	win = draw = defeat = 0;
	int aCount[3] = { 0 }, bCount[3] = { 0 }; //0-C,1-J,2-B
	scanf("%d", &n);
	while (n--) {
		char a, b;
		scanf(" %c %c", &a, &b);
		if ((a == 'C' && b == 'J') || (a == 'J' && b == 'B')
				|| (a == 'B' && b == 'C')) {
			win++;
			if (a == 'B') {
				aCount[0]++;
			} else if (a == 'C') {
				aCount[1]++;
			} else {
				aCount[2]++;
			}
		} else if (a == b) {
			draw++;
		} else {
			defeat++;
			if (b == 'B') {
				bCount[0]++;
			} else if (b == 'C') {
				bCount[1]++;
			} else {
				bCount[2]++;
			}
		}
	}
	printf("%d %d %d\n", win, draw, defeat);
	printf("%d %d %d\n", defeat, draw, win);
	printf("%c %c\n", getMaxGesture(aCount), getMaxGesture(bCount));
	return 0;
}
```

