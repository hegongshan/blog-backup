---
title: LeetCode 343.整数拆分/《剑指Offer》14.剪绳子
date: 2020-02-22 21:22:40
tags: dp
categories: leetcode
mathjax: true
---

给定一个正整数 n，将其拆分为至少两个正整数的和，并使这些整数的乘积最大化。 返回你可以获得的最大乘积。

<!--more-->

**示例 1:**

```
输入: 2
输出: 1
解释: 2 = 1 + 1, 1 × 1 = 1。
```

**示例 2:**

```
输入: 10
输出: 36
解释: 10 = 3 + 3 + 4, 3 × 3 × 4 = 36。
```

**说明:** 你可以假设 n 不小于 2 且不大于 58。

### 方法一：递归

设函数f(n)为把n拆分成若干个正整数后，这些正整数乘积的最大值。

在拆分过程中，一个整数i (i < n)可能需要被拆分，也可能不需要被拆分。

若拆分后，获得的最大乘积$f(i) < i$，则不应该对i进行拆分。

因此，该问题可以用如下的公式来描述：
$$
f(n) = \max_i (
	\max(i, f(i)) \times \max(n - i, f(n - i))
)
$$


```java
class Solution {
    public int integerBreak(int n) {
        if(n <= 1) {
            return 0;
        }
        int max = 0;
        for(int i = 1; i <= n / 2; i++) {
            max = Math.max(max,
                Math.max(i, integerBreak(i)) * Math.max(n - i, integerBreak(n - i))
            );
        }
        return max;
    }
}
```

时间复杂度和空间复杂度均为O($n^2$)。

虽然该方法写起来简单，但由于存在大量的重复计算，将会导致超时。

### 方法二：动态规划（自下而上）

使用数组将每一个f(i)存储起来，可以避免重复计算。

```java
class Solution {
    public int integerBreak(int n) {
        if(n <= 1) {
            return 0;
        }
        int[] products = new int[n + 1];
        products[1] = 1;
        for(int i = 1; i <= n; i++) {
            int  max = 0;
            for(int j = 1; j <= i / 2; j++) {
                max = Math.max(max,
                    Math.max(j, products[j]) * Math.max(i - j, products[i - j]));
            }
            // 存储f(i)，避免重复计算
            products[i] = max;          
        }
        return products[n];
    }
}
```

时间复杂度为O($n^2$)，空间复杂度为O(n)。

### 方法三：贪心算法

容易证明（数学归纳法）：除1以外，任何一个正整数都可以分解为若干个2和若干个3的和。

当$n \ge 5$时，
$$
n > 4 \Rightarrow 2(n - 2) > n \\\\
n > 4.5 \Rightarrow 3(n - 3) > n \\\\
n \ge 5 \Rightarrow 3(n - 3) \ge 2(n-2)
$$
因此，当$n \ge 5$时，应该尽可能多地拆分成3；当剩下的值为4时，将其拆分成2个2，而不是1和3，因为$2 \times 2 > 1 \times 3$。

```java
class Solution {
    public int integerBreak(int n) {
        if(n <= 1) {
            return 0;
        }
        if(n == 2) {
            return 1;
        }
        if(n == 3) {
            return 2;
        }
        int count3 = n / 3;
        if(count3 * 3 + 1 == n) {
            count3--;
        }
        int count2 = (n - count3 * 3) / 2;
        return (int) (Math.pow(3, count3) * Math.pow(2, count2));
    }
}
```

时间复杂度和空间复杂度均为O(1)。

