---
title: PAT甲级 1025.PAT Ranking (25 分)
date: 2019-05-23 13:42:39
tags: pat
categories: pat甲级
---

Programming Ability Test (PAT) is organized by the College of Computer Science and Technology of Zhejiang University. Each test is supposed to run simultaneously in several places, and the ranklists will be merged immediately after the test. Now it is your job to write a program to correctly merge all the ranklists and generate the final rank.

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line contains a positive number *N* (≤100), the number of test locations. Then *N* ranklists follow, each starts with a line containing a positive integer *K* (≤300), the number of testees, and then *K* lines containing the registration number (a 13-digit number) and the total score of each testee. All the numbers in a line are separated by a space.

### Output Specification:

For each test case, first print in one line the total number of testees. Then print the final ranklist in the following format:

```
registration_number final_rank location_number local_rank
```

The locations are numbered from 1 to *N*. The output must be sorted in nondecreasing order of the final ranks. The testees with the same score must have the same rank, and the output must be sorted in nondecreasing order of their registration numbers.

### Sample Input:

```in
2
5
1234567890001 95
1234567890005 100
1234567890003 95
1234567890002 77
1234567890004 85
4
1234567890013 65
1234567890011 25
1234567890014 100
1234567890012 85
```

### Sample Output:

```out
9
1234567890005 1 1 1
1234567890014 1 2 1
1234567890001 3 1 2
1234567890003 3 1 2
1234567890004 5 1 4
1234567890012 5 2 2
1234567890002 7 1 5
1234567890013 8 2 3
1234567890011 9 2 4
```

### 分析：

**题目要求：**已知有N个考场，每个考场有若干个考生，给定每个考场中考生的准考证号和分数，要求计算排名。按照总排名的先后顺序，输出每个考生的准考证号、总排名、考场号以及考场内排名。

**思路：**先进行考场内排名，然后再进行总排名。分数相同的情况下，按照准考证号从小到大的顺序排列，但其排名是相同的。

```c++
#include <cstdio>
#include <cstring>
#include <algorithm>
using namespace std;

struct Testee {
	char registrationNumber[14];
	int finalRank;
	int locationNumber;
	int localRank;
	int score;
};
// 按照分数降序排序，若分数相同，则按照准考证号从小到大排序
bool cmp(Testee a, Testee b) {
	if (a.score != b.score) {
		return a.score > b.score;
	}
	return strcmp(a.registrationNumber, b.registrationNumber) < 0;
}

int main() {
	int n, k, num = 0;
	scanf("%d", &n);
	// max(n) * max(k) = 100 * 300
	struct Testee testees[30000];
	for (int i = 1; i <= n; i++) {
		scanf("%d", &k);
		// 1.输入考生的准考证号和分数
		for (int j = 0; j < k; j++) {
			Testee testee;
			scanf("%s %d", testee.registrationNumber, &testee.score);
			testee.locationNumber = i;
			testees[num++] = testee;
		}
		// 2.计算考场内排名
		sort(testees + num - k, testees + num, cmp);
		for (int j = num - k; j < num; j++) {
			if (j == num - k) {
				testees[j].localRank = 1;
			} else {
				if (testees[j].score == testees[j - 1].score) {
					testees[j].localRank = testees[j - 1].localRank;
				} else {
					testees[j].localRank = j - (num - k) + 1;
				}
			}
		}
	}
	// 3.计算总排名
	sort(testees, testees + num, cmp);
	printf("%d\n", num);
	for (int j = 0; j < num; j++) {
		if (j == 0) {
			testees[j].finalRank = 1;
		} else {
			if (testees[j].score == testees[j - 1].score) {
				testees[j].finalRank = testees[j - 1].finalRank;
			} else {
				testees[j].finalRank = j + 1;
			}
		}
		printf("%s %d %d %d\n", testees[j].registrationNumber,
				testees[j].finalRank, testees[j].locationNumber,
				testees[j].localRank);
	}
	return 0;
}
```



