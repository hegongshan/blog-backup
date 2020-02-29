---
title: 《剑指Offer》21.调整数组顺序使奇数位于偶数前面
date: 2020-02-28 23:17:24
tags: array
categories: 剑指offer
---

输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有的奇数位于数组的前半部分，所有的偶数位于数组的后半部分。

<!--more-->

### 方法一：

思路：首先，定义变量cntEven，用于统计偶数的个数；

然后，从前往后遍历数组：若当前元素为偶数，则把后面的所有元素向前移动一位，并将当前元素置于数组的末尾，cntEven加一，直到当前下标i + cntEven >= nums.length为止。

该方法可以保证奇数和奇数，偶数和偶数之间的相对位置不变。

```java
class Solution {
    public int[] exchange(int[] nums) {
        if (nums == null || nums.length == 0) {
            return nums;
        }
        for (int i = 0, cntEven = 0; i + cntEven < nums.length; ) {
            // 若为当前元素为奇数，则继续遍历下一个元素
            if ((nums[i] & 1) == 1) {
                i++;
                continue;
            }
            // 若当前元素为偶数，则把后面的所有元素向前移动一位
            int temp = nums[i];
            for (int j = i + 1; j < nums.length; j++) {
                nums[j - 1] = nums[j];
            }
            // 将当前元素（偶数）置于数组的末尾
            nums[nums.length - 1] = temp;
            // 统计遇到的偶数个数
            cntEven ++;
        }
        return nums;
    }
}
```

时间复杂度为O(n^2)，空间复杂度为O(1)。

### 方法二：使用辅助空间

思路：新建两个队列，分别存储奇数和偶数，然后按照先奇数后偶数的顺序，将两个队列中的元素依次加入到数组中。

该方法可以保证奇数和奇数，偶数和偶数之间的相对位置不变。

```java
class Solution {
    public int[] exchange(int[] nums) {
        if (nums == null || nums.length == 0) {
            return nums;
        }

        Queue<Integer> oddQueue = new LinkedList<>();
        Queue<Integer> evenQueue = new LinkedList<>();
        for (int i = 0; i < nums.length; i++) {
            if ((nums[i] & 1) == 1) {
                oddQueue.offer(nums[i]);
            } else {
                evenQueue.offer(nums[i]);
            }
        }
        
        int i = 0;
        while (!oddQueue.isEmpty()) {
            nums[i++] = oddQueue.poll();
        }
        while (!evenQueue.isEmpty()) {
            nums[i++] = evenQueue.poll();
        }
        return nums;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(n)。

### 方法三：快慢指针

思路：设置两个指针slow和fast，slow用于指向下一个奇数的存储位置，而fast用于向后寻找奇数。

1.若当前元素为奇数，则交换fast与slow指向的元素，slow向后移动一位；

2.fast向后移动一位；

3.重复执行1和2，直到fast指向数组的末尾为止。

```java
class Solution {
    public int[] exchange(int[] nums) {
        if (nums == null || nums.length == 0) {
            return nums;
        }
        int slow = 0, fast = 0;
        int temp;
        while (fast < nums.length) {
            if ((nums[fast] & 1) == 1) {
                temp = nums[slow];
                nums[slow] = nums[fast];
                nums[fast] = temp;
                slow++;
            }
            fast++;
        }
        return nums;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(1)。

### 方法四：首尾双指针

思路：设置两个指针i和j，i用于从前往后寻找偶数，j用于从后往前寻找奇数。

1.当i<j时，i依次向后移动，直到当前元素为偶数为止；

2.当i<j时，j依次向前移动，直到当前元素为奇数为止；

3.若i<j，则交换i和j指向的元素；

4.重复上述操作，直到i>=j为止。

```java
class Solution {
    public int[] exchange(int[] nums) {
        if (nums == null || nums.length == 0) {
            return nums;
        }
        int i = 0, j = nums.length - 1;
        int temp;
        while (i < j) {
            while (i < j && (nums[i] & 1) == 1) {
                i++;
            }
            while (i < j && (nums[j] & 1) == 0) {
                j--;
            }
            if (i < j) {
                temp = nums[i];
                nums[i] = nums[j];
                nums[j] = temp;
            }   
        }
        return nums;
    }
}
```

时间复杂度为O(n)，空间复杂度为O(1)。

