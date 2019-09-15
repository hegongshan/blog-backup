---
title: 2019年“锐捷网络杯”华中区高校研究生程序设计大赛K.A good game
date: 2019-06-02 20:07:33
categories: 程序设计
mathjax: true
---

Bigbrother is a cute boy who likes to play cards. One day, he gets *N* cards and every of them has a number $V_i$. Now, he wants to play a game with you.

He has *M* operations.

In the *k*-th operation, the sum of $V_i$ between intervals \[L,R\] is *S*, *k×S* is the *k*-th score.

You can sort the *M* operations and get the maximum sum of scores.

<!--more-->

### Input

There are multiple tests. The first line contains integer T(1≤T≤10).

The second line contains integer N, M(1 ≤ N,M ≤ 100000)

The next line contain *N* numbers $V_i$  (1 ≤$V_i$ ≤ 1000) .

The following $M​$ lines, each line contains two numbers, L,R(1 ≤ L,R ≤ N).

### Output

There are T lines.

In every line print a single integer — the answer to the problem.

### Sample Input

```in
1
4 3
1 2 3 4
1 2
2 4
1 4
```

### Sample Output

```out
51
```

### 分析

**题目大意：**给定N张牌，每张牌的权值为$V_i$。对这些牌进行M次操作，第k次操作的得分为$k \times S$，其中$S = \sum_{i=L}^{R}V_i$，L和R由输入给出，表示第L和R张牌。对M次操作的先后顺序进行调换，使得总得分最高，输出最高总得分。

**思路：前缀和 加 贪心。**

输入$V_i$时，计算每张牌到第1张牌之间的权值和span[i]。

然后通过对应的权值之和，计算某一操作的得分S。

对所有的S进行升序排列，使得较大的S位于序列的后面，从而使得总得分最高。

```c++
#include <cstdio>
#include <algorithm>
using namespace std;

int main() {
	int t;
	scanf("%d", &t);
	while (t--) {
		int n, m;
		scanf("%d %d", &n, &m);
		int arr[n];
		// span[i]存储第i+1张牌到第1张牌之间的权值和
		int span[n];
		for (int i = 0; i < n; i++) {
			scanf("%d", &arr[i]);
			if (i == 0) {
				span[i] = arr[i];
			} else {
				// 前缀和
				span[i] = span[i - 1] + arr[i];
			}
		}
		int left, right;
		// 存储单个操作的得分S
		long long scores[m];
		for (int i = 0; i < m; i++) {
			scanf("%d %d", &left, &right);
			if (left == 1) {
				scores[i] = span[right - 1];
			} else {
				scores[i] = span[right - 1] - span[left - 2];
			}
		}
		// 对所有的S进行升序排列
		sort(scores, scores + m);

		// 最大总得分
		long long sum = 0;
		for (int i = 0; i < m; i++) {
			sum += (i + 1) * scores[i];
		}
		printf("%lld\n", sum);
	}
	return 0;
}
```

本题需要注意的几个地方：
$$
\max(S) = \max(V_i) \times \max(N) = 10^5 \times 10^3 = 10^8
$$

$$
max(sum) = max(S) \times (1+2+\dots+\max(N)) = 10^8 \times \frac{10^5 \times (10^5 + 1)}{2} ≈ 5\times 10^{17}
$$

因此，总得分sum必须用long long存储。

又因为$\max(k \times S) = 10^5 \times 10^8 = 10^{13}$，因此S必须采用long long存储，否则，$ k \times S$可能会溢出。

