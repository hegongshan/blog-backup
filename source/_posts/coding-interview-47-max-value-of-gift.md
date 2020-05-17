---
title: 《剑指Offer》47.礼物的最大价值
date: 2020-03-15 17:48:11
tags: dp
categories: 剑指offer
mathjax: true
---

在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物?

<!--more-->

### 问题分析

令f(i,j)表示到达坐标为(i,j)的格子时，能够拿到的礼物的最大价值；

`grid[i][j]`表示坐标为(i,j)的格子中礼物的价值，那么：
$$
f(i,j) = \max(f(i-1,j),\ f(i, j-1)) + grid[i][j]
$$

### 算法实现

```java
class Solution {
    public int maxValue(int[][] grid) {
        int m, n;
        if(grid == null || (m = grid.length) == 0 || (n = grid[0].length) == 0) {
            return 0;
        }
        int[][] dp = new int[m][n];
        int left, up;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                left = up = 0;
                if (i > 0) {
                    up = dp[i - 1][j];
                }
                if (j > 0) {
                    left = dp[i][j - 1];
                }
                dp[i][j] = Math.max(left, up) + grid[i][j];
            }
        }
        return dp[m - 1][n - 1];
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(m × n)。

### 算法优化

到达坐标为(i,j)的格子时，能够拿到的礼物的最大价值f(i,j)只依赖坐标为(i,j-1)和(i-1,j)的两个格子。

因此，第i-2行以及更上面的格子并不需要保存，我们可以使用一个长度为n的一维数组dp代替之前的二维数组。

当我们在计算到达坐标为(i,j)的格子，能够拿到的礼物的最大价值f(i,j)时，数组dp的前j个元素为$f(i, 0), f(i, 1), \cdots, f(i, j-1)$，后n-j个元素为$f(i-1, j), f(i-1, j+1), \cdots, f(i-1, n-1)$，如下图所示：

![](/static/images/coding-interview-47-1.png)

此时，
$$
\begin{align}
f(i,j) 
&= \max(f(i-1,j),\ f(i, j-1)) + grid[i][j]\\\\
&= \max(dp[j],\ dp[j-1]) + grid[i][j] \\\\
&= 新的dp[j] 
\end{align}
$$
计算完f(i,j)后，数组dp中存储的内容为：

![](/static/images/coding-interview-47-2.png)

```java
class Solution {
    public int maxValue(int[][] grid) {
        int m, n;
        if(grid == null || (m = grid.length) == 0 || (n = grid[0].length) == 0) {
            return 0;
        }
        int[] dp = new int[n];
        int left, up;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                left = up = 0;
                if (i > 0) {
                    up = dp[j];
                }
                if (j > 0) {
                    left = dp[j - 1];
                }
                dp[j] = Math.max(left, up) + grid[i][j];
            }
        }
        return dp[n - 1];
    }
}
```

复杂度分析：时间复杂度为O(m × n)，空间复杂度为O(n)。