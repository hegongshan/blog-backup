---
title: 数据结构(C/C++版)之单链表的实现
date: 2018-06-07 18:45:53
updated: 2018-06-07 18:45:53
tags: [数据结构,c/c++]
categories: 数据结构
---

<p class="text-center">用C/C++实现的单链表</p>

<!--more-->

```c
#include <stdio.h>
#include <stdlib.h>
/*以下所有方法中的index从1开始，而不是0. */
typedef struct Node
{
	ElemType data;
	struct Node * next;
} LinkedList;//单链表
//如果参数写为LinkedList * list，并不会改变实参的值，但可以改变实参指针变量所指向的变量的值
//初始化单链表
void init(LinkedList * &list)
{
	list = (LinkedList *) malloc(sizeof(LinkedList));
	list->next = NULL;
}
//是否为空
bool isEmpty(LinkedList * list)
{
	return list->next == NULL;
}
//输出单链表
void print(LinkedList * list)
{
	LinkedList * p = list->next;
	while(p!=NULL)
	{
		printf("%d ",p->data);
		p=p->next;
	}
	printf("\n");
}
//计算单链表长度，头结点不算在内
int length(LinkedList * list)
{
	int count = 0;
	LinkedList * p = list;
	while(p->next!=NULL)
	{
		count++;
		p = p->next;
	}
	return count;
}
/*//判断index是否为正确的位置索引，索引号从1开始到length(list)
static bool isPositionIndex(LinkedList * list,int index) {
	if(index > 0 && index <= length(list))
		return true;
	else
		return false;
}
//判断index是否为正确的可添加结点的位置索引，索引号从1开始到length(list)+1
static bool isPositionIndexForAdd(LinkedList * list,int index) {
	if(index > 0 && index <= length(list) + 1)
		return true;
	else
		return false;
}*/
//在单链表尾部添加结点
bool add(LinkedList * &list,ElemType e)
{
	LinkedList * p,* last = list;
	while(last->next!=NULL)
	{
		last = last->next;
	}
	p = (LinkedList *)malloc(sizeof(LinkedList));
	p->data = e;
	p->next = NULL;
	last->next = p;
	return true;
}
//在索引位置为index处插入新的结点
//下面的写法，只遍历了一次单链表
bool add(LinkedList * &list,int index,ElemType e)
{
	int count = 0;
	LinkedList * newNode,* p = list;
	while(p != NULL && count < index - 1)//找到index结点的前一个结点
	{
		count++;
		p = p->next;
	}
	if(p == NULL)//不存在第index-1个结点
		return false;
	else
	{
		newNode = (LinkedList *)malloc(sizeof(LinkedList));
		newNode->data = e;
		newNode->next = p->next;
		p->next = newNode;
		return true;
	}
}
/*//下面的写法，  遍历了两遍单链表
bool add(LinkedList * &list,int index,ElemType e)
{
	//判断给定的index是否合理
	if(!isPositionIndexForAdd(list,index))
		return false;
	int count = 0;
	LinkedList * newNode,* p = list;
	while(p != NULL && count < index - 1)//找到index结点的前一个结点
	{
		count++;
		p = p->next;
	}
	newNode = (LinkedList *)malloc(sizeof(LinkedList));
	newNode->data = e;
	newNode->next = p->next;
	p->next = newNode;
	return true;
}*/
//获取单链表中位置索引为index的元素，并将值赋给e
//只遍历一次
bool get(LinkedList * list,int index,ElemType &e)
{
	LinkedList * p = list->next;
	int count = 1;
	while(p != NULL && count < index)
	{
		count++;
		p = p->next;
	}
	if(p == NULL)//不存在第index个结点
		return false;
	else
	{
		e = p->data;
		return true;
	}
}
/*//需要遍历两次单链表
bool get(LinkedList * list,int index,ElemType &e)
{
	if(!isPositionIndex(list,index))
		return false;
	LinkedList * p = list->next;
	int count = 1;
	while(p != NULL && count < index)
	{
		count++;
		p = p->next;
	}
	e = p->data;
	return true;
}*/
/*//另一种更简洁的写法
ElemType get(LinkedList * list,int index)
{
	LinkedList * p = list->next;
	int count = 1;
	while(p != NULL && count < index)
	{
		count++;
		p = p->next;
	}
	if(p == NULL)//不存在第index个结点
		return NULL;
	else
		return p->data;
}
 */
//删除最后一个结点
bool remove(LinkedList * &list,ElemType &e)
{
	LinkedList * oldNode,* p = list;
	if(p->next == NULL)
		return false;
	while(p->next->next != NULL)//找最后一个结点的前驱结点
	{
		p = p->next;
	}
	oldNode = p->next;
	e =oldNode->data;
	p->next = NULL;
	free(oldNode);
	return true;
}
//删除第index个结点
bool remove(LinkedList * &list,int index,ElemType &e)
{
	int count = 0;
	LinkedList * oldNode, * p = list;
	while(p != NULL && count < index - 1)//找到第index-1个结点
	{
		count++;
		p = p->next;
	}
	if(p == NULL)//不存在第index-1个结点
		return false;
	else
	{
		oldNode = p->next;
		//这里需要特别注意，必须判断oldNode是否为NULL
		if(oldNode == NULL)
			return false;
		e = oldNode->data;
		p->next = oldNode->next;
		free(oldNode);
		return true;
	}
}
//在单链表中元素e首次出现的位置 ，若不存在，则返回-1
int indexOf(LinkedList * list,ElemType e)
{
	int count = 1;
	LinkedList * p = list->next;
	while(p != NULL && p->data != e)
	{
		count++;
		p = p->next;
	}
	if(p == NULL)
		return -1;
	else
		return count;
}
//销毁单链表
void destroy(LinkedList * &list)
{
	LinkedList * pre = list,* p = list->next;
	while(p!=NULL)
	{
		free(pre);
		pre = p;
		p = p->next;
	}
	free(pre);
}
```

测试程序：

```c
typedef int ElemType;//声明LinkedList.h中的ElemType为int类型
#include <stdio.h>
#include "LinkedList.h"//包含头文件时，尖括号用于引入系统库，自己定义的头文件，需要使用引号引入

int main() {
	LinkedList * list;
	init(list);
	add(list,20);
	add(list,20);
	add(list,21);
	add(list,22);
	add(list,23);
	add(list,2,100);
	printf("长度：%d\n",length(list));
	print(list);
	ElemType e;
	if(get(list,4,e))
		printf("第4个结点的值为：%d\n",e);
	printf("100首次出现的位置为：%d\n",indexOf(list,100));
	if(remove(list,3,e))
		printf("第3个结点的值为：%d\n",e);
	if(remove(list,e))
		printf("最后一个结点的值为：%d\n",e);
	print(list);
	destroy(list);
	return 0;
}
```

输出结果：

```c
长度：6
20 100 20 21 22 23 
第4个结点的值为：21
100首次出现的位置为：2
第3个结点的值为：20
最后一个结点的值为：23
20 100 21 22 
```

