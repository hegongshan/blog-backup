---
title: PAT乙级 1004.成绩排名 （20 分)
date: 2019-04-10 17:31:10
tags: pat
categories: pat乙级
---

读入 *n*（>0）名学生的姓名、学号、成绩，分别输出成绩最高和成绩最低学生的姓名和学号。

<!--more-->

### 输入格式：

每个测试输入包含 1 个测试用例，格式为

```
第 1 行：正整数 n
第 2 行：第 1 个学生的姓名 学号 成绩
第 3 行：第 2 个学生的姓名 学号 成绩
  ... ... ...
第 n+1 行：第 n 个学生的姓名 学号 成绩
```

其中`姓名`和`学号`均为不超过 10 个字符的字符串，成绩为 0 到 100 之间的一个整数，这里保证在一组测试用例中没有两个学生的成绩是相同的。

### 输出格式：

对每个测试用例输出 2 行，第 1 行是成绩最高学生的姓名和学号，第 2 行是成绩最低学生的姓名和学号，字符串间有 1 空格。

### 输入样例：

```in
3
Joe Math990112 89
Mike CS991301 100
Mary EE990830 95
```

### 输出样例：

```out
Mike CS991301
Joe Math990112
```

### 分析：

1.定义一个结构体类型Student，存储学生的姓名name、学号no和成绩grade。

2.定义两个Student型变量maxGradeStu、minGradeStu分别表示成绩最高、最低的学生，并为maxGradeStu和minGradeStu的成绩grade初始化，分别设为101和0。

3.每读入一个学生信息，就将其成绩grade与maxGradeStu、minGradeStu的成绩比较，若高于maxGradeStu，则将该学生信息赋给maxGradeStu，若低于minGradeStu，则将该学生赋给minGradeStu。

```c++
#include <cstdio>

struct Student {
	char name[11];
	char no[11];
	int grade;
};

int main() {
	int n;
	scanf("%d", &n);
	Student stu[n];
	Student maxGradeStu, minGradeStu;
	maxGradeStu.grade = 0;
	minGradeStu.grade = 101;
	for (int i = 0; i < n; i++) {
		scanf("%s %s %d", stu[i].name, stu[i].no, &stu[i].grade);
		if (maxGradeStu.grade < stu[i].grade) {
			maxGradeStu = stu[i];
		}
		if (minGradeStu.grade > stu[i].grade) {
			minGradeStu = stu[i];
		}
	}
	printf("%s %s\n", maxGradeStu.name, maxGradeStu.no);
	printf("%s %s\n", minGradeStu.name, minGradeStu.no);
	return 0;
}
```

