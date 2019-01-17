---
title: Java集合框架源码阅读之双链表LinkedList
date: 2018-04-01 16:33:12
updated: 2018-04-01 16:33:12
tags: java collections api
categories: java
---
>本文只分析LinkedList的增(add) 删(remove) 改(set) 查(get)的实现，剩余的部分留给读者自己去浏览吧

本文是《Java集合框架源码阅读》系列的第二篇，我们的主角是java.util.LinkedList
老规矩，先看LinkedList继承结构
```java
public class LinkedList<E>
    extends AbstractSequentialList<E>
    implements List<E>, Deque<E>, Cloneable, java.io.Serializable
```
<!--more-->
构造方法：
```java
public LinkedList()
public LinkedList(Collection<? extends E> c)
```
成员属性：
```java
transient int size = 0;
transient Node<E> first;//头结点
transient Node<E> last;//尾结点
```

### 问题一：LinkedList如何存储结点信息？
查看源码可以发现，LinkedList内部有一个静态内部类Node&lt;E&gt;，其保存了当前结点的数据信息，以及指向其前驱和后继结点的链（或称指针）
```java
private static class Node<E> {
	E item;
	Node<E> next;
	Node<E> prev;
	Node(Node<E> prev, E element, Node<E> next) {
		this.item = element;
		this.next = next;
		this.prev = prev;
	}
}
```
### 问题二：LinkedList是如何实现尾部添加add(E e)方法的？
源码如下：
```java
public boolean add(E e) {
	linkLast(e);
	return true;
}
void linkLast(E e) {
	final Node<E> l = last;
	final Node<E> newNode = new Node<>(l, e, null);
	last = newNode;
	if (l == null)
		first = newNode;
	else
		l.next = newNode;
	size++;
	modCount++;
}
```
解析：每当调用add(E e)方法时，首先调用linkLast(E e)，linkLast顾名思义，链接到尾结点，
新建一个Node，让当前尾结点l成为其前驱结点，后继结点设为null，继而，新建的Node成为了新
的尾结点，若原尾结点l尚未初始化，则让头结点指向新建的Node结点，否则，原来的尾节点L已经初始化了，则让新增结点成为原来的尾节点L的后继结点

我们都知道Java中的表List都是可以通过索引号（下标）获取结点值的，即 T get(int index)，ArrayList本身是数组，当然很好实现，而LinkedList却是双链表，它又是如何实现的呢？
### 问题三：LinkedList是如何实现随机添加add(int index,E e)方法的？
先来看下原理图：
![双链表插入](http://p64uw9x5j.bkt.clouddn.com/image/20180401191343.png "在双链表中插入新的结点")
<pre>
第一步：newNode.prev = succ.prev;
        newNode.next = succ;
第二步：succ.prev = newNode;
第三步：if(pred != null) 
			pred.next = newNode;
		else
			first = newNode;
</pre>
源码如下：
```java
public void add(int index, E element) {
	checkPositionIndex(index);//判断index是否为可以插入的位置

	if (index == size)
		linkLast(element);
	else
		linkBefore(element, node(index));
}
private void checkPositionIndex(int index) {
	if (!isPositionIndex(index))
		throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
}
private boolean isPositionIndex(int index) {
	return index >= 0 && index <= size;
}
//在给定结点succ的前面插入一个新的结点，结点的值为e
void linkBefore(E e, Node<E> succ) {
	final Node<E> pred = succ.prev;
	final Node<E> newNode = new Node<>(pred, e, succ);
	succ.prev = newNode;
	if (pred == null)
		first = newNode;
	else
		pred.next = newNode;
	size++;
	modCount++;
}
```

### 问题四：LinkedList是如何实现get(int index)方法的？
源码如下：
```java
public E get(int index) {
	//检查是否满足0 <= index < size，不满足则抛出下标越界异常
	checkElementIndex(index);
	return node(index).item;
}
private void checkElementIndex(int index) {
	if (!isElementIndex(index))
		throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
}
private boolean isElementIndex(int index) {
	return index >= 0 && index < size;
}
Node<E> node(int index) {
	if (index < (size >> 1)) {
		Node<E> x = first;
		for (int i = 0; i < index; i++)
			x = x.next;
		return x;
	} else {
		Node<E> x = last;
		for (int i = size - 1; i > index; i--)
			x = x.prev;
		return x;
	}
}
```
可以发现，get(int index)中使用了一个node(int index)来获取指定下标的Node，而node(int index)又采用了二分法——首先判断指定索引位于LinkedList的前半部分，还是后半部分，这么做主要是为了提高效率，减少需要遍历的结点个数，然后依次遍历结点，直至找到指定下标的Node。
从源码也可以看出来，***LinkedList并不适合随机取数据***，因为每次按照索引号随机取数据时，都需要依次遍历表

### 问题五：LinkedList是如何实现remove(int index)方法的？
先看原理图：
![双链表删除](http://p64uw9x5j.bkt.clouddn.com/image/20180401193913.png "删除双链表中的结点")
源码如下：
```java
public E remove(int index) {
	checkElementIndex(index);
	return unlink(node(index));
}
E unlink(Node<E> x) {
	final E element = x.item;
	final Node<E> next = x.next;
	final Node<E> prev = x.prev;

	/* [===] ——>  [===]  ——> [===] 
	 *  ||	                   ||
	 * null         ×         first
	 */
	if (prev == null) {
		first = next;
	} else {
		prev.next = next;
		x.prev = null;
	}	
	
	/* [===] ——>  [===]  ——> [===] 
	 *  ||                    ||
	 * last         ×         null  
	 */
	if (next == null) {
		last = prev;
	} else {
		next.prev = prev;
		x.next = null;
	}

	x.item = null;
	size--;
	modCount++;
	return element;
}
```

### 问题六：LinkedList是如何实现set(int index,E element)方法的？
set方法的实现相对简单，源码如下：
```java
//把element设为新的item，返回原来的item
public E set(int index, E element) {
	checkElementIndex(index);
	Node<E> x = node(index);
	E oldVal = x.item;
	x.item = element;
	return oldVal;
}
```
>作业：自己实现简单的单链表SingleLinkedList以及循环单/双链表CircularSingleLinkedList/CircularDoubleLinkedList
>下回预告：数据结构与算法分析之Java中的栈