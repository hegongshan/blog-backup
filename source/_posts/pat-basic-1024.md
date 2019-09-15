---
title: PAT乙级 1024.科学计数法/PAT甲级 1073.Scientific Notation (20 分)
date: 2019-05-05 11:01:20
tags: pat
categories: [pat乙级,pat甲级]
---

科学计数法是科学家用来表示很大或很小的数字的一种方便的方法，其满足正则表达式 \[+-]\[1-9]`.`[0-9]+E\[+-]\[0-9]+，即数字的整数部分只有 1 位，小数部分至少有 1 位，该数字及其指数部分的正负号即使对正数也必定明确给出。

现以科学计数法的格式给出实数 *A*，请编写程序按普通数字表示法输出 *A*，并保证所有有效位都被保留。

<!--more-->

### 输入格式：

每个输入包含 1 个测试用例，即一个以科学计数法表示的实数 *A*。该数字的存储长度不超过 9999 字节，且其指数的绝对值不超过 9999。

### 输出格式：

对每个测试用例，在一行中按普通数字表示法输出 *A*，并保证所有有效位都被保留，包括末尾的 0。

### 输入样例 1：

```in
+1.23400E-03
```

### 输出样例 1：

```out
0.00123400
```

### 输入样例 2：

```in
-1.2E+10
```

### 输出样例 2：

```out
-12000000000
```

### 分析：

本题的关键是，找到`E`的位置dot，`E`前面为数字部分，后面为指数。

本题需要分以下三种情况考虑：

（1）**输入的指数部分e为负数**。首先输出`0.`，然后输出`e-1`个0，最后将输入的数字部分（不带小数点）原样输出即可。

（2）**输入的指数部分e为正数，且小数位count小于指数e**。首先将输入的数字部分（不带小数点）原样输出，然后再输出`e-count`个0即可。

（3）**输入的指数部分e为正数，且小数位count大于等于指数e**。首先将小数点前的数字部分输出，然后将小数点后e位输出。接着，判断count是否大于e。若大于，先输出小数点，然后将数字部分剩下的`count-e`位依次输出。

最后，需要注意的是：若输入为正数，则输出时不带符号。

```c++
#include <iostream>
#include <string>
using namespace std;

int main() {
	string s, e, n, result;
	cin >> s;

	int index = s.find("E");
	// 数字部分
	n = s.substr(1, index - 1);
	// 指数部分
	e = s.substr(index + 2, s.size() - index - 2);
	// 若为负数
	if (s[0] == '-') {
		result = s[0];
	}
	int x = stoi(e);
	int dot = n.find(".");
	// 若指数为负
	if (s[index + 1] == '-') {
		result += "0.";

		for (int i = 0; i < x - 1; i++) {
			result += "0";
		}

		result += n.substr(0, dot) + n.substr(dot + 1, n.size() - dot - 1);
	} else {
		int count = n.size() - n.find(".") - 1;
		// 若指数大于小数位数
		if (count < x) {
			result += n.substr(0, dot) + n.substr(dot + 1, n.size() - dot - 1);

			for (int i = 0; i < x - count; i++) {
				result += "0";
			}
		} else {
			result += n.substr(0, dot) + n.substr(dot + 1, x);
			// 若指数小于小数位数
			if (x < count) {
				result += "." + n.substr(dot + x + 1, n.size() - dot - x - 1);
			}
		}
	}
	cout << result << endl;
	return 0;
}
```

