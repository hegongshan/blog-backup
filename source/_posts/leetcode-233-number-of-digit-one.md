---
title: LeetCode 233.数字 1 的个数/《剑指Offer》43.1～n整数中1出现的次数
date: 2020-03-11 17:12:14
tags: 剑指offer
categories: leetcode
mathjax: true
---

给定一个整数 n，计算所有小于等于 n 的非负整数中数字 1 出现的个数。

<!--more-->

**示例:**

```
输入: 13
输出: 6 
解释: 数字 1 出现在以下数字中: 1, 10, 11, 12, 13 。
```

### 方法一：暴力法

```java
class Solution {
    public int countDigitOne(int n) {
        int count = 0;
        for (int i = 1; i <= n; i++) {
            count += countDigitOne0(i);
        }
        return count;
    }
    public int countDigitOne0(int n) {
        int count = 0;
        while (n != 0) {
            if (n % 10 == 1) {
                count ++;
            }
            n /= 10;
        }
        return count;
    }
}
```

复杂度分析：时间复杂度为$O(n \log_{10} n)$，空间复杂度为O(1)。

