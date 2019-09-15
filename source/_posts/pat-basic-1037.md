---
title: PAT乙级 1037.在霍格沃茨找零钱 （20 分)
date: 2019-04-19 11:07:00
tags: pat
categories: pat乙级
---

如果你是哈利·波特迷，你会知道魔法世界有它自己的货币系统 —— 就如海格告诉哈利的：“十七个银西可(Sickle)兑一个加隆(Galleon)，二十九个纳特(Knut)兑一个西可，很容易。”现在，给定哈利应付的价钱 *P* 和他实付的钱 *A*，你的任务是写一个程序来计算他应该被找的零钱。

<!--more-->

### 输入格式：

输入在 1 行中分别给出 *P* 和 *A*，格式为 `Galleon.Sickle.Knut`，其间用 1 个空格分隔。这里 `Galleon` 是 [0, 10^7] 区间内的整数，`Sickle` 是 [0, 17) 区间内的整数，`Knut` 是 [0, 29) 区间内的整数。

### 输出格式：

在一行中用与输入同样的格式输出哈利应该被找的零钱。如果他没带够钱，那么输出的应该是负数。

### 输入样例 1：

```in
10.16.27 14.1.28
```

### 输出样例 1：

```out
3.2.1
```

### 输入样例 2：

```in
14.1.28 10.16.27
```

### 输出样例 2：

```out
-3.2.1
```

### 分析：

用g1.s1.k1表示应付的价钱price，g2.s2.k2表示实付的钱money，change表示应该被找的零钱。

首先，将输入的钱均转换为以纳特(Knut)为单位。转换规则：十七个银西可(Sickle)兑一个加隆(Galleon)，二十九个纳特(Knut)兑一个西可。

然后，用money减去price得到change，若change小于0，则表示没带够钱，那么就输出一个负号，然后change取反。

最后，按照`Galleon.Sickle.Knut`的格式输出change即可。

```c++
#include <cstdio>

const int Galleon = 17 * 29;
const int Sickle = 29;

int main() {
	int g1, s1, k1, g2, s2, k2;
	scanf("%d.%d.%d %d.%d.%d", &g1, &s1, &k1, &g2, &s2, &k2);
	int price = g1 * Galleon + s1 * Sickle + k1;
	int money = g2 * Galleon + s2 * Sickle + k2;
	int change = money - price;
	if (change < 0) {
		printf("-");
		change = -change;
	}
	printf("%d.%d.%d\n", change / Galleon, change % Galleon / Sickle,
			change % Sickle);
	return 0;
}
```

