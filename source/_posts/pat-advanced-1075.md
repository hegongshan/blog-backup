---
title: PAT甲级 1075.PAT Judge (25 分)
date: 2019-06-28 16:25:19
tags: pat
categories: pat甲级
---

The ranklist of PAT is generated from the status list, which shows the scores of the submissions. This time you are supposed to generate the ranklist for PAT.

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line contains 3 positive integers, *N* (≤10^4), the total number of users, *K* (≤5), the total number of problems, and *M* (≤10^5), the total number of submissions. It is then assumed that the user id's are 5-digit numbers from 00001 to *N*, and the problem id's are from 1 to *K*. The next line contains *K* positive integers `p[i]` (`i`=1, ..., *K*), where `p[i]` corresponds to the full mark of the i-th problem. Then *M* lines follow, each gives the information of a submission in the following format:

```
user_id problem_id partial_score_obtained
```

where `partial_score_obtained` is either −1 if the submission cannot even pass the compiler, or is an integer in the range [0, `p[problem_id]`]. All the numbers in a line are separated by a space.

### Output Specification:

For each test case, you are supposed to output the ranklist in the following format:

```
rank user_id total_score s[1] ... s[K]
```

where `rank` is calculated according to the `total_score`, and all the users with the same `total_score` obtain the same `rank`; and `s[i]` is the partial score obtained for the `i`-th problem. If a user has never submitted a solution for a problem, then "-" must be printed at the corresponding position. If a user has submitted several solutions to solve one problem, then the highest score will be counted.

The ranklist must be printed in non-decreasing order of the ranks. For those who have the same rank, users must be sorted in nonincreasing order according to the number of perfectly solved problems. And if there is still a tie, then they must be printed in increasing order of their id's. For those who has never submitted any solution that can pass the compiler, or has never submitted any solution, they must NOT be shown on the ranklist. It is guaranteed that at least one user can be shown on the ranklist.

### Sample Input:

```in
7 4 20
20 25 25 30
00002 2 12
00007 4 17
00005 1 19
00007 2 25
00005 1 20
00002 2 2
00005 1 15
00001 1 18
00004 3 25
00002 2 25
00005 3 22
00006 4 -1
00001 2 18
00002 1 20
00004 1 15
00002 4 18
00001 3 4
00001 4 2
00005 2 -1
00004 2 0
```

### Sample Output:

```out
1 00002 63 20 25 - 18
2 00005 42 20 0 22 -
2 00007 42 - 25 - 17
2 00001 42 18 18 4 2
5 00004 40 15 0 25 -
```

### 分析：

**题目要求：**给定N个用户、K个题目的满分以及M次提交，其中每次提交包含用户的ID、题号及相应的得分。

每道题用户可能会提交多次，因此，只记录其最高得分。

然后，按照总分从高到低排序，若总分相同，则按照获得满分的题目个数从大到小排序；若前两者均相等，则按照用户ID从小到大排序，输出排序后的排名信息。

若某用户从未提交过代码，或者没有能通过编译的提交，则该用户不出现在最后的排名中。

**需要注意的地方：**

1.题目给出的`user_id`和`problem_id`均从1开始；

2.编译不通过时，`partial_score_obtained`给出的结果为-1，但得分为0；

3.用户每个题目的得分，只记录最高分；

4.计算用户获得满分的题目个数时，需要考虑到同一道题用户可能会多次获得满分；

5.若某题用户未提交过，则该题的得分为`-`；

6.若某用户从未提交过代码，或者没有能通过编译的提交，则该用户不需要输出。

**坑点：**用户id需要提前初始化，否则，无法通过最后一个测试点。

```c++
#include <cstdio>
#include <algorithm>
using namespace std;

typedef struct Node {
	int rank, id;
	int totalScore;
	// solve表示获得满分的题目个数
	int solve;
	// 数组的值，-2表示未提交，-1表示编译错误
	int s[5];
	// 是否参加排名
	bool status;
} User;

bool cmp(User a, User b) {
	if (a.totalScore != b.totalScore) {
		return a.totalScore > b.totalScore;
	}
	if (a.solve != b.solve) {
		return a.solve > b.solve;
	}
	return a.id < b.id;
}

int main() {
	int k, n, m;
	scanf("%d %d %d", &n, &k, &m);
	int p[k];
	for (int i = 0; i < k; i++) {
		scanf("%d", &p[i]);
	}

	User user[n];
	// 初始化
	for (int i = 0; i < n; i++) {
		user[i].id = i;
		user[i].rank = 0;
		user[i].totalScore = 0;
		user[i].solve = 0;
		for (int j = 0; j < k; j++) {
			// -2表示未提交
			user[i].s[j] = -2;
		}
		user[i].status = false;
	}

	int userId, problemId, score;
	for (int i = 0; i < m; i++) {
		scanf("%d %d %d", &userId, &problemId, &score);
		userId--;
		problemId--;

		user[userId].id = userId + 1;

		if (score > user[userId].s[problemId]) {
			// 当提交结果，编译通过时
			if (score >= 0) {
				// 计算用户的总分
				user[userId].totalScore += score;
				if (user[userId].s[problemId] > 0) {
					user[userId].totalScore -= user[userId].s[problemId];
				}
				// 至少有一次编译通过，则参加排名
				user[userId].status = true;
			}
			// 计算用户得满分的题目个数，score > user[userId].s[problemId]保证solve不会重复累加
			if (score == p[problemId]) {
				user[userId].solve++;
			}
			// 更新题目的最高得分
			user[userId].s[problemId] = score;
		}
	}

	// 排名
	sort(user, user + n, cmp);
	user[0].rank = 1;
	for (int i = 1; i < n; i++) {
		if (user[i].totalScore == user[i - 1].totalScore) {
			user[i].rank = user[i - 1].rank;
		} else {
			user[i].rank = i + 1;
		}
	}

	for (int i = 0; i < n && user[i].status; i++) {
		printf("%d %05d %d", user[i].rank, user[i].id, user[i].totalScore);
		for (int j = 0; j < k; j++) {
			// 该题未提交
			if (user[i].s[j] == -2) {
				printf(" -");
			} else if (user[i].s[j] == -1) { // 提交过，但编译错误
				printf(" 0");
			} else {
				printf(" %d", user[i].s[j]);
			}
		}
		printf("\n");
	}
	return 0;
}
```

