---
title: GCC常见编译选项
date: 2021-09-29 10:04:41
tags: gcc
categories: gcc
---

GCC，全称**G**NU **C**ompiler **C**ollection。

<!--more-->

新建test.c文件，内容如下：

```c
#include <stdio.h>

int main()
{
    printf("Hello world!\n");
    return 0;
}
```

### 预处理

* -E：只进行预处理

```shell
gcc -E test.c -o test.i
```

### 编译

* -S：只进行预处理和编译，生成汇编代码*.s

```shell
gcc -S test.c
```

### 汇编

* -c：只进行预处理、编译和汇编，生成对象文件（机器码）*.o

```c
gcc -c test.c
```

### 链接

生成可执行文件。使用-o选项指定可执行文件名。

```c
// 默认的可执行文件名为a.out
gcc test.c
// 可执行文件名为test.out
gcc test.c -o test.out
```

* -g：生成源码级的调试信息

### 指定代码的编译版本

使用GCC进行编译时，部分特性可能无法在默认的编译版本中编译通过，比如在for循环中定义变量：

```c
#include <stdio.h>

int main()
{
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += i;  
    }
    printf("%d\n", sum);
    return 0;
}
```

编译错误：

```shell
root@hgs:~# gcc sum.c -o sum.out
sum.c: In function 'main':
sum.c:6:5: error: 'for' loop initial declarations are only allowed in C99 or C11 mode
     for (int i = 0; i < 10; i++) {
     ^
sum.c:6:5: note: use option -std=c99, -std=gnu99, -std=c11 or -std=gnu11 to compile your code
```

此时，可以指定代码的编译版本：

```shell
gcc -std=c99 sum.c -o sum.out
```

### 静态编译与动态编译

`*.so`：shared object，共享库

`*.a`：archive，静态库

-static：静态编译，不进行动态链接

