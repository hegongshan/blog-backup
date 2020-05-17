---
title: AbstractStringBuilder
date: 2020-04-13 00:50:58
tags: java
categories: java
mathjax: true
---

AbstractStringBuilder是一个抽象类，它是StringBuffer和StringBuilder的父类，内部使用char数组实现。

<!--more-->

### 存储结构

```java
char[] value;
// 元素的个数
int count;
```

### 构造方法

```java
AbstractStringBuilder(int capacity) {
    value = new char[capacity];
}
```

###  append方法

这里仅分析下追加布尔型和整型。

#### 追加布尔型

```java
// 构造器模式
public AbstractStringBuilder append(boolean b) {
    if (b) {
        ensureCapacityInternal(count + 4);
        value[count++] = 't';
        value[count++] = 'r';
        value[count++] = 'u';
        value[count++] = 'e';
    } else {
        ensureCapacityInternal(count + 5);
        value[count++] = 'f';
        value[count++] = 'a';
        value[count++] = 'l';
        value[count++] = 's';
        value[count++] = 'e';
    }
    return this;
}
```

#### 追加整型

```java
public AbstractStringBuilder append(int i) {
    // Integer.stringSize以及getChars方法均无法处理Integer.MIN_VALUE
    if (i == Integer.MIN_VALUE) {
        append("-2147483648");
        return this;
    }
    // 1.计算整数i的位数
    int appendedLength = (i < 0) ? Integer.stringSize(-i) + 1
                                 : Integer.stringSize(i);
    int spaceNeeded = count + appendedLength;
    ensureCapacityInternal(spaceNeeded);
    // 2.将整数i转变为字符数组，存入value中
    Integer.getChars(i, spaceNeeded, value);
    count = spaceNeeded;
    return this;
}
```

这里调用了Integer类的两个静态方法：

Integer.stringSize方法用于计算给定整数x的位数（x必须为正数）；

Integer.getChars方法用于将整数转变为字符数组。

1.首先，我们来看下Integer.stringSize方法。

```java
// 存储int范围内不同位数的最大值
final static int [] sizeTable = { 9, 99, 999, 9999, 99999, 999999, 9999999,
                                  99999999, 999999999, Integer.MAX_VALUE };

// Requires positive x
static int stringSize(int x) {
    for (int i=0; ; i++)
        if (x <= sizeTable[i])
            return i+1;
}
```

该方法比较简单，但却十分实用。

它事先存储了int范围内不同位数的最大值，然后将给定的正数x与这些最大值逐一进行比较，从而得到x的位数，避免了除法运算。

2.接着，我们再来看下Integer.getChars方法。

```java
// java.lang.Integer.getChars
// i不能为Integer.MIN_VALUE
static void getChars(int i, int index, char[] buf) {
    int q, r;
    int charPos = index;
    char sign = 0;
    // 若为负数，则转变为正数
    if (i < 0) {
        sign = '-';
        i = -i;
    }
    // 1.当i >= 2^16时，每次除以100，计算余数个位和十位对应的字符
    // Generate two digits per iteration
    while (i >= 65536) {
        q = i / 100;
        // really: r = i - (q * 100);
        // 等价于r = i - q * (64 + 32 + 4) = i - (q * 100)
        r = i - ((q << 6) + (q << 5) + (q << 2));
        i = q;
        buf [--charPos] = DigitOnes[r];
        buf [--charPos] = DigitTens[r];
    }

    // 2.当i < 2^16时， 每次除以10，计算余数对应的字符
    // Fall thru to fast mode for smaller numbers
    // assert(i <= 65536, i);
    for (;;) {
        // 等价于q = i / 10;
        q = (i * 52429) >>> (16+3);
        r = i - ((q << 3) + (q << 1));  // r = i-(q*10) ...
        buf [--charPos] = digits [r];
        i = q;
        if (i == 0) break;
    }
    // 加上负号
    if (sign != 0) {
        buf [--charPos] = sign;
    }
}
```

Integer.getChars会将负数转变为其相反数来处理，因此该方法无法处理Integer.MIN_VALUE，会导致向上溢出。

此外，在JDK中，几乎所有的乘除运算，都采用了位移运算来优化。比如上面的`q = (i * 52429) >>> (16+3);`
$$
\begin{align}
q &= (i * 52429) >>> (16+3) \\\\
&= \frac{i \times 52429} {65536 \times 8} = \frac{i \times 6553.625} {65536} \\\\
&\approx 0.1 \times i = i / 10
\end{align}
$$
Integer类事先存储了各个数字对应的字符（数组digits），以及100以内各数字个位和十位对应的字符（数组DigitOnes和DigitTens）。

```java
final static char[] digits = {
    '0' , '1' , '2' , '3' , '4' , '5' ,
    '6' , '7' , '8' , '9' , 'a' , 'b' ,
    'c' , 'd' , 'e' , 'f' , 'g' , 'h' ,
    'i' , 'j' , 'k' , 'l' , 'm' , 'n' ,
    'o' , 'p' , 'q' , 'r' , 's' , 't' ,
    'u' , 'v' , 'w' , 'x' , 'y' , 'z'
};
// 存储100以内各个数字的十位
final static char [] DigitTens = {
    '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
    '1', '1', '1', '1', '1', '1', '1', '1', '1', '1',
    '2', '2', '2', '2', '2', '2', '2', '2', '2', '2',
    '3', '3', '3', '3', '3', '3', '3', '3', '3', '3',
    '4', '4', '4', '4', '4', '4', '4', '4', '4', '4',
    '5', '5', '5', '5', '5', '5', '5', '5', '5', '5',
    '6', '6', '6', '6', '6', '6', '6', '6', '6', '6',
    '7', '7', '7', '7', '7', '7', '7', '7', '7', '7',
    '8', '8', '8', '8', '8', '8', '8', '8', '8', '8',
    '9', '9', '9', '9', '9', '9', '9', '9', '9', '9',
    } ;
// 存储100以内各个数字的个位
final static char [] DigitOnes = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    } ;
```

### 扩容操作

新的容量为`newCapacity = (value.length << 1) + 2`。

```java
private void ensureCapacityInternal(int minimumCapacity) {
    // overflow-conscious code
    if (minimumCapacity - value.length > 0) {
        value = Arrays.copyOf(value,
                newCapacity(minimumCapacity));
    }
}
private int newCapacity(int minCapacity) {
    // overflow-conscious code
    int newCapacity = (value.length << 1) + 2;
    if (newCapacity - minCapacity < 0) {
        newCapacity = minCapacity;
    }
    return (newCapacity <= 0 || MAX_ARRAY_SIZE - newCapacity < 0)
        ? hugeCapacity(minCapacity)
        : newCapacity;
}
```

###  取值操作

```java
public char charAt(int index) {
    if ((index < 0) || (index >= count))
        throw new StringIndexOutOfBoundsException(index);
    return value[index];
}
```

### 删除操作

使用数组复制来实现。

```java
public AbstractStringBuilder deleteCharAt(int index) {
    if ((index < 0) || (index >= count))
        throw new StringIndexOutOfBoundsException(index);
    System.arraycopy(value, index+1, value, index, count-index-1);
    count--;
    return this;
}
```

