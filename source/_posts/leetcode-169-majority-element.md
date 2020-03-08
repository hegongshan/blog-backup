---
title: LeetCode 169.多数元素/《剑指Offer》39.数组中出现次数超过一半的数字
date: 2020-03-07 15:43:42
tags: array
categories: leetcode
---

给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数大于 ⌊ n/2 ⌋ 的元素。

你可以假设数组是非空的，并且给定的数组总是存在多数元素。

<!--more-->

**示例 1:**

```
输入: [3,2,3]
输出: 3
```

**示例 2:**

```
输入: [2,2,1,1,1,2,2]
输出: 2
```

### 方法一：暴力法

```java
class Solution {
   public int majorityElement(int[] nums) {
        for (int x : nums) {
            int count = 0;
            for (int y : nums) {
                if (y == x) {
                    count ++;
                }
            }
            if (count > nums.length / 2) {
                return x;
            }
        }
        return -1;
    }
}
```

复杂度分析：时间复杂度为O(n^2)，空间复杂度为O(1)。

### 方法二：排序

思路：已知多数元素出现次数大于 ⌊ n/2 ⌋ ，因此，将数组排序后，正中间的那个元素必是多数元素。

```java
class Solution {
   public int majorityElement(int[] nums) {
        Arrays.sort(nums);
        return nums[nums.length / 2];
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(1)。

### 方法三：哈希表

思路：遍历数组，使用哈希表存储每个数字的出现次数。

```java
class Solution {
   public int majorityElement(int[] nums) {
        Map<Integer,Integer> map = new HashMap<>();
        for (int x : nums) {
            if (!map.containsKey(x)) {
                map.put(x, 1);
            } else {
                map.put(x, map.get(x) + 1);           
            }
        }

        for (Map.Entry<Integer, Integer> e : map.entrySet()) {
            if (e.getValue() > nums.length / 2) {
                return e.getKey();
            }
        }
        return -1;
    }
}
```

实际上，上述操作只需要一个循环就能完成。

```java
class Solution {
   public int majorityElement(int[] nums) {
        Map<Integer,Integer> map = new HashMap<>();
        for(int x : nums) {
            int count = map.getOrDefault(x, 0) + 1;            
            if(count > nums.length / 2) {
                return x;
            } 
            map.put(x, count);
        }
        return -1;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。

### 方法四：Partition方法（快速排序）

```java
class Solution {
   public int majorityElement(int[] nums) {
        int low = 0;
        int high = nums.length - 1;
        int mid = nums.length >> 1;
        int idx = partition(nums, low, high);
        while (idx != mid) {
            if (idx < mid) {
                low = idx + 1;
            } else {
                high = idx - 1;
            }
            idx = partition(nums, low, high);
        }
        return nums[idx];
    }

    private int partition(int[] nums, int low, int high) {
        int temp = nums[low];
        while (low < high) {
            while (low < high && nums[high] >= temp) {
                high --;
            }
            nums[low] = nums[high];
            while (low < high && nums[low] < temp) {
                low ++;
            }
            nums[high] = nums[low];
        }
        nums[low] = temp;
        return low;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

### 方法五：摩尔投票法

思路：已知多数元素出现次数大于 ⌊ n/2 ⌋ ，两两相互抵消后，剩下的元素必为多数元素。

```java
class Solution {
   public int majorityElement(int[] nums) {
        int count = 0;
        int candidate = nums[0];
        for (int x : nums) {
            if (count == 0) {
                candidate = x;
            }
            if(candidate == x) {
                count ++;
            } else {
                count --;
            }
        }
        return candidate;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。