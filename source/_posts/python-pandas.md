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

二维表格型数据结构。

构造函数：

```python
DataFrame([data, index, columns, dtype, copy])	
```

常用属性

* values：返回一个DataFrame的NumPy表示

* shape：返回一个表示DataFrame维度的元组

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

