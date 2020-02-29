---
title: Leetcode 65.有效的数字/《剑指Offer》20.表示数值的字符串
date: 2020-02-27 18:07:29
tags: string
categories: leetcode
---

验证给定的字符串是否可以解释为十进制数字。

<!--more-->

例如:

```
"0" => true
" 0.1 " => true
"abc" => false
"1 a" => false
"2e10" => true
" -90e3   " => true
" 1e" => false
"e3" => false
" 6e-1" => true
" 99e2.5 " => false
"53.5e93" => true
" --6 " => false
"-+3" => false
"95a54e53" => false
```

说明: 我们有意将问题陈述地比较模糊。在实现代码之前，你应当事先思考所有可能的情况。这里给出一份可能存在于有效十进制数字中的字符列表：

* 数字 0-9
* 指数 - "e"
* 正/负号 - "+"/"-"
* 小数点 - "."

当然，在输入中，这些字符的上下文也很重要。

<!--more-->

### 问题分析

数值有以下两种模式：

* `A[.[B]][e|EC]`。
* `[+|-].B[e|EC]`。

其中，A表示数值的整数部分，B表示数值的小数部分，C表示数值的指数部分。

A和C是有符号整数，它们的前面可能存在正负号，也可能没有；B是无符号整数，它的前面没有正负号。

显然，A和B至少要有一个存在。

### 方法一：正则表达式

```java
class Solution {
    public boolean isNumber(String s) {
        if(s == null || (s = s.trim()).isEmpty()) {
            return false;
        }
        String regex = "[+-]?(\\d+(\\.\\d*)?|\\.\\d+)([eE][+-]?\\d+)?";
        return s.matches(regex);
    }
}
```

### 方法二：直接法

```java
class Solution {
    private int i;
    public boolean isNumber(String s) {
        if(s == null || (s = s.trim()).isEmpty()) {
            return false;
        }

        i = 0;
        boolean hasA = hasInteger(s);
      
        boolean hasB = false;
        if(i < s.length() && s.charAt(i) == '.') {
            i++;
            hasB = hasUnsignedInteger(s);
        }
        
        if(i < s.length() && (s.charAt(i) == 'e' || s.charAt(i) == 'E')) {
            i++;
            // 若e/E的后面没有数字，则该字符串不能表示数字
            boolean hasC = hasInteger(s);
            if(!hasC) {
                return false;
            }  
        }
        // A和B至少要有一个存在，否则无法表示数字
        return i == s.length() && (hasA || hasB);
    }

    // 是否存在无符号整数
    public boolean hasUnsignedInteger(String s) {
        int start = i;
        while(i < s.length() && '0' <= s.charAt(i) && s.charAt(i) <= '9') {
            i++;
        }
        return i > start;
    }

    // 是否存在有符号整数
    public boolean hasInteger(String s) {
        if(i < 0 || i >= s.length()) {
            return false;
        }
        char c = s.charAt(i);
        if(c == '+' || c == '-') {
            i++;
        }
        return hasUnsignedInteger(s);
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。





