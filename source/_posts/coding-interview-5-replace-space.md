---
title: 《剑指offer》5.替换空格
date: 2020-02-13 22:19:35
tags: string
categories: 剑指offer
---

请实现一个函数，将一个字符串中的每个空格替换成“%20”。

例如，当字符串为We Are Happy.则经过替换之后的字符串为We%20Are%20Happy。

<!--more-->

### 方法一：使用自带方法

```java
class Solution {
    public String replaceSpace(StringBuffer str) {
        return str.toString().replace(" ", "%20");
    }
}
```

### 方法二：创建新字符串

新建StringBuilder，然后逐一append。

```java
class Solution {
    public String replaceSpace(StringBuffer str) {
        StringBuilder sb = new StringBuilder();
        for(int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            if(c == ' ') {
                sb.append("%20");
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}
```

时间复杂度为O(n)，空间复杂度为O(n)。

### 方法三：原地替换

1.统计字符串中空格的个数space；

2.对原字符串进行扩容，长度增加2 * space；

3.从后往前替换空格。

```java
class Solution {
    public String replaceSpace(StringBuffer str) {
        // 1.判断是否为空
        if(str == null || str.length() == 0) {
            return str.toString();
        }
        
        // 2.统计空格的个数
        int space = 0;
        for(int i = 0; i < str.length(); i++) {
            if(str.charAt(i) == ' ') {
                space ++;
            }
        }

        // 3.扩容，长度增加 2*space
        int left = str.length() - 1;
        int right = left + 2 * space;
        str.setLength(right + 1);
        
        // 4.原地替换空格
        while(0 <= left && left <= right) {
            if(str.charAt(left) != ' ') {
                str.setCharAt(right--, str.charAt(left));
            } else {
                str.setCharAt(right--, '0');
                str.setCharAt(right--, '2');
                str.setCharAt(right--, '%');
            }
            left --;
        }
        return str.toString();
    }
}
```

时间复杂度为O(n)，空间复杂度为O(n)。