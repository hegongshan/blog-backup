---
title: LeetCode 260.只出现一次的数字 III/《剑指Offer》56-I.数组中数字出现的次数
date: 2020-03-22 18:14:34
tags: 位运算
categories: leetcode
---

给定一个整数数组 `nums`，其中恰好有两个元素只出现一次，其余所有元素均出现两次。 找出只出现一次的那两个元素。

<!--more-->

**示例 :**

```
输入: [1,2,1,3,2,5]
输出: [3,5]
```

**注意：**

1. 结果输出的顺序并不重要，对于上面的例子， `[5, 3]` 也是正确答案。
2. 你的算法应该具有线性时间复杂度。你能否仅使用常数空间复杂度来实现？

### 方法一：集合

```java
class Solution {
    public int[] singleNumbers(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for (int x : nums) {
            if (set.contains(x)) {
                set.remove(x);
            } else {
                set.add(x);
            }
        }
        
        int[] result = new int[2];
        int i = 0;
        for (Integer x : set) {
            result[i++] = x;
        }
        return result;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

### 方法二：哈希表

```java
class Solution {
    public int[] singleNumbers(int[] nums) {
        Map<Integer,Integer> map = new HashMap<>();
        for (int x : nums) {
            map.put(x, map.getOrDefault(x, 0) + 1);
        }

        int[] result = new int[2];
        int i = 0;
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 1) {
                result[i++] = entry.getKey();
            }
        }
        return result;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n为数组的长度。

### 方法三：位运算

以下方法来自《剑指Offer》

```java
class Solution {
    public int[] singleNumber(int[] nums) {
        int bit = 0;
        for (int x : nums) {
            bit ^= x;
        }
        int v = findRightestOne(bit);
        int a = 0, b = 0;
        // 按照第v位是否为1，将原数组拆分成两个子数组
        for (int x : nums) {
            if ((x >> v & 0x1) == 1) {
                a ^= x;
            } else {
                b ^= x;
            }
        }
        return new int[]{a, b};
    }

    // 寻找二进制表示下最右边的1
    private int findRightestOne(int bit) {
        int cnt = 0;
        while ((bit & 1) == 0) {
            bit >>= 1;
            cnt ++;
        }
        return cnt;
    }
}
```

事实上，上述方法还能被简化（来自LeetCode官方题解）

```java
class Solution {
    public int[] singleNumber(int[] nums) {
        int bit = 0;
        for (int x : nums) {
            bit ^= x;
        }
        // 负数采用补码表示，按位与后，将得到一个只有某个位置为1，其他均为0的二进制数
        int v = bit & (-bit);
        int a = 0;
        for (int x : nums) {
            if ((x & v) != 0) {
                a ^= x;
            }
        }
        // a ^ bit = a ^ a ^ b = b
        return new int[]{a, a ^ bit};
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。其中，n为数组的长度。