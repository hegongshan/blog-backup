---

title: MathJax语法
date: 2018-07-16 19:09:32
tags: mathjax
categories: mathjax
mathjax: true
---

如何在网页中便捷地输入数学公式呢？MathJax就是一个不错的选择。

使用`$`或者`$$`来标明需要MathJax解析的公式。`$`表示行内公式，而`$$`表示的数学公式会独占一行，如

`$y=ax+b$`： $y=ax+b$

`$$y=ax+b$$`：
$$
y=ax+b
$$

<!--more-->

#### 输入分数

示例：`$\frac{1}{3}$` 或者　`$1 \over 3$`

显示：$\frac{1}{3}$

#### 开根号

示例：`$\sqrt{3}$` 或者 `$\sqrt[n]{3}$`

显示：$\sqrt{3}$、$\sqrt[n]{3}$

#### 上下标

^表示上标，_表示下标。如果上下标的内容多于一个字符，则需要用{ }括起来。

示例：`$e^2$`、`$e^{ax+b}$`、

显示：$e^2$、$e^{ax+b}$

#### 对数

* 普通对数：`$\log_2{8}$` => $\log_2{8}$
* 自然对数：`$\ln 8$` => $\ln 8$
* 常用对数：`$\lg 100$` => $\lg 100$\

#### 累加、累乘

* 累加：`$\sum_{i=1}^{n}{I^2+1}$`　=> $\sum_{i=1}^n{(i^2+2i+1)}$
* 累乘：`$\prod_{i=1}^n{\frac{1}{i^2}}$` => $\prod_{i=1}^n{\frac{1}{i^2}}$

#### 向量

示例：`$\vec x$` => $\vec x$

#### 积分

示例：`$\int_a^b sinx dx$` => $\int_a^b sinx dx$

#### 无穷

示例：`$\infty$` $\Rightarrow$  $\infty$

#### 偏导数

示例：`$\frac{\partial f(x,y)}{\partial x}$` => $\frac{\partial f(x,y)}{\partial x}$

#### 标签

示例：`$$(a+b)(a-b)=a^2-b^2 \tag{1.1}$$`
$$
(a+b)(a-b)=a^2-b^2 \tag{1.1}
$$

#### 最大、最小

最大：`$$\max_{x} y$$`
$$
\max_{x} y
$$
最小：`$$\min_{x} y$$`
$$
\min_{x} y
$$

#### 统计估计

示例：`$$\hat y$$ `
$$
\hat y
$$

#### 向上（下）取整

向上取整：`$$\left \lceil \frac{a}{b} \right \rceil$$`
$$
\left \lceil \frac{a}{b} \right \rceil
$$
向下取整：`$$\left \lfloor \frac{a}{b} \right \rfloor$$`
$$
\left \lfloor \frac{a}{b} \right \rfloor
$$

#### 空格

空一格：`a\ b ` => $a \ b$

空四格：`a \quad b` => $a \quad b$

空八格：`a \qquad b` $\Rightarrow$ $a \qquad b$

#### 绝对值、范数

绝对值：`\lvert x \rvert` $\Rightarrow$ $\lvert x \rvert$

范数：`\lVert x \rVert` $\Rightarrow$ $\lVert x \rVert$

#### 对齐

```
$$
\begin{align}
y &= (a-b)(a+b) \\
&= a^2 - b^2
\end{align}
$$
```

$$
\begin{align}
y &= (a-b)(a+b) \\\
&= a^2 - b^2
\end{align}
$$

#### 分段函数

```latex
$$
y=
\begin{cases}
0,& x < 0 \\
0.5,& x = 0 \\
1,& x > 0
\end{cases}
$$
```

$$
y=
\begin{cases}
0,& x < 0 \\\
0.5,& x = 0 \\\
1,& x > 0
\end{cases}
$$

#### 矩阵

* 不带括号的矩阵

```latex
$$
A = 
\begin{matrix}
2 & 0 \\
0 & 5
\end{matrix}
$$
```

$$
A = 
\begin{matrix}
2 & 0 \\\\
0 & 5
\end{matrix}
$$

* 带括号的矩阵

1.`\begin{vmatrix}...\end{vmatrix}` 
$$
A = 
\begin{vmatrix}
2 & 0 \\\\
0 & 5
\end{vmatrix}
$$


2.`\begin{bmatrix}...\end{bmatrix}` 
$$
A = 
\begin{bmatrix}
2 & 0 \\\\
0 & 5
\end{bmatrix}
$$

3.`\begin{Bmatrix}...\end{Bmatrix}`
$$
A = 
\begin{Bmatrix}
2 & 0 \\\
0 & 5
\end{Bmatrix}
$$
4.`\begin{pmatrix}...\end{pmatrix}`
$$
A = 
\begin{pmatrix}
2 & 0 \\\
0 & 5
\end{pmatrix}
$$


#### 括号

|          括号          |          符号          |
| :--------------------: | :--------------------: |
|  $\overbrace{x,y,z}$   |  `\overbrace{x,y,z}`   |
| $\underbrace{x_1,x_2}$ | `\underbrace{x_1,x_2}` |

#### 箭头

|     箭头      |     符号      |
| :-----------: | :-----------: |
|  $\uparrow$   |  `\uparrow`   |
|  $\Uparrow$   |  `\Uparrow`   |
| $\downarrow$  | `\downarrow`  |
| $\Downarrow$  | `\Downarrow`  |
| $\rightarrow$ | `\rightarrow` |
| $\Rightarrow$ | `\Rightarrow` |
| $\leftarrow$  | `\leftarrow`  |
| $\Leftarrow$  | `\Leftarrow`  |

#### 四则运算

| 四则运算 |   符号   |
| :------: | :------: |
|    +     |    +     |
|    -     |    -     |
| $\times$ | `\times` |
|  $\div$  |  `\div`  |

#### 关系运算法

| 关系运算  |   符号    |
| :-------: | :-------: |
|  $\leq$   |  `\leq`   |
|  $\geq$   |  `\geq`   |
|  $\neq$   |  `\neq`   |
| $\approx$ | `\approx` |

#### 逻辑运算符

|   逻辑运算    |     符号      |
| :-----------: | :-----------: |
|   $\forall$   |   `\forall`   |
|    $\cup$     |    `\cup`     |
|    $\cap$     |    `\cap`     |
|     $\in$     |     `\in`     |
|   $\notin$    |   `\notin`    |
| $\varnothing$ | `\varnothing` |

#### 希腊字母

|    字母    |    符号    |
| :--------: | :--------: |
|  $\alpha$  |  `\alpha`  |
|  $\beta$   |  `\beta`   |
|  $\gamma$  |  `\gamma`  |
| $\lambda$  | `\lambda`  |
|   $\eta$   |   `\eta`   |
| $\epsilon$ | `\epsilon` |
|  $\theta$  |  `\theta`  |
| $ \sigma $ |  `\sigma`  |
|  $\Sigma$  |  `\Sigma`  |











