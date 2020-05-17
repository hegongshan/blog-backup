---
title: 《剑指Offer》61.扑克牌中的顺子
date: 2020-03-28 17:24:02
tags: 剑指offer
categories: 剑指offer
---

从扑克牌中随机抽5张牌，判断是不是一个顺子，即这5张牌是不是连续的。2～10为数字本身，A为1，J为11，Q为12，K为13，而大、小王为 0 ，可以看成任意数字。A 不能视为 14。

<!--more-->

### 方法一：排序

思路：对牌进行升序排序，统计其中王的个数，即0的个数。

如果牌中王的个数>=空缺的个数，则表示这手牌是顺子。

另外，如果存在相邻2张牌数字相同，则这手牌一定不是顺子。

```java
class Solution {
    public boolean isStraight(int[] nums) {
        Arrays.sort(nums);
        // 统计王的个数，即数组中0的个数
        int king = 0;
        // 统计数组中间隔的个数
        int span = 0;
        for (int i = 0; i < nums.length - 1; i++) {
            if (nums[i] == 0) {
                king ++;
                continue;
            }
            // 如果存在相邻2张牌相同，则一定不是顺子
            if (nums[i] == nums[i+1]) {
                return false;
            }
            span += nums[i+1] - nums[i] - 1;                    
        }
        return king >= span;
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(1)。其中，n为数组nums的长度。

### 方法二：不排序

思路：使用一个长度为14的boolean数组map充当哈希表，用于记录非零数字是否已经出现。

与此同时，统计牌中最大的非零数字max与最小的非零数字min。

如果max - min > 5，则这手牌不可能是顺子。

另外，如果某个非零数字已经出现过了，即存在相同的牌，同样表示这手牌不是顺子。

```java
class Solution {
    public boolean isStraight(int[] nums) {
        boolean[] map = new boolean[14];
        int max = 0, min = 14;
        for(int x : nums) {
            if(x == 0) {
                continue;
            }
            if(map[x]) {
                return false;
            }
            map[x] = true;
            max = Math.max(max, x);
            min = Math.min(min, x);
        }
        return max - min <= 4;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。其中，n为数组nums的长度。