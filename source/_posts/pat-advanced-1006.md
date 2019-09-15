---
title: PAT甲级 1006.Sign In and Sign Out （25 分)
date: 2019-04-11 21:31:52
tags: pat
categories: pat甲级
---

At the beginning of every day, the first person who signs in the computer room will unlock the door, and the last one who signs out will lock the door. Given the records of signing in's and out's, you are supposed to find the ones who have unlocked and locked the door on that day.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case contains the records for one day. The case starts with a positive integer *M*, which is the total number of records, followed by *M* lines, each in the format:

```
ID_number Sign_in_time Sign_out_time
```

where times are given in the format `HH:MM:SS`, and `ID_number` is a string with no more than 15 characters.

### Output Specification:

For each test case, output in one line the ID numbers of the persons who have unlocked and locked the door on that day. The two ID numbers must be separated by one space.

Note: It is guaranteed that the records are consistent. That is, the sign in time must be earlier than the sign out time for each person, and there are no two persons sign in or out at the same moment.

### Sample Input:

```in
3
CS301111 15:30:28 17:00:10
SC3021234 08:00:00 11:25:25
CS301133 21:45:00 21:58:40
```

### Sample Output:

```out
SC3021234 CS301133
```

### 分析：

题目要求：输出最早来的人和最晚走的人的id_number。

1.定义结构体类型Person，存储人的编号idNumber、第一次打卡（Sign in）时间signIn、第二次打卡（Sign out）时间signOut。

2.用unlock、lock分别表示开门和关门的人。

3.每当输入一个人的编号及其sign in和sign out时间，若其sign in比unlock早，则将其赋给unlock，若其sign out比lock晚，则将其赋给lock。

```c++
#include <cstdio>
#include <cstring>

struct Person {
	char idNumber[16];
	char signIn[9];
	char signOut[9];
};

int main() {
	int m;
	scanf("%d", &m);
	Person persons[m];
	Person unlock, lock;
	strcpy(unlock.signIn, "23:59:59");
	strcpy(lock.signOut, "00:00:00");
	for (int i = 0; i < m; i++) {
		scanf("%s %s %s", persons[i].idNumber, persons[i].signIn,
				persons[i].signOut);
		if (strcmp(unlock.signIn, persons[i].signIn) > 0) {
			unlock = persons[i];
		}
		if (strcmp(lock.signOut, persons[i].signOut) < 0) {
			lock = persons[i];
		}
	}
	printf("%s %s\n", unlock.idNumber, lock.idNumber);
	return 0;
}
```



