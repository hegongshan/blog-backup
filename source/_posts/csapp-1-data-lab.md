---
title: 《深入理解计算机系统》实验1.Data Lab
date: 2021-05-06 19:53:18
tags: CSAPP
categories: CSAPP
mathjax: true
---

Data Lab主要考察位运算和浮点数运算。

<!--more-->

### bitXor(x, y)

题目说明：使用按位与&和按位取反~实现异或运算^。

异或运算的定义如下：
$$
a \oplus b = (\lnot a \land b) \lor (a \land \lnot b)
$$
根据分配律和德摩根定律，可以推出：
$$
\begin{align}
a \oplus b 
&= (\lnot a \land b) \lor (a \land \lnot b) \\\\
&= \left(\lnot a \lor (a \land \lnot b) \right) 
\land 
\left( b \lor (a \land \lnot b) \right) \\\\
&= \left( \lnot a \lor \lnot b \right) \land 
\left ( a \lor b \right) \\\\
&= \lnot \left( \lnot a \land \lnot b \right) \land 
 \lnot \left ( a \land b \right)
\end{align}
$$

因此：

```c
/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y)
{
    return ~(~x & ~y) & ~(x & y);
}
```

### tmin

题目说明：求最小的补码。

对于32位的int型，其补码的取值范围为$-2^{31}$~$2^{31}-1$。

```c
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void)
{
    return 0x1 << 31;
}
```

### isTmax(x)

题目说明：若x是最大的补码，则返回1；否则，返回0。

最大的补码x为0x7FFFFFFF，其满足`x = ~(x + 1)`。除了0x7FFFFFFF以外，-1也满足该表达式。

`~(-1)=0`，而`~(0x7FFFFFFF)=-1`，因此，可以使用`!!(~x)`排除掉-1。

注意到，关系运算符`a == b`等价于 `!(a ^ b)`。因此：

```c
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x)
{
    // 0x7FFFFFFF
    /*
    int mask = 0xFF;
    mask |= mask << 8;
    mask |= mask << 15;
    return !(x ^ mask);
    */
    return !(~(x + 1) ^ x) & !!(~x);
}
```

### allOddBits(x)

题目说明：给定整数x，若其二进制形式的奇数位（从前往后编号）均为1，则返回1；否则，返回0。

分析：只需要判断x是否等于0xAAAAAAAA即可。

```c
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int addOddBits(int x)
{
    // 0xAAAAAAAA
    int mask = 0xAA;
    mask |= (mask << 8);
    mask |= (mask << 16);
    return !((x & mask) ^ mask);
}
```

### negate(x)

题目说明：使用位运算求相反数。

```c
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(x)
{
    return ~x + 1;
}
```

### isAsciiDigit(x)

题目说明：若0x30<=x<=0x39（48<=x<=57），则返回1。

48~57的二进制形式如下所示：

```c
48 => 110000
49 => 110001
50 => 110010
51 => 110011
52 => 110100
53 => 110101
54 => 110110
55 => 110111
56 => 111000
57 => 111001
```

不难发现：

* 若前3位=110，则x一定位于30~39之间；
* 若前5位=11100，则x一定位于30~39之间。

```c
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x)
{
    return !((x >> 3) ^ 0x6) | !((x >> 1) ^ 0x1c)
}
```

### conditional(x, y, z)

题目说明：实现三目运算符。
$$
f(x, y, z) = 
\begin{cases}
\sim\ 0\ \&\ y, & x\neq0\\\\
\sim\ 0\ \&\ z, & x=0
\end{cases}
$$
而：
$$
!x + \sim 0 = 
\begin{cases}
\sim 0, & x \neq 0 \\\\
0, & x = 0
\end{cases}
$$
因此：

```c
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
    int flag = !x + ~0;
    return (flag & y) | (~flag & y);
}
```

### isLessOrEqual(x, y)

题目说明：实现x<=y。

* 当x和y的符号不相同时，x必须为负数，即x < 0 <= y；

* 当x和y的符号相同时，$y + (-x) \ge 0$。

$$
\begin{align}
x \le y 
&\Leftrightarrow y - x \ge 0 \\\\
&= y + (-x) \ge 0
\end{align}
$$

问题一：如何判断一个整数是正数还是负数呢？

对于32位的int型，右移31位，若结果为0，则为正数；若结果为-1，则为负数。

问题二：如何判断两个整数的符号位是否相同呢？
$$
(x >> 31) \oplus (y >> 31) =
\begin{cases}
0, & 符号位相同\\\\
1, & 符号位不相同
\end{cases}
$$

```c
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
    int sign_x = x >> 31;
    int sign_y = y >> 31;
    int is_different_sign = x ^ y;
    int negate_x = ~x + 1;
    int sign_y_minus_x = (y + negate_x) >> 31;
    return (!!(is_different_sign & sign_x)) | ((!is_different_sign) & (!sign_y_minus_x));
}
```

### logicalNeg(x)

题目说明：实现逻辑非!运算。
$$
!x=
\begin{cases}
1, & x = 0\\\\
0, & 其他
\end{cases}
$$
分析：只需要判断x是否等于0。

0和其相反数0执行按位或运算，结果的符号位为0；除0以外，任何一个数和它的相反数执行按位或运算，结果的符号位为1，即：
$$
(x | -x) >> 31 = 
\begin{cases}
0, & x = 0\\\\
-1, & 其他
\end{cases}
$$
因此：
$$
!x = ((x | -x) >> 31) + 1
$$

```c
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x) {
    return ((x | (~x + 1)) >> 31) + 1;
}
```

### howManyBits(x)

二分法

```c
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
    int b16, b8, b4, b2, b1;
    int sign = x >> 31;
    // 若为负数，则按位取反；若为正数，则不变
    x = (sign & ~x) | (~sign & x);
    
    // 1.若高16位有1，则至少需要16位
    b16 = (!!(x >> 16)) << 4;
    x >>= b16;
  	
		// 2.若高8位有1，则还需要8位
    b8 = (!!(x >> 8)) << 3;
    x >>= b8;

  	// 3.若高4位有1，则还需要4位
    b4 = (!!(x >> 4)) << 2;
    x >>= b4;

  	// 4.若高2位有1，则还需要2位
    b2 = (!!(x >> 2)) << 1;
    x >>= b2;

  	// 5.若高1位有1，则还需要1位
    b1 = (!!(x >> 1));
    x >>= b1;

  	// 6.加上符号位
    return b16 + b8 + b4 + b2 + b1 + x + 1;
}
```

## 浮点数

给定一个浮点数N，其可以表示为：
$$
N = (-1)^s \times M \times 2^E
$$
其中，s表示符号位；M表示尾数；E表示指数。

单精度浮点数float，占32位，其存储格式为：`1个符号位 + 8位阶码 + 23位尾数`

双精度浮点数double，占64位，其存储格式为：`1个符号位 + 11位阶码 + 52位尾数`

移码：
$$
X = E + 2^{n - 1} - 1
$$
### floatScale2(x)

```c
/* 
 * floatScale2 - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatScale2(unsigned uf) {
    const unsigned sign_mask = 0x1 << 31;
    const unsigned exp_mask = 0xFF << 23;
    const unsigned exp_plus_one = 0x1 << 23;
    const unsigned tail_mask = 0x007FFFFF;
    unsigned exp = uf & exp_mask;

    // 1.若阶码均为1
    if (exp == exp_mask) {
        return uf;
    }

    // 2.若阶码为0，即输入为0或者接近0的小数
    if (exp == 0) {
      unsigned sign = uf & sign_mask;
      unsigned tail = uf & tail_mask;
      return sign | (tail << 1);
    }

    // 3.否则，阶码+1
    /*
    exp  = ((exp >> 23) + 1) << 23;
    uf &= ~exp_mask;
    uf |= exp;
    */
    uf += exp_plus_one;
    return uf;
}
```

### floatFloat2Int(x)

```c
/* 
 * floatFloat2Int - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int floatFloat2Int(unsigned uf) {
    const unsigned sign_mask = 0x1 << 31;
    const unsigned exp_mask = 0xFF << 23;
    const unsigned tail_mask = 0x007FFFFF;
    int sign = uf & sign_mask;
    int exp = uf & exp_mask;
    int tail = uf & tail_mask;
    exp = (exp >> 23) - 127;
    // 1.若指数为负数
    if (exp < 0) {
      return 0;
    }
    // 2.若指数超出了范围
    if (exp > 31) {
      return sign_mask;
    }
    // 3.加上隐含位1
    tail |= 1 << 23;
    if (exp <= 23) {
      tail >>= 23 - exp;
    } else {
      tail <<= exp - 23;
    }
    // 4.若结果为负数
    if (sign) {
      return ~tail + 1;
    }
    return tail;
}
```

### floatPower2(x)

题目说明：使用位运算求$2.0^x$。
$$
\begin{align}
2.0^x 
&= 1.0 \times 2^x
\end{align}
$$

```c
/* 
 * floatPower2 - Return bit-level equivalent of the expression 2.0^x
 *   (2.0 raised to the power x) for any 32-bit integer x.
 *
 *   The unsigned value that is returned should have the identical bit
 *   representation as the single-precision floating-point number 2.0^x.
 *   If the result is too small to be represented as a denorm, return
 *   0. If too large, return +INF.
 * 
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. Also if, while 
 *   Max ops: 30 
 *   Rating: 4
 */
unsigned floatPower2(int x) {
    const int INF = 0xFF << 23;
    int exp = x + 127;
    // 1.若为0或者负数
    if (exp <= 0) {
      return 0;
    }
    // 2.阶码太大
    if (exp >= 0xFF) {
      return INF;
    }
    return exp << 23;
}
```

