---
title: LeetCode 264.丑数 II
date: 2019-05-03 20:19:40
tags: math
categories: leetcode
---

### 题目描述

编写一个程序，找出第 `n` 个丑数。

丑数就是只包含质因数 `2, 3, 5` 的**正整数**。

**示例:**

```
输入: n = 10
输出: 12
解释: 1, 2, 3, 4, 5, 6, 8, 9, 10, 12 是前 10 个丑数。
```

**说明:**  

1. `1` 是丑数。
2. `n` **不超过**1690。

<!--more-->

### 解决方案

**三指针法**：使用数组ugly存储所有的丑数，ugly[0] = 1。下一个丑数ugly[i]定义为丑数数组中的值乘以权重2、3和5，所得到的最小值。

（1）使用三个指针idx2、idx3、idx5，分别表示2应该乘以ugly[idx2]，3应该乘以ugly[idx3]，5应该乘以ugly[idx5]。

（2）在计算下一个丑数时，若某指针指向的丑数乘以对应的权重所得积最小，则该指针向后移动一位。

（3）应该使用三个并列的`if`让指针后移，而不能采用`if-else`。例如，丑数6，可以由丑数2乘以权重3得到，亦可以由丑数3乘以权重2得到，此时，权重2、3的指针都需要向后移一位。

```java
class Solution {
    public int nthUglyNumber(int n) {
        int[] ugly = new int[n];
        ugly[0] = 1;
        
        int idx2,idx3,idx5,a,b,c,temp;
        idx2 = idx3 = idx5 = 0;
        
        for(int i=1;i<n;i++) {
            a = 2 * ugly[idx2];
            b = 3 * ugly[idx3];
            c = 5 * ugly[idx5];
            temp = Math.min(Math.min(a,b),c);
            if(temp == a) {
                idx2++;
            } 
            if(temp == b) {
                idx3++;
            } 
            if(temp == c) {
                idx5++;
            }
            ugly[i] = temp;
        }
        return ugly[n-1];
    }
}
```

