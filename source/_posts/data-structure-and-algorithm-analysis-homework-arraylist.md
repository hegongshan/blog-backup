---
title: 数据结构与算法分析作业之自己实现Java顺序表
date: 2018-05-25 22:55:17
updated: 2018-05-25 22:55:17
tags: [数据结构,java]
categories: 数据结构与算法分析:Java语言描述
---

<p class="text-center">自己实现的Java顺序表</p>

<!--more-->

```java
package com.hegongshan.collections;
/**
 * 顺序表
 * @author hegongshan https://www.hegongshan.com
 * @param <E>
 */
public class ArrayList<E> {
	private static final int DEFAULT_CAPACITY = 10;
	private Object[] elementData;
	private int size = 0;

	public ArrayList() {
		this(DEFAULT_CAPACITY);
	}

	public ArrayList(int capacity) {
		if (capacity < 0) {
			throw new IllegalArgumentException("Illegal Capacity: " + capacity);
		}
		elementData = new Object[capacity];
	}

	// 返回顺序表中的元素个数
	public int size() {
		return size;
	}

	// 是否为空
	public boolean isEmpty() {
		return size == 0;
	}

	// 添加元素
	public boolean add(E e) {
		ensureCapacity();
		elementData[size] = e;
		size++;
		return true;
	}

	// 根据索引号添加元素
	public void add(int index, E e) {
		checkPositionIndex(index);
		ensureCapacity();
		for (int i = size - 1; i >= index; i--) {
			elementData[i + 1] = elementData[i];
		}
		elementData[index] = e;
		size++;
	}

	// 删除指定索引处的元素
	@SuppressWarnings("unchecked")
	public E remove(int index) {
		checkElementIndex(index);
		E oldValue = (E) elementData[index];
		for (int i = size - 1; i > index; i--) {
			elementData[i - 1] = elementData[i];
		}
		elementData[--size] = null;// 最后一个元素变为null
		return oldValue;
	}

	// 删除指定元素值首次出现的那个元素
	public boolean remove(Object obj) {
		int index = indexOf(obj);
		if (index != -1) {
			remove(index);
			return true;
		}
		return false;
	}

	// 根据索引号获取元素
	@SuppressWarnings("unchecked")
	public E get(int index) {
		checkElementIndex(index);
		return (E) elementData[index];
	}

	// 改变指定索引号的元素值
	public void set(int index, E e) {
		checkElementIndex(index);
		elementData[index] = e;
	}

	public void clear() {
		for (int i = 0; i < size; i++) {
			elementData[i] = null;
		}
		size = 0;
	}

	// 去掉多余的容量
	public void trimToSize() {
		if (size < elementData.length) {
			if (size == 0) {
				return;
			}
			Object[] newElementData = new Object[size];
			for (int i = 0; i < size; i++) {
				newElementData[i] = elementData[i];
			}
			elementData = newElementData;
		}
	}

	// 是否包含某一元素
	public boolean contains(Object obj) {
		return indexOf(obj) != -1;
	}

	// 某一元素首次出现的位置
	public int indexOf(Object obj) {
		if (obj == null) {
			for (int i = 0; i < size; i++) {
				if (elementData[i] == null) {
					return i;
				}
			}
		} else {
			for (int i = 0; i < size; i++) {
				if (obj.equals(elementData[i])) {
					return i;
				}
			}
		}
		return -1;
	}

	// 某一元素最后一次出现的位置
	public int lastIndexOf(Object obj) {
		if (obj == null) {
			for (int i = size - 1; i >= 0; i--) {
				if (elementData[i] == null) {
					return i;
				}
			}
		} else {
			for (int i = size - 1; i >= 0; i--) {
				if (obj.equals(elementData[i])) {
					return i;
				}
			}
		}
		return -1;
	}

	// 确保容量，如果实际的元素个数大于等于容量，则扩容
	private void ensureCapacity() {
		if (size >= elementData.length) {
			grow();
		}
	}

	// 扩容，每次增加原来一半的容量
	private void grow() {
		// 右移的时候一定要加括号，>>的优先级低于+，
		// 为了避免size为0，取扩容后的size和默认容量两者的最大值为新的容量
		int newCapacity = Math.max(size + (size >> 1), DEFAULT_CAPACITY);
		Object[] newElementData = new Object[newCapacity];
		for (int i = 0; i < size; i++) {
			newElementData[i] = elementData[i];
		}
		elementData = newElementData;
	}

	// 判断索引值是否为正确的元素索引
	private void checkElementIndex(int index) {
		if (index < 0 || index >= size) {
			throw new IndexOutOfBoundsException("index:" + index + ",size:" + size);
		}
	}

	// 可以添加元素的位置，索引从0开始到size
	private void checkPositionIndex(int index) {
		if (index < 0 || index > size) {
			throw new IndexOutOfBoundsException("index:" + index + ",size:" + size);
		}
	}

	@Override
	public String toString() {
		StringBuilder list = new StringBuilder();
		list.append("ArrayList [");
		for (int i = 0; i < size; i++) {
			list.append(elementData[i]);
			if (i < size - 1) {
				list.append(',');
			}
		}
		list.append("]");
		return list.toString();
	}
}
```

