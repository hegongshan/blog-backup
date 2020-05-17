---
title: LeetCode 5.最长回文子串
date: 2020-04-17 20:42:29
tags: dp
categories: leetcode
mathjax: true
---

给定一个字符串 `s`，找到 `s` 中最长的回文子串。你可以假设 `s` 的最大长度为 1000。

<!--more-->

**示例 1：**

```
输入: "babad"
输出: "bab"
注意: "aba" 也是一个有效答案。
```

**示例 2：**

```
输入: "cbbd"
输出: "bb"
```

### 方法一：暴力法

```java
class Solution {
    public String longestPalindrome(String s) {
        if (s == null || s.length() <= 1) {
            return s;
        }
        
        int len;
        int maxLen = 0;
        int left = 0;
        int right = 0;
        for (int i = 0; i < s.length(); i++) {
            for (int j = i; j < s.length(); j++) {
                len = j - i + 1;
                if (isPalindrome(s, i, j) && maxLen < len) {
                    maxLen = len;
                    left = i;
                    right = j;
                }
            }
        }
        return s.substring(left, right + 1);
    }

    public boolean isPalindrome(String s, int start, int end) {
        while(start < end && s.charAt(start) == s.charAt(end)) {
            start ++;
            end --;
        }
        // 当长度为奇数时，二者应该相等；当长度为偶数时，则start > end
        return start >= end;
    }
}
```

复杂度分析：时间复杂度为O(n^3)，空间复杂度为O(1)。其中，n为字符串s的长度。

### 方法二：动态规划

状态转移方程：
$$
\mathrm{dp[i][j]} = 
\begin{cases}
false, & \mathrm{s[i] \ne s[j]} \\\\
true, & \mathrm{s[i] = s[j]\ and\ j \le i + 1} \\\\
dp[i+1][j-1], &\mathrm{s[i] = s[j]\ and\ i + 2 \le j}
\end{cases}
$$

```java
class Solution {
    public String longestPalindrome(String s) {
        if (s == null || s.length() <= 1) {
            return s;
        }
        int n = s.length();
        boolean[][] dp = new boolean[n][n];

        int len;
        int maxLen = 0;
        int left = 0;
        int right = 0;
        
        for (int r = 0; r < n; r++) {
            for (int l = 0; l <= r; l++) {
                if (s.charAt(l) != s.charAt(r)) {
                    continue;
                }
                if (r - l <= 1 || dp[l + 1][r - 1]) {
                    dp[l][r] = true;
                    len = r - l + 1;
                    if (maxLen < len) {
                        maxLen = len;
                        left = l;
                        right = r;
                    } 
                }              
            }
        }
        return s.substring(left, right + 1);
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(n^2)。其中，n为字符串s的长度。

### 方法三：中心扩展法

```java
class Solution {
    public String longestPalindrome(String s) {
        if (s == null || s.length() <= 1) {
            return s;
        }
        int maxLen = 0;
        int left = 0;
        int right = 0;
        for (int i = 0; i < s.length(); i++) {
            // 假设长度为奇数：以i为中心，向左右两边扩展
            int oddLen = expandAroundCenter(s, i, i);
            // 假设长度为偶数：以i和i+1为中心，向左右两边扩展
            int evenLen = expandAroundCenter(s, i, i + 1);
            int len = Math.max(oddLen, evenLen);
            if (maxLen < len) {
                maxLen = len;
                left = i - (len - 1) / 2;
                right = i + len / 2;
            }
        }
        return s.substring(left, right + 1);
    }

    private int expandAroundCenter(String s, int left, int right) {
        while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
            left --;
            right ++;
        }
        return right - left - 1;
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(1)。其中，n为字符串s的长度。