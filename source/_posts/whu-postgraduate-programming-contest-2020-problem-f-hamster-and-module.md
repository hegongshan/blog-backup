---
title: 2020年“锐捷网络杯”华中区高校研究生程序设计大赛F.Hamster and Module
date: 2021-01-23 12:01:57
tags: 程序设计
categories: 程序设计
mathjax: true
---

本题是一道数学题，比赛的时候做了很久也没有AC。赛后很长一段时间都比较忙，时间一久差点忘记写题解了。

<!--more-->

As a great mathematician in the Hamster world, WCQ loves the math operation "module", which is represented as symbol "%" in many programming languages.

For two integers a and b, a module b equals the remainder of a divided by b.

For example, $32 \mod 5 = 2\quad (32 = 5 \times 6 + 2)$, and $5 \mod 7 = 5$.

WCQ has made a lot of research on module operation, creating numbers of papers, but here comes the conclusion that WCQ admires the most.

Given three integers n, a, b, how to calculate the value of $\left((n^a - 1) \mod (n^b - 1)\right)$ quickly and correctly?

WCQ believes that you can solve this problem too! Since the answer might be two large, you only need to find  $\left((n^a - 1) \mod (n^b - 1)\right) \mod (10^9 + 7)$.

### Input

There is only a single line, including three integers n, a, b ($1 \le n, a, b \le 10^9$).

### Ouput

One integer. If $ans = \left((n^a - 1) \mod (n^b - 1)\right)$, you need to output $ans \mod 10^9 + 7$. 

### 解决方案

当$a < b$时，$ans = n^a - 1$；

当$a \ge b$时，
$$
\begin{aligned}
\frac{n^a - 1}{n^b - 1} &= x \cdots ans \\\\
\Rightarrow n^a - 1 &= x (n^b - 1) + ans
\end{aligned}
$$
其中，x和ans分别表示商和余数。

容易得出
$$
n^a - 1 = n^{a - b}(n^b - 1) + n^{a - b} - 1
$$
故
$$
ans = 
\begin{cases}
n^{a - b} - 1, & a \ge b \\\\
n^a - 1, & a < b
\end{cases}
$$

### 相关公式

$$
(a + b) \mod c = (a \mod c + b \mod c) \mod c\\\\
(a \times b) \mod c = ((a \mod c) \times (b \mod c)) \mod c\\\\
a^b \mod c = (a \mod c)^b \mod c
$$

证明：$(a \times b) \mod c = ((a \mod c) \times (b \mod c)) \mod c$。

设$a = mc + r_1, b = nc + r_2$（$r_1, r_2 < c$）
$$
a \times b = m n c^2 + n c r_1 + m c r_2 + r_1 r_2 \\\\(a \times b) \mod c = (r_1 r_2) \mod c
$$
又
$$
a \mod c = r_1, \quad b \mod c = r_2 \\\\((a \mod c) \times (b \mod c)) \mod c = (r_1 r_2) \mod c
$$
证明完毕。

### 相关问题

问题：求$a^b \mod c$。

将b转换为二进制形式
$$
b = b_{n - 1} \times 2^{n - 1} + b_{n - 2} \times 2^{n - 2} + \cdots + b_0 \times 2^0
$$
从而
$$
\begin{aligned}
a^b &= a^{b_{n - 1} \times 2^{n - 1}} \times a^{b_{n - 2} \times 2^{n - 2}} \cdots \times a^{b_0 \times 2^0} \\\\
&= (a^{2^{n - 1}})^{b_{n - 1}} \times (a^{2^{n - 2}})^{b_{n - 2}} \times \cdots \times (a^{2^0})^{b_0}
\end{aligned}
$$
故
$$
a^b \mod c = \left( (a^{2^{n - 1}})^{b_{n - 1}} \times (a^{2^{n - 2}})^{b_{n - 2}} \times \cdots \times (a^{2^0})^{b_0} \right) \mod c \\\\
= \left( (a^{2^{n - 1}})^{b_{n - 1}} \mod c \right)
\left( (a^{2^{n - 2}})^{b_{n - 2}} \mod c \right) 
\cdots
\left( (a^{2^0})^{b_0} \mod c\right)
$$


```python
def quick_power_module(a: int, b: int, c: int) -> int:
	result = 1
	while b > 0:
		if b & 0x1 == 1:
			result = (result * a) % c
		a = (a * a) % c
		b >>= 1
	return result
```