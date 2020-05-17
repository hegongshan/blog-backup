---
title: LeetCode 10./《剑指Offer》19.正则表达式匹配
date: 2020-02-26 17:02:37
tags: string
categories: leetcode
---

给你一个字符串 s 和一个字符规律 p，请你来实现一个支持 '.' 和 '*' 的正则表达式匹配。

```
'.' 匹配任意单个字符
'*' 匹配零个或多个前面的那一个元素
```

所谓匹配，是要涵盖 **整个** 字符串 s的，而不是部分字符串。

<!--more-->

**说明:**

* s 可能为空，且只包含从 a-z 的小写字母。
* p 可能为空，且只包含从 a-z 的小写字母，以及字符 . 和 *。

**示例 1:**

```java
输入:
s = "aa"
p = "a"
输出: false
解释: "a" 无法匹配 "aa" 整个字符串。
```

**示例 2:**

```
输入:
s = "aa"
p = "a*"
输出: true
解释: 因为 '*' 代表可以匹配零个或多个前面的那一个元素, 在这里前面的元素就是 'a'。因此，字符串 "aa" 可被视为 'a' 重复了一次。
```

**示例 3:**

```
输入:
s = "ab"
p = ".*"
输出: true
解释: ".*" 表示可匹配零个或多个（'*'）任意字符（'.'）。
```

**示例 4:**

```
输入:
s = "aab"
p = "c*a*b"
输出: true
解释: 因为 '*' 表示零个或多个，这里 'c' 为 0 个, 'a' 被重复一次。因此可以匹配字符串 "aab"。
```

**示例 5:**

```
输入:
s = "mississippi"
p = "mis*is*p*."
输出: false
```

### 方法一：使用库函数

```java
class Solution {
    public boolean isMatch(String s, String p) {
        return s.matches(p);
    }
}
```

### 方法二：回溯

```java
class Solution {
    public boolean isMatch(String s, String p) {
        // 若s与p相等
        if (s == p || (s != null && s.equals(p))) {
            return true;
        }
        return isMatch(s, p, 0, 0);
    }

    public boolean isMatch(String s, String p, int i, int j) {
        if (j == p.length()) {
            return i == s.length();
        }
        // 当前字符是否匹配
        boolean isCurrentCharMatch = i < s.length() &&  (
            s.charAt(i) == p.charAt(j) || p.charAt(j) == '.');
        // 如果p的下一个字符为*
        if (j < p.length() - 1 && p.charAt(j + 1) == '*') {
            // 若当前字符不匹配，则跳过通配符*
            if(!isCurrentCharMatch) {
                return isMatch(s, p, i, j + 2);
            }
            // 匹配0次或多次 
            return isMatch(s, p, i, j + 2) || isMatch(s, p, i + 1, j);
        }
        return isCurrentCharMatch && isMatch(s, p, i + 1, j + 1);
    }
}
```



