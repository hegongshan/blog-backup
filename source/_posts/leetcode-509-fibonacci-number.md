---
title: LeetCode 509.斐波那契数
date: 2019-11-24 11:36:51
tags: leetcode
categories: leetcode
mathjax: true
---

斐波那契数，通常用 F(n) 表示，形成的序列称为斐波那契数列。该数列由 0 和 1 开始，后面的每一项数字都是前面两项数字的和。也就是：

```
F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
```

给定 N，计算 F(N)。

<!--more-->

 示例 1：

```
输入：2
输出：1
解释：F(2) = F(1) + F(0) = 1 + 0 = 1.
```

示例 2：

```
输入：3
输出：2
解释：F(3) = F(2) + F(1) = 1 + 1 = 2.
```

示例 3：

```
输入：4
输出：3
解释：F(4) = F(3) + F(2) = 2 + 1 = 3.
```


提示：0 ≤ N ≤ 30

### 方法一：递归

```python
class Solution:
    def fib(self, N: int) -> int:
        # 递归
        if N == 0:
            return 0
        if N == 1:
            return 1
        return self.fib(N-1) + self.fib(N-2)
```

上述解法虽然形式简单，但时间复杂度为$O(2^n)$。

### 方法二：动态规划

```python
class Solution:
    def fib(self, N: int) -> int:
      	# 动态规划
        if N == 0:
            return 0
        if N == 1:
            return 1
        arr = [0, 1]
        for i in range(2, N+1):
           arr.append(arr[i-1] + arr[i-2])
        return arr[N]
```

该方法的时间复杂度和空间复杂度均为O(n)。

上述方法仍可以进一步优化

```python
class Solution:
    def fib(self, N: int) -> int:
        if N == 0:
            return 0
        if N == 1:
            return 1
        pre = 0
        cur = 1
        for i in range(2, N+1):
           cur += pre
           pre = cur - pre
        return cur     
```

此时，时间复杂度不变，空间复杂度为O(1)。