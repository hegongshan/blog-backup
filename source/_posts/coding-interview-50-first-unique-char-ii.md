---
title: 《剑指Offer》50-II.字符流中第一个不重复的字符
date: 2020-03-17 22:29:52
tags: hash table
categories: 剑指offer
---

请实现一个函数用来找出字符流中第一个只出现一次的字符。例如，当从字符流中只读出前两个字符"go"时，第一个只出现一次的字符是"g"。当从该字符流中读出前六个字符“google"时，第一个只出现一次的字符是"l"。

<!--more-->

如果当前字符流没有存在出现一次的字符，返回#字符。

### 方法一：有序的哈希表

```java
import java.util.Map;
import java.util.LinkedHashMap;

public class Solution {
    //Insert one char from stringstream
    private Map<Character, Integer> map = new LinkedHashMap<>();
    public void Insert(char ch) {
        map.put(ch, map.getOrDefault(ch, 0) + 1);
    }
    //return the first appearence once char in current stringstream
    public char FirstAppearingOnce() {       
        for (Map.Entry<Character, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 1) {
                return entry.getKey();
            }
        }
        return '#';
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为字符串的长度。

### 方法二：两个数组

思路：使用两个数组，一个用于存储每个字符出现的次数，另一个按照字符出现的顺序依次存储每个字符。

```java
public class Solution {
    //Insert one char from stringstream
    // 1.hash用于存储每个字符的出现次数
    private int[] cnt = new int[256];
    // 2.按照出现的顺序依次存储每个字符
    private StringBuilder sb = new StringBuilder();
    public void Insert(char ch) {
        cnt[ch] += 1;
        sb.append(ch);
        
    }
    //return the first appearence once char in current stringstream
    public char FirstAppearingOnce() {
        for (int i = 0; i < sb.length(); i++) {
            char c = sb.charAt(i);
            if (cnt[c] == 1) {
                return c;
            }
        }
        return '#';
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为字符串的长度。

### 方法三：一个数组

```java
import java.util.Arrays;

public class Solution {
    //Insert one char from stringstream
    // pos用于存储每个字符首次出现的位置,初始值设为-1
    // 若某个字符出现次数超过了1次，则将值设置为-2
    private int[] pos = new int[256];
    private int index = 0;
    public Solution() {
        Arrays.fill(pos, -1);
    }
    public void Insert(char ch) {
        // 首次出现
        if (pos[ch] == -1) {
            pos[ch] = index;
        } else if (pos[ch] >= 0) {
            // 出现次数超过1次
            pos[ch] = -2;
        }
        index++;
    }
    //return the first appearence once char in current stringstream
    public char FirstAppearingOnce() {
        char c = '#';
        int minIndex = Integer.MAX_VALUE;
        for (int i = 0; i < pos.length; i++) {
            // 寻找第一个只出现一次的字符
            if (pos[i] >= 0 && pos[i] < minIndex) {
                minIndex = pos[i];
                c = (char) i;
            }
        }
        return c;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(1)，与输入规模n无关。

