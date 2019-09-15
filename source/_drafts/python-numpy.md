---
title: NumPy常用函数总结
tags:
---

NumPy，全称Numerical Python，是Python中常用的张量（tensor）运算库。

通常在引入NumPy时，遵循如下的惯例：

```python
import numpy as np
```

<!--more-->

### array()

array()函数，可以将Python的列表转换为NumPy中的ndarray（n维数组，或者张量）

```python
import numpy as np

a = np.array([2,3,4])
print(type(a),a)
print(a.dtype)
print(a.shape)
print(a.ndim)
```



### arange()



### reshape()

reshape()函数，表示将张量变形，即改变张量的行和列，以得到想要的形状。变形后的张量的元素总个数与初始张量相同。

```python
import numpy as np

a = np.array([1,2,3,4])
print(a)
a2 = a.reshape((2,2))
print(a2)
```



### zeros()/ones()



### eye()



### dot()



### sum()



### max()/argmax()



### mean()



### concatenate()



### average()

