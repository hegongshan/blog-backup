---
title: LeetCode 204.计数质数
date: 2019-05-02 18:37:33
tags: math
categories: leetcode
mathjax: true
---

### 题目描述

统计所有小于非负整数 *n* 的质数的数量。

**示例:**

```
输入: 10
输出: 4
解释: 小于 10 的质数一共有 4 个, 它们是 2, 3, 5, 7 。
```

<!--more-->

### 解决方案

#### 方法一：暴力法

逐个判断 [ 2 , n )中的每个整数，是否为质数。

```java
class Solution {
    public int countPrimes(int n) {
        int count = 0;
        for(int i = 2; i < n; i++) {
            if(isPrime(i)) {
                count++;
            }
        }
        return count;
    }
    public boolean isPrime(int x) {
        if(x == 2 || x == 3) {
            return true;
        }
        for(int i = 2; i <= Math.sqrt(x); i++) {
            if(x % i == 0) {
                return false;
            }
        }
        return true;
    }
}
```

该方法的时间复杂度为$O(n\sqrt{n})$。

由于本题有几个较大的测试用例，如1500000，采用暴力法会超时。

#### 方法二：埃氏筛法

埃拉托色尼筛选法(the Sieve of Eratosthenes)，简称埃氏筛法，其主要思想：当某个数为素数时，那么这个数的倍数一定不是素数。

```java
class Solution {
    public int countPrimes(int n) {
        int count = 0;
        boolean[] isPrime = new boolean[n];
        for(int i = 0; i < isPrime.length; i++) {
            isPrime[i] = true;
        }
        for(int i = 2; i < n; i++) {
            if(isPrime[i]) {
                for(int j = 2; i * j < n; j++) {
                    isPrime[i * j] = false;
                }
                count++;
            }
        }
        return count;
    }   
}
```

该方法的时间复杂度为$O(n\log{\log{n}})$。

#### 方法三：欧式筛法

在埃氏筛选法中，每一个非素数（合数）可能会有多次判断，例如，12，被2 * 6判定为非素数，亦会被3 * 4判定为非素数。

为了去除这种重复的判断，只使用一个数的**最小质因数（能整除给定正整数的最小的质数）**来排除该数字，这就是欧式筛选法。

```java
class Solution {
    public int countPrimes(int n) {
        int count = 0;
        // 除2以外的偶数，必定为合数
        int[] prime = new int[n / 2];
        boolean[] isPrime = new boolean[n];
        for(int i = 0; i < isPrime.length; i++) {
            isPrime[i] = true;
        }
        for(int i = 2; i < n; i++) {
            if(isPrime[i]) {
                prime[count++] = i;
            }
            // 遍历当前找到的所有素数
            for(int j = 0; j < count && i * prime[j] < n; j++) {
                isPrime[i * prime[j]] = false;
                // 第一个满足条件i % prime[j] == 0的prime[j]，就是i的最小质因数
                // 保证i只被其最小质因数排除
                if(i % prime[j] == 0) {
                    break;
                }
            }
        }
        return count;
    }   
}
```

该方法的时间复杂度为$O(n)$。