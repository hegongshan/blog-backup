---
title: 《剑指Offer》45.把数组排成最小的数
date: 2020-03-13 18:14:51
tags: array
categories: 剑指offer
---

输入一个正整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。例如输入数组{3，32，321}，则打印出这三个数字能排成的最小数字为321323。

<!--more-->

### 问题分析

首先，定义如下的排序规则：

假定a和b是数组中的任意两个数字，将a和b拼接在一起，可以得到ab和ba。若ab < ba，则a < b。

例如，如果a=30，b=3，那么ab=303，ba=330。显然，ab < ba，因此，a < b。

然后，基于该排序规则，按照从小到大的顺序，对数组中的数字进行排序。

最后，将数组中的所有数字拼接在一起，拼接得到的数字即为最小数字。

### 算法实现

```java
class Solution {
    public String minNumber(int[] nums) {
        if (nums == null || nums.length == 0) {
            return "";
        }
        List<String> list = new ArrayList<>(nums.length);
        for (int x : nums) {
            list.add(String.valueOf(x));
        }
        list.sort((a, b) -> {
            return (a + b).compareTo(b + a);
        });
        StringBuilder sb = new StringBuilder();
        for (String s : list) {
            sb.append(s);
        }
        return sb.toString();
    }
} 
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(n)。其中，n为数组的长度。