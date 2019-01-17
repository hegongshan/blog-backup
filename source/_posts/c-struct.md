---
title: C语言结构体
date: 2018-05-31 12:04:44
updated: 2018-05-31 12:04:44
tags: c
categories: c
---

C语言允许用户自己建立由不同类型数据组成的组合型的数据结构，它称为结构体。（类似于Java中的类）

### 定义结构体类型

声明一个结构体类型的一般形式：

```c
struct 结构体名 {
	成员列表  
};
```

对结构体中各成员都应进行类型声明，即

```c
类型名	成员名;
```

<!--more-->

示例

```c
struct Book {
    char author[10];
    char name[20];
    double price;
};//注意最后有一个分号
```

结构体的成员可以属于另一个结构体类型。例如：

```c
struct Date {
    int year;
    int month;
    int day;
};
struct Book {
    char author[10];
    char name[20];
    double price;
    struct Date publishTime;//成员publishTime属于struct Date类型
}
```

值得注意的是，***结构体类型的名字是由关键字struct和结构体名组合而成的***，即结构体类型 = struct 结构体名。 

### 定义结构体类型变量

C语言中定义结构体类型变量有三种方式。

1.先声明结构体类型，再定义该类型的变量（常用）

上面说到结构体内可以定义结构体类型的成员变量时，我的做法是先声明了一个结构体类型Struct Date，然后在声明Struct Book类型时，将成员变量publishTime指定为struct Date类型。下面再举一个例子说明

```c
struct Date {
    int year;
    int month;
    int day;
};//声明struct Date类型
int main() {
    struct Date today;//定义struct Date类型的变量
    ...
    return 0;
}
```

2.在声明类型的同时定义变量

这种定义的一般形式如下：

```c
struct 结构体名 {
    成员列表
} 变量名列表;
```

例如：

```c
struct Book {
    char author[10];
    char name[20];
    double price;  
} book1,book2;//声明struct Book类型的同时定义了两个struct Book类型的变量book1,book2
```

个人觉得，把上面的申明类型同时定义变量，变成如下形式来看，可能更易于理解：

```c
struct Book{char author[10];char name[20];double price;} book1,book2;
```

这样看，是不是特别类似于普通变量的定义，前面是类型，后面是变量列表。当然你也可以通过其他的方式来记住结构体类型，不管黑猫白猫能抓到老鼠就是好猫>_<。

 3.不指定类型名而直接定义结构体类型变量

其一般形式如下：

```c
struct {
    成员列表
} 变量名列表;
```

例如：

```c
struct {
    char author[10];
    char name[20];
    double price;  
} book1,book2;
```

可以看到，这种方法指定了一个匿名的结构体类型，它没有名字，因此不能再以此结构体类型去定义其他变量。这种方式用的不多。

### 结构体变量的初始化和引用

#### 初始化结构体变量

在定义结构体变量时，可以对它初始化，即赋予初始值。

先看一个例子

```c
#include <stdio.h>
int main() {
	struct Book {
		char author[10];
		char name[20];
		double price;
	} book = {"谭浩强","C程序设计",33.00};
	printf("作者：%s，书名：%s，价格：%f\n",book.author,book.name,book.price);
	return 0;
}
```

输出结果:

```c
作者：谭浩强，书名：C程序设计，价格：33.000000
```

从上例可以看出，***初始化列表是用花括号括起来的一些常量，这些常量依次赋给结构体变量中的各成员。***

如果我只想对某一成员初始化怎么办呢？

C99标准允许对某一成员初始化，如：

```c
#include <stdio.h>
int main() {
	struct Book {
		char author[10];
		char name[20];
		double price;
	} book = {.price = 33.00};
    //在成员名前有成员运算符".",".price"隐含代表结构体变量book的成员book.price
	printf("作者：%s，书名：%s，价格：%f\n",book.author,book.name,book.price);
	return 0;
}
```

输出结果：

```c
作者：，书名：，价格：33.000000
```

其他未被初始化的成员由系统赋默认值，数值型为0，字符型为'\0'，指针型成员为NULL

#### 引用结构体变量中的成员

引用方式为

```c
结构体变量名.成员名
```

其中，“.”是成员运算符，它在所有的运算符中优先级最高

### 结构体数组

定义结构体数组的一般形式：

①直接定义

```c
struct 结构体名 {
    成员列表
} 数组名[数组长度]; 
```

②先声明结构体类型，再用此类型定义结构体数组

```c
结构体类型 数组名[数组长度]; 
```

示例：

```c
#include <stdio.h>
int main() {
	struct Book{
		char author[16];
		char name[25];
		double price;
	} book[2] = {{"谭浩强","C程序设计",33.00},{"明日科技","Java从入门到精通",55.51}};
	const int n = 2;//定义常变量,const 类似于Java中的 final
	for(int i = 0 ; i < n ;i++) {
		printf("作者：%s，书名：%s，价格：%f\n",book[i].author,book[i].name,book[i].price);
	}
	return 0;
}

```

输出结果：

```c
作者：谭浩强，书名：C程序设计，价格：33.000000
作者：明日科技，书名：Java从入门到精通，价格：55.510000
```

需要注意的是，在上面代码的第7行，给数组初始化的时候，每本书的信息，我用一对花括号包起来了，这样做的目的是方便阅读和检查。事实上，下面的代码也是可行的，但不推荐

```c
struct Book{
    char author[16];
    char name[25];
    double price;
} book[2] = {"谭浩强","C程序设计",33.00,"明日科技","Java从入门到精通",55.51};
```

### 结构体指针

结构体指针变量的定义和引用，与普通的指针变量一样。

示例:

```c
#include <stdio.h>
#include <string.h>
struct Book{
	char author[16];
	char name[25];
	double price;
};
int main() {
	struct Book book;
	struct Book * p = &book;//定义结构体指针变量p并让其指向book
	strcpy(book.author,"谭浩强");
    //这里不能直接写book.name = "C程序设计";，会报错，必须通过c语言提供的字符串赋值函数赋值
	strcpy(book.name,"C程序设计");
	book.price = 33.00;
	printf("作者：%s，书名：%s，价格：%f\n",book.author,book.name,book.price);
	printf("作者：%s，书名：%s，价格：%f\n",(*p).author,(*p).name,(*p).price);
	return 0;
}
```

输出结果：

```c
作者：谭浩强，书名：C程序设计，价格：33.000000
作者：谭浩强，书名：C程序设计，价格：33.000000
```

需要注意的是,"."的优先级高于“\*”，所以必须用括号将\*p括起来，即使用(\*p).author这种形式。

<hr>

为了使用方便和直观，C语言允许把(\*p).author用p->author来代替，<strong>“->”称为指向运算符</strong>，p->author表示p所指向的结构体变量中的author成员。(这里很重要，C语言中最常见的就是"->")

用->改写上面的代码：

```c
#include <stdio.h>
#include <string.h>
struct Book{
	char author[16];
	char name[25];
	double price;
};
int main() {
	struct Book book;
	struct Book * p = &book;
	strcpy(book.author,"谭浩强");
	strcpy(book.name,"C程序设计");
	book.price = 33.00;
	printf("作者：%s，书名：%s，价格：%f\n",book.author,book.name,book.price);
	printf("作者：%s，书名：%s，价格：%f\n",p->author,p->name,p->price);
	return 0;
}
```

输出结果：

```
作者：谭浩强，书名：C程序设计，价格：33.000000
作者：谭浩强，书名：C程序设计，价格：33.000000
```

