---
title: LeetCode 54.螺旋矩阵/《剑指Offer》29.顺时针打印矩阵
date: 2020-03-01 19:07:18
tags: array
categories: leetcode
---

给定一个包含 *m* x *n* 个元素的矩阵（*m* 行, *n* 列），请按照顺时针螺旋顺序，返回矩阵中的所有元素。

<!--more-->

**示例 1:**

```
输入:
[
 [ 1, 2, 3 ],
 [ 4, 5, 6 ],
 [ 7, 8, 9 ]
]
输出: [1,2,3,6,9,8,7,4,5]
```

**示例 2:**

```
输入:
[
  [1, 2, 3, 4],
  [5, 6, 7, 8],
  [9,10,11,12]
]
输出: [1,2,3,4,8,12,11,10,9,5,6,7]
```

### 问题分析

思路：按照顺时针顺序，依次遍历当前范围的上边界、右边界、下边界及左边界。

当遍历行（或者列）时，把最后一个元素放到接下来的列（或者行）中遍历，就像下面这样。

<img src="/static/images/leetcode-54.png" width="200" height="200"/>

可能存在的问题：如果最后仅剩下一行（或者一列），那么该行（或者列）的最后一个元素将无法被访问到。

解决办法：每当遍历完当前范围的上边界（或者右边界）时，及时判断是否仅剩下一行（或者一列）。

### 算法实现

```java
class Solution {
    public List<Integer> spiralOrder(int[][] matrix) {
        if(matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return new ArrayList<>();
        }

        int row = matrix.length;
        int column = matrix[0].length;
        List<Integer> list = new ArrayList<>(row * column);       

        int top = 0, bottom = row - 1;
        int left = 0, right = column - 1;
        while(top <= bottom && left <= right) {
            // 上边界：从左到右
            for(int j = left; j < right; j++) {
                list.add(matrix[top][j]);
            }
            // 若只有一行
            if(top == bottom) {
                list.add(matrix[top][right]);
                break;
            }
            // 右边界：从上到下
            for(int i = top; i < bottom; i++) {
                list.add(matrix[i][right]);
            }
            // 若只有一列
            if(left == right) {
                list.add(matrix[bottom][right]);
                break;
            }
            // 下边界：从右到左
            for(int j = right; j > left; j--) {
                list.add(matrix[bottom][j]);
            }
            // 左边界：从下到上
            for(int i = bottom; i > top; i--) {
                list.add(matrix[i][left]);
            }

            // 缩小遍历范围
            top++;
            bottom--;
            left++;
            right--;
        }
        return list;
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(m×n)。