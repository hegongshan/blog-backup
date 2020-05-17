---
title: 《剑指Offer》64.求1+2+…+n
date: 2020-03-31 17:14:17
tags: 剑指offer
categories: 剑指offer
---

求 `1+2+...+n` ，要求不能使用乘除法、for、while、if、else、switch、case等关键字及条件判断语句（A?B:C）。

<!--more-->

### 方法一：暴力法

该方法使用了**for循环**，违反了题目的要求。

```java
class Solution {
    public int sumNums(int n) {
        int sum = 0;
        for (int i = 1; i <=n; i++) {
            sum += i;
        }
        return sum;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

### 方法二：等差数列求和

该方法使用了**乘除法**，违反了题目的要求。

```java
class Solution {
    public int sumNums(int n) {
        return (n + 1) * n / 2;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(1)。

### 方法三：递归

该方法使用了**if条件判断**，违反了题目的要求。

```java
class Solution {
    public int sumNums(int n) {
        if (n == 0) {
            return 0;
        }
        return n + sumNums(n - 1);
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。

### 方法四：递归（无if）

```java
class Solution {
    public int sumNums(int n) {
        int sum = n;
        boolean flag = n > 0 && (sum += sumNums(n - 1)) > 0;
        return sum;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。