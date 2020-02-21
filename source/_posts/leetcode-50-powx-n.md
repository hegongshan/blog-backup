---
title: LeetCode 50.Pow(x, n)/《剑指Offer》16.数值的整数次方
date: 2020-02-23 18:43:00
tags: mathematics
categories: leetcode
mathjax: true
---

实现 pow(x, n) ，即计算 x 的 n 次幂函数。

<!--more-->

**示例 1:**

```
输入: 2.00000, 10
输出: 1024.00000
```

**示例 2:**

```
输入: 2.10000, 3
输出: 9.26100
```

**示例 3:**

```
输入: 2.00000, -2
输出: 0.25000
解释: 2-2 = 1/22 = 1/4 = 0.25
```

**说明:**

*  -100.0 < x < 100.0
* n 是 32 位有符号整数，其数值范围是 [$−2^{31},  2^{31 − 1}$] 。

### 方法一：暴力法

思路：连乘n次。

```java
class Solution {
    public double myPow(double x, int n) {
        long N = n;
        if(N < 0) {
            N = -N;
            x = 1 / x;
        }
        double result = 1;
        for(long i = 0; i < N; i++) {
            result *= x;
        }
        return result;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(1)。

### 方法二：快速幂（递归）

$$
x^n = 
\begin{cases}
x^{n/2} \times x^{n/2}, & n为偶数 \\\\
x^{(n-1)/2} \times x^{(n-1)/2} \times x, & n为奇数
\end{cases}
$$

上述方法称之为快速幂算法。

```java
class Solution {
    public double myPow(double x, int n) {       
        long N = n;
        if(N < 0) {
            N = -N;
            x = 1 / x;
        }
        return pow(x, N);
    }

    public double pow(double x, long n) {
        if(n == 0) {
            return 1.0;
        }
        double half = pow(x, n / 2);
        if(n % 2 == 0) {
            return half * half;
        }
        return half * half * x;
    }
}
```

使用位运算优化后：

```java
class Solution {
    public double myPow(double x, int n) {       
        long N = n;
        if(N < 0) {
            N = -N;
            x = 1 / x;
        }
        return pow(x, N);
    }

    public double pow(double x, long n) {
        if(n == 0) {
            return 1.0;
        }
        double half = pow(x, n >> 1);
        if((n & 1) == 0) {
            return half * half;
        }
        return half * half * x;
    }
}
```

时间复杂度为O(log n)，空间复杂度为O(log n)。

### 方法三：快速幂（循环）

设n的二进制形式为$b_l b_{l-1} \cdots b_0$，从而有$n=\sum_i 2^i b_i$。

因为$x^{a+b} = x^a \times x^b$，故，
$$
x^n = x^{\sum_i 2^i b_i} = \prod_i x^{2^i b_i}
$$
又因为$x^{2n} = (x^n)^2$，从而有
$$
x^{2^i} = (x^{2^{i-1}})^2
$$

```java
class Solution {
    public double myPow(double x, int n) {       
        long N = n;
        if(N < 0) {
            N = -N;
            x = 1 / x;
        }

        double result = 1;
        // 第一项为x^{2^0}
        double prod = x;
        while(N > 0) {
            // 若bi = (N & 1) 为1，则乘以当前项 x^{2^i}
            if((N & 1) == 1) {
                result *= prod;
            }
            // 计算下一项（等于当前项的平方）
            prod = prod * prod;
            N = N >> 1;
        }
        return result;
    }
}
```

时间复杂度为O(log n)，空间复杂度为O(1)。