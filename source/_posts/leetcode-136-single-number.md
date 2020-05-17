---
title: LeetCode 136.只出现一次的数字
date: 2020-03-22 18:10:24
tags: 位运算
categories: leetcode
mathjax: true
---

给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

<!--more-->

**说明：**

你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

**示例 1:**

```
输入: [2,2,1]
输出: 1
```

**示例 2:**

```
输入: [4,1,2,1,2]
输出: 4
```

### 方法一：集合

```java
class Solution {
    public int singleNumber(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for (int x : nums) {
            if (set.contains(x)) {
                set.remove(x);
            } else {
                set.add(x);
            }
        }
        return (int) set.toArray()[0];
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

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
        return -1;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

### 方法三：求和

```java
class Solution {
    public int singleNumber(int[] nums) {
        Set<Integer> set = new HashSet<>();
        int sum = 0, uniqueSum = 0;
        for (int x : nums) {
            if (!set.contains(x)) {
                set.add(x);
                uniqueSum += x;
            }
            sum += x;
        }
        return 2 * uniqueSum - sum;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

### 方法四：位运算

异或运算有如下的性质：

* $a \oplus a = 0$

* $a \oplus 0 = a$
* $(a \oplus b) \oplus c = a \oplus (b \oplus c)$

```java
class Solution {
    public int singleNumber(int[] nums) {
        int data = 0;
        for (int x : nums) {
            data ^= x;
        }
        return data;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。其中，n为数组的长度。