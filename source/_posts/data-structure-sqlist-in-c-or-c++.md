---
title: 数据结构(C/C++版)之动态顺序表的实现
date: 2018-06-03 22:35:32
tags: [数据结构,C/C++]
categories: 数据结构
---

>**写在前面的话**：类似如下函数：bool add(SqList &list, int i, ElemType e)
>**c语言没有bool关键字**，c++才有，若需要在c语言中使用，需要引入**&lt;stdbool.h&gt;（或者自己定义）.**
>另外，**函数参数中&符号，表示引用，c语言也没有**（c语言中的&表示取地址符），这是c++才有的语法，若需要在c语言中实现类似功能，即改变实参的值，只能采用指针实现

用C/C++实现的动态顺序表

<!--more-->

```c
#include <stdlib.h>

#define DEFAULT_CAPACITY 10 //默认容量
#define DEFAULT_INCREMENT_SIZE 1 //默认扩容大小

typedef struct {
	ElemType * data;//存储元素的一维数组
	int length; //顺序表当前的长度
	int size; //顺序表的容量
	int incrementSize; //增补空间大小
} SqList;

//初始化，需要注意的是：给参数设置默认值，c语言没有这种语法
void init(SqList &list, int capacity = DEFAULT_CAPACITY, int incrementSize = DEFAULT_INCREMENT_SIZE) {
	list.data = (ElemType *) malloc(capacity * sizeof(ElemType));
	if (!list.data) {
		exit(1);
	}
	list.length = 0;
	list.size = capacity;
	list.incrementSize = incrementSize;
}

bool isEmpty(SqList list) {
	return list.length == 0;
}

//求顺序表的长度
int length(SqList list) {
	return list.length;
}
//元素首次出现的位置
int indexOf(SqList list, ElemType e) {
	for (int i = 0; i < list.length; i++) {
		if (list.data[i] == e) {
			return i;
		}
	}
	return -1;
}

//元素最后一次出现的位置
int lastIndexOf(SqList list, ElemType e) {
	for (int i = list.length - 1; i >= 0; i--) {
		if (list.data[i] == e) {
			return i;
		}
	}
	return -1;
}

/*
 * static关键字的作用类似于Java中private，声明为内部函数，只能在本文件中使用
 * 另外需要注意的是，该函数必须放在引用之前，否则，编译时会报错
 */
static bool isElementIndex(SqList list, int i) {
	return (i >= 0 && i < list.length) ? true : false;
}

static bool isPositionIndex(SqList list, int i) {
	return (i >= 0 && i <= list.length) ? true : false;
}

static void ensureCapacity(SqList &list) {
	//扩容
	if (list.length >= list.size) {
		list.data = (ElemType *) realloc(list.data,
				(list.size + list.incrementSize) * sizeof(ElemType));
		//判断存储空间是否分配成功
		if (!list.data) {
			exit(1);
		}
		list.size += list.incrementSize; //增加当前存储容量
	}
}
//在顺序表中指定索引处插入元素
bool add(SqList &list, int i, ElemType e) {
	if (!isPositionIndex(list, i)) {
		return false;
	}
	ensureCapacity(list);
	for (int j = list.length; j > i; j--) {
		list.data[j] = list.data[j - 1];
	}
	list.data[i] = e; //???
	list.length++;
	return true;
}
//在顺序表的最后面添加元素
bool add(SqList &list, ElemType e) {
	//扩容
	ensureCapacity(list);
	list.data[list.length] = e;
	list.length++;
	return true;
}
//删除最后一个元素
bool remove(SqList &list, ElemType &e) {
	if (isEmpty(list)) {
		return false;
	}
	e = list.data[list.length - 1];
	list.length--;
	return true;
}
//删除指定索引处的元素
bool remove(SqList &list, int i, ElemType &e) {
	if (!isElementIndex(list, i) || isEmpty(list)) {
		return false;
	}
	e = list.data[i];
	for (int j = i + 1; j <= list.length - 1; j++) {
		list.data[j - 1] = list.data[j];
	}
	list.length--;
	return true;
}
//取元素
bool get(SqList list, int i, ElemType &e) {
	if (!isElementIndex(list, i)) {
		return false;
	}
	e = list.data[i];
	return true;
}
//遍历输出
void print(SqList list) {
	for (int i = 0; i < list.length; i++) {
		printf("%d\n", list.data[i]);
	}
}
//销毁
void destroy(SqList &list) {
	free(list.data);
	list.length = 0;
	list.incrementSize = 0;
}
```

