---
title: 数据结构与算法分析作业之自己实现Java单链表
date: 2018-05-26 20:14:55
updated: 2018-05-26 20:14:55
tags: [数据结构,java]
categories: 数据结构与算法分析:Java语言描述
---

<p class="text-center">自己实现的Java单链表</p>

<!--more-->

```java
package com.hegongshan.collections;
import java.util.NoSuchElementException;
/**
 * 单链表
 * @author hegongshan https://www.hegongshan.com
 * @param <E>
 */
public class SingleLinkedList<E> {

	private int size = 0;
	private Node<E> first;

	public SingleLinkedList() {
	}

	// 单链表中元素个数
	public int size() {
		return size;
	}

	// 判断单链表是否为空
	public boolean isEmpty() {
		return first == null;
	}

	public boolean contains(Object obj) {
		return indexOf(obj) != -1;
	}

	public Object[] toArray() {
		if (isEmpty()) {
			return null;
		}
		Object[] array = new Object[size];
		Node<E> node = first;
		for (int i = 0; i < size; i++) {
			array[i] = node.data;
			node = node.next;
		}
		return array;
	}

	@SuppressWarnings("unchecked")
	public <T> T[] toArray(T[] a) {
		return (T[]) toArray();
	}

	public boolean add(E e) {
		linkLast(e);
		return true;
	}

	// 在单链表尾部插入新的结点
	public void linkLast(E e) {
		if (!isEmpty()) {
			Node<E> newNode = new Node<>(e, null);
			Node<E> last = first;
			while (last.next != null) {
				last = last.next;
			}
			last.next = newNode;
		} else {
			first = new Node<>(e, null);
		}
		size++;
	}

	// 在单链表头部插入新的数据
	public void linkFirst(E e) {
		Node<E> newNode = new Node<>(e, first);
		first = newNode;
		size++;
	}

	// 清空单链表
	public void clear() {
		for (Node<E> node = first; node != null;) {
			Node<E> next = node.next;
			node.data = null;
			node.next = null;
			node = next;
		}
		first = null;
		size = 0;
	}

	public E get(int index) {
		checkElementIndex(index);
		return node(index).data;
	}
	
	public E getFirst() {
		if(first == null) {
			throw new NoSuchElementException();
		}
		return first.data;
	}

	// 把索引号为index的结点的数据改为element，并返回原来的结点数据
	public E set(int index, E element) {
		checkElementIndex(index);
		Node<E> node = node(index);
		E oldElement = node.data;
		node.data = element;
		return oldElement;
	}

	// 在指定索引处插入元素
	public void add(int index, E element) {
		checkPositionIndex(index);
		if (index == 0) {
			linkFirst(element);
			return;
		}
		Node<E> newNode = new Node<>(element, null);
		Node<E> node = first;
		for (int i = 0; i < index - 1; i++) {
			node = node.next;
		}
		newNode.next = node.next;
		node.next = newNode;
		size++;
	}

	// 删除指定索引的结点，并返回该结点的数据值
	public E remove(int index) {
		checkElementIndex(index);
		Node<E> node = first;
		for (int i = 0; i < index - 1; i++) {
			node = node.next;
		}
		Node<E> removeNode = node.next;
		node.next = removeNode.next;
		E e = removeNode.data;
		removeNode.data = null;
		removeNode.next = null;
		return e;
	}
	
	//反转单链表pre->p->next
	public void reverse() {
		Node<E> pre = first;
		Node<E> p = first.next;
		Node<E> next = null;
		pre.next = null;
		while(p != null) {
			next = p.next;
			p.next = pre;
			pre = p;
			p = next;
		}
		first = pre;
	}

	// 给定数据在单链表中首次出现的位置
	public int indexOf(Object obj) {
		int index = 0;
		if (obj == null) {
			for (Node<E> node = first; node != null; node = node.next) {
				if (node.data == null) {
					return index;
				}
				index++;
			}
		} else {
			for (Node<E> node = first; node != null; node = node.next) {
				if (obj.equals(node.data)) {
					return index;
				}
				index++;
			}
		}
		return -1;
	}

	// 给定数据在单链表中最后一次出现的位置
	public int lastIndexOf(Object obj) {
		int index = 0;
		int i = 0;
		int[] array = new int[size];
		if (obj == null) {
			for (Node<E> node = first; node != null; node = node.next) {
				if (node.data == null) {
					array[i++] = index;
				}
				index++;
			}
		} else {
			for (Node<E> node = first; node != null; node = node.next) {
				if (obj.equals(node.data)) {
					array[i++] = index;
				}
				index++;
			}
		}
		if (array.length != 0) {
			return array[i - 1];
		}
		return -1;
	}
	
	/*public int lastIndexOf(Object obj) {
		Object[] array = toArray();
		if(obj == null) {
			for(int i = array.length -1;i>=0;i--) {
				if(array[i] == null) {
					return i;
				}
			}
		} else {
			for(int i = array.length -1;i>=0;i--) {
				if(obj.equals(array[i])) {
					return i;
				}
			}
		}
		return -1;
	}*/

	@Override
	public String toString() {
		StringBuilder list = new StringBuilder("[");
		Node<E> node = first;
		int index = 0;
		while (node != null) {
			index++;
			if (index == size) {
				list.append(node.data);
			} else {
				list.append(node.data).append(",");
			}
			node = node.next;
		}
		list.append("]");
		return list.toString();
	}
	
	private Node<E> node(int index) {
		checkElementIndex(index);
		Node<E> node = first;
		for(int i = 0 ; i < index ;i++) {
			node = node.next;
		}
		return node;
	}

	private static class Node<E> {
		private E data;
		private Node<E> next;

		Node(E data, Node<E> next) {
			this.data = data;
			this.next = next;
		}
	}

	// 单链表中的结点索引从0开始到size-1
	private void checkElementIndex(int index) {
		if (index < 0 || index >= size) {
			throw new IndexOutOfBoundsException("index:" + index + ",size:" + size);
		}
	}

	// 可以添加结点的位置，索引从0开始到size
	private void checkPositionIndex(int index) {
		if (index < 0 || index > size) {
			throw new IndexOutOfBoundsException("index:" + index + ",size:" + size);
		}
	}
}
```

