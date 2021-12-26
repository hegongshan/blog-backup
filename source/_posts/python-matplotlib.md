---
title: Matplotlib入门
date: 2018-06-26 20:36:44
tags: python
categories: python
---

Matplotlib是一个Python的2D绘图库。

```python
import matplotlib.pyplot as plt
```

<!--more-->

### 设置图片标题

```python
plt.title('title')
```

### 设置x/y轴文字

```python
plt.xlabel('xlabel')
plt.ylabel('ylabel')
```

### 设置x/y轴的刻度范围

默认情况下，matplotlib的坐标轴刻度并不会从0开始。通过xlim()和ylim()方法，设置x/y轴的刻度范围，可以让x/y轴的刻度从0开始。

```python
plt.xlim(xmin,xmax)
plt.ylim(ymin,ymax)
```

示例：

```python
plt.xlim(xmin=0, xmax=1000)
plt.ylim(ymin=0, ymax=100)
```

### 设置x/y轴的刻度

可以使用xticks()和yticks()方法，设置x/y轴需要显示的所有刻度值。

```python
plt.xticks(ticks=None, labels=None, **kwargs)
plt.yticks(ticks=None, labels=None, **kwargs)
```

示例：

```python
# 以50为步长，x轴的刻度为0,50,100,150,...,900,950
plt.xticks(np.arange(0, 950, step=50))
```

### 显示图片

```python
plt.show()
```

### 使用中文

Matplotlib默认是不支持中文的。因此，如果要显示中文，可以导入本地的中文字体库。

```python
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties

# 设置字体，fname为本地字体库的所在路径
font = FontProperties(fname='/System/Library/Fonts/Hiragino Sans GB.ttc',size=14)
# 在用到中文的地方，设置fontproperties
plt.title("出行时段分布",fontproperties=font)
```

### 折线图

绘制折线图，需要使用matplotlib.pyplot中的**plot**方法

```python
plot([x], y, [fmt], *, data=None, **kwargs)
plot([x], y, [fmt], [x2], y2, [fmt2], ..., **kwargs)
```

#### 线条样式及颜色

fmt由标记（marker）、线条样式（linestyle）以及颜色（color）组成。

```python
# marker、line以及color均为可选
fmt = '[marker][line][color]'
```

* Markers

```python
符号	描述
--------------
 o	圆形
 v	下三角
 ^	上三角
 s	正方形
 *	星号
 +	加号
 x	X
 D	等边菱形
 d	不等边菱形
```

* Line Styles

```python
符号	描述
--------------
 -	实线
 --	虚线
 -.	点划线
 :	点线
```

* Colors

```python
符号	描述
--------------
 b	blue
 g	green
 r	red
 c	cyan 蓝绿色
 m	magenta 洋红色
 y	yellow
 k	black
 w	white
```

示例：

```python
import matplotlib.pyplot as plt
y = [1,4,9,16]
# 带圆形标记的红色实线
plt.plot(y, 'o-r')
plt.show()
```

#### 常用关键字参数

```python
符号			描述
--------------------------------
color or c		color
linestyle or ls		float
linewidth or lw		float
marker			marker style
markersize or ms	float
markerfacecolor or mfc		设置标记面颜色
label			线条的名字
clip_on		bool,超出坐标轴的部分是否隐藏
```

Tips：**当使用圆形标记时，设置`markerfacecolor='white'`可以呈现出空心圆的效果。**

#### 设置图中的字体大小

```shell
# 坐标轴标签
plt.xlabel('xlabel', fontsize=font_size)
plt.ylabel('ylabel', fontsize=font_size)

# 坐标轴刻度
plt.xticks(x_values, fontsize=font_size)
plt.yticks(y_values, fontsize=font_size)

# 图例
plt.legend(fontsize=font_size)

# 图片标题
plt.title('title', fontsize=font_size)
```

### 散点图

绘制散点图，需要使用matplotlib.pyplot中的**scatter**方法

```python
import matplotlib.pyplot as plt
x = [1,2,3,4,5]
y = [i**2 for i in x]
plt.scatter(x,y,linewidth=5)

plt.title('Squares Numbers',fontsize=24)
plt.xlabel('value',fontsize=14)
plt.ylabel('square of value',fontsize=14)

plt.tick_params(axis='both',labelsize=14)
plt.show()
```

### 柱状图

绘制柱状图，需要使用matplotlib.pyplot中的**bar**方法

```python
bar(x, height, width=0.8, bottom=None, *, align='center', data=None, **kwargs)
```

### 饼状图

绘制饼状图，需要使用matplotlib.pyplot中的**pie**方法

```python
pie(x, explode=None, labels=None, colors=None, autopct=None,
        pctdistance=0.6, shadow=False, labeldistance=1.1, startangle=None,
        radius=None, counterclock=True, wedgeprops=None, textprops=None,
        center=(0, 0), frame=False, rotatelabels=False, hold=None, data=None)
```

### 子图

如果需要一次性绘制多张图片，需要使用matplotlib.pyplot中的**subplot**方法：

```python
subplot(nrows, ncols, index, **kwargs)
subplot(pos, **kwargs)
```

* (*nrows*, *ncols*, *index*)：nrows表示总行数，ncols表示总列数，index表示当前图片的编号（index从1开始，并按照从左至右、从上至下的顺序依次增加）。
* pos：包含三个数字的整数，每一位与上面三个参数一一对应。

例如，`subplot(235)`，等价于`subplot(2,3,5)`。

注意：如果使用该方式创建子图，**子图的数量不能超过9张**。

#### 调整子图布局

需要使用matplotlib.pyplot中的**subplots_adjust**方法

```python
subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=None, hspace=None)
```

* left：图片左边界的位置

### 保存图片

保存图片，需要使用matplotlib.pyplot中的savefig方法。

需要注意的是：**savefig必须在show方法之前执行**。

```python
plt.savefig('./test.eps')

plt.show()
```

### 添加水平/垂直线

可以使用hlines()和vlines()方法分别绘制水平、垂直线段。

```
plt.vlines(x=0, ymin=0, ymax=1, linestyles='dashed')
plt.hlines(y=0.5, xmin=-10, xmax=10, linestyles='dashed')
```

### 显示图例

```python
plt.legend(*args, **kwargs)
```

* loc：图例的位置，值为字符串或者对应的数字，共有以下11种情况

```python
Location String	Location Code
'best'	0
'upper right'	1
'upper left'	2
'lower left'	3
'lower right'	4
'right'	5
'center left'	6
'center right'	7
'lower center'	8
'upper center'	9
'center'	10
```

其中，'center right'和'right'是等价的。

示例：

```python
# 右下角
plt.legend(loc='lower right')
```

* ncol：图例的列数，默认为1。

### 显示网格

```python
plt.grid(b=None, which='major', axis='both', **kwargs)
```

b：是否显示网格

which：在哪些刻度上画网格线（主刻度|小刻度），可选的值有{'major', 'minor', 'both'}

axis：在哪个轴上画网格线，可选的值有{'both', 'x', 'y'}

其他关键字参数：

```python
符号			描述
----------------------------------
color or c		网格线的颜色
linestyle or ls 	网格线的样式
linewidth or lw 	线的宽度
```

### 更改坐标轴的位置

```python
# gca，get current axis
ax = plt.gca()

# 隐藏右边和顶部的线条
ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')

# 设置x轴和y轴所在的位置
ax.xaxis.set_ticks_position('bottom')
ax.yaxis.set_ticks_position('left')

# 设置x轴和y轴的交点为(0,0)
ax.spines['bottom'].set_position(('data', 0))
ax.spines['left'].set_position(('data', 0))
```

### 对LaTex的支持

在需要输入LaTex公式的地方，使用一对美元符$$包裹起来，就像这样`r'sigmoid(x)=$\frac{1}{1+e^{-x}}$'`，不要忘记前面的字母r（告诉编译器后面的字符串是个raw string，不需要对反斜杠进行转义）。

示例：

绘制Sigmoid函数，并在图例中显示sigmoid的数学表达式

```python
import matplotlib.pyplot as plt
import numpy as np
import math

x = np.arange(start=-10, stop=10, step=0.1)
y = 1 / (1 + math.e ** (-x))
plt.plot(x, y, linewidth=3, label=r'sigmoid(x)=$\frac{1}{1+e^{-x}}$')
plt.xlabel('x', fontsize=15)
plt.ylabel('sigmoid(x)', fontsize=15)

plt.xticks(np.arange(-10, 11, step=1))
plt.yticks(np.arange(0, 1.1, step=0.1))
plt.ylim(ymin=0, ymax=1)
plt.xlim(xmin=-10, xmax=10)

plt.vlines(x=0, ymin=0, ymax=1, linestyles='dashed')
plt.hlines(y=0.5, xmin=-10, xmax=10, linestyles='dashed')

plt.legend()
plt.show()
```

输出：

![](/static/images/sigmoid-legend.png)

更多信息，参看https://matplotlib.org/api/pyplot_summary.html