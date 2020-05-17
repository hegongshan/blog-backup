---
title: 《剑指Offer》58-II.左旋转字符串
date: 2020-03-24 18:05:32
updated: 2020-03-24 18:05:32
tags: string
categories: 剑指offer
---

字符串的左旋转操作是把字符串前面的若干个字符转移到字符串的尾部。请定义一个函数实现字符串左旋转操作的功能。比如，输入字符串"abcdefg"和数字2，该函数将返回左旋转两位得到的结果"cdefgab"。

<!--more-->

### 方法一：暴力法

思路：每次向左移动一位，循环执行n次。

```java
class Solution {
    public String reverseLeftWords(String s, int n) {
        if (s == null || s.isEmpty() || n <= 0 || n >= s.length()) {
            return s;
        }
        char[] cArr = s.toCharArray();
        for (int i = 0; i < n; i++) {
            char c = cArr[0];
            for (int j = 0; j < cArr.length - 1; j++) {
                cArr[j] = cArr[j + 1];
            }
            cArr[cArr.length - 1] = c;
        }
        return new String(cArr);
    }
}
```

复杂度分析：时间复杂度为O(n × k)，空间复杂度为O(k)。其中，k为字符串的长度。

### 方法二：拼接法

思路：创建一个数组cArr。先将字符串s的后k - n依次放入数组中，再将前n位依次放入数组中。

复杂度分析：时间复杂度和空间复杂度均为O(k)。其中，k为字符串的长度。

#### 两次循环

```java
class Solution {
    public String reverseLeftWords(String s, int n) {
        if (s == null || s.isEmpty() || n <= 0 || n >= s.length()) {
            return s;
        }
        char[] cArr = new char[s.length()];
        int idx = 0;
        for (int i = n; i < cArr.length; i++) {
            cArr[idx++] = s.charAt(i);
        }
        for (int i = 0; i < n; i++) {
            cArr[idx++] = s.charAt(i);
        }
        return new String(cArr);
    }
}
```

#### 使用substring

```java
class Solution {
    public String reverseLeftWords(String s, int n) {
        if (s == null || s.isEmpty() || n <= 0 || n >= s.length()) {
            return s;
        }
        return s.substring(n) + s.substring(0, n);
    }
}
```

#### 使用取模运算

```java
class Solution {
    public String reverseLeftWords(String s, int n) {
        if (s == null || s.isEmpty() || n <= 0 || n >= s.length()) {
            return s;
        }
        int len = s.length();
        char[] cArr = new char[len];
        for (int i = 0; i < len; i++) {
            cArr[i] = s.charAt((n + i) % len);
        }
        return new String(cArr);
    }
}
```

### 方法三：三次反转

思路：参考[PAT乙级 1008.数组元素循环右移问题](/2019/03/15/pat-basic-1008/)

```java
class Solution {
    public String reverseLeftWords(String s, int n) {
        if(s == null || s.isEmpty() || n <= 0 || n >= s.length()) {
            return s;
        }
        char[] cArr = s.toCharArray();
        reverseRange(cArr, 0, n - 1);
        reverseRange(cArr, n, cArr.length - 1);
        reverseRange(cArr, 0, cArr.length - 1);
        return new String(cArr);
    }
    // 将数组cArr下标在[start, end]区间内的元素反转
    private void reverseRange(char[] cArr, int start, int end) {
        char temp;
        while (start < end) {
            temp = cArr[start];
            cArr[start] = cArr[end];
            cArr[end] = temp;
            start++;
            end--;
        }
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(k)。其中，k为字符串的长度。