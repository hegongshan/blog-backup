---
title: Python函数注解
date: 2019-12-20 22:08:38
tags: python
categories: python
---

Python3引入了一种新语法——函数注解，用于为函数声明中的参数和返回值添加注解。注解中最常用的类型是类（如str或者int）和字符串。

<!--more-->

### 语法

#### 参数

函数声明中的各个参数可以在:后增加注解表达式。

```python
def sum(a: int, b: int):
  return a + b
```

如果参数有默认值，注解放在参数名和=号之间，就像下面这样。

```python
def sum(a: int, b: int = 4):
  return a + b
```

#### 返回值

如果想注解返回值，在)和函数声明末尾的:之间添加->和注解表达式。

```python
def sum(a: int, b: int = 4) -> int:
  return a + b
```

### 访问函数注解

Python不会对注解做任何处理，只是将其存储在函数的`__annotations__`属性（一个字典）中。

```python
>>> print(sum.__annotations__)
{'a': <class 'int'>, 'b': <class 'int'>, 'return': <class 'int'>}
```

return键保存的是返回值注解。

### 参考资料

函数注解提案 https://www.python.org/dev/peps/pep-3107/