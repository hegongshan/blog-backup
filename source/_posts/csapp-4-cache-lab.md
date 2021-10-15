---
title: 《深入理解计算机系统》实验4.Cache Lab
date: 2021-06-27 16:11:08
tags: CSAPP
categories: CSAPP
mathjax: true
---

Cache Lab是《深入理解计算机系统》第6章 存储器层次结构的对应实验。

<!--more-->

Cache Lab由两个部分组成：Part A要求实现一个缓存模拟器，而Part B则要求实现一个缓存性能优化的矩阵转置函数。

### Part A：Writing a Cache Simulator

#### 定义全局变量和缓存类型

```c
// S：缓存组数，s：缓存组索引位数，E：缓存行数，b：块偏移位数
int S, s, E, b;

// 是否输出调试信息
int verbose = 0;

// hits：缓存命中次数，misses：缓存不命中次数，evictions：缓存驱逐次数
int hits = 0, misses = 0, evictions = 0;

// trace文件名
char tracefile[50];

typedef struct {
    int valid_bit; //有效位
    int tag; // 标记位
    int timestamp; //LRU时间戳
} cache_line, *cache_group, **cache;

cache cache_simulator = NULL;
```

#### 解析命令行参数

```c
void print_usage()
{
    puts("Usage: ./csim [-hv] -s <num> -E <num> -b <num> -t <file>");
    puts("Options:");
    puts("   -h\t\tPrint this help message.");
    puts("   -v\t\tOptional verbose flag.");
    puts("   -s <num>\tNumber of set bits (S = 2^s is the number of sets).");
    puts("   -E <num>\tNumber of lines per set.");
    puts("   -b <num>\tNumber of block bits (B = 2^b is the block size).");
    puts("   -t <file>\tTrace file.");
    putchar('\n');
    puts("Exampes:");
    puts("   linux> ./csim -s 4 -E 1 -b 4 -t traces/yi.trace");
    puts("   linux> ./csim -v -s 8 -E 2 -b 4 -t traces/yi.trace");
    exit(0);
}
```

这里需要用到<getopt.h>头文件中的getopt方法：

http://www.gnu.org/software/libc/manual/html_node/Getopt.html

```c
void parse_arg(int argc, char *argv[])
{
    int val;
    while ((val = getopt(argc, argv, "hvs:E:b:t:")) != -1) {
        switch (val) {
        case 'h':
            print_usage();
            break;
        case 'v':
            verbose = 1;
            break;
        case 's':
            s = atoi(optarg);
            break;
        case 'E':
            E = atoi(optarg);
            break;
        case 'b':
            b = atoi(optarg);
            break;
        case 't':
            strcpy(tracefile, optarg);
            break;
        default:
            print_usage();
            break;
        }    
    }

    // 如果参数不合法
    if (s <= 0 || E <= 0 || b <=0) {
        printf("parameter value error\n");
        exit(-1);
    }

    // S = 2^s
    S = 1 << s;
}
```

#### 初始化缓存

```c
/*
 * 初始化缓存
 */
void init_cache(int S, int E)
{
    cache_simulator = (cache) malloc(sizeof(cache_group) * S);
    for (int i = 0; i < S; i++) {
        cache_simulator[i] = (cache_group) malloc(sizeof(cache_line) * E);
        for (int j = 0; j <  E; j++) {
            cache_simulator[i][j].valid_bit = 0;
            cache_simulator[i][j].tag = 0;
            cache_simulator[i][j].timestamp = 0;
        }
    }
}
```

#### 解析Trace文件

Trace文件格式：

```
[space]operation address,size
```

描述：

> The operation field denotes the type of memory access: “I” denotes an instruction load, “L” a data load, “S” a data store, and “M” a data modify (i.e., a data load followed by a data store). There is never a space before each “I”. There is always a space before each “M”, “L”, and “S”. The address field specifies a 64-bit hexadecimal memory address. The size field specifies the number of bytes accessed by the operation.

I：加载指令，L：加载数据，S：存储数据，M：修改数据。

```c
/**
 * 解析缓存文件
 */
void parse_trace(char *filename)
{
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("file open error\n");
        exit(-1);
    }

    char operator;
    unsigned int address;
    int size;
    while (fscanf(fp, " %c %x,%d", &operator, &address, &size) != EOF) {
        switch (operator) {
        case 'I': // 不处理
            break;
        case 'L':
            update_cache(operator, address, size, 1);
            break;
        case 'S':
            update_cache(operator, address, size, 1);
            break;
        case 'M':
            // 先加载数据，再存储数据
            update_cache(operator, address, size, 1);
            update_cache(operator, address, size, 2);
            break;
        }
        update_timestamp();
    }

    fclose(fp);
}
```

#### 更新缓存

```c
/**
 * 更新缓存，operator、size以及call_count只用于调试
 * call_count表示对于trace文件的当前行来说，第call_count次调用该方法，用于调试operator='M'
 */
void update_cache(char operator, unsigned int address, int size, int call_count)
{
    int mask = ~(~0 << s);
    int set_idx = (address >> b) & mask;
    int tag = address >> (s + b);
    int max_timestamp = INT_MIN;
    int max_timestamp_idx = -1;

    // 如果命中
    for (int i = 0; i < E; i++) {
        if (cache_simulator[set_idx][i].valid_bit && cache_simulator[set_idx][i].tag == tag) {        
            hits++;
            cache_simulator[set_idx][i].timestamp = 0;

            // 打印调试信息
            if (verbose) {
                if (operator == 'M' && call_count > 1) {
                    printf(" hit\n");
                } else {
                    printf("%c %x,%d hit", operator, address, size);
                    if (operator != 'M') {
                        putchar('\n');
                    }
                }
            }
            return ;
        }
    }

    // 没有命中
    misses++;
    if (verbose) {
        printf("%c %x,%d miss", operator, address, size); 
        if (operator != 'M') {
            putchar('\n');
        } 
    }

    // 如果存在空行
    for (int i = 0; i < E; i++) {
        if (!cache_simulator[set_idx][i].valid_bit) {
            cache_simulator[set_idx][i].valid_bit = 1;
            cache_simulator[set_idx][i].tag = tag;
            cache_simulator[set_idx][i].timestamp = 0;
            return ;
        }
    }

    // 没有空行，则执行替换策略：LRU（Least Recently Used）
    evictions++;
    for (int i = 0; i < E; i++) {
        if (cache_simulator[set_idx][i].timestamp > max_timestamp) {
            max_timestamp = cache_simulator[set_idx][i].timestamp;
            max_timestamp_idx = i;
        }
    }
    cache_simulator[set_idx][max_timestamp_idx].tag = tag;
    cache_simulator[set_idx][max_timestamp_idx].timestamp = 0;
}

/**
 * 更新LRU时间戳
 */
void update_timestamp()
{
    for (int i = 0; i < S; i++) {
        for (int j = 0; j < E; j++) {
            if (cache_simulator[i][j].valid_bit) {
                cache_simulator[i][j].timestamp++;
            }
        }
    }
}
```

#### 释放缓存

```c
/**
 * 释放缓存
 */
void free_cache()
{
    for (int i = 0; i < S; i++) {
        free(cache_simulator[i]);
    }
    free(cache_simulator);
}
```

#### main方法

```c
int main(int argc, char *argv[])
{
    // 1.解析命令行参数
    parse_arg(argc, argv);

    // 2.初始化缓存
    init_cache(S, E);

    // 3.解析trace文件
    parse_trace(tracefile);

    // 4.释放缓存
    free_cache();

    // 5.输出统计信息
    printSummary(hits, misses, evictions);
    return 0;
}
```



[csim.c的完整代码](https://github.com/hegongshan/ppi-induction-training/master/4.CSAPP/cachelab-handout/csim.c)

实验结果如下所示：

![Part A实验结果](/static/images/csapp-cachelab-part-a.png)

### Part B: Optimizing Matrix Transpose

**任务描述：**在文件`trans.c`中，编写一个矩阵转置函数`transpose_submit`，使得对于不同大小的矩阵，缓存不命中次数最少。

trans.c

```c
/* 
 * transpose_submit - This is the solution transpose function that you
 *     will be graded on for Part B of the assignment. Do not change
 *     the description string "Transpose submission", as the driver
 *     searches for that string to identify the transpose function to
 *     be graded. 
 */
char transpose_submit_desc[] = "Transpose submission";
void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{
}
```

使用直接映射高度缓存（E=1），组索引位数s=5（组数$S=2^s=32$），块偏移位数b=5（块大小$B=2^b=32$）。

**任务要求：**

1.最多只能定义12个int类型的局部变量

2.不能使用递归

3.不能修改数组A，只能修改数组B

4.只需要正确处理32×32（不命中次数m < 300）、64×64（m < 1300）以及61×67（m < 2000）三种矩阵即可，针对输入的大小，可以分别处理这三种情况。

首先，查看下示例代码的性能，结果如下：

```c
hits:870, misses:1183, evictions:1151
```

说明文档给出了如下提示：

> Blocking is a useful technique for reducing cache misses

故，本题可以使用分块（Blocking）技术。在C语言中，int类型占4个字节，而本题中的块大小为32个字节，从而一个高速缓存行可以存放8个int型变量。

下面考虑使用8×8的分块来减少缓存不命中：

#### 32x32

```c
void transpose_32x32(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, k, l;
    for (i = 0; i < M; i += 8) {
        for (j = 0; j < N; j += 8) {
            for (k = i; k < i + 8; k++) {
                for (l = j; l < j + 8; l++) {
                    B[l][k] = A[k][l];
                }
            }
        }
    }
}
```

![](/static/images/csapp-cachelab-part-b32x32.png)

```c
void transpose_32x32(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, k;
    int temp0, temp1, temp2, temp3;
    int temp4, temp5, temp6, temp7;

    for (i = 0; i < M; i += 8) {
        for (j = 0; j < N; j += 8) {
            for (k = i; k < i + 8; k++) {          
                temp0 = A[k][j];
                temp1 = A[k][j + 1];
                temp2 = A[k][j + 2];
                temp3 = A[k][j + 3];
                temp4 = A[k][j + 4];
                temp5 = A[k][j + 5];
                temp6 = A[k][j + 6];
                temp7 = A[k][j + 7];

                B[j][k] = temp0;
                B[j + 1][k] = temp1;
                B[j + 2][k] = temp2;
                B[j + 3][k] = temp3;
                B[j + 4][k] = temp4;
                B[j + 5][k] = temp5;
                B[j + 6][k] = temp6;
                B[j + 7][k] = temp7;
            }
        }
    }
}
```

![](/static/images/csapp-cachelab-part-b2.png)

#### 64x64

