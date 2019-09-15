---
title: PAT乙级 1010.一元多项式求导 （25 分)
date: 2019-04-07 13:53:34
tags: pat
categories: pat乙级
mathjax: true
---

设计函数求一元多项式的导数。（注：$x^n$（n为整数）的一阶导数为$nx^{n−1}$。）

<!--more-->

### 输入格式:

以指数递降方式输入多项式非零项系数和指数（绝对值均为不超过 1000 的整数）。数字间以空格分隔。

### 输出格式:

以与输入相同的格式输出导数多项式非零项的系数和指数。数字间以空格分隔，但结尾不能有多余空格。注意“零多项式”的指数和系数都是 0，但是表示为 `0 0`。

### 输入样例:

```in
3 4 -5 2 6 1 -2 0
```

### 输出样例:

```out
12 3 -10 1 6 0
```

### 分析：

高中数学告诉我们：$ax^b$的一阶导数为$abx^{b-1}$。

用coefficient和exponent分别表示多项式非零项的系数和指数，则该单项式的一阶导数为$coefficient \times exponent\ x^{exponent - 1}​$。

若单项式的指数exponent = 0，其一阶导数为0，不需要输出。故循环输入时，只需考虑指数exponent != 0的情况即可。

用bool型的变量flag表示是否已经有过输出，默认为false，即没有输出。若已有输出，即flag == true，则在本次输出之前，先输出一个空格，以此保证结尾不会有多余空格。

值得注意的是，输入的测试用例可能为零多项式。因此，在程序的最后需要判断flag == false是否成立，若成立，则表示输入的多项式为零多项式，此时需输出“0 0”。

```c++
#include <cstdio>

int main() {
	int coefficient;
	int exponent;
	//判断是否已经有过输出
	bool flag = false;
	while (scanf("%d %d", &coefficient, &exponent) != EOF) {
		if (exponent != 0) {
			if (flag) {
				printf(" ");
			}
			printf("%d %d", coefficient * exponent, exponent - 1);
			flag = true;
		}
	}
	if(!flag) {
		printf("0 0");
	}
	return 0;
}
```



