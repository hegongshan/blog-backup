---
title: LeetCode 121.买卖股票的最佳时机/《剑指Offer》63.股票的最大利润
date: 2020-03-30 13:14:32
tags: dp
categories: leetcode
mathjax: true
---

给定一个数组，它的第 i 个元素是一支给定股票第 i 天的价格。

如果你最多只允许完成一笔交易（即买入和卖出一支股票一次），设计一个算法来计算你所能获取的最大利润。

注意：你不能在买入股票前卖出股票。

<!--more-->

**示例 1:**

```
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
```

**示例 2:**

```
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

### 方法一：暴力法

```java
class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length < 2) {
            return 0;
        }
        int profit = 0;
        int maxSellPrice;
        for (int i = 0; i < prices.length; i++) {
            // 寻找之后最大的卖出价格
            maxSellPrice = 0;
            for (int j = i + 1; j < prices.length; j++) {
                maxSellPrice = Math.max(maxSellPrice, prices[j]);
            }
            profit = Math.max(profit, maxSellPrice - prices[i]);
        }
        return profit;
    }
}
```

复杂度分析：时间复杂度为$O(n^2)$，空间复杂度为O(1)。其中，n为数组prices的长度。

### 方法二：动态规划

#### 计算最大的卖出价格

思路：用数组dp来存储第i天以后最大的卖出价格，从后往前计算
$$
dp[i] = \max(dp[i+1], prices[i+1])
$$
从而，最大利润为
$$
profit = \max(dp[i] - prices[i])
$$

```java
class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length < 2) {
            return 0;
        }
        int profit = 0;
        // 存储第i天之后最大的卖出价格
        int[] dp = new int[prices.length];
        dp[prices.length - 1] = 0;
        for (int i = prices.length - 2; i >= 0; i--) {
            dp[i] = Math.max(dp[i + 1], prices[i + 1]);
        }
        for (int i = 0; i < prices.length; i++) {
            profit = Math.max(profit, dp[i] - prices[i]);
        }
        return profit;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组prices的长度。

#### 计算最小的买入价格

##### 解法

思路：用数组dp来存储第i天以前最小的买入价格，状态转移方程如下
$$
dp[i] = \min(dp[i-1],\ prices[i-1])
$$
从而，最大利润为
$$
profit = \max(prices[i] - dp[i])
$$

```java
class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length < 2) {
            return 0;
        }
        int profit = 0;
        int[] dp = new int[prices.length];
        dp[0] = Integer.MAX_VALUE;
        for (int i = 1; i < prices.length; i++) {
            dp[i] = Math.min(dp[i - 1], prices[i - 1]);
            profit = Math.max(profit, prices[i] - dp[i]);
        }
        return profit;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组prices的长度。

##### 优化

由于dp[i]只与dp[i-1]以及prices[i-1]有关系，因此，不需要存储第0~i-2项。

```java
class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length < 2) {
            return 0;
        }
        int profit = 0;
        int minBuyPrice = Integer.MAX_VALUE;
        for (int i = 1; i < prices.length; i++) {
            minBuyPrice = Math.min(minBuyPrice, prices[i - 1]);
            profit = Math.max(profit, prices[i] - minBuyPrice);
        }
        return profit;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。其中，n为数组prices的长度。

