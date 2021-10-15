---
title: LeetCode 29.两数相除
date: 2021-10-06 22:36:51
tags: leetcode
categories: leetcode
mathjax: true
---

给定两个整数，被除数`dividend`和除数`divisor`。将两数相除，要求不使用乘法、除法和mod运算符。

返回被除数`dividend`除以除数`divisor`得到的商。

整数除法的结果应当截去（truncate）其小数部分，例如：`truncate(8.345) = 8`以及`truncate(-2.7335) = -2`

<!--more-->

**示例 1:**

```
输入: dividend = 10, divisor = 3
输出: 3
解释: 10/3 = truncate(3.33333..) = truncate(3) = 3
```

**示例 2:**

```
输入: dividend = 7, divisor = -3
输出: -2
解释: 7/-3 = truncate(-2.33333..) = -2
```

**提示：**

* 被除数和除数均为 32 位有符号整数。
* 除数不为 0。
* 假设我们的环境只能存储 32 位有符号整数，其数值范围是 $[−2^{31},  2^{31} − 1]$。本题中，如果除法结果溢出，则返回 $2^{31} − 1$。

#### 解题思路

两数相除的一般形式如下：
$$
\begin{aligned}
\frac{a}{b} &=c \cdots d \\\\
\Leftrightarrow a &= b \times c + d
\end{aligned}
$$
设c的二进制表示为$x_0 x_1 \cdots x_{31}$​​​​，则有：
$$
c = \sum_{i=0}^{31} x_i \times 2^i
$$

完整代码如下：

```java
class Solution {

    public int divide(int dividend, int divisor) {
        // 处理特殊值
        if (dividend == 0) {
            return 0;
        }
        if (dividend == divisor) {
            return 1;
        }

        boolean sign = (dividend ^ divisor) >= 0;
        // 转换为负数
        if (dividend > 0) {
            dividend = -dividend;
        }
        if (divisor > 0) {
            divisor = -divisor;
        }

        // 不断逼近
        int result = 0;
        while (divisor >= dividend) {
            int count = -1;
            int val = divisor;
            while (val >= (Integer.MIN_VALUE >> 1) && (val << 1) >= dividend) {
                count <<= 1;
                val <<= 1;
            }
            dividend -= val;
            result += count;
        }
      
        if (sign) {
            if (result == Integer.MIN_VALUE) {
                return Integer.MAX_VALUE;
            }
            result = -result;
        }
        return result;
    }
}
```

