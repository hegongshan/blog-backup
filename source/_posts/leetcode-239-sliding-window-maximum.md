---
title: LeetCode 239./《剑指Offer》59-I.滑动窗口最大值
date: 2020-03-25 17:58:47
tags: sliding-window
categories: leetcode
---

给定一个数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。返回滑动窗口中的最大值。

<!--more-->

**进阶：**你能在线性时间复杂度内解决此题吗？

**示例:**

```
输入: nums = [1,3,-1,-3,5,3,6,7], 和 k = 3
输出: [3,3,5,5,6,7] 
解释: 

  滑动窗口的位置                最大值
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```

**提示：**

- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `1 <= k <= nums.length`

### 方法一：暴力法

```java
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        if (nums == null || nums.length <= 1 || k <= 1) {
            return nums;
        }
        
        int max;
        int[] result = new int[nums.length - k + 1];
        
        for (int i = 0; i < result.length; i++) {
            max = nums[i];
            for (int j = i; j < i + k; j++) {
                max = Math.max(max, nums[j]);
            }
            result[i] = max;
        }
        return result;
    }
}
```

复杂度分析：时间复杂度为O(n × k)，空间复杂度为O(n)。