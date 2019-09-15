---
title: PAT甲级 1083.List Grades (25 分)
date: 2019-06-28 17:22:00
tags: pat
categories: pat甲级
---

Given a list of *N* student records with name, ID and grade. You are supposed to sort the records with respect to the grade in non-increasing order, and output those student records of which the grades are in a given interval.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case is given in the following format:

```
N
name[1] ID[1] grade[1]
name[2] ID[2] grade[2]
... ...
name[N] ID[N] grade[N]
grade1 grade2
```

where `name[i]` and `ID[i]` are strings of no more than 10 characters with no space, `grade[i]` is an integer in [0, 100], `grade1` and `grade2` are the boundaries of the grade's interval. It is guaranteed that all the grades are **distinct**.

### Output Specification:

For each test case you should output the student records of which the grades are in the given interval [`grade1`, `grade2`] and are in non-increasing order. Each student record occupies a line with the student's name and ID, separated by one space. If there is no student's grade in that interval, output `NONE` instead.

### Sample Input 1:

```in
4
Tom CS000001 59
Joe Math990112 89
Mike CS991301 100
Mary EE990830 95
60 100
```

### Sample Output 1:

```out
Mike CS991301
Mary EE990830
Joe Math990112
```

### Sample Input 2:

```in
2
Jean AA980920 60
Ann CS01 80
90 95
```

### Sample Output 2:

```out
NONE
```

### 分析：

**题目要求：**给定N个学生的姓名name、ID和成绩grade，以及成绩范围[grade1,grade2]。

先按照成绩从高到低排序，然后输出成绩在[grade1,grade2]内的学生的姓名和ID。

若没有一个学生的成绩在给定的范围内，则输出`NONE`。		

```c++
#include <cstdio>
#include <algorithm>
using namespace std;

typedef struct Node {
	char name[11], id[11];
	int grade;
} Student;

bool cmp(Student a, Student b) {
	return a.grade > b.grade;
}

int main() {
	int n, low, high;

	scanf("%d", &n);
	Student stu[n];
	for (int i = 0; i < n; i++) {
		scanf("%s %s %d", stu[i].name, stu[i].id, &stu[i].grade);
	}
	scanf("%d %d", &low, &high);

	sort(stu, stu + n, cmp);

	// 是否存在满足条件的学生
	bool exist = false;
	for (int i = 0; i < n; i++) {
		if (low <= stu[i].grade && stu[i].grade <= high) {
			printf("%s %s\n", stu[i].name, stu[i].id);
			exist = true;
		}
	}
	if (!exist) {
		printf("NONE\n");
	}
	return 0;
}
```

