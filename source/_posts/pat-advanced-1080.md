---
title: PAT甲级 1080.Graduate Admission (30 分)
date: 2019-06-30 11:59:55
tags: pat
categories: pat甲级
mathjax: true
---

It is said that in 2011, there are about 100 graduate schools ready to proceed over 40,000 applications in Zhejiang Province. It would help a lot if you could write a program to automate the admission procedure.

Each applicant will have to provide two grades: the national entrance exam grade $G_E​$, and the interview grade $G_I​$. The final grade of an applicant is ($G_E​$+$G_I​$)/2. The admission rules are:

- The applicants are ranked according to their final grades, and will be admitted one by one from the top of the rank list.
- If there is a tied final grade, the applicants will be ranked according to their national entrance exam grade $G_E​$. If still tied, their ranks must be the same.
- Each applicant may have *K* choices and the admission will be done according to his/her choices: if according to the rank list, it is one's turn to be admitted; and if the quota of one's most preferred shcool is not exceeded, then one will be admitted to this school, or one's other choices will be considered one by one in order. If one gets rejected by all of preferred schools, then this unfortunate applicant will be rejected.
- If there is a tied rank, and if the corresponding applicants are applying to the same school, then that school must admit all the applicants with the same rank, **even if its quota will be exceeded**.

<!--more-->

### Input Specification:

Each input file contains one test case.

Each case starts with a line containing three positive integers: *N* (≤40,000), the total number of applicants; *M* (≤100), the total number of graduate schools; and *K* (≤5), the number of choices an applicant may have.

In the next line, separated by a space, there are *M* positive integers. The *i*-th integer is the quota of the *i*-th graduate school respectively.

Then *N* lines follow, each contains 2+*K* integers separated by a space. The first 2 integers are the applicant's $G_E​$ and $G_I​$, respectively. The next *K* integers represent the preferred schools. For the sake of simplicity, we assume that the schools are numbered from 0 to *M*−1, and the applicants are numbered from 0 to *N*−1.

### Output Specification:

For each test case you should output the admission results for all the graduate schools. The results of each school must occupy a line, which contains the applicants' numbers that school admits. The numbers must be in increasing order and be separated by a space. There must be no extra space at the end of each line. If no applicant is admitted by a school, you must output an empty line correspondingly.

### Sample Input:

```in
11 6 3
2 1 2 2 2 3
100 100 0 1 2
60 60 2 3 5
100 90 0 3 4
90 100 1 2 0
90 90 5 1 3
80 90 1 0 2
80 80 0 1 2
80 80 0 1 2
80 70 1 3 2
70 80 1 2 3
100 100 0 2 4
```

### Sample Output:

```out
0 10
3
5 6 7
2 8

1 4
```

### 分析：

**题目要求：**给定N个考生、M个学校，每个考生可以填报K个学校。

每个考生的成绩由两部分组成：国家入学考试成绩$G_E$和面试成绩$G_I$，最终成绩为($G_E$+$G_I$)/2。

按照他们的最终成绩从高到低排序，依次进入录取程序。

若最终成绩相同，则按照$G_E$从高到低排序。若$G_E$也相同，则排名相同。

若考生当前志愿学校尚未招满，则考生被录取。否则，依次考虑其他志愿。此外，若当前考生与该校上一个录取的学生排名相同，即使招生计划已满，考生也会被录取。

最后，输出各校的录取名单，各校录取名单按照学生编号从小到大排序。若某校未录取任何考生，则输出空行。

```c++
#include <cstdio>
#include <vector>
#include <algorithm>
using namespace std;

typedef struct Node {
	int id, rank;
	// 成绩
	int gExam, gInterview, gFinal;
	// 报考院校
	int preferred[5];
} Applicant;

typedef struct Node2 {
	// 计划招生数
	int quota;
	// 上一次录取的学生下标
	int last;
	// 录取名单（学生的编号）
	vector<int> admission;
} School;

bool cmp(Applicant a, Applicant b) {
	if (a.gFinal != b.gFinal) {
		return a.gFinal > b.gFinal;
	}
	return a.gExam > b.gExam;
}

int main() {
	int n, m, k;
	scanf("%d %d %d", &n, &m, &k);
	Applicant applicant[n];
	School schools[m];
	for (int i = 0; i < m; i++) {
		scanf("%d", &schools[i].quota);
		schools[i].last = -1;
	}

	for (int i = 0; i < n; i++) {
		applicant[i].id = i;
		scanf("%d %d", &applicant[i].gExam, &applicant[i].gInterview);
		applicant[i].gFinal = (applicant[i].gExam + applicant[i].gInterview) / 2;
		for (int j = 0; j < k; j++) {
			scanf("%d", &applicant[i].preferred[j]);
		}
	}

	// 排名
	sort(applicant, applicant + n, cmp);
	applicant[0].rank = 1;
	for (int i = 1; i < n; i++) {
		if (applicant[i].gFinal == applicant[i - 1].gFinal
				&& applicant[i].gExam == applicant[i - 1].gExam) {
			applicant[i].rank = applicant[i - 1].rank;
		} else {
			applicant[i].rank = i + 1;
		}
	}
	
	// 录取过程
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < k; j++) {
			int index = applicant[i].preferred[j];
			int last = schools[index].last;
			int size = schools[index].admission.size();

			// 若尚未招满，或者当前学生与上一个录取的学生排名相同
			if (schools[index].quota > size
					|| (last != -1 && applicant[last].rank == applicant[i].rank)) {
				schools[index].admission.push_back(applicant[i].id);
				schools[index].last = i;
				break;
			}
		}
	}
	// 输出录取结果
	for (int i = 0; i < m; i++) {
		int size = schools[i].admission.size();
		if (size > 0) {
			sort(schools[i].admission.begin(), schools[i].admission.end());
			for (int j = 0; j < size; j++) {
				if (j > 0) {
					printf(" ");
				}
				printf("%d", schools[i].admission[j]);
			}
		}
		printf("\n");
	}
	return 0;
}
```

