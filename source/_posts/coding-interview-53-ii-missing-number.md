---
title: 《剑指Offer》53-II.0～n-1中缺失的数字
date: 2020-03-19 21:40:12
tags: binary search
categories: 剑指offer
---

一个长度为n-1的递增排序数组中的所有数字都是唯一的，并且每个数字都在范围0～n-1之内。在范围0～n-1内的n个数字中有且只有一个数字不在该数组中，请找出这个数字。

<!--more-->

### 方法一：遍历

思路：已知n-1=nums.length，因此，数字的取值范围为[0, nums.length]。

遍历数组，寻找第一个值与下标不相等的位置，如果这样的下标存在，则该下标即为缺失的数字。

如果数组中的数字与下标均相等，则表示缺失的数字就是最后一个数字nums.length。

```java
class Solution {
    public int missingNumber(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != i) {
                return i;
            }
        }
        // 缺失的数字为最后一个数字。例如，[0]
        return nums.length;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

### 方法二：求和

思路：首先，利用等差数列的求和公式，计算出0～n-1这n个数字之和expectedSum=n(n-1)/2。

然后，计算数组中所有数字之和sum。二者之差expectedSum - sum就是那个缺失的数字。

```java
class Solution {
    public int missingNumber(int[] nums) {
        int n = nums.length + 1;
        int expectedSum = n * (n - 1) >> 1;
        int sum = 0;
        for (int i = 0; i < nums.length; i++) {
            sum += nums[i];
        }
        return expectedSum - sum;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(1)。

### 方法三：二分查找

思路：如果中间元素的值与下标相等，则表示缺失的数字在右半边；否则，继续向左寻找第一个值与下标不相等的位置。

```java
class Solution {
    public int missingNumber(int[] nums) {
        int low = 0;
        int high = nums.length - 1;
        while(low <= high) {
            int mid = (low + high) >> 1;
            if(nums[mid] == mid) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return low;
    }
}
```

复杂度分析：时间复杂度为O(log n)，空间复杂度为O(1)。