---
title: LeetCode 238.除自身以外数组的乘积/《剑指Offer》66.构建乘积数组  
date: 2020-04-02 16:49:29
updated: 2020-04-02 16:49:29
tags: array
categories: leetcode
mathjax: true
---

给你一个长度为 n 的整数数组 nums，其中 n > 1，返回输出数组 output ，其中 output[i] 等于 nums 中除 nums[i] 之外其余各元素的乘积。

<!--more-->

**示例:**

```
输入: [1,2,3,4]
输出: [24,12,8,6]
```

**提示：**题目数据保证数组之中任意元素的全部前缀元素和后缀（甚至是整个数组）的乘积都在 32 位整数范围内。

**说明:** 请不要使用除法，且在 O(n) 时间复杂度内完成此题。

**进阶：**
你可以在常数空间复杂度内完成这个题目吗？（ 出于对空间复杂度分析的目的，输出数组不被视为额外空间。）

### 方法一：暴力法

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;
        int[] output = new int[n];

        int prod;
        for (int i = 0; i < n; i++) {
            prod = 1;
            for (int j = 0; j < n; j++) {
                if (i == j) {
                    continue;
                }
                prod *= nums[j];
            }
            output[i] = prod;
        }
        return output;
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(1)。

### 方法二：统计0的个数

思路：设prod为数组nums中所有非零元素的乘积。统计数组nums中0的个数。

1.如果nums中没有0，则output[i] = prod / nums[i]；

2.如果nums中有1个0，则
$$
output[i] = 
\begin{cases}
prod, & 当 \mathrm{nums[i] = 0} \\\\
0, & 否则
\end{cases}
$$
3.如果nums中有2个（及以上）0，则数组output中所有元素全为0。

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;
        int[] output = new int[n];
        
        // 计算nums中非零元素的乘积
        int prod = 1;
        // 统计nums中0的个数
        int zeroCount = 0;
        for (int i = 0; i < n; i++) {
            if (nums[i] == 0) {
                zeroCount ++;
            } else {
                prod *= nums[i];
            }
        }

        if(zeroCount == 0) {
            for (int i = 0; i < n; i++) {
                output[i] = prod / nums[i];
            }
        } else if (zeroCount == 1) {
            for (int i = 0; i < n; i++) {
                if (nums[i] == 0) {
                    output[i] = prod;
                    break;
                } 
            }
        } 
        return output;       
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

该方法虽然时间复杂度达到了题目的要求，但使用了除法运算，违反了题目说明。

### 方法三：计算左右乘积

已知：
$$
output[i] = \underbrace{nums[0] \times nums[1] \times \cdots \times nums[i-1]} \times \underbrace{nums[i+1] \times \cdots \times nums[n-1]}
$$
如果先计算出左右两边的乘积：
$$
left[i] = nums[0] \times nums[1] \times \cdots \times nums[i-1] \\\\
right[i] = nums[i+1] \times \cdots \times nums[n-1]
$$
那么，$output[i] = left[i] \times right[i]$。

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;

        int[] left = new int[n];
        int[] right = new int[n];
        int[] output = new int[n];

        // 计算左侧乘积
        left[0] = 1;
        for (int i = 1; i < n; i++) {
            left[i] = left[i - 1] * nums[i - 1];
        }
        // 计算右侧乘积
        right[n - 1] = 1;
        for (int i = n - 2; i >= 0; i--) {
            right[i] = right[i + 1] * nums[i + 1];
        }
        
        for (int i = 0; i < n; i++) {
            output[i] = left[i] * right[i];
        }
        return output; 
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。

### 方法四：原地求乘积

首先，按照从左到右的顺序，计算nums[i]左侧的乘积，并存储在output[i]中；

然后，按照从右到左的顺序，让output[i]再乘以nums[i]右侧乘积。

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;
        int[] output = new int[n];
        
        // 计算左侧乘积
        output[0] = 1;
        for (int i = 1; i < n; i++) {
            output[i] = output[i - 1] * nums[i - 1];
        }
        // 继续乘右侧乘积
        int prod = 1;
        for (int i = n - 1; i >= 0; i--) {          
            output[i] *= prod;
            prod *= nums[i];
        }
        return output;        
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。