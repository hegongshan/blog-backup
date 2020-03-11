---
title: LeetCode 295./《剑指Offer》41.数据流的中位数
date: 2020-03-09 18:02:07
tags: heap
categories: leetcode
---

中位数是有序列表中间的数。如果列表长度是偶数，中位数则是中间两个数的平均值。

例如，

[2,3,4] 的中位数是 3

[2,3] 的中位数是 (2 + 3) / 2 = 2.5

设计一个支持以下两种操作的数据结构：

* void addNum(int num) - 从数据流中添加一个整数到数据结构中。
* double findMedian() - 返回目前所有元素的中位数。

<!--more-->


示例：

```java
addNum(1)
addNum(2)
findMedian() -> 1.5
addNum(3) 
findMedian() -> 2
```

进阶:

1. 如果数据流中所有整数都在 0 到 100 范围内，你将如何优化你的算法？
2. 如果数据流中 99% 的整数都在 0 到 100 范围内，你将如何优化你的算法？

### 方法一：先添加再排序

```java
class MedianFinder {
    private List<Integer> list;
    /** initialize your data structure here. */
    public MedianFinder() {
        list = new ArrayList<>();
    }
    
    public void addNum(int num) {
        list.add(num);
    }
    
    public double findMedian() {
        Collections.sort(list);
        int size = list.size();
        int mid = size >> 1;
        if ((size & 0x1) == 1) {
            return (double)list.get(mid);
        }
        return (list.get(mid - 1) + list.get(mid)) / 2.0;
    }
}
```

复杂度分析：时间复杂度为O(n log n)，空间复杂度为O(n)。其中，n为列表的长度。

### 方法二：边添加边排序

#### 1.直接插入法

```java
class MedianFinder {

    private int[] data;
    private int size;
    /** initialize your data structure here. */
    public MedianFinder() {
        data = new int[16];
        size = 0;
    }
    
    public void addNum(int num) {
        if(size == 0) {
            data[size++] = num;
            return ;
        }
        // 扩容
        if(size == data.length) {
            data = Arrays.copyOf(data, size + (size >> 1));
        }
        // 寻找插入位置
        int idx = size - 1;
        while(idx >= 0 && data[idx] > num) {
            idx--;
        }
        idx = idx + 1;
        for(int i = size - 1; i >= idx; i--) {
            data[i+1] = data[i];
        }
        data[idx] = num;
        size++;
    }
    
    public double findMedian() {
        int mid = size >> 1;
        if((size & 0x1) == 1) {
            return data[mid];
        }
        return (double)(data[mid - 1] + data[mid]) / 2.0;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为列表的长度。

#### 2.二分插入法

```java
class MedianFinder {

    private int[] data;
    private int size;
    /** initialize your data structure here. */
    public MedianFinder() {
        data = new int[16];
        size = 0;
    }
    
    public void addNum(int num) {
        if(size == 0) {
            data[size++] = num;
            return ;
        }
        // 扩容
        if(size == data.length) {
            data = Arrays.copyOf(data, size + (size >> 1));
        }
        // 寻找插入位置
        int low = 0;
        int high = size - 1;
        while(low <= high) {
            int mid = (low + high) / 2;
            if(data[mid] == num) {
                low = mid;
                break;
            } else if(data[mid] < num) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        for(int i=size-1;i>=low;i--) {
            data[i+1] = data[i];
        }
        data[low] = num;
        size++;
    }
    
    public double findMedian() {
        int mid = size >> 1;
        if((size & 0x1) == 1) {
            return data[mid];
        }
        return (double)(data[mid - 1] + data[mid]) / 2.0;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为列表的长度。

### 方法三：Partition方法（快速排序）

```java
class MedianFinder {
    private List<Integer> list;
    /** initialize your data structure here. */
    public MedianFinder() {
        list = new ArrayList<>();
    }
    
    public void addNum(int num) {
        list.add(num);
    }
    
    public double findMedian() {
        int low = 0;
        int high = list.size() - 1;
        int mid = list.size() / 2;
        int idx = partition(list, low, high);
        while(idx != mid) {
            if(idx < mid) {
                low = idx + 1;
            } else {
                high = idx - 1;
            }
            idx = partition(list, low, high);
        }
        int size = list.size();
        if((size & 0x1) == 1) {
            return (double)list.get(idx);
        }
        return (list.get(idx-1) + list.get(idx)) / 2.0;
    }

    public int partition(List<Integer> list, int low, int high) {
        int temp = list.get(low);
        while(low < high) {
            while(low < high && list.get(high) >= temp) {
                high --;
            }
            list.set(low, list.get(high));
            while(low < high && list.get(low) < temp) {
                low ++;
            }
            list.set(high, list.get(low));
        }
        list.set(low, temp);
        return low;
    }
}
```

复杂度分析：时间复杂度为O(n)，空间复杂度为O(n)。其中，n为列表的长度。

### 方法四：两个堆

思路：使用两个堆，一个大根堆，另一个小根堆。

假设列表是升序排列的，它被中位数分为两个部分，前半部分的数据小于后半部分数据。

我们使用大根堆存前半部分，让小根堆存后半部分。

若两个堆中的元素个数相等，则表示列表长度是偶数，那么两个堆的顶部元素的平均值就是中位数；

否则，列表的长度是奇数，那么大根堆的顶部元素就是中位数。

```java
class MedianFinder {
    private PriorityQueue<Integer> minHeap, maxHeap;
    /** initialize your data structure here. */
    public MedianFinder() {
        minHeap = new PriorityQueue<>();
        maxHeap = new PriorityQueue<>((a, b) -> b - a);
    }
    
    public void addNum(int num) {
        maxHeap.offer(num);
        minHeap.offer(maxHeap.poll());
        if(minHeap.size() > maxHeap.size()) {
            maxHeap.offer(minHeap.poll());
        }
    }
    
    public double findMedian() {
        if(minHeap.size() == maxHeap.size()) {
            return (minHeap.peek() + maxHeap.peek()) / 2.0;
        }
        return maxHeap.peek();
    }
}
```

复杂度分析：时间复杂度为O(log n)，空间复杂度为O(n)。其中，n为列表的长度。