---
title: PAT甲级 1031.Hello World for U （20 分)
date: 2019-04-15 10:23:00
tags: pat
categories: pat甲级
---

Given any string of *N* (≥5) characters, you are asked to form the characters into the shape of `U`. For example, `helloworld` can be printed as:

```
h  d
e  l
l  r
lowo
```

That is, the characters must be printed in the original order, starting top-down from the left vertical line with *n*1characters, then left to right along the bottom line with *n*2 characters, and finally bottom-up along the vertical line with *n*3 characters. And more, we would like `U` to be as squared as possible -- that is, it must be satisfied that n1=n3=max { *k* | *k*≤n2 for all 3≤n2≤*N* } with n1+n2+n3−2=N.

<!--more-->

### Input Specification:

Each input file contains one test case. Each case contains one string with no less than 5 and no more than 80 characters in a line. The string contains no white space.

### Output Specification:

For each test case, print the input string in the shape of U as specified in the description.

### Sample Input:

```in
helloworld!
```

### Sample Output:

```out
h   !
e   d
l   l
lowor
```

### 分析：

**题目要求：**将输入的字符串以U型图案的方式输出。n1和n3分别是U型图案左右两条竖线的字符数，n2是底部横线的字符数。

**约束条件：**

1.n1=n3

2.n1≤n2

3.U型图案尽可能方，即n1在满足上述条件的情况下尽可能大

**思路：**字符串长度n=n1+n2+n3-2，从而2×n1+n2=n+2，下面分情况讨论：

1.若(n+2) % 3 == 0，即n+2刚好被3整除，此时n1=n2=n3；

2.若(n+2) % 3 == 1，由于n1=n3且n1≤n2，故n1=n2=(n+2) / 3，n2=(n+2) / 3 + 1；

3.若(n+2) % 3 == 2，故n1=n2=(n+2) / 3，n2=(n+2) / 3 + 2。

因此，n1=n3=(n+2) / 3，n2 = (n+2) / 3 + (n+2) % 3。

```c++
#include <cstdio>
#include <cstring>

int main() {
	char str[81];
	scanf("%s", str);
	int n = strlen(str);
	int n1, n2, n3;
	n1 = n3 = (n + 2) / 3;
	n2 = (n + 2) / 3 + (n + 2) % 3;
    //输出U型图案的左右两侧(不包括属于底部横线的部分)
	for (int i = 0; i < n1 - 1; i++) {
		printf("%c", str[i]);
		for (int j = 0; j < n2 - 2; j++) {
			printf(" ");
		}
		printf("%c\n", str[n - i - 1]);
	}
    //输出底部的横线
	for (int i = 0; i < n2; i++) {
		printf("%c", str[n1 + i - 1]);
	}
	printf("\n");
	return 0;
}
```



