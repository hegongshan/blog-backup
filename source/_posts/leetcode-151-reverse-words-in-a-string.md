---
title: LeetCode 151.翻转字符串里的单词/《剑指Offer》58-I.翻转单词顺序
date: 2020-03-24 17:33:05
updated: 2020-03-24 17:33:05
tags: string
categories: leetcode
---

给定一个字符串，逐个翻转字符串中的每个单词。

<!--more-->

**示例 1：**

```
输入: "the sky is blue"
输出: "blue is sky the"
```

**示例 2：**

```
输入: "  hello world!  "
输出: "world! hello"
解释: 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
```

**示例 3：**

```
输入: "a good   example"
输出: "example good a"
解释: 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。
```

### 问题分析

首先，按照空格分割字符串，得到单词序列；

然后，按照从后往前的顺序，将所有的单词依次拼接在一起，单词之间用一个空格隔开。

### 方法一：使用库函数分割

```java
class Solution {
    public String reverseWords(String s) {
        if (s == null || s.isEmpty()) {
            return s;
        }
        // 注意去掉首尾的空格，否则，分割以后可能会出现空串
        String[] sArr = s.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = sArr.length - 1; i >= 0; i--) {
            sb.append(sArr[i]);
            if (i > 0) {
                sb.append(' ');
            }
        }
        return sb.toString();
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为字符串的长度。

### 方法二：手动分割

```java
class Solution {
    public String reverseWords(String s) {
        if (s == null || s.isEmpty()) {
            return s;
        }
        
        StringBuilder sb = new StringBuilder();
        int start = s.length() - 1;
        int end = start + 1;
        while (start >= 0) {
            // 去掉多余的空格
            while(start >=0 && s.charAt(start) == ' ') {
                start --;
            }
            // 如果字符串已经遍历完了（字符串的前面可能存在多余的空格）
            if (start < 0) {
                break;
            }
            // 记录单词的结束索引
            end = start + 1;
            // 寻找单词的起始索引
            while (start >= 0 && s.charAt(start) != ' ') {
                start --;
            }
            // 如果有单词
            if (start + 1 < end) {
                sb.append(s.substring(start + 1, end)).append(' ');
            }
        }
        // 如果字符串中有单词，则删除末尾多出的空格
        if (sb.length() > 0) {
            sb.deleteCharAt(sb.length() - 1);
        }
        return sb.toString();
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为字符串的长度。

