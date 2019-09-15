---
title: PAT乙级 1028.人口普查 （20 分)
date: 2019-04-10 18:26:36
tags: pat
categories: pat乙级
---

某城镇进行人口普查，得到了全体居民的生日。现请你写个程序，找出镇上最年长和最年轻的人。

这里确保每个输入的日期都是合法的，但不一定是合理的——假设已知镇上没有超过 200 岁的老人，而今天是 2014 年 9 月 6 日，所以超过 200 岁的生日和未出生的生日都是不合理的，应该被过滤掉。

<!--more-->

### 输入格式：

输入在第一行给出正整数 *N*，取值在(0,10^5]；随后 *N* 行，每行给出 1 个人的姓名（由不超过 5 个英文字母组成的字符串）、以及按 `yyyy/mm/dd`（即年/月/日）格式给出的生日。题目保证最年长和最年轻的人没有并列。

### 输出格式：

在一行中顺序输出有效生日的个数、最年长人和最年轻人的姓名，其间以空格分隔。

### 输入样例：

```in
5
John 2001/05/12
Tom 1814/09/06
Ann 2121/01/30
James 1814/09/05
Steve 1967/11/20
```

### 输出样例：

```out
3 Tom John
```

### 分析：

1.定义结构体类型Person，存储人的姓名name、出生年year、月month、日day。

2.设定年龄的左右边界，用maxPerson表示具有合理的最大年龄（1814年9月6日）的人，current表示具有合理的最小年龄（2014年9月6日）的人。用youngest表示镇上最年轻的人，oldest表示镇上最年长者，并对他们初始化，分别赋值为maxPerson和current。用count表示输入有效生日的个数。

3.每当读入一个人的信息时，需要先判断其年龄是否合理（不小于current的年龄，且不超过maxPerson的年龄）。若合理，则将其年龄分别与youngest、oldest的年龄比较。若其年龄比youngest小，则将其赋给youngest。若其年龄比oldest大，则将其赋给oldest。然后count增加1。

需要注意的是，最终得到的count有可能为0，即输入的测试用例均为无效生日，此时count后没有空格，否则会因为多出一个空格而报“格式错误”。

```c++
#include <cstdio>

struct Person {
	char name[6];
	int year;
	int month;
	int day;
};
//若p1比p2的年龄大，则返回1；若一样大，返回0；否则，返回-1；
int old(Person p1, Person p2) {
	if (p1.year < p2.year) {
		return 1;
	}
	if (p1.year == p2.year) {
		if (p1.month < p2.month) {
			return 1;
		}
		if (p1.month == p2.month) {
			if (p1.day < p2.day) {
				return 1;
			}
			if (p1.day == p2.day) {
				return 0;
			}
		}
	}
	return -1;
}

int main() {
	int n;
	int currentYear = 2014, currentMonth = 9, currentDay = 6, maxAge = 200;
	scanf("%d", &n);
	Person youngest, oldest, current, maxPerson;
	maxPerson.year = currentYear - maxAge;
	maxPerson.month = currentMonth;
	maxPerson.day = currentDay;
	current.year = currentYear;
	current.month = currentMonth;
	current.day = currentDay;
	oldest = current;
	youngest = maxPerson;
	Person person[n];
	int count = 0;
	for (int i = 0; i < n; i++) {
		scanf("%s %d/%d/%d", person[i].name, &person[i].year, &person[i].month,
				&person[i].day);
		if (old(person[i], current) >= 0 && old(maxPerson, person[i]) >= 0) {
			if (old(person[i], oldest) == 1) {
				oldest = person[i];
			}
			if (old(youngest, person[i]) == 1) {
				youngest = person[i];
			}
			count++;
		}
	}
	printf("%d", count);
	if (count > 0) {
		printf(" %s %s", oldest.name, youngest.name);
	}
	printf("\n");
	return 0;
}
```

