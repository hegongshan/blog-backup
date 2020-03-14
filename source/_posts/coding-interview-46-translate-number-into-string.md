---
title: 《剑指Offer》46.把数字翻译成字符串
date: 2020-03-14 17:20:07
tags: dp
categories: 剑指offer
mathjax: true
---

给定一个数字，我们按照如下规则把它翻译为字符串：0 翻译成 “a” ，1 翻译成 “b”，……，11 翻译成 “l”，……，25 翻译成 “z”。一个数字可能有多个翻译。请编程实现一个函数，用来计算一个数字有多少种不同的翻译方法。

<!--more-->

示例 1:**

```
输入: 12258
输出: 5
解释: 12258有5种不同的翻译，分别是"bccfi", "bwfi", "bczi", "mcfi"和"mzi"
```

**提示：**

- `0 <= num < 2^31`

### 问题分析

从头到尾：定义函数f(i)表示以第i位数字为起点，不同翻译方法的数量，那么
$$
f(i) = 
\begin{cases}
f(i + 1) + f(i + 2), & \mathrm{if\ 10 \le g(i, i + 1) \le 25} \\\\
f(i + 1), & \mathrm{otherwise}
\end{cases}
$$
2.从尾到头：定义函数f(i)表示以第i位数字为终点，不同翻译方法的数量，那么
$$
f(i) = 
\begin{cases}
f(i - 1) + f(i - 2), & \mathrm{if\ 10 \le g(i - 1, i) \le 25} \\\\
f(i - 1), & \mathrm{otherwise}
\end{cases}
$$
其中，g(x,y)表示将num中第x和y位数字拼在一起。例如，num = 542，则g(1, 2) = 54。

### 方法一：递归

* 从头到尾

```java
class Solution {
    public int translateNum(int num) {
        if (num < 10) {
            return 1;
        }
        String str = String.valueOf(num);
        int first = translateNum(Integer.parseInt(str.substring(1)));
        int x = Integer.parseInt(str.substring(0, 2));
        if (10 <= x && x <= 25) {
            String s2 = str.substring(2);
            return first + translateNum(s2.isEmpty() ? 0: Integer.parseInt(s2));
        }
        return first;
    }
}
```

* 从尾到头

```java
class Solution {
    public int translateNum(int num) {
        if (num < 10) {
            return 1;
        }
        int x = num % 100;
        if (10 <= x && x <= 25) {
            return translateNum(num / 10) + translateNum(num / 100);
        }
        return translateNum(num / 10);
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为数字num的长度。

### 方法二：迭代

```java
class Solution {
    public int translateNum(int num) {
        String str = String.valueOf(num);
        int[] dp = new int[str.length() + 1];
        dp[0] = 1;
        dp[1] = 1;
        for (int i = 2; i <= str.length(); i++) {
            int x = Integer.parseInt(str.substring(i - 2, i));
            if (10 <= x && x <= 25) {
                dp[i] = dp[i - 1] + dp[i - 2];
            } else {
                dp[i] = dp[i - 1];
            }
        }
        return dp[str.length()];
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为数字num的长度。