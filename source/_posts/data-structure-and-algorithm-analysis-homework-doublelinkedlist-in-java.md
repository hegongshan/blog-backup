---
title: 数据结构与算法分析作业之自己实现Java双链表
date: 2018-05-27 17:30:16
tags: [数据结构,Java]
categories: 数据结构与算法分析:Java语言描述
---

<p class="text-center">自己实现的Java双链表</p>

<!--more-->

```java
package com.hegongshan.collections;
import java.util.NoSuchElementException;
/**
 * 双链表
 * @author hegongshan https://www.hegongshan.com
 * @param <E>
 */
public class DoubleLinkedList<E> {
	private int size = 0;
	private Node<E> first;
	private Node<E> last;
	
	private static class Node<E> {
		Node<E> prev;
		E data;
		Node<E> next;
		Node(Node<E> prev, E data, Node<E> next) {
			super();
			this.prev = prev;
			this.data = data;
			this.next = next;
		}
	}
    
	public DoubleLinkedList(){
		
	}
	
	public int size() {
		return size;
	}
	
	public boolean isEmpty() {
		return first == null;
	}
	
	public boolean add(E e) {
		linkLast(e);
		return true;
	}
	
	public void add(int index,E e) {
		checkPositionIndex(index);
		if(index == size) {
			linkLast(e);
		} else {
			linkBefore(e,node(index));
		}
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
	
	public E getLast() {
		if(last == null) {
			throw new NoSuchElementException();
		}
		return last.data;
	}
	
	public E set(int index,E e) {
		checkElementIndex(index);
		Node<E> node = node(index);
		E oldValue = node.data;
		node.data = e;
		return oldValue;
	}
	
	public E remove(int index) {
		checkElementIndex(index);
		Node<E> node = node(index);
		node.prev.next = node.next;
		node.next.prev = node.prev;
		E e = node.data;
		node.prev = null;
		node.next = null;
		node.data = null;
		size--;
		return e;
	}
	
	public E removeFirst() {
		if(first == null) {
			throw new NoSuchElementException();
		}
		Node<E> node = first;
		E e = node.data;
		first = node.next;
		node.next = null;
		node.data = null;
		if(first == null) {
			last = null;
		} else {
			first.prev = null;
		}
		size--;
		return e;
	}
	
	public E removeLast() {
		if(last == null) {
			throw new NoSuchElementException();
		}
		Node<E> node = last;
		E e = node.data;
		last = node.prev;
		node.prev = null;
		node.data = null;
		if(last == null) {
			first = null;
		} else {
			last.next = null;
		}
		size--;
		return e;
	}
	
	public void clear() {		
		for(Node<E> node = first;node != null;) {
			Node<E> next = node.next;
			node.prev = null;
			node.data = null;
			node.next = null;
			node = next;
		}
		first = last = null;
		size = 0;
	}
	
	public void reverse() {
		Node<E> temp = first;
		first = last;
		last = temp;
	}
	
	public boolean contains(Object obj) {
		return indexOf(obj) != -1;
	}
	
	public int indexOf(Object obj) {
		int index = 0;
		if(obj == null) {
			for(Node<E> node = first;node != null;node = node.next) {
				if(node.data == null) {
					return index;
				}
				index++;
			}
		} else {
			for(Node<E> node = first;node != null;node = node.next) {
				if(obj.equals(node.data)) {
					return index;
				}
				index++;
			}
		}
		return -1;
	}
	
	public int lastIndexOf(Object obj) {
		int index = size - 1;
		if(obj == null) {
			for(Node<E> node = last;node != null;node = node.prev) {
				if(node.data == null) {
					return index;
				}
				index--;
			}
		} else {
			for(Node<E> node = last;node != null;node = node.prev) {
				if(obj.equals(node.data)) {
					return index;
				}
				index--;
			}
		}
		return -1;
	}
	
	public void linkFirst(E e) {
		Node<E> node = new Node<>(null,e,first);
		first.prev = node;
		first = node;
		size++;
	}
	
	private void linkBefore(E e,Node<E> node) {
		Node<E> newNode = new Node<>(node.prev,e,node);
		node.prev.next = newNode;
		node.prev = newNode;
		size++;
	}
	
	public void linkLast(E e) {
		if(size == 0) {
			first = new Node<>(null,e,null);
			last = first;
			size++;
			return ;
		}
		Node<E> node = new Node<E>(last,e,null);
		last.next = node;
		last = node;
		size++;
	}
	
	private Node<E> node(int index) {
		checkElementIndex(index);
		if(index < (size >> 1)) {
			Node<E> node = first;
			for(int i = 0 ; i < index ; i++) {
				node = node.next;
			}
			return node;
		} else {
			Node<E> node = last;
			for(int i = size - 1 ; i > index ; i--) {
				node = node.prev;
			}
			return node;
		}
	}
	
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

