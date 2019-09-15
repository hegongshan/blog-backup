---
title: PAT甲级 1011.World Cup Betting （20 分)
date: 2019-04-11 15:29:32
tags: pat
categories: pat甲级
---

With the 2010 FIFA World Cup running, football fans the world over were becoming increasingly excited as the best players from the best teams doing battles for the World Cup trophy in South Africa. Similarly, football betting fans were putting their money where their mouths were, by laying all manner of World Cup bets.

Chinese Football Lottery provided a "Triple Winning" game. The rule of winning was simple: first select any three of the games. Then for each selected game, bet on one of the three possible results -- namely `W` for win, `T` for tie, and `L` for lose. There was an odd assigned to each result. The winner's odd would be the product of the three odds times 65%.

For example, 3 games' odds are given as the following:

```
 W    T    L
1.1  2.5  1.7
1.2  3.1  1.6
4.1  1.2  1.1
```

To obtain the maximum profit, one must buy `W` for the 3rd game, `T` for the 2nd game, and `T` for the 1st game. If each bet takes 2 yuans, then the maximum profit would be (4.1×3.1×2.5×65%−1)×2=39.31 yuans (accurate up to 2 decimal places).

<!--more-->

### Input Specification:

Each input file contains one test case. Each case contains the betting information of 3 games. Each game occupies a line with three distinct odds corresponding to `W`, `T` and `L`.

### Output Specification:

For each test case, print in one line the best bet of each game, and the maximum profit accurate up to 2 decimal places. The characters and the number must be separated by one space.

### Sample Input:

```in
1.1 2.5 1.7
1.2 3.1 1.6
4.1 1.2 1.1
```

### Sample Output:

```out
T T W 39.31
```

### 分析：

题目要求：给定三场比赛，及每场比赛赢W、平分T、输L的赔率，选取每场比赛赔率最大的结果下注（赔率分别记为a、b、c），以期获得最大收益。

分别输出三场比赛的下注情况（W、T 或 L），然后按照`（a × b × c × 0.65 - 1）× 2`计算收益。

```c++
#include <cstdio>

int main() {
	const int n = 3;
	char results[n + 1] = { "WTL" };
	double x;
	double rate = 0.65;
	int perBetMoney = 2;
	double product = 1.0;
	for (int i = 0; i < n; i++) {
		double maxValue = 0.0;
		int maxChar = 0;
		for (int j = 0; j < n; j++) {
			scanf("%lf", &x);
			if (x > maxValue) {
				maxValue = x;
				maxChar = j;
			}
		}
		product *= maxValue;
		printf("%c ", results[maxChar]);
	}
	printf("%.2f\n", (product * rate - 1) * perBetMoney);
	return 0;
}
```

