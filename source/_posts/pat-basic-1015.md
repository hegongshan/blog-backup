---
title: PAT乙级 1015.德才论/PAT甲级 1062.Talent and Virtue (25 分)
date: 2019-05-29 19:11:11
tags: pat
categories: [pat乙级,pat甲级]
---

宋代史学家司马光在《资治通鉴》中有一段著名的“德才论”：“是故才德全尽谓之圣人，才德兼亡谓之愚人，德胜才谓之君子，才胜德谓之小人。凡取人之术，苟不得圣人，君子而与之，与其得小人，不若得愚人。”

现给出一批考生的德才分数，请根据司马光的理论给出录取排名。

<!--more-->

### 输入格式：

输入第一行给出 3 个正整数，分别为：*N*（≤10^5），即考生总数；*L*（≥60），为录取最低分数线，即德分和才分均不低于 *L* 的考生才有资格被考虑录取；*H*（<100），为优先录取线——德分和才分均不低于此线的被定义为“才德全尽”，此类考生按德才总分从高到低排序；才分不到但德分到线的一类考生属于“德胜才”，也按总分排序，但排在第一类考生之后；德才分均低于 *H*，但是德分不低于才分的考生属于“才德兼亡”但尚有“德胜才”者，按总分排序，但排在第二类考生之后；其他达到最低线 *L* 的考生也按总分排序，但排在第三类考生之后。

随后 *N* 行，每行给出一位考生的信息，包括：`准考证号 德分 才分`，其中`准考证号`为 8 位整数，德才分为区间 [0, 100] 内的整数。数字间以空格分隔。

### 输出格式：

输出第一行首先给出达到最低分数线的考生人数 *M*，随后 *M* 行，每行按照输入格式输出一位考生的信息，考生按输入中说明的规则从高到低排序。当某类考生中有多人总分相同时，按其德分降序排列；若德分也并列，则按准考证号的升序输出。

### 输入样例：

```in
14 60 80
10000001 64 90
10000002 90 60
10000011 85 80
10000003 85 80
10000004 80 85
10000005 82 77
10000006 83 76
10000007 90 78
10000008 75 79
10000009 59 90
10000010 88 45
10000012 80 100
10000013 90 99
10000014 66 60
```

### 输出样例：

```out
12
10000013 90 99
10000012 80 100
10000003 85 80
10000011 85 80
10000004 80 85
10000007 90 78
10000006 83 76
10000005 82 77
10000002 90 60
10000014 66 60
10000008 75 79
10000001 64 90
```

### 分析：

按照题目要求，可以建立如下的结构体：

```c++
struct Student {
	// 准考证号
	int permitNo;
	// 德分
	int personalityScore;
	// 才分
	int abilityScore;
	// 所属类别，1表示才德全尽，2表示德胜才，3表示“才德兼亡”但尚有“德胜才”，4表示其他满足最低要求的考生
	int level;
};
```

然后进行相应的排序即可。

完整代码如下：

```c++
#include <cstdio>
#include <algorithm>
using namespace std;

struct Student {
	// 准考证号
	int permitNo;
	// 德分
	int personalityScore;
	// 才分
	int abilityScore;
	// 所属类别
	int level;
};

bool cmp(struct Student stu1, struct Student stu2) {
	if (stu1.level != stu2.level) {
		return stu1.level < stu2.level;
	}
	// 按总分排序
	if (stu1.abilityScore + stu1.personalityScore
			!= stu2.abilityScore + stu2.personalityScore) {
		return stu1.abilityScore + stu1.personalityScore
				> stu2.abilityScore + stu2.personalityScore;
	}
	// 若总分相同，则按德分降序排列
	if (stu1.personalityScore != stu2.personalityScore) {
		return stu1.personalityScore > stu2.personalityScore;
	}
	// 若德分并列，则按准考证号升序
	return stu1.permitNo < stu2.permitNo;
}

void print(struct Student stu[], int len) {
	for (int i = 0; i < len; i++) {
		printf("%d %d %d\n", stu[i].permitNo, stu[i].personalityScore,
				stu[i].abilityScore);
	}
}

int main() {
	int n, low, high, m = 0;
	scanf("%d %d %d", &n, &low, &high);

	struct Student stu[n];
	int permitNo, personalityScore, abilityScore;

	for (int i = 0; i < n; i++) {
		scanf("%d %d %d", &permitNo, &personalityScore, &abilityScore);
		if (personalityScore < low || abilityScore < low) {
			continue;
		}
		stu[m].permitNo = permitNo;
		stu[m].abilityScore = abilityScore;
		stu[m].personalityScore = personalityScore;
		// 才德全尽
		if (personalityScore >= high && abilityScore >= high) {
			stu[m].level = 1;
		} else if (personalityScore >= high) { // 德胜才
			stu[m].level = 2;
		} else if (abilityScore >= high) {
			stu[m].level = 4;
		} else {
			// “才德兼亡”但尚有“德胜才”
			if (personalityScore >= abilityScore) {
				stu[m].level = 3;
			} else {
				stu[m].level = 4;
			}
		}
		m++;
	}

	// 排序
	sort(stu, stu + m, cmp);

	// 输出
	printf("%d\n", m);
	print(stu, m);
	return 0;
}

```

