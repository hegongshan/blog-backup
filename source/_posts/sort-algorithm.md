---
title: 手写八大排序算法
date: 2020-04-02 20:50:24
tags: sort
categories: algorithm
---

晚上，腾讯的面试官让我写出**熟记的最复杂的**排序算法，我猜他是想让我写那几个O(n log n)的排序算法。然而，好久没看排序了，一时之间只写出了O(n^2)，结果可想而知......

<!--more-->

首先，定义交换函数swap，用于交换数组中任意两个位置的值。

```java
private static void swap(int[] arr, int i, int j) {
	int temp = arr[i];
	arr[i] = arr[j];
	arr[j] = temp;
}
```

接下来，使用8种排序算法，对数组进行升序排序。

### 交换排序

#### 冒泡排序

* 向上浮

```java
public static void bubbleSort(int[] arr) {
	boolean exchange = false;
	for (int i = 0; i < arr.length - 1; i++) {
		exchange = false;
		for (int j = arr.length - 1; j > i; j--) {
			if (arr[j - 1] > arr[j]) {
				swap(arr, j - 1, j);
				exchange = true;
			}
		}
		if (!exchange) {
			break;
		}
	}
}
```

* 向下沉

```java
public static void bubbleSort(int[] arr) {
	boolean exchange = false;
	for (int i = 0; i < arr.length - 1; i++) {
		exchange = false;
		for (int j = 0; j < arr.length - i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
				swap(arr, j, j + 1);
				exchange = true;
			}
		}
		if (!exchange) {
			break;
		}
	}
}
```

#### 快速排序

```java
public static void quickSort(int[] arr) {
	quickSort(arr, 0, arr.length - 1);
}

private static void quickSort(int[] arr, int start, int end) {
	if (start >= end) {
		return;
	}
	int data = arr[start];
	int i = start, j = end;
	while (i < j) {
		while (i < j && arr[j] >= data) {
			j--;
		}
		if (i < j) {
			arr[i++] = arr[j];
		}
		while (i < j && arr[i] <= data) {
			i++;
		}
		if (i < j) {
			arr[j--] = arr[i];
		}
	}
	arr[i] = data;
	quickSort(arr, start, i - 1);
	quickSort(arr, i + 1, end);
}
```

### 插入排序

#### 直接插入排序

```java
public static void insertionSort(int[] arr) {
	for (int i = 1; i < arr.length; i++) {
		for (int j = i - 1; j >= 0 && arr[j] > arr[j + 1]; j--) {
			swap(arr, j, j + 1);
		}
	}
}
```

#### 希尔排序

```java
public static void shellSort(int[] arr) {
	for (int d = arr.length >> 1; d > 0; d >>= 1) {
		for (int i = d; i < arr.length; i++) {
			for (int j = i - d; j >= 0 && arr[j] > arr[j + d]; j -= d) {
				swap(arr, j, j + d);
			}
		}
	}
}
```

### 选择排序

#### 直接选择排序

```java
public static void selectionSort(int[] arr) {
	for (int i = 0; i < arr.length - 1; i++) {
		int minIdx = i;
		for (int j = i + 1; j < arr.length; j++) {
			if (arr[j] < arr[minIdx]) {
				minIdx = j;
			}
		}
		if (minIdx != i) {
			swap(arr, i, minIdx);
		}
	}
}
```

#### 堆排序

```java
public static void heapSort(int[] arr) {
	// 1.从最后一个非叶子结点开始，将数组调整为大根堆
	for (int i = (arr.length >> 1) - 1; i >= 0; i--) {
		siftDown(arr, i, arr.length);
	}
	// 2.每次交换堆首元素与末尾元素，然后从堆首向下调整
	for (int i = arr.length - 1; i > 0; i--) {
		swap(arr, 0, i);
		siftDown(arr, 0, i);
	}
}
// 这里参考了PriorityQueue的源码
private static void siftDown(int[] arr, int i, int len) {
	int x = arr[i];
	int half = len >> 1;
	while (i < half) {
		int k = (i << 1) + 1;
		int right = k + 1;
		if (right < len && arr[k] < arr[right]) {
			k++;
		}
		// 如果该结点比左右孩子中的较大者还要大
		if (arr[k] <= x) {
			break;
		}
		// 子结点大于父结点，继续向下寻找
		arr[i] = arr[k];
		i = k;
	}
	arr[i] = x;
}
```

### 归并排序

```java
public static void mergeSort(int[] arr) {
	int[] temp = new int[arr.length];
	mergeSort(arr, 0, arr.length - 1, temp);
}

private static void mergeSort(int[] arr, int low, int high, int[] temp) {
	if (low >= high) {
		return;
	}
	int mid = (low + high) >> 1;
	mergeSort(arr, low, mid, temp);
	mergeSort(arr, mid + 1, high, temp);
	merge(arr, low, mid, high, temp);
}

private static void merge(int[] arr, int low, int mid, int high, int[] temp) {
	int i = low;
	int j = mid + 1;
	int k = 0;
	while (i <= mid && j <= high) {
		if (arr[i] <= arr[j]) {
			temp[k++] = arr[i++];
		} else {
			temp[k++] = arr[j++];
		}
	}
	while (i <= mid) {
		temp[k++] = arr[i++];
	}
	while (j <= high) {
		temp[k++] = arr[j++];
	}
	for (i = 0; i < k; i++) {
		arr[low + i] = temp[i];
	}
}
```

### 基数排序

```java
public static void radixSort(int[] arr) {
	// 1.寻找数组中的最大值
	int max = arr[0];
	for (int i = 1; i < arr.length; i++) {
		if (max < arr[i]) {
			max = arr[i];
		}
	}
	// 2.逐位进行排序
	radixSort(arr, 10, max);
}

private static void radixSort(int[] arr, int radix, int max) {
	int[] copy = new int[arr.length];
	int[] buckets = new int[radix];
	// 从个位开始，依次向前处理
	for (int divisor = 1; divisor <= max; divisor *= radix) {
		// 1.先将桶初始化
		for (int i = 0; i < buckets.length; i++) {
			buckets[i] = 0;
		}
		// 2.将元素放入对应的桶中：统计每个桶中元素的个数
		for (int i = 0; i < arr.length; i++) {
			buckets[(arr[i] / divisor) % radix]++;
		}
		// 3.从左向右，依次统计到第j个桶时，元素个数
		for (int i = 1; i < buckets.length; i++) {
			buckets[i] += buckets[i - 1];
		}
		// 4.将桶中的元素依次放入临时数组copy中
		for (int i = arr.length - 1; i >= 0; i--) {
			int idx = --buckets[(arr[i] / divisor) % radix];
			copy[idx] = arr[i];
		}
		// 5.将copy中的元素放回数组中
		for (int i = 0; i < arr.length; i++) {
			arr[i] = copy[i];
		}
	}
}
```

### 比较

|   排序算法   | 最好的时间复杂度 | 平均时间复杂度 | 最坏的时间复杂度 |        空间复杂度         | 稳定性 |
| :----------: | :--------------: | :------------: | :--------------: | :-----------------------: | :----: |
|   冒泡排序   |       O(n)       |     O(n^2)     |      O(n^2)      |           O(1)            |  稳定  |
|   快速排序   |    O(n log n)    |   O(n log n)   |      O(n^2)      | 最好O(log n)<br/>最坏O(n) | 不稳定 |
| 直接插入排序 |       O(n)       |     O(n^2)     |      O(n^2)      |           O(1)            |  稳定  |
|   希尔排序   |    O(n log n)    |    O(n^1.3)    |      O(n^2)      |           O(1)            | 不稳定 |
| 直接选择排序 |      O(n^2)      |     O(n^2)     |      O(n^2)      |           O(1)            | 不稳定 |
|    堆排序    |    O(n log n)    |   O(n log n)   |    O(n log n)    |           O(1)            | 不稳定 |
|   归并排序   |    O(n log n)    |   O(n log n)   |    O(n log n)    |           O(n)            |  稳定  |
|   基数排序   |   O(d(n + r))    |  O(d(n + r))   |   O(d(n + r))    |          O(n+r)           |  稳定  |

其中，n表示关键字的个数，d表示关键字的最大长度，r表示关键字的基数。