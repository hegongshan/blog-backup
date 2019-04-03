---
title: PAT乙级 1008.数组元素循环右移问题 （20 分)
date: 2019-03-15 11:49:28
tags: pat
categories: pat乙级
mathjax: true
---

一个数组*A*中存有*N*（>0）个整数，在**不允许使用另外数组**的前提下，将每个整数循环向右移*M*（≥0）个位置，即将*A*中的数据由（$A_0 A_1⋯A_{N−1}$）变换为（$A_{N-M}⋯A_{N−1} A_0 A_1⋯A_{N−M−1}$）（最后*M*个数循环移至最前面的*M*个位置）。如果需要考虑程序移动数据的次数尽量少，要如何设计移动的方法？

<!--more-->

### 输入格式:

每个输入包含一个测试用例，第1行输入*N*（1≤*N*≤100）和*M*（≥0）；第2行输入*N*个整数，之间用空格分隔。

### 输出格式:

在一行中输出循环右移*M*位以后的整数序列，之间用空格分隔，序列结尾不能有多余空格。

### 输入样例:

```in
6 2
1 2 3 4 5 6
```

### 输出样例:

```out
5 6 1 2 3 4
```

### 解法一：直接法

* **算法思路**：每次向右移动一位，循环执行m次

* **代码实现**

```c++
#include <iostream>
using namespace std;

int main() {
	int n, m;
	cin >> n >> m;
	int arr[n];
	for (int i = 0; i < n; i++) {
		cin >> arr[i];
	}
	for (int i = 0; i < m; i++) {
            //保存数组的最后一位
            int temp = arr[n - 1];
            //自后向前，循环后移一位
            for (int j = n - 2; j >= 0; j--) {
                arr[j + 1] = arr[j];
            }
            arr[0] = temp;
	}

	for (int i = 0; i < n; i++) {
            cout << arr[i];
            if (i != n - 1) {
                cout << " ";
            }
	}
}
```

* **时间复杂度**：每次向右移动一位，需要执行n次赋值操作，这个过程循环执行m次，所以共执行**nm**次赋值操作，时间复杂度为**O(nm)**

### 解法二：反转法

* **算法思想**

假设N>=M（若N<M，只需令M=M%N即可），数组A中的数据为$A_0 A_1⋯A_{N−1}$，现在需要将数组A循环向右移M个位置，即将$A_{N-M}⋯A_{N−1}$移到数组的前面。

我们可以将数组A中的数据分为两个部分$A_0 A_1⋯A_{N−M-1}$和$A_{N-M}⋯A_{N−1}$来看，

（1）先将$A_0 A_1⋯A_{N−M-1}​$反转，得到$A_{N−M-1} ⋯A_1 A_0​$；

（2）再将$A_{N-M}⋯A_{N−1}​$反转，得到$A_{N-1}⋯A_{N−M}​$

（3）经过（1）和（2）后，数组A中的数据为$A_{N−M-1} ⋯A_1 A_0 A_{N-1}⋯A_{N−M}$，将数组A中的数据反转，此时数组A中的数据顺序为$A_{N-M}⋯A_{N−1} A_0 A_1⋯A_{N−M−1}$

* **代码实现**

```c++
#include <iostream>
using namespace std;

int main() {
	int n, m;
	cin >> n >> m;
	int arr[n];
	for (int i = 0; i < n; i++) {
		cin >> arr[i];
	}
	if(m > n) {
		m = m % n;
	}
	int temp = 0;
    // 反转前n-m项
	for(int i=0;i<(n-m)/2;i++) {
		temp = arr[n-m-i-1];
		arr[n-m-i-1] = arr[i];
		arr[i] = temp;
	}
    // 反转后m项
	for(int i=n-m;i<n-m/2;i++) {
		temp = arr[2*n-m-i-1];
		arr[2*n-m-i-1] = arr[i];
		arr[i] = temp;
	}
    // 反转整个数组
	for(int i=0;i<n/2;i++) {
		temp = arr[n-i-1];
		arr[n-i-1] = arr[i];
		arr[i] = temp;
	}
	for (int i = 0; i < n; i++) {
		cout << arr[i];
		if (i != n - 1) {
			cout << " ";
		}
	}
}
```

* **时间复杂度**

三次反转操作，共执行 $3 \times \frac{n-m}{2}+3 \times [n-\frac{m}{2}-(n-m)]+3 \times \frac{n}{2}=3n$次赋值操作，故时间复杂度为**O(n)**