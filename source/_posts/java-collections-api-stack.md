---
title: Java集合框架源码阅读之栈Stack
date: 2018-04-02 14:36:12
updated: 2018-04-02 14:36:12
tags: java collections api
categories: java
---
>什么是栈？
>栈是限制插入和删除只能在一个位置上进行的表，它是一个后进先出(last-in-first-out，LIFO)表

本文是《Java集合框架源码阅读》系列的第三篇，我们来说说Java中的栈
在Java Collections API中有一个类叫做java.util.Stack，它的继承结构如下：
```java
public class Stack<E> extends Vector<E>
```
它是在java.util.Vector类的基础上扩展了5个方法而来的
```java
public E push(E item)//进栈
public synchronized E pop()//出栈，返回栈顶元素并将其删除
public synchronized E peek()//取得栈顶元素（不删除）
public boolean empty()//判断是否为空栈
public synchronized int search(Object o)//详见问题四
```
<!--more-->
Stack本身是扩展Vector而来的，而Vector是一个可增长的对象数组（The Vector class implements a growable array of objects），那么这个数组的哪部分成为了Stack的栈顶和栈底呢？

### 问题一：Stack的栈顶和栈底在哪里？
我们先来观察peek()方法的源码：
```java
public synchronized E peek() {
	int     len = size();

	if (len == 0)
		throw new EmptyStackException();
	return elementAt(len - 1);
}
```
这里调用了父类Vector的elementAt(int index)方法
```java
public synchronized E elementAt(int index) {
	if (index >= elementCount) {
		throw new ArrayIndexOutOfBoundsException(index + " >= " + elementCount);
	}

	return elementData(index);
}
@SuppressWarnings("unchecked")
E elementData(int index) {
	return (E) elementData[index];
}
```
通过观察以上源码，我们可以发现：调用peek()方法时，实际返回的是数组elementData的最后一位，也就是说，***Stack的栈顶为Vector中数组的末端***，相应的，数组起始端即为栈底
事实上，在peek()方法的注释中也说明了这一点：return the object at the top of this stack (the last item of the Vector object).

### 问题二：Stack如何实现进栈操作？
源码如下：
```java
public E push(E item) {
	addElement(item);

	return item;
}
```
此处调用了其父类Vector的addElement(E item)，源码如下：
```java
protected Object[] elementData;//默认初始化容量为10
protected int elementCount;
protected int capacityIncrement;
public synchronized void addElement(E obj) {
	modCount++;
	ensureCapacityHelper(elementCount + 1);
	elementData[elementCount++] = obj;
}
private void ensureCapacityHelper(int minCapacity) {
	if (minCapacity - elementData.length > 0)
		grow(minCapacity);
}
private void grow(int minCapacity) {
	int oldCapacity = elementData.length;
	//默认的capacityIncrement为0，即默认扩容后新的容量为原来的两倍
	int newCapacity = oldCapacity + 
	((capacityIncrement > 0) ? capacityIncrement : oldCapacity);
	if (newCapacity - minCapacity < 0)
		newCapacity = minCapacity;
	if (newCapacity - MAX_ARRAY_SIZE > 0)
		newCapacity = hugeCapacity(minCapacity);
	elementData = Arrays.copyOf(elementData, newCapacity);
}
private static int hugeCapacity(int minCapacity) {
	if (minCapacity < 0) // overflow
		throw new OutOfMemoryError();
	return (minCapacity > MAX_ARRAY_SIZE) ?
		Integer.MAX_VALUE :
		MAX_ARRAY_SIZE;
}
```

### 问题三：Stack如何实现出栈操作？
源码如下：
```java
public synchronized E pop() {
	E       obj;
	int     len = size();

	obj = peek();
	removeElementAt(len - 1);

	return obj;
}
```

### 问题四：Stack中的search(Object o)方法返回的值表示什么意思？

search(Object o)的源码（下面的注释是我从原方法注释中截取下来的）如下：
```java
//The equals method is used to compare o to the items in this stack.
//return the 1-based position from the top of the stack where the object is located; 
//the return value -1 indicates that the object is not on the stack.
public synchronized int search(Object o) {
	int i = lastIndexOf(o);

	if (i >= 0) {
		return size() - i;
	}
	return -1;
}
```
这里调用了父类Vector的lastIndexOf(Object o)方法，从数组的最后往前找（也即从栈顶往下依次查找），查找第一次出现的位置（因为栈中元素是可以重复的），若没找到该对象，返回-1，否则返回该对象和栈顶元素之间的距离，***返回值从1（表示所要查找的对象就是栈顶元素）开始***
下面的示例让我们很容易明白search(Object o)到底要返回的是什么？
```java
Stack<String> s = new Stack<>();
for(int i = 0 ;i < 10;i++) 
	s.push(String.valueOf(i));
System.out.println("栈顶元素："+s.peek());
System.out.println("9到栈顶的距离："+s.search("9"));
System.out.println("0到栈顶的距离："+s.search("0"));
System.out.println("10到栈顶的距离："+s.search("10"));
```
输出：
```java
栈顶元素：9
9到栈顶的距离：1
0到栈顶的距离：10
10到栈顶的距离：-1

```
值得注意的是，***search(Object o)方法的查找是基于对象的equals方法进行，若泛型申明为自定义的类型，需要重写equals方法***

### 栈的应用之配对问题
***问题：***输入一串字符串，判断其中的括号是否配对（可以引申为判断字符串是否为json串，是否为算数表达式等等），例如，***[( )]***是配对的，而***[( ])]***就不配对
***算法思想：***先判断输入的字符串是否为空串（null或者"    "等均认为是空串），若为空串则直接返回false。否则，实例化一个空栈。如果字符为(，[，{等开放符号，则让其进栈。如果字符为)，]，}等封闭符号，则当栈空时返回false。若栈不空，则判断栈顶字符是否为对应的开放字符，若不是，则返回false，否则继续判断下一个字符
***代码示例如下：***
```java
import java.util.Stack;

public class Main {
	
	public static boolean isMatch(String json) {
		if(isEmpty(json))
			return false;
		char[] charArray = json.toCharArray();
		Stack<Character> s = new Stack<Character>();
		for(char c : charArray) {
			if(c == '{' || c == '[' || c == '(')
				s.push(c);
			else if(c == '}') {
				if(isMatch0(s,'{'))
					s.pop();
				else
					return false;
					
			} else if(c == ']') {
				if(isMatch0(s,'['))
					s.pop();
				else
					return false;
			} else if(c == ')') {
				if(isMatch0(s,'('))
					s.pop();
				else
					return false;
			}
		}
		return true;	
	}
	//当栈空时返回false。
	//若栈不空，则判断栈顶字符是否为对应的开放字符，若不是，则返回false
	private static boolean isMatch0(Stack<?> s,char openChar) {
		if(s.empty() || (char)s.peek() != openChar)
			return false;
		return true;
	}
	
	public static boolean isEmpty(String str) {
		return str == null || str.trim().isEmpty();
	}
	
	public static void main(String[] args) {
		System.out.println(isMatch("{[([asdfffffffffff])]}"));
		System.out.println(isMatch("{][])99(}"));
	}
}
```
输出结果
```java
true
false
```

> ***结语***
> ***java.util.Stack的注释中写道：***A more complete and consistent set of LIFO stack operations is provided by the Deque interface and its implementations, which should be used in preference to this class. For example: Deque&lt;Integer&gt; stack = new ArrayDeque&lt;Integer&gt;();
> 言下之意是相比Stack类，***双端队列Deque和它的实现类***具有更好的完整性和一致性，应该被优先使用

* 下回预告：数据结构与算法分析之Java中的队列Queue
