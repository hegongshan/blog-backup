---
title: LeetCode 263.丑数
date: 2019-05-03 12:43:02
tags: math
categories: leetcode
mathjax: true
---

### 题目描述

编写一个程序判断给定的数是否为丑数。

丑数就是只包含质因数 `2, 3, 5` 的**正整数**。

**示例 1:**

```
输入: 6
输出: true
解释: 6 = 2 × 3
```

**示例 2:**

```
输入: 8
输出: true
解释: 8 = 2 × 2 × 2
```

**示例 3:**

```
输入: 14
输出: false 
解释: 14 不是丑数，因为它包含了另外一个质因数 7。
```

**说明：**

1. `1` 是丑数。
2. 输入不会超过 32 位有符号整数的范围: $[−2^{31},  2^{31}-1]$。

<!--more-->

### 解决方案

#### 方法一：递归

```java
class Solution {
    public boolean isUgly(int num) {
        if(num <= 0) {
            return false;
        }
        if(num == 1) {
            return true;
        }
        if(num % 2 == 0) {
            return isUgly(num / 2);
        }
        if(num % 3 == 0) {
            return isUgly(num / 3);
        }
        if(num % 5 == 0) {
            return isUgly(num / 5);
        }
        return false;
    }
}
```

#### 方法二：循环

```java
class Solution {
    public boolean isUgly(int num) {
        if(num <= 0) {
            return false;
        }
        while(num % 2 == 0) {
            num /= 2;
        }
        while(num % 3 == 0) {
            num /= 3;
        }
        while(num % 5 == 0) {
            num /= 5;
        }
        return num == 1;
    }
}
```

