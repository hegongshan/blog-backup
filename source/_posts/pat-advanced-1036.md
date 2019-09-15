---
title: PAT甲级 1036.Boys vs Girls （25 分)
date: 2019-04-12 18:20:57
tags: pat
categories: pat甲级
mathjax: true
---

This time you are asked to tell the difference between the lowest grade of all the male students and the highest grade of all the female students.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case contains a positive integer *N*, followed by *N* lines of student information. Each line contains a student's `name`, `gender`, `ID` and `grade`, separated by a space, where `name` and `ID` are strings of no more than 10 characters with no space, `gender` is either `F` (female) or `M` (male), and `grade`is an integer between 0 and 100. It is guaranteed that all the grades are distinct.

### Output Specification:

For each test case, output in 3 lines. The first line gives the name and ID of the female student with the highest grade, and the second line gives that of the male student with the lowest grade. The third line gives the difference $grade_F−grade_M$. If one such kind of student is missing, output `Absent` in the corresponding line, and output `NA`in the third line instead.

### Sample Input 1:

```in
3
Joe M Math990112 89
Mike M CS991301 100
Mary F EE990830 95
```

### Sample Output 1:

```out
Mary EE990830
Joe Math990112
6
```

### Sample Input 2:

```in
1
Jean M AA980920 60
```

### Sample Output 2:

```out
Absent
Jean AA980920
NA
```

### 分析：

1.定义结构体类型Person，包含学生姓名name、性别gender、学号id以及成绩grade。

2.用boy、girl分别表示分数最低的男生、分数最高的女生。并为他们的成绩grade字段初始化，boy的成绩grade赋值为101，girl的成绩grade赋值-1。用person接受每次输入的信息。

3.若当前person为男性、且成绩低于boy，则将其赋给boy。若当前person为女性，且成绩高于girl，则将其赋给girl。

4.在输出前，需要分别判断boy.grade == 101、girl.grade == -1 是否成立。若成立，则表示不存在该性别的同学，对应行要输出“Absent”。以上两个条件只要有一个成立，最后girl与boy的分数差就输出“NA”。

```c++
#include <cstdio>

struct Person {
	char name[11];
	char gender;
	char id[11];
	int grade;
};

int main() {
	int n;
	scanf("%d", &n);
	//boy表示分数最低的男学生、girl表示分数最高的女学生
	Person boy, girl, person;
	boy.grade = 101;
	girl.grade = -1;
	for (int i = 0; i < n; i++) {
		scanf("%s %c %s %d", person.name, &person.gender, person.id,
				&person.grade);
		if (person.gender == 'M' && person.grade < boy.grade) {
			boy = person;
		}
		if (person.gender == 'F' && person.grade > girl.grade) {
			girl = person;
		}
	}
	bool isMissing = false;
	if (girl.grade == -1) {
		isMissing = true;
		printf("Absent\n");
	} else {
		printf("%s %s\n", girl.name, girl.id);
	}
	if (boy.grade == 101) {
		isMissing = true;
		printf("Absent\n");
	} else {
		printf("%s %s\n", boy.name, boy.id);
	}
	if (isMissing) {
		printf("NA\n");
	} else {
		printf("%d\n", girl.grade - boy.grade);
	}
	return 0;
}
```

