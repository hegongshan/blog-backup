---
title: 使用C语言解析命令行参数
date: 2021-06-27 18:28:12
tags: c
categories: c
---

本文总结了如何使用C语言去解析命令行中的短选项、长选项以及对应的参数值。

<!--more-->

### 解析短选项

解析短选项使用getopt函数，其定义在头文件**<unistd.h>**中，函数原型如下：

```c
int getopt (int argc, char *const *argv, const char *options)
```

功能：返回下一个选项。如果没有下一个选项，则返回-1。如果返回`?`，则表明当前选项不在options中，或者缺少参数值。

参数：

* argc：参数的个数
* argv：参数数组

* options

后跟冒号`:`，表明其需要一个参数值；后跟两个冒号`::`，表明该选项是可选的（optional）。

```c
// 若当前选项有参数，则optarg中存储着对应的参数值
char *optarg;
// 若当前选项不在options中，或者缺少参数值，则optopt中存储着对应的选项
int optopt;

int opterr;
int optind;
```

* 例子

```c
#include <stdio.h>
#include <unistd.h>

void print_usage()
{
    printf("help info.\n");
}

int main(int argc, char *argv[])
{
    int val, v = 0;
    char *f;
  
    opterr = 0;
    while ((val = getopt(argc, argv, "hvf:")) != -1) {
        switch (val) {
            case 'h':
                print_usage();
                break;
            case 'v':
                v = 1;
                break;
            case 'f':
                f = optarg;
                break;
            case '?':
                if (optopt == 'f')
                    printf("Option -%c requires an argument.\n", optopt);
                else if (isprint(optopt))
                    printf("Unknown option '-%c'.\n", optopt);
                else
                    printf("Unknown option character '\\x%x'.\n", optopt);
                return 1;
            default:
                print_usage();
                break;
        }
        printf("verbose = %d, fvalue = %s\n", verbose, optopt);
    }
    return 0;
}
```

### 解析长选项

#### getopt_long

getopt_long函数定义在头文件**<getopt.h>**中，函数原型如下：

```c
int getopt_long (int argc, char *const *argv, const char *shortopts, const struct option *longopts, int *indexptr)
```

其中，`struct option`定义如下：

```c
struct option
{
    const char *name;
    // 选项是否有参数，有三个合法值：no_argument, required_argument, optional_argument
    int has_arg;
    int *flag;
    int val;
}
```

#### getopt_long_only

```c
int getopt_long_only (int argc, char *const *argv, const char *shortopts, const struct option *longopts, int *indexptr)
```

### 参考资料

1. https://www.gnu.org/software/libc/manual/html_node/Getopt.html

