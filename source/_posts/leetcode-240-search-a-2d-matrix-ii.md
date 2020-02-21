---
title: LeetCode 240.搜索二维矩阵 II/《剑指Offer》4.二维数组中的查找
date: 2020-02-12 21:41:40
tags: array
categories: leetcode
mathjax: true
---

编写一个高效的算法来搜索 m x n 矩阵 matrix 中的一个目标值 target。该矩阵具有以下特性：

* 每行的元素从左到右升序排列。
* 每列的元素从上到下升序排列。

<!--more-->

**示例:**

现有矩阵 matrix 如下：

```
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
```

给定 target = 5，返回 true。

给定 target = 20，返回 false。

### 方法一：暴力法

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        for row in matrix:
            if target in row:
                return True
        return False
```

时间复杂度为$O(m \times n)$，空间复杂度为O(1)。

### 方法二：二分查找（行）

由于每行的元素从左到右升序排列，因此，在遍历每行时，可以使用二分法进行查找。

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        for row in matrix:
            if self.binary_search(row, target):
                return True
        return False

    def binary_search(self, nums: List[int], target: int) -> bool:
        low, high = 0, len(nums) - 1
        while low <= high:
            mid = (low + high) // 2
            if target < nums[mid]:
                high = mid - 1
            elif target > nums[mid]:
                low = mid + 1
            else:
                return True
        return False
```

时间复杂度为$O(m \log_2 n)$，空间复杂度为O(1)。

### 方法三：二分查找（行和列）

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        if not matrix:
            return False
        for i in range(min(len(matrix), len(matrix[0]))):
            row_found = self.binary_search(matrix, target, i, True)
            column_found = self.binary_search(matrix, target, i, False)
            if row_found or column_found:
                return True
        return False

    def binary_search(self, matrix: List[List[int]], target: int, start: int, row: bool) -> bool:
        low= start
        high = len(matrix[0]) - 1 if row else len(matrix) - 1
        while low <= high:
            mid = (low + high) // 2
            if row:
                if target == matrix[start][mid]:
                    return True
                if target < matrix[start][mid]:
                    high = mid - 1
                else:
                    low = mid + 1
            else:
                if target == matrix[mid][start]:
                    return True
                if target < matrix[mid][start]:
                    high = mid - 1
                else:
                    low = mid + 1
        return False
```

时间复杂度为$O(\log_2 (n!))$，空间复杂度为O(1)。

### 方法四：

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        if not matrix:
            return False
        m, n = len(matrix), len(matrix[0])
        i, j = m-1, 0
        while i >= 0 and j < n:
            if target == matrix[i][j]:
                return True
            if target > matrix[i][j]:
                j += 1
            else:
                i -= 1
        return False
```

时间复杂度为O(m+n)，空间复杂度为O(1)。