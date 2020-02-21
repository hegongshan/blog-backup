---
title: LeetCode 287.寻找重复数/《剑指Offer》3.数组中重复的数字
date: 2020-02-10 21:24:13
tags: array
categories: leetcode
---

给定一个包含 n + 1 个整数的数组 nums，其数字都在 1 到 n 之间（包括 1 和 n），可知至少存在一个重复的整数。假设只有一个重复的整数，找出这个重复的数。

<!--more-->

示例 1:

```
输入: [1,3,4,2,2]
输出: 2
```

示例 2:

```
输入: [3,1,3,4,2]
输出: 3
```

说明：

1. 不能更改原数组（假设数组是只读的）。
2. 只能使用额外的 O(1) 的空间。
3. 时间复杂度小于 O(n^2) 。
4. 数组中只有一个重复的数字，但它可能不止重复出现一次。

### 方法一：排序

```python
class Solution:
    def findDuplicate(self, nums: List[int]) -> int:
        nums.sort()
        for i in range(1, len(nums)):
            if nums[i - 1] == nums[i]:
                return nums[i]
```

时间复杂度为O(n log n)，空间复杂度为O(1)。

该方法改变了数组，违反了说明1。

### 方法二：哈希表

字典

```python
class Solution:
    def findDuplicate(self, nums: List[int]) -> int:
        lookup = {}
        for x in nums:
            if x in lookup.keys():
                return x
            lookup[x] = 1
```

集合

```python
class Solution:
    def findDuplicate(self, nums: List[int]) -> int:
        num_set = set()
        for x in nums:
            if x in num_set:
                return x
            num_set.add(x)
```

时间复杂度为O(n)，空间复杂度为O(n)。该方法违反了说明2。