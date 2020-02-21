---
title: 《剑指Offer》13.机器人的运动范围
date: 2020-02-21 21:06:04
tags: 剑指offer
categories: 剑指offer
---

地上有一个m行和n列的方格。一个机器人从坐标0,0的格子开始移动，每一次只能向左，右，上，下四个方向移动一格，但是不能进入行坐标和列坐标的数位之和大于k的格子。 例如，当k为18时，机器人能够进入方格（35,37），因为3+5+3+7 = 18。但是，它不能进入方格（35,38），因为3+5+3+8 = 19。请问该机器人能够达到多少个格子？

<!--more-->

### 方法：回溯

```java
class Solution {
    public int movingCount(int m, int n, int k) {
        boolean[][] visited = new boolean[m][n];
        return movingCount0(m, n, k, 0, 0, visited);
    }

    public int movingCount0(int m, int n, int k, int x, int y, boolean[][] visited) {
        // 若不能进入坐标(x,y)
        if(x < 0 || x >= m || y < 0 || y >= n || 
            getDigitalSum(x) + getDigitalSum(y) > k || 
            visited[x][y]) {
            return 0;
        }
        visited[x][y] = true;
        return 1 + movingCount0(m, n, k, x, y - 1, visited) + 
            movingCount0(m, n, k, x, y + 1, visited) + 
            movingCount0(m, n, k, x - 1, y, visited) + 
            movingCount0(m, n, k, x + 1, y, visited);
    }

    public int getDigitalSum(int x) {
        int sum = 0;
        while(x > 0) {
            sum += x % 10;
            x /= 10;
        }
        return sum;
    }
}
```

