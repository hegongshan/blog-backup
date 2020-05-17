---
title: 《剑指Offer》17.打印从1到最大的n位数
date: 2020-02-24 17:28:07
tags: 剑指offer
categories: 剑指offer
mathjax: true
---

输入数字 `n`，按顺序打印出从 1 到最大的 n 位十进制数。比如输入 3，则打印出 1、2、3 一直到最大的 3 位数 999。

<!--more-->

### 方法一：不考虑大数问题

假设最大的n位数没有超过int的存储范围。

```java
class Solution {
    public void printNumbers(int n) {
        if (n <= 0) {
            return;
        }
        int number = 1;
        int len = 0;
        while (len < n) {
            number *= 10;
            len++;
        }

        for (int i = 1; i < number; i++) {
            System.out.println(i);
        }
    }
}
```

上述方法在计算最大的n位数时，需要进行n次循环，我们可以使用缓存来优化该操作：

```java
class Solution {
    public void printNumbers(int n) {
        if (n <= 0) {
            return;
        }
        int[] arr = { 9, 99, 999, 9999, 99999, 999999, 9999999, 99999999, 999999999, Integer.MAX_VALUE };
        for (int i = 1; i <= arr[n - 1]; i++) {
            System.out.println(i);
        }
    }
}
```

复杂度分析：时间复杂度为$O(10^n)$，空间复杂度为O(1)。

### 方法二：模拟加法

```java
import java.util.Arrays;

class Solution {
    public void printNumbers(int n) {
        if (n <= 0) {
            return;
        }
        char[] cArr = new char[n];
        Arrays.fill(cArr, '0');
        while (addOne(cArr)) {
            int startIdx = numberOfLeadingZero(cArr);
            System.out.println(new String(cArr, startIdx, cArr.length - startIdx));
        }
    }
    // 第一个非零元素所在的索引（前导0的个数）
    public int numberOfLeadingZero(char[] cArr) {
        for (int i = 0; i < cArr.length; i++) {
            if (cArr[i] > '0') {
                return i;
            }
        }
        return -1;
    }
    // 模拟加法操作
    public boolean addOne(char[] cArr) {
        // 进位
        int carry = 1;
        for (int i = cArr.length - 1; i >= 0; i--) {
            int val = cArr[i] - '0' + carry;
            carry = val / 10;
            // 若没有进位
            if (carry == 0) {
                cArr[i] = (char) (val + '0');
                break;
            }
            val %= 10;
            cArr[i] = (char) (val + '0');
        }
        // 判断是否溢出
        return carry == 0;
    }
}
```

复杂度分析：时间复杂度为$O(n \times 10^n)$，空间复杂度为O(n)。

### 方法三：递归

```java
class Solution {
    public void printNumbers(int n) {
        if (n <= 0) {
            return;
        }
        char[] cArr = new char[n];
        printNumbers(cArr, 0);
    }

    public void printNumbers(char[] cArr, int idx) {
        if (idx == cArr.length) {
            int startIdx = numberOfLeadingZero(cArr);
            // 排除全为0的情况
            if (startIdx != -1) {
                System.out.println(new String(cArr, startIdx, cArr.length - startIdx));
            }
            return;
        }
        for (int i = 0; i < 10; i++) {
            cArr[idx] = (char) (i + '0');
            printNumbers(cArr, idx + 1);
        }
    }

    public int numberOfLeadingZero(char[] cArr) {
        for (int i = 0; i < cArr.length; i++) {
            if (cArr[i] > '0') {
                return i;
            }
        }
        return -1;
    }
}
```

复杂度分析：时间复杂度为$O(10^n)$，空间复杂度为O(n)。