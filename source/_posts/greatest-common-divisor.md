---
title: 最大公约数与最小公倍数
date: 2020-04-07 21:46:23
tags: algorithm
categories: algorithm
mathjax: true
---

晚上，网易笔试考察了求解n个数的最大公约数。

<!--more-->

### 问题引出

我当时的思路是：先寻找n个数的最小值min，然后从2~min，逐一判断是否为这n个数的公约数，这些公约数的最大值即为这n个数的最大公约数。该算法的时间复杂度为O(min × n)，因此只通过了20%的测试用例。

事实上，可以将“求n个数的最大公约数”转换为“求2个数的最大公约数”。

### 最大公约数

最大公约数（Greatest Common Divisor，简称GCD）。

#### 更相减损术

更相减损术，源自于《九章算术》，其原文如下：

> 可半者半之，不可半者，副置分母、子之数，以少减多，更相减损，求其等也。以等数约之。

大意是：假设有两个正整数a和b，如果a和b都是偶数，则同除以2，并将结果乘以2；

否则，比较a和b的大小，用较大者减去较小者，接着将所得的差与较小的数进行比较，并以大数减去小数。

循环执行这个过程，直到减数和差相等为止。这个相等的数就是最大公约数。

```java
public static int gcd(int a, int b) {
    // 求其等也
    if (a == b) {
        return a;
    }
    // 可半者半之
    if (a % 2 == 0 && b % 2 == 0) {
        return gcd(a / 2, b / 2) * 2;
    }
    // 不可半者，副置分母、子之数，以少减多，更相减损
    if (a > b) {
        return gcd(a - b, b);
    }
    return gcd(b - a, a);
}
```

#### Stein算法

Stein算法：若两个数都为偶数，则同除以2，结果乘以2；若为一奇一偶，则偶数除以2，结果不变；若为两个奇数才相减。

```java
public static int gcd(int a, int b) {
    if (a == b) {
        return a;
    }
    // 如果a和b均为偶数
    if (a % 2 == 0 && b % 2 == 0) {
        return gcd(a / 2, b / 2) * 2;
    }
    // 如果a为偶数
    if (a % 2 == 0) {
        return gcd(a / 2, b);
    }
    // 如果b为偶数
    if (b % 2 == 0) {
        return gcd(a, b / 2);
    }
    // 如果a和b均为奇数
    if (a > b) {
        return gcd(a - b, b);
    }
    return gcd(b - a, a);
}
```

可以使用位运算来优化取模运算：

```java
public static int gcd(int a, int b) {
    if (a == b) {
        return a;
    }
    // 如果a和b均为偶数
    if ((a & 0x1 == 0) && (b & 0x1 == 0)) {
        return gcd(a >> 1, b >> 1) << 1;
    }
    // 如果a为偶数
    if (a & 0x1 == 0) {
        return gcd(a >> 1, b);
    }
    // 如果b为偶数
    if (b & 0x1 == 0) {
        return gcd(a, b >> 1);
    }
    // 如果a和b均为奇数
    if (a > b) {
        return gcd(a - b, b);
    }
    return gcd(b - a, a);
}
```

#### 辗转相除法

辗转相除法，又叫欧几里德算法，主要思想是：假设有两个正整数a与b，它们的最大公约数等于b与a % b的最大公约数，即gcd(a, b) = gcd(b, a mod b)，循环执行上述过程，直到余数为0。

```java
public static int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}
```

####  求n个数的最大公约数

```java
public static int gcd(int[] arr) {
    if (arr == null) {
        throw new NullPointerException("数组不允许为空");
    }
    if (arr.length <= 1) {
        throw new IllegalArgumentException("数组的长度必须>=2");
    }
    int result = arr[0];
    for (int i = 1; i < arr.length; i++) {
        result = gcd(result, arr[i]);
    }
    return result;
}
```

### 最小公倍数

最小公倍数（Least Common Multiple，简称LCM）。

假设有两个整数a和b，它们的最大公约数为gcd，最小公倍数为lcm，则
$$
a = gcd \times x \\\\
b = gcd \times y \tag{1}
$$
从而有：
$$
a \times b = {gcd}^2 \times x \times y \\\\
lcm = gcd \times x \times y \tag{2}
$$
故：
$$
lcm = \frac{a \times b}{gcd} \tag{3}
$$
根据公式（3），我们可以将求两个数的最小公倍数，转换为求它们的最大公约数。

```java
public static int lcm(int a, int b) {
    int numerator = a * b;
    int denominator = gcd(a, b);
    return numerator / denominator;
}
```

### 参考资料

* [更相减损术](https://baike.baidu.com/item/更相减损术/449183)

* [辗转相除法](https://baike.baidu.com/item/欧几里得算法/1647675)
* [最小公倍数](https://baike.baidu.com/item/最小公倍数)