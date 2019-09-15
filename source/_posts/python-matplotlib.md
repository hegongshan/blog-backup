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

### 设置图片标题

```python
plt.title('title')
```

### 设置x/y轴文字

```python
plt.xlabel('xlabel')
plt.ylabel('ylabel')
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

### 线条图

绘制线条图，需要使用matplotlib.pyplot中的**plot**方法

```python
import matplotlib.pyplot as plt
y = [1,4,9,16]
plt.plot(y)
plt.show()
```

修改标签文字和线条粗细

```python
import matplotlib.pyplot as plt
y = [1,4,9,16,25]
plt.plot(y,linewidth=5)
# 
plt.title('Squares Numbers',fontsize=24)
plt.xlabel('value',fontsize=14)
plt.ylabel('square of value',fontsize=14)

plt.tick_params(axis='both',labelsize=14)
plt.show()
```

校正图形

```python
import matplotlib.pyplot as plt
x = [1,2,3,4,5]
y = [i**2 for i in x]
plt.plot(x,y,linewidth=5)

plt.title('Squares Numbers',fontsize=24)
plt.xlabel('value',fontsize=14)
plt.ylabel('square of value',fontsize=14)

plt.tick_params(axis='both',labelsize=14)
plt.show()
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

### 保存图片

保存图片，需要使用matplotlib.pyplot中的savefig方法。值得注意的是，**savefig必须在show方法之前执行**。

```python
plt.savefig('./test.eps')

plt.show()
```

