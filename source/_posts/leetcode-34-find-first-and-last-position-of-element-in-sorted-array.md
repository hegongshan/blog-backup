---
title: LeetCode 34.在排序数组中查找元素的第一个和最后一个位置/《剑指Offer》53-I.在排序数组中查找数字
date: 2020-03-19 21:26:21
tags: binary search
categories: leetcode
---

给定一个按照升序排列的整数数组 nums，和一个目标值 target。找出给定目标值在数组中的开始位置和结束位置。

你的算法时间复杂度必须是 O(log n) 级别。

如果数组中不存在目标值，返回 [-1, -1]。

<!--more-->

**示例 1:**

```
输入: nums = [5,7,7,8,8,10], target = 8
输出: [3,4]
```

**示例 2:**

```
输入: nums = [5,7,7,8,8,10], target = 6
输出: [-1,-1]
```

### 方法一：暴力法

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int[] range = new int[]{-1, -1};
        int i = 0;
        while (i < nums.length && nums[i] < target) {
            i++;
        }
        if (i == nums.length || nums[i] > target) {
            return range;
        }
        range[0] = i;
        while (i < nums.length && nums[i] == target) {
            i++;
        }
        range[1] = i - 1;
        return range;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

### 方法二：一次二分查找

思路：首先，利用二分查找，寻找target在数组中的某一个位置mid。

然后，以该位置为基准，向左右两边分别寻找target在数组中的开始位置和结束位置。

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int low = 0;
        int high = nums.length - 1;
        int mid = (low + high) >> 1;
        while (low <= high) {
            mid = (low + high) >> 1;
            if (nums[mid] == target) {
                break;
            } 
            if (nums[mid] < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        if (low > high) {
            return new int[]{-1, -1};
        }
        int first = mid;
        while (first >= 0 && nums[first] == target) {
            first--;
        }
        int last = mid;
        while (last < nums.length && nums[last] == target) {
            last++;
        }
        return new int[]{first + 1, last - 1};
    }
}
```

复杂度分析：时间复杂度为O(k + log n)，空间复杂度为O(1)。其中，k为target在数组中出现的次数。

### 方法三：两次二分查找

思路：对数组执行两次二分查找，分别寻找target在数组中的开始位置和结束位置。

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int low = binarySearch(nums, target, true);
        int high = binarySearch(nums, target, false);
        if (low > high) {
            return new int[]{-1, -1};
        }
        return new int[]{low, high};
    }

    public int binarySearch(int[] nums, int target, boolean left) {
        int low = 0;
        int high = nums.length - 1;
        int mid = (low + high) >> 1;
        while (low <= high) {
            mid = (low + high) >> 1;
            if (nums[mid] < target) {
                low = mid + 1;
            } else if(nums[mid] > target) {
                high = mid - 1;
            } else {
                if (left) {
                    high --;
                } else {
                    low ++;
                }
            }
        }
        return left ? low : high;
    }
}
```

复杂度分析：时间复杂度为O(log n)，空间复杂度为O(1)。