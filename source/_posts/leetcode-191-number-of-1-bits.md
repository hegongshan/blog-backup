---
title: LeetCode 191.位1的个数/《剑指offer》15.二进制中1的个数
date: 2020-02-22 22:45:38
tags: 位运算
categories: leetcode
---

编写一个函数，输入是一个无符号整数，返回其二进制表达式中数字位数为 ‘1’ 的个数（也被称为汉明重量）。

 <!--more-->

**示例 1：**

```
输入：00000000000000000000000000001011
输出：3
解释：输入的二进制串 00000000000000000000000000001011 中，共有三位为 '1'。
```

**示例 2：**

```
输入：00000000000000000000000010000000
输出：1
解释：输入的二进制串 00000000000000000000000010000000 中，共有一位为 '1'。
```

**示例 3：**

```
输入：11111111111111111111111111111101
输出：31
解释：输入的二进制串 11111111111111111111111111111101 中，共有 31 位为 '1'。
```

**提示：**

* 请注意，在某些语言（如 Java）中，没有无符号整数类型。在这种情况下，输入和输出都将被指定为有符号整数类型，并且不应影响您的实现，因为无论整数是有符号的还是无符号的，其内部的二进制表示形式都是相同的。
* 在 Java 中，编译器使用二进制补码记法来表示有符号整数。因此，在上面的 示例 3 中，输入表示有符号整数 -3。

**进阶:**
如果多次调用这个函数，你将如何优化你的算法？

### 方法一：位运算+循环

**n对2取模，相当于和1做按位与运算，即 n % 2 等价于 n & 1。**

```java
public class Solution {
    // you need to treat n as an unsigned value
    public int hammingWeight(int n) {
        int count = 0;
        while(n != 0) {
            count += n & 1;
            n >>>= 1;
        }
        return count;
    }
}
```

时间复杂度为O(1)：由于运算时间与n的位数有关，而int型数据只有32位，因此运行时间为O(1)。

空间复杂度为O(1)。

### 方法二：

把一个整数减去1之后，再和原来的整数做位与运算，得到的结果相当于把整数的二进制表示中的最右边一个1变成0。

```java
public class Solution {
    // you need to treat n as an unsigned value
    public int hammingWeight(int n) {
        int count = 0;
        while(n != 0) {
            n &= (n-1);
            count ++;
        }
        return count;
    }
}
```

时间复杂度和空间复杂度均为O(1)。

### 方法三：

```java
public class Solution {
    // you need to treat n as an unsigned value
    public int hammingWeight(int n) {
        return Integer.bitCount(n);
    }
}
```

bitCount方法的源码如下：

```java
public static int bitCount(int i) {
    // HD, Figure 5-2
    i = i - ((i >>> 1) & 0x55555555);
    i = (i & 0x33333333) + ((i >>> 2) & 0x33333333);
    i = (i + (i >>> 4)) & 0x0f0f0f0f;
    i = i + (i >>> 8);
    i = i + (i >>> 16);
    return i & 0x3f;
}
```

时间复杂度和空间复杂度均为O(1)。