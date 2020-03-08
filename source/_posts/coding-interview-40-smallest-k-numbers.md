---
title: 《剑指Offer》40.最小的k个数
date: 2020-03-08 19:06:13
tags: heap
categories: 剑指offer
---

输入整数数组 `arr` ，找出其中最小的 `k` 个数。例如，输入4、5、1、6、2、7、3、8这8个数字，则最小的4个数字是1、2、3、4。

<!--more-->

### 方法一：排序

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        if (k <= 0 || k > arr.length) {
            return new int[0];
        }        
        Arrays.sort(arr);
        return Arrays.copyOf(arr, k);
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(k)。其中，n为数组的长度。

### 方法二：Partition方法（快速排序）

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        if (k <= 0 || k > arr.length) {
            return new int[0];
        }
        int low = 0;
        int high = arr.length - 1;
        int idx = partition(arr, low, high);
        while (idx + 1 != k) {
            if (idx + 1 > k) {
                high = idx - 1;
            } else {
                low = idx + 1;
            }
            idx = partition(arr, low, high);
        }
        return Arrays.copyOf(arr, k);
    }
    // 一次快速排序
    private int partition(int[] arr, int low, int high) {
        int temp = arr[low];
        while (low < high) {
            while (low < high && arr[high] >= temp) {
                high --;
            }
            arr[low] = arr[high];
            while (low < high && arr[low] < temp) {
                low ++;
            }
            arr[high] = arr[low];
        }
        arr[low] = temp;
        return low;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(k)。其中，n为数组的长度。

### 方法三：堆

* 大根堆

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        if (k <= 0 || k > arr.length) {
            return new int[0];
        }
        PriorityQueue<Integer> queue = new PriorityQueue<>((a, b) -> b - a);
        for (int x : arr) {
            queue.offer(x);
            if (queue.size() > k) {
                queue.poll();
            }
        }
        int[] results = new int[k];
        for (int i = 0; i < results.length; i++) {
            results[i] = queue.poll();
        }
        return results;
    }
}
```

复杂度分析：时间复杂度为O(n log k)，空间复杂度为O(k)。其中，n为数组的长度。

* 小根堆

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        if (k <= 0 || k > arr.length) {
            return new int[0];
        }
        PriorityQueue<Integer> queue = new PriorityQueue<>();
        for (int x : arr) {
            queue.offer(x);
        }
        int[] results = new int[k];
        for (int i = 0; i < results.length; i++) {
            results[i] = queue.poll();
        }
        return results;
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(n)。其中，n为数组的长度。