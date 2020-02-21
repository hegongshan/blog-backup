---
title: LeetCode 79.单词搜索/《剑指Offer》12.矩阵中的路径
date: 2020-02-20 19:38:33
tags: 回溯
categories: leetcode
---

给定一个二维网格和一个单词，找出该单词是否存在于网格中。

单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用。

<!--more-->

**示例:**

```
board =
[
  ['A','B','C','E'],
  ['S','F','C','S'],
  ['A','D','E','E']
]

给定 word = "ABCCED", 返回 true.
给定 word = "SEE", 返回 true.
给定 word = "ABCB", 返回 false.
```

### 方法：回溯

```java
class Solution {
    public boolean exist(char[][] board, String word) {
        if(board == null || word == null) {
            return false;
        }
        int row = board.length;
        int column = board[0].length;
        boolean[][] visited = new boolean[row][column];
        for(int i = 0; i < row; i++) {
            for(int j = 0; j < column; j++) {
                boolean flag = exist0(board, word, 0, i, j, visited);
                if(flag) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean exist0(char[][] board, String word, int index, int x, int y, boolean[][] visited) {
        if(index == word.length()) {
            return true;
        }
        if(x < 0 || x >= board.length || 
            y <0 || y >= board[0].length ||
            board[x][y] != word.charAt(index) ||
            visited[x][y]) {
            return false;
        }

        visited[x][y] = true;
        index++;
        
        boolean flag = exist0(board, word, index, x, y-1, visited) ||
            exist0(board, word, index, x, y+1, visited) ||
            exist0(board, word, index, x-1, y, visited) ||
            exist0(board, word, index, x+1, y, visited);
        // 回溯
        if(!flag) {
            index--;
            visited[x][y] = false;
        }
        return flag;
    }
}
```

时间复杂度为O(mnk)，空间复杂度为O(k)。其中，m为网格（矩阵）的行数，n为列数，k为单词的长度。

