---
title: LeetCode 137.只出现一次的数字 II/《剑指Offer》56-II.数组中数字出现的次数
date: 2020-03-22 18:15:05
tags: 位运算
categories: leetcode
---

给定一个**非空**整数数组，除了某个元素只出现一次以外，其余每个元素均出现了三次。找出那个只出现了一次的元素。

<!--more-->

**说明：**

你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

**示例 1:**

```
输入: [2,2,3,2]
输出: 3
```

**示例 2:**

```
输入: [0,1,0,1,0,1,99]
输出: 99
```

### 方法一：排序

```java
class Solution {
    public int singleNumber(int[] nums) {
        Arrays.sort(nums);
        int i = 0;
        while(i < nums.length - 2 && nums[i] == nums[i+1] && nums[i] == nums[i+2]) {
            i += 3;
        }
        return nums[i];
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(1)。其中，n为数组的长度。

### 方法二：哈希表

```java
class Solution {
    public int singleNumber(int[] nums) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int x : nums) {
            map.put(x, map.getOrDefault(x, 0) + 1);
        }
        for (int x : nums) {
            if (map.get(x) == 1) {
                return x;
            }
        }
        return 0;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

### 方法三：求和

```java
class Solution {
    public int singleNumber(int[] nums) {
        Set<Integer> set = new HashSet<>();
        long uniqueSum = 0L, sum = 0L;
        for (int x : nums) {
            if (!set.contains(x)) {
                set.add(x);
                uniqueSum += x;
            }
            sum += x;
        }
        return (int) ((3 * uniqueSum - sum) >> 1);
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

