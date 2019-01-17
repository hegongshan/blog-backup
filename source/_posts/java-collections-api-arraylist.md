---
title: Java集合框架源码阅读之顺序表ArrayList
date: 2018-03-30 21:40:42
updated: 2018-03-30 21:40:42
tags: java collections api
categories: java
---
今天是《Java集合框架源码阅读》的第一篇，我们来讲讲Java中的顺序表ArrayList
首先来看下ArrayList的继承结构
```java
public class ArrayList<E> extends AbstractList<E>
        implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```
<!--more-->
	
构造方法：   
```java
public ArrayList(int initialCapacity)
public ArrayList()
public ArrayList(Collection<? extends E> c)
```

成员属性：
```java
private static final int DEFAULT_CAPACITY = 10;//ArrayList的默认容量
private static final Object[] EMPTY_ELEMENTDATA = {};//空数组
private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};//默认容量的空数组
transient Object[] elementData;
private int size;//ArrayList中实际存储的元素个数
private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;
```

### 问题一：ArrayList的底层是采用什么实现的？
查看ArrayList的源码可以发现如下代码:
```java
transient Object[] elementData;
```
不难看出，ArrayList是采用数组实现的，事实上，ArrayList就是一个动态数组。


### 问题二：ArrayList是带泛型的，为什么不直接申明泛型数组T[]，而要采用Object型数组存储数据？
java中不能直接实例化泛型数组，即不能new T[capacity];
如果硬要申明泛型数组T[]，需创建一个泛型类型限界的数组，然后使用一个数组进行类型转换。这将产生一个编译器警告，但在泛型集合的实现中这是不可避免的。
```java
T[] elementData;
...
elementData = (T[]) Object[capacity];
```

我们都知道数组的长度是不变的，那么ArrayList是如何实现动态扩容的呢？

### 问题三：ArrayList采用什么方式实现动态扩容？
下面举个很简单的例子，大家就能明白了
```java
static final DEFAULT_CAPACITY = 10;
...
int arr = new int[DEFAULT_CAPACITY];
...
//下面扩大arr容量
int newCapacity = arr.length + arr.length / 2;
int[] newArr = new int[newCapacity];
for(int i = 0; i< arr.length;i++) {
	newArr[i] = arr[i];
}
arr = newArr;
```
事实上，ArrayList内部也是采用的复制数组的方式实现动态扩容。至于其到底是如何做到的，请看下一个问题。

### 问题四：ArrayList的扩容机制？
要回答这个问题，我们先得弄明白：当我们使用add(E e)时，ArrayList都干了什么
```java
//在尾部添加
public boolean add(E e) {
	ensureCapacityInternal(size + 1);  // Increments modCount!!
	elementData[size++] = e;
	return true;
}```
可以看到，当我们调用add(E e)方法时，先执行的ensureCapacityInternal(size+1),然后将e加入elementData，size加1。ensureCapacityInternal直译为“确保内部容量”，它又是怎么实现的呢？
​```java
//@param   minCapacity   需要的最小容量
private void ensureCapacityInternal(int minCapacity) {
	//判断elementData是否为默认长度的空数组，
	//若是，则minCapacity取默认容量和原minCapacity的最大值
	if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
		minCapacity = Math.max(DEFAULT_CAPACITY, minCapacity);
	}
	ensureExplicitCapacity(minCapacity);
}```

看到这里，又出现了一个新的方法ensureExplicitCapacity(int minCapacity)，ensureExplicitCapacity直译为“确保明确的容量”，接着往下挖
​```java
private void ensureExplicitCapacity(int minCapacity) {
	//modCount是ArrayList的父类AbstractList中定义的局部变量，
	//用于表示List的结构修改次数
	modCount++;
	// 如果minCapacity超过了ArrayList的容量，则对其扩容
	if (minCapacity - elementData.length > 0)
		grow(minCapacity);
}```
这里出现了一个新的方法grow(int minCapacity)，grow意为“成长”，这就是**ArrayList动态扩容的秘密**吗？我们接着往下看

​```java 
private void grow(int minCapacity) {
	int oldCapacity = elementData.length;
	//每次扩容后，新的容量为原来容量的1.5倍，oldCapacity >> 1等价于 oldCapacity / 2
	int newCapacity = oldCapacity + (oldCapacity >> 1);
	if (newCapacity - minCapacity < 0)
		newCapacity = minCapacity;
	if (newCapacity - MAX_ARRAY_SIZE > 0)
		newCapacity = hugeCapacity(minCapacity);
	//通过复制数组的方式，将数组扩容
	elementData = Arrays.copyOf(elementData, newCapacity);
}
```
其中出现了一个新的变量MAX_ARRAY_SIZE，ArrayList中对它的定义如下：<br>
```java
private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;
```
为什么这么定义？

源代码中的注释如下：
The maximum size of array to allocate. Some VMs reserve some header words in an array.
Attempts to allocate larger arrays may result in OutOfMemoryError: Requested array size exceeds VM limit<br>
翻译：可分配的最大的数组大小。一些虚拟机在数组中保留了一些头部信息。
试图给数组分配更大的空间可能导致内存溢出错误：请求的数组大小超过了虚拟机的限制

```java
//给定需要的最小容量，如果所给最小容量小于0，抛出内存溢出错误，
//如果最小容量大于ArrayList定义的最大数组长度，则返回Integer的最大值，
//否则，返回ArrayList定义的最大数组长度
private static int hugeCapacity(int minCapacity) {
	if (minCapacity < 0) // overflow
		throw new OutOfMemoryError();
	return (minCapacity > MAX_ARRAY_SIZE) ?
		Integer.MAX_VALUE :
		MAX_ARRAY_SIZE;
}
```

>作业：自己动手实现简单的ArrayList
>下回预告：数据结构与算法分析之Java中的双链表LinkedList