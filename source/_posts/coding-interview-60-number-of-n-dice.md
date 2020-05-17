---
title: 《剑指Offer》60.n个骰子的点数
date: 2020-03-27 20:28:33
tags: dp
categories: 剑指offer
mathjax: true
---

把n个骰子扔在地上，所有骰子朝上一面的点数之和为s。输入n，打印出s的所有可能的值出现的概率。

 你需要用一个浮点数数组返回答案，其中第 i 个元素代表这 n 个骰子所能掷出的点数集合中第 i 小的那个的概率。

<!--more-->

**示例 1:**

```
输入: 1
输出: [0.16667,0.16667,0.16667,0.16667,0.16667,0.16667]
```

**示例 2:**

```
输入: 2
输出: [0.02778,0.05556,0.08333,0.11111,0.13889,0.16667,0.13889,0.11111,0.08333,0.05556,0.02778]
```

**限制：**`1 <= n <= 11`

### 方法一：回溯

```java
class Solution {
    public double[] twoSum(int n) {
        double[] result = new double[5 * n + 1];

        backtrack(result, 0, 0, n);

        double total = Math.pow(6, n);
        for (int i = 0; i < result.length; i++) {
            result[i] /= total;
        }
        return result;
    }

    public void backtrack(double[] result, int val, int cur, int n) {
        if (cur == n) {
            result[val - n] ++;
            return ;
        }
        for (int i = 1; i <= 6; i++) {
            backtrack(result, val + i, cur + 1, n);
        }
    }
}
```

复杂度分析：时间复杂度为O(6^n)，空间复杂度为O(n)。

### 方法二：动态规划

定义函数f(n,s)表示n个骰子，掷出的点数之和为s的次数。

当n = 1时，$f(n, s) = 1, s = 1, 2, \cdots, 6$

当$n \ge 2$时，

* 如果s > 6，则$f(n, s) = f(n-1,s-1) + f(n-1,s-2) + \cdots + f(n-1, s-6)$；
* 如果$s \le 6$，则$f(n,s) = f(n-1,s-1) + f(n-1,s-2) + \cdots + f(n-1, 1)$。

综上所述，可以得到如下的转态转移方程：
$$
f(n,s) =
\begin{cases}
1, & n = 1 \\\\
\sum_{k=1}^{\min(6,s-1)} f(n-1,s-k), & n \ge 2
\end{cases}
$$

```java
class Solution {
    public double[] twoSum(int n) {
        int[][] dp = new int[n + 1][6 * n + 1];
        for (int i = 1; i <= 6; i++) {
            dp[1][i] = 1;
        }
        for (int i = 2; i <= n; i++) {
            for (int j =  i ; j <= 6 * i; j++) {
                for (int k = 1; k <= Math.min(6, j - 1); k++) {
                    dp[i][j] += dp[i - 1][j - k];
                }
            }
        }

        double total = Math.pow(6, n);
        double[] result = new double[5 * n + 1];
        for (int i = n; i <= 6 * n; i++) {
            result[i - n] = dp[n][i] / total;
        }
        return result;
    }
}
```

复杂度分析：该算法的时间消耗主要在于第7-13行的循环
$$
\begin{align}
\sum_{i = 2}^n \sum_{j = i}^{6i} &= \sum_{i = 2}^n (5i + 1) \\\\
&= 5 \times \frac{(n-1)\times(n+2)}{2} + (n - 1) \\\\
&= O(n^2)
\end{align}
$$
故时间复杂度和空间复杂度均为$O(n^2)$。