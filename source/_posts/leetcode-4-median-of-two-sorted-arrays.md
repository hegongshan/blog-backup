---
title: LeetCode 4.寻找两个有序数组的中位数
date: 2020-04-12 21:41:19
tags: 
categories: leetcode
---

给定两个大小为 m 和 n 的有序数组 nums1 和 nums2。

请你找出这两个有序数组的中位数，并且要求算法的时间复杂度为 O(log(m + n))。

你可以假设 nums1 和 nums2 不会同时为空。

<!--more-->

**示例 1:**

```
nums1 = [1, 3]
nums2 = [2]

则中位数是 2.0
```

**示例 2:**

```
nums1 = [1, 2]
nums2 = [3, 4]

则中位数是 (2 + 3)/2 = 2.5
```

### 方法一：归并

```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        // 合并两个有序数组
        int[] arr = merge(nums1, nums2);
        // 如果数组的长度为奇数，则中位数为正中间那个数
        if ((arr.length & 0x1) == 1) {
            return arr[arr.length >> 1];
        }
        // 如果数组的长度为偶数，则中位数为中间两个数的平均值
        return (arr[(arr.length >> 1) - 1] + arr[arr.length >> 1]) / 2.0;
    }

    public int[] merge(int[] nums1, int[] nums2) {
        int[] arr = new int[nums1.length + nums2.length];
        int i = 0, j = 0, k = 0;
        while (i < nums1.length && j < nums2.length) {
            if (nums1[i] <= nums2[j]) {
                arr[k++] = nums1[i++];
            } else {
                arr[k++] = nums2[j++];
            }
        }
        while (i < nums1.length) {
            arr[k++] = nums1[i++];
        }
        while (j < nums2.length) {
            arr[k++] = nums2[j++];
        }
        return arr;
    }
} 
```

复杂度分析：时间复杂度和空间复杂度均为O(m + n)。

