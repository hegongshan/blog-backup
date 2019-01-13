---
title: python数据分析之matplotlib
date: 2018-06-26 20:36:44
tags: [python,matplotlib]
categories: python
---

matplotlib

### 折线图

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
# 
plt.title('Squares Numbers',fontsize=24)
plt.xlabel('value',fontsize=14)
plt.ylabel('square of value',fontsize=14)

plt.tick_params(axis='both',labelsize=14)
plt.show()
```



### 散点图



### 画分段函数

