---
title: LeetCode 8.字符串转换整数 (atoi)/《剑指Offer》67.把字符串转换成整数
date: 2020-04-03 16:56:16
tags: string
categories: leetcode
---

请你来实现一个 atoi 函数，使其能将字符串转换成整数。

<!--more-->

首先，该函数会根据需要丢弃无用的开头空格字符，直到寻找到第一个非空格的字符为止。

当我们寻找到的第一个非空字符为正或者负号时，则将该符号与之后面尽可能多的连续数字组合起来，作为该整数的正负号；假如第一个非空字符是数字，则直接将其与之后连续的数字字符组合起来，形成整数。

该字符串除了有效的整数部分之后也可能会存在多余的字符，这些字符可以被忽略，它们对于函数不应该造成影响。

注意：假如该字符串中的第一个非空格字符不是一个有效整数字符、字符串为空或字符串仅包含空白字符时，则你的函数不需要进行转换。

在任何情况下，若函数不能进行有效的转换时，请返回 0。

**说明：**

假设我们的环境只能存储 32 位大小的有符号整数，那么其数值范围为 [−2^31,  2^31 − 1]。如果数值超过这个范围，请返回  INT_MAX (2^31 − 1) 或 INT_MIN (−2^31) 。

**示例 1:**

```
输入: "42"
输出: 42
```

**示例 2:**

```
输入: "   -42"
输出: -42
解释: 第一个非空白字符为 '-', 它是一个负号。
     我们尽可能将负号与后面所有连续出现的数字组合起来，最后得到 -42 。
```

**示例 3:**

```
输入: "4193 with words"
输出: 4193
解释: 转换截止于数字 '3' ，因为它的下一个字符不为数字。
```

**示例 4:**

```
输入: "words and 987"
输出: 0
解释: 第一个非空字符是 'w', 但它不是数字或正、负号。
     因此无法执行有效的转换。
```

**示例 5:**

```
输入: "-91283472332"
输出: -2147483648
解释: 数字 "-91283472332" 超过 32 位有符号整数范围。 
     因此返回 INT_MIN (−2^31) 。
```

### 算法实现

```java
class Solution {
    public int myAtoi(String str) {
        int i = 0;
        // 去掉前面的空格
        while (i < str.length() &&  str.charAt(i) == ' ') {
            i++;
        }

        // 如果字符串为空，或字符串仅包含空白字符
        if (i == str.length()) {
            return 0;
        }
        // 如果第一个非空格字符不是一个有效整数字符
        char c = str.charAt(i);
        if (c != '+' && c!= '-' && !isDigit(c)) {
            return 0;
        }

        // 判断正负号
        boolean isNegative = false;
        if (c == '-') {
            isNegative = true;
            i ++;
        } else if (c == '+') {
            i ++;
        }

        // 转换
        int prod = 0, d = 0;
        int limit = Integer.MAX_VALUE / 10;
        while (i < str.length() && isDigit(str.charAt(i))) {
            d = str.charAt(i) - '0';
            // 如果将要溢出
            if (prod > limit) {
                return isNegative ? Integer.MIN_VALUE : Integer.MAX_VALUE;
            }
            if (prod == limit) {
                if (isNegative && d >= 8) {
                    return Integer.MIN_VALUE;
                }
                if (!isNegative && d >= 7) {
                    return Integer.MAX_VALUE;
                }
            }

            prod = 10 * prod + d;
            i++;
        }
        return isNegative ? -prod : prod;
    }

    private boolean isDigit(char c) {
        return '0' <= c && c <= '9';
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。其中，n为字符串的长度。