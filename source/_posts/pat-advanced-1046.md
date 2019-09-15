---
title: PAT甲级 1046.Shortest Distance （20 分)
date: 2019-04-05 21:29:22
tags: pat
categories: pat甲级
---

The task is really simple: given *N* exits on a highway which forms a simple cycle, you are supposed to tell the shortest distance between any pair of exits.

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line contains an integer *N* (in [3,105]), followed by *N* integer distances *D*1 *D*2 ⋯ DN, where Di is the distance between the *i*-th and the (*i*+1)-st exits, and DN is between the *N*-th and the 1st exits. All the numbers in a line are separated by a space. The second line gives a positive integer *M* (≤104), with *M* lines follow, each contains a pair of exits numbers, provided that the exits are numbered from 1 to *N*. It is guaranteed that the total round trip distance is no more than 107.

### Output Specification:

For each test case, print your results in *M* lines, each contains the shortest distance between the corresponding given pair of exits.

### Sample Input:

```in
5 1 2 4 14 9
3
1 3
2 5
4 1
```

### Sample Output:

```out
3
10
7
```

### 分析：

声明一个数组distances，`distances[i]`存储从第一个结点，沿顺时针方向，到第i个结点的距离。

使用sum表示所有结点形成的环的总长度。

计算结点start和end之间的最短距离时，只需比较shortestDistance = distances[end]-distances[start]和sum-shortestDistance，取两者中的较小者即可。

需要注意的是，输入的start不一定比end小，故在计算最短距离前，让start为较小结点编号，end为较大结点的编号。

```c++
#include <cstdio>

int main() {
	int n, m;
	scanf("%d", &n);
	// 存储从第一个结点，沿顺时针方向，到第i个结点的距离
	// i=0这个位置空置不用
	int distances[n+1];
	int sum = 0, temp;
	for (int i = 1; i <= n; i++) {
		scanf("%d", &temp);
		distances[i] = sum;
		sum += temp;
	}
	int start, end;
	int shortestDistance;
	scanf("%d", &m);
	while (m--) {
		scanf("%d %d", &start, &end);
		if (start > end) {
			temp = start;
			start = end;
			end = temp;
		}
		shortestDistance = distances[end] - distances[start];
		// 若 shorestDistance > totalDistance - shorestDistance
		if (sum < 2 * shortestDistance) {
			shortestDistance = sum - shortestDistance;
		}
		printf("%d\n", shortestDistance);
	}
	return 0;
}
```

