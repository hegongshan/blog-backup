---
title: LeetCode 154.寻找旋转排序数组中的最小值 II/《剑指Offer》11.旋转数组的最小数字
date: 2020-02-19 21:13:57
tags: binary-search
categories: leetcode
---

假设按照升序排序的数组在预先未知的某个点上进行了旋转。

( 例如，数组 [0,1,2,4,5,6,7] 可能变为 [4,5,6,7,0,1,2] )。

请找出其中最小的元素。

注意数组中可能存在重复的元素。

<!--more-->

**示例 1：**

```
输入: [1,3,5]
输出: 1
```

**示例 2：**

```
输入: [2,2,2,0,1]
输出: 0
```

### 方法一：暴力查找

思路：从前往后遍历一次数组，查找数组中的最小元素。

```java
class Solution {
    public int minArray(int[] numbers) {
        int min = numbers[0];
        for(int i = 1; i < numbers.length; i++) {
            if(numbers[i] < min) {
                min = numbers[i];
            }
        }
        return min;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(1)。

### 方法二：

思路：旋转后的数组以最小元素为界，被分割为两个有序（递增）区域。

除了最小元素和它的前一个元素外，数组中相邻的两个结点x和y，满足x <= y。

```java
class Solution {
    public int minArray(int[] numbers) {        
        for(int i = 0; i < numbers.length - 1; i++) {
            if(numbers[i] > numbers[i + 1]) {
                return numbers[i + 1];
            }
        }
        // 若数组没有被旋转，如示例1
        return numbers[0];
    }
}
```

时间复杂度为O(n)，空间复杂度为O(1)。

### 方法三：二分查找

```java
class Solution {
    public int minArray(int[] numbers) {
        int low = 0;
        int high = numbers.length - 1;
        int mid = low;
        while(low < high) {
            mid = (low + high) / 2;
            if(numbers[mid] > numbers[high]) {
                low = mid + 1;
            } else if(numbers[mid] < numbers[high]) {
                high = mid;
            } else {
                high --;
            }
        }
        return numbers[low];
    }
}
```

时间复杂度为O(log n)，空间复杂度为O(1)。