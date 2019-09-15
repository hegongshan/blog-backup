---
title: PAT甲级 1058.A+B in Hogwarts （20 分)
date: 2019-04-22 10:44:02
tags: pat
categories: pat甲级
---

If you are a fan of Harry Potter, you would know the world of magic has its own currency system -- as Hagrid explained it to Harry, "Seventeen silver Sickles to a Galleon and twenty-nine Knuts to a Sickle, it's easy enough." Your job is to write a program to compute *A*+*B* where *A* and *B* are given in the standard form of `Galleon.Sickle.Knut` (`Galleon` is an integer in [0,10^7], `Sickle` is an integer in [0, 17), and `Knut` is an integer in [0, 29)).

<!--more-->

### Input Specification:

Each input file contains one test case which occupies a line with *A* and *B* in the standard form, separated by one space.

### Output Specification:

For each test case you should output the sum of *A* and *B* in one line, with the same format as the input.

### Sample Input:

```in
3.2.1 10.16.27
```

### Sample Output:

```out
14.1.28
```

### 分析：

题目大意：在一种新的货币体系下，计算货币A、B之和。

思路：

（1）一种很直接的思路是将输入的货币A、B转换为Knut的形式，然后相加，最后再转换成`Galleon.Sickle.Knut`格式。

这种解法需要注意的是，A、B之和sum可能会超过int的取值范围，因此，需要使用long long存储数据。

（2）另一种解法是**相加进位**。

用g、s、k分别表示A、B之和的Galleon、Sickle、Knut。先将A、B的Knut部分加到k上，若此时k大于等于29，则k -= 29，s+=1。然后将A、B的Sickle部分加到s上，若此时s大于等于17，则s -= 17，g+=1。最后将A、B的Galleon部分加到g上即可。

这里采用第二种解法，代码如下：

```c++
#include <cstdio>

int main() {
	int g1, s1, k1, g2, s2, k2, g, s, k;
	scanf("%d.%d.%d %d.%d.%d", &g1, &s1, &k1, &g2, &s2, &k2);
	g = s = k = 0;
	k += k1 + k2;
	if (k >= 29) {
		//s += k / 29; k %= 29;
		k -= 29;
		s++;
	}
	s += s1 + s2;
	if (s >= 17) {
		s -= 17;
		g++;
	}
	g += g1 + g2;
	printf("%d.%d.%d\n", g, s, k);
	return 0;
}
```

