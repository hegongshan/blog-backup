---
title: PAT甲级 1048.Find Coins (25 分)
date: 2019-07-17 19:42:04
tags: pat
categories: pat甲级
---

Eva loves to collect coins from all over the universe, including some other planets like Mars. One day she visited a universal shopping mall which could accept all kinds of coins as payments. However, there was a special requirement of the payment: for each bill, she could only use exactly two coins to pay the exact amount. Since she has as many as 105 coins with her, she definitely needs your help. You are supposed to tell her, for any given amount of money, whether or not she can find two coins to pay for it.

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line contains 2 positive numbers: *N* (≤10^5, the total number of coins) and *M* (≤10^3, the amount of money Eva has to pay). The second line contains *N* face values of the coins, which are all positive numbers no more than 500. All the numbers in a line are separated by a space.

### Output Specification:

For each test case, print in one line the two face values *V*1 and *V*2 (separated by a space) such that *V*1+*V*2=*M* and *V*1≤*V*2. If such a solution is not unique, output the one with the smallest *V*1. If there is no solution, output `No Solution` instead.

### Sample Input 1:

```in
8 15
1 2 8 7 2 4 11 15
```

### Sample Output 1:

```out
4 11
```

### Sample Input 2:

```in
7 14
1 8 7 2 4 11 15
```

### Sample Output 2:

```out
No Solution
```

### 分析：

**题目要求：**给定N个硬币（每个硬币的面值不超过500），和一个金额M。从N个硬币中选出两个，使得两者的和等于M。然后，按照面值从小到大的顺序，输出这两个硬币的金额V1、V2（V1≤V2）。

若存在多组硬币满足要求，则输出V1最小的那组值。若不存在这样的两个硬币，则输出`No Solution`。

**思路：**本题考察**哈希表和排序**的简单应用。

使用数组hash表示哈希表，下标表示硬币的面值，对应的值表示该面值出现的次数，初始值为0。

将输入的N个硬币的存在数组arr中。

首先，遍历数组arr，统计出各面值硬币出现的次数。

由于题目要求按照从小到大的顺序输出，因此，需要对数组arr进行升序排序。

接着，再次遍历arr，若`m - arr[i] >=0 && m-arr[i] <= 500 && hash[m - arr[i]] > 0`成立，

则接着判断`m == arr[i] * 2 && hash[arr[i]] < 2`是否成立，

若成立，则继续下一轮循环；否则，表示已经找到这样两个硬币。

```c++
#include <cstdio>
#include <algorithm>
using namespace std;

int main() {
	int n, m;
	scanf("%d %d", &n, &m);

	int hash[501] = { 0 };
	int arr[n];
	for (int i = 0; i < n; i++) {
		scanf("%d", &arr[i]);
		hash[arr[i]]++;
	}

	sort(arr, arr + n);
	for (int i = 0; i < n; i++) {
		if (m - arr[i] >= 0 && m - arr[i] <= 500 && hash[m - arr[i]] > 0) {
			if (2 * arr[i] == m && hash[arr[i]] < 2) {
				continue;
			}
			printf("%d %d\n", arr[i], m - arr[i]);
			return 0;
		}
	}
	printf("No Solution\n");
	return 0;
}
```

