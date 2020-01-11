---
title: Pandas入门
date: 2019-09-12 22:35:28
tags: python
categories: python
---

Pandas是一个Python数据分析库。

按照标准约定，我们在使用Pandas时，最好遵循如下格式：

```python
import pandas as pd
```

<!--more-->

### DataFrame

数据帧：二维表格型数据结构。

构造函数：

```python
DataFrame(data=None, index=None, columns=None, dtype=None, copy=False)	
```

常用属性

* values：返回一个DataFrame的NumPy表示

* shape：返回一个表示DataFrame维度的元组

#### 访问元素

* at：通过行名和列名来访问某一个元素。

```python
import pandas as pd
df = pd.DataFrame([[0, 2, 3], [0, 4, 1], [10, 20, 30]],
                  index=[4, 5, 6], columns=['A', 'B', 'C'])
print(df)
print(df.at[4,'B'])
```

输出：

```python
    A   B   C
4   0   2   3
5   0   4   1
6  10  20  30
2
```

* iat：通过行和列的索引来访问某一个元素。

```python
import pandas as pd
df = pd.DataFrame([[0, 2, 3], [0, 4, 1], [10, 20, 30]],
                  index=[4, 5, 6], columns=['A', 'B', 'C'])
print(df.iat[0,1])
```

输出：

```python
2
```

* head

函数原型：

```python
head(n=5)
```

返回DataFrame的前n行，n的默认值为5。

* tail

函数原型：

```python
tail(n=5)
```

返回DataFrame的最后n行，n的默认值为5。

#### 遍历

* iterrows()：按照行进行迭代，每次返回一个(index, Series)对

```python
import pandas as pd

df = pd.DataFrame([[23,24],[25,26]],columns=['A','B'])

for index,row in df.iterrows():
    print(index)
    print(row)
```

输出：

```python
0
A    23
B    24
Name: 0, dtype: int64
1
A    25
B    26
Name: 1, dtype: int64
```

* iteritems()和items()：按照列进行迭代，每次返回一个(column name, Series)对

```python
import pandas as pd

df = pd.DataFrame([[23,24],[25,26]],columns=['A','B'])

for label, content in df.iteritems():
    print(label)
    print(content)
```

输出：

```python
A
0    23
1    25
Name: A, dtype: int64
B
0    24
1    26
Name: B, dtype: int64
```

#### 添加行

添加行可以使用DataFrame的append()方法，该方法将返回一个新的DataFrame对象。

```python
import pandas as pd

df = pd.DataFrame([[23,24]],columns=['A','B'])
print(df)
df = df.append(pd.DataFrame([[33,44]],columns=('A','B')),ignore_index=True)
print(df)
```

输出：

```python
    A   B
0  23  24
    A   B
0  23  24
1  33  44
```

#### 删除行/列

删除行/列，可以使用DataFrame的drop()方法，该方法将返回一个新的DataFrame对象。

drop()包含一个叫axis的参数：

**axis** : {0 or ‘index’, 1 or ‘columns’}, default 0

Whether to drop labels from the index (0 or ‘index’) or columns (1 or ‘columns’).

### 读取CSV文件

使用read_csv()方法，可以读取CSV文件，并返回一个DataFrame对象。

```python
import pandas as pd

df = pd.read_csv('./test.csv')
```

### 生成CSV文件

使用DataFrame对象的to_csv()方法，可以方便地生成CSV文件。

```python
import pandas as pd
...
df.to_csv('./test.csv')
```

### 读取Excel文件

读取Excel可以使用read_excel()（使用前需要先**安装xlrd**）。

```python
import pandas as pd

df = pd.read_excel('./test.xlsx')
```

### 生成Excel文件

使用DataFrame对象的to_excel()方法，可以方便地生成Excel文件（使用前需要先**安装xlwt**）。

```python
import pandas as pd
...
df.to_excel('./test.xlsx')
```

