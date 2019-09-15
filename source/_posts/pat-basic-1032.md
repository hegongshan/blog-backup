---
title: PAT乙级 1032.挖掘机技术哪家强 （20 分)
date: 2019-04-11 14:36:28
tags: pat
categories: pat乙级
---

为了用事实说明挖掘机技术到底哪家强，PAT 组织了一场挖掘机技能大赛。现请你根据比赛结果统计出技术最强的那个学校。

<!--more-->

### 输入格式：

输入在第 1 行给出不超过 10^5 的正整数 *N*，即参赛人数。随后 *N* 行，每行给出一位参赛者的信息和成绩，包括其所代表的学校的编号（从 1 开始连续编号）、及其比赛成绩（百分制），中间以空格分隔。

### 输出格式：

在一行中给出总得分最高的学校的编号、及其总分，中间以空格分隔。题目保证答案唯一，没有并列。

### 输入样例：

```in
6
3 65
2 80
1 100
2 70
3 40
3 0
```

### 输出样例：

```out
2 150
```

### 分析：

用数组scores保存每个学校的编号及其对应的分数，数组下标为学校编号，值为对应的分数。

用maxNo、maxScore表示总得分最高的学校的编号、及其总分，均初始化为0。

每当输入一个编号no和分数score时，让scores[no]增加score，然后与maxScore进行比较，若比maxScore大，则将no、scores[no]分别赋给maxNo、maxScore。

```c++
#include <cstdio>

int main() {
	int n;
	scanf("%d", &n);
	int scores[100001] = { 0 };
	int maxNo, maxScore, no, score;
	maxNo = maxScore = 0;
	for (int i = 0; i < n; i++) {
		scanf("%d %d", &no, &score);
		scores[no] += score;
		if (scores[no] > maxScore) {
			maxNo = no;
			maxScore = scores[no];
		}
	}
	printf("%d %d\n", maxNo, maxScore);
	return 0;
}
```

