---
title: PAT甲级 1012.The Best Rank (25 分)
date: 2019-06-20 16:25:35
tags: pat
categories: pat甲级
---

To evaluate the performance of our first year CS majored students, we consider their grades of three courses only: `C` - C Programming Language, `M` - Mathematics (Calculus or Linear Algrbra), and `E` - English. At the mean time, we encourage students by emphasizing on their best ranks -- that is, among the four ranks with respect to the three courses and the average grade, we print the best rank for each student.

For example, The grades of `C`, `M`, `E` and `A` - Average of 4 students are given as the following:

```
StudentID  C  M  E  A
310101     98 85 88 90
310102     70 95 88 84
310103     82 87 94 88
310104     91 91 91 91
```

Then the best ranks for all the students are No.1 since the 1st one has done the best in C Programming Language, while the 2nd one in Mathematics, the 3rd one in English, and the last one in average.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case starts with a line containing 2 numbers *N* and *M* (≤2000), which are the total number of students, and the number of students who would check their ranks, respectively. Then *N* lines follow, each contains a student ID which is a string of 6 digits, followed by the three integer grades (in the range of [0, 100]) of that student in the order of `C`, `M` and `E`. Then there are *M* lines, each containing a student ID.

### Output Specification:

For each of the *M* students, print in one line the best rank for him/her, and the symbol of the corresponding rank, separated by a space.

The priorities of the ranking methods are ordered as `A` > `C` > `M` > `E`. Hence if there are two or more ways for a student to obtain the same best rank, output the one with the highest priority.

If a student is not on the grading list, simply output `N/A`.

### Sample Input:

```in
5 6
310101 98 85 88
310102 70 95 88
310103 82 87 94
310104 91 91 91
310105 85 90 90
310101
310102
310103
310104
310105
999999
```

### Sample Output:

```out
1 C
1 M
1 E
1 A
3 A
N/A
```

### 分析：

**题目要求：**给定N个学生，及其C语言（C）、数学（M）、英语（E）三门课的成绩，对包括平均分（A）在内的四个成绩分别进行排名。

给定M个学生的id，求他们的最好排名及对应的课程（或者平均分）

当有多个科目取得相同的最好排名时，按照`A` > `C` > `M` > `E`的顺序，输出其中优先级最大的课程。

若学生id不存在，则输出`N/A`。

**需要注意的地方：**1.平均分要四舍五入；2.若分数相同，则排名并列。

```c++
#include <cstdio>
#include <algorithm>
using namespace std;

struct Student {
	int id;
	// 0-A,1-C,2-M,3-E
	int score[4];
	int rank[4];
	int best;
};

int flag = 0;
// 快速判断id是否存在
int exists[1000000];
char course[5] = { 'A', 'C', 'M', 'E' };

bool cmp(struct Student s1, struct Student s2) {
	return s1.score[flag] > s2.score[flag];
}

int main() {
	int n, m, id;
	scanf("%d %d", &n, &m);
	struct Student stu[n];
	// 输入
	for (int i = 0; i < n; i++) {
		scanf("%d", &stu[i].id);
		int sum = 0;
		for (int j = 1; j <= 3; j++) {
			scanf("%d", &stu[i].score[j]);
			sum += stu[i].score[j];
		}
		// 平均成绩四舍五入
		stu[i].score[0] = sum / 3.0 + 0.5;
	}

	// 按照不同的科目分别排序
	for (flag = 0; flag < 4; flag++) {
		sort(stu, stu + n, cmp);
		stu[0].rank[flag] = 1;
		for (int j = 1; j < n; j++) {
			stu[j].rank[flag] = j + 1;
			// 若分数相同，则排名并列
			if (stu[j].score[flag] == stu[j - 1].score[flag]) {
				stu[j].rank[flag] = stu[j - 1].rank[flag];
			}
		}
	}
	// 计算最佳排名
	for (int i = 0; i < n; i++) {
		exists[stu[i].id] = i + 1;
		int rank = n + 1;
		for (int j = 0; j < 4; j++) {
			if (stu[i].rank[j] < rank) {
				rank = stu[i].rank[j];
				stu[i].best = j;
			}
		}
	}

	for (int i = 0; i < m; i++) {
		scanf("%d", &id);
		int index = exists[id];
		if (index) {
			index -= 1;
			int best = stu[index].best;
			printf("%d %c\n", stu[index].rank[best], course[best]);
		} else {
			printf("N/A\n");
		}
	}
	return 0;
}
```

