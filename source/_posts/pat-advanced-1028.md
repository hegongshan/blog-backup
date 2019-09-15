---
title: PAT甲级 1028.List Sorting (25 分)
date: 2019-06-24 17:08:03
tags: pat
categories: pat甲级
mathjax: true
---

Excel can sort records according to any column. Now you are supposed to imitate this function.

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line contains two integers *N* (≤$10^5$) and *C*, where *N* is the number of records and *C* is the column that you are supposed to sort the records with. Then *N* lines follow, each contains a record of a student. A student's record consists of his or her distinct ID (a 6-digit number), name (a string with no more than 8 characters without space), and grade (an integer between 0 and 100, inclusive).

### Output Specification:

For each test case, output the sorting result in *N* lines. That is, if *C* = 1 then the records must be sorted in increasing order according to ID's; if *C*= 2 then the records must be sorted in non-decreasing order according to names; and if *C* = 3 then the records must be sorted in non-decreasing order according to grades. If there are several students who have the same name or grade, they must be sorted according to their ID's in increasing order.

### Sample Input 1:

```in
3 1
000007 James 85
000010 Amy 90
000001 Zoe 60
```

### Sample Output 1:

```out
000001 Zoe 60
000007 James 85
000010 Amy 90
```

### Sample Input 2:

```in
4 2
000007 James 85
000010 Amy 90
000001 Zoe 60
000002 James 98
```

### Sample Output 2:

```out
000010 Amy 90
000002 James 98
000007 James 85
000001 Zoe 60
```

### Sample Input 3:

```in
4 3
000007 James 85
000010 Amy 90
000001 Zoe 60
000002 James 90
```

### Sample Output 3:

```out
000001 Zoe 60
000007 James 85
000002 James 90
000010 Amy 90
```

### 分析：

**题目要求：**给定N个学生的ID、姓名和成绩，根据给定的参数C，进行不同的排序，输出排序后的结果。

当C==1时，按照ID从小到大排序；

当C==2时，按照姓名字典序从小到大排序；若姓名相同，则按照ID从小到大排序；

当C==3时，按照成绩从低到高排序；若成绩相同，则按照ID从小到大排序。

```c++
#include <cstdio>
#include <cstring>
#include <algorithm>
using namespace std;

struct Student {
	char id[7];
	char name[9];
	int grade;
};
int c = 0;
bool cmp(struct Student a, struct Student b) {
	if (c == 1) {
		return strcmp(a.id, b.id) < 0;
	}
	if (c == 2) {
		int s = strcmp(a.name, b.name);
		if (s == 0) {
			return strcmp(a.id, b.id) < 0;
		}
		return s < 0;
	}
	if (a.grade == b.grade) {
		return strcmp(a.id, b.id) < 0;
	}
	return a.grade < b.grade;
}

int main() {
	int n;
	scanf("%d %d", &n, &c);
	struct Student stu[n];
	for (int i = 0; i < n; i++) {
		scanf("%s %s %d", stu[i].id, stu[i].name, &stu[i].grade);
	}
	sort(stu, stu + n, cmp);
	for (int i = 0; i < n; i++) {
		printf("%s %s %d\n", stu[i].id, stu[i].name, stu[i].grade);
	}
	return 0;
}
```

