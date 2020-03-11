---
title: 《剑指Offer》50-I.第一个只出现一次的字符
date: 2020-03-17 20:30:46
tags: hash table
categories: 剑指offer
---

在字符串 s 中找出第一个只出现一次的字符。如果没有，返回一个单空格。

<!--more-->

**示例:**

```
s = "abaccdeff"
返回 "b"

s = "" 
返回 " "
```

**限制：**

0 <= s 的长度 <= 50000

### 方法一：暴力法

```java
class Solution {
    public char firstUniqChar(String s) {
        // 若直接使用字符串的charAt，空间复杂度为O(1)
        char[] cArr = s.toCharArray();
        for (int i = 0; i < cArr.length; i++) {
            // 是否只出现一次
            boolean unique = true;
            for (int j = 0; j < cArr.length; j++) {
                if (i == j) {
                    continue;
                }
                if (cArr[i] == cArr[j]) {
                    unique = false;
                    break;
                }
            }
            if(unique) {
                return cArr[i];
            }
        }
        return ' ';
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(n)。其中，n为字符串的长度。

### 方法二：哈希表

```java
class Solution {
    public char firstUniqChar(String s) {
        Map<Character, Integer> map = new HashMap<>();
        char[] cArr = s.toCharArray();
        for (char c : cArr) {
            // 下面的if...else...可简写为
            // map.put(c, map.getOrDefault(c, 0) + 1);
            if (!map.containsKey(c)) {
                map.put(c, 1);
            } else {
                map.put(c, map.get(c) + 1);
            }
        }
        for (char c : cArr) {
            if (map.get(c) == 1) {
                return c;
            }
        }
        return ' ';
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为字符串的长度。

### 方法三：有序的哈希表

```java
class Solution {
    public char firstUniqChar(String s) {
        Map<Character, Integer> map = new LinkedHashMap<>();
        char[] cArr = s.toCharArray();
        for(char c : cArr) {
            if(!map.containsKey(c)) {
                map.put(c, 1);
            } else {
                map.put(c, map.get(c) + 1);
            }
        }
        for(Map.Entry<Character, Integer> entry : map.entrySet()) {
            if(entry.getValue() == 1) {
                return entry.getKey();
            }          
        }
        return ' ';
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为字符串的长度。