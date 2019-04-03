---
title: PAT甲级 1042.Shuffling Machine （20 分)
date: 2019-04-03 17:36:18
tags: pat
categories: pat甲级
---

Shuffling is a procedure used to randomize a deck of playing cards. Because standard shuffling techniques are seen as weak, and in order to avoid "inside jobs" where employees collaborate with gamblers by performing inadequate shuffles, many casinos employ **automatic shuffling machines**. Your task is to simulate a shuffling machine.

The machine shuffles a deck of 54 cards according to a given random order and repeats for a given number of times. It is assumed that the initial status of a card deck is in the following order:

```
S1, S2, ..., S13, 
H1, H2, ..., H13, 
C1, C2, ..., C13, 
D1, D2, ..., D13, 
J1, J2
```

where "S" stands for "Spade", "H" for "Heart", "C" for "Club", "D" for "Diamond", and "J" for "Joker". A given order is a permutation of distinct integers in [1, 54]. If the number at the *i*-th position is *j*, it means to move the card from position *i* to position *j*. For example, suppose we only have 5 cards: S3, H5, C1, D13 and J2. Given a shuffling order {4, 2, 5, 3, 1}, the result will be: J2, H5, D13, S3, C1. If we are to repeat the shuffling again, the result will be: C1, H5, S3, J2, D13.

<!--more-->

### Input Specification:

Each input file contains one test case. For each case, the first line contains a positive integer *K* (≤20) which is the number of repeat times. Then the next line contains the given order. All the numbers in a line are separated by a space.

### Output Specification:

For each test case, print the shuffling results in one line. All the cards are separated by a space, and there must be no extra space at the end of the line.

### Sample Input:

```in
2
36 52 37 38 3 39 40 53 54 41 11 12 13 42 43 44 2 4 23 24 25 26 27 6 7 8 48 49 50 51 9 10 14 15 16 5 17 18 19 1 20 21 22 28 29 30 31 32 33 34 35 45 46 47
```

### Sample Output:

```out
S7 C11 C10 C12 S1 H7 H8 H9 D8 D9 S11 S12 S13 D10 D11 D12 S3 S4 S6 S10 H1 H2 C13 D2 D3 D4 H6 H3 D13 J1 J2 C1 C2 C3 C4 D1 S5 H5 H11 H12 C6 C7 C8 C9 S2 S8 S9 H10 D5 D6 D7 H4 H13 C5
```

### 分析：

**题目大意**：模拟一个洗牌机。共有54张牌，其初始顺序为

```
S1, S2, ..., S13, 
H1, H2, ..., H13, 
C1, C2, ..., C13, 
D1, D2, ..., D13, 
J1, J2
```

给定洗牌次数K ( ≤20 )，以及第i张牌需要放置的位置j，输出洗完以后的牌顺序。

例如，假定只有五张牌：S3, H5, C1, D13 和 J2。洗牌顺序为{4, 2, 5, 3, 1}，洗完一次后的结果为： J2, H5, D13, S3, C1。若再洗一次，则结果为 C1, H5, S3, J2, D13。

**思路**：

使用二维数组`arr[n][2]`存储牌号(`[1,54]`)及该牌的当前位置，数组`numbers[n]`存储洗牌顺序。

每次洗牌，对所有牌执行`arr[i][1]=numbers[i]`，然后按照牌的当前位置升序排序，即对数组`arr[n][2]`第二维升序排序。

上述操作循环执行K次以后，得到最终的牌顺序。

输出时，按照牌号转换为对应的牌内容。先按照牌号得到其对应的字母编号，如牌号不大于13，则为字母编号为`S`…然后让牌号对13取模，若余数为0，则该牌的数字编号为`13`，否则该牌的数字编号为取模后的余数。

```c++
#include <cstdio>

const int n = 54;

void sort(int arr[n][2]) {
	int temp = 0;
	for (int i = 0; i < n - 1; i++) {
		for (int j = n - 1; j >= i + 1; j--) {
			if (arr[j][1] < arr[j - 1][1]) {
				temp = arr[j][1];
				arr[j][1] = arr[j - 1][1];
				arr[j - 1][1] = temp;

				temp = arr[j][0];
				arr[j][0] = arr[j - 1][0];
				arr[j - 1][0] = temp;
			}
		}
	}
}

int main() {
	int k;
	scanf("%d", &k);
	int arr[n][2] = { 0 };
	int numbers[n];
	for (int i = 0; i < n; i++) {
		arr[i][0] = i + 1;
		scanf("%d", &numbers[i]);
	}
	while (k--) {
		for (int i = 0; i < n; i++) {
			arr[i][1] = numbers[i];
		}
		sort(arr);
	}

	for (int i = 0; i < n; i++) {
		char c;
		if (arr[i][0] <= 13) {
			c = 'S';
		} else if (arr[i][0] <= 26) {
			c = 'H';
		} else if (arr[i][0] <= 39) {
			c = 'C';
		} else if (arr[i][0] <= 52) {
			c = 'D';
		} else {
			c = 'J';
		}
		int r = arr[i][0] % 13;
		int data = r == 0 ? 13 : r;
		printf("%c%d", c, data);
		if (i < n - 1) {
			printf(" ");
		} else {
			printf("\n");
		}
	}
	return 0;
}
```

