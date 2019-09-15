---
title: Python字符串
date: 2019-09-13 14:12:58
tags: python
categories: python
---

字符串是Python中最常用的数据类型。我们可以使用引号`'`或`”`来创建字符串。

<!--more-->

### capitalize()

将字符串的**第一个字母变成大写，其他字母变小写**。

```python
temp = 'wuhan City'
print(temp.capitalize())
```

输出：

```python
Wuhan city
```

### title()

返回"标题化"的字符串——所有单词的首个字母转化为大写，其余字母均为小写。

```python
temp = 'wuHan different every day!'
print(temp.title())
```

输出：

```python
Wuhan Different Every Day!
```

### upper()

将字符串中的小写字母转换为大写字母。

```python
temp = 'wuhan city'
print(temp.upper())
```

输出：

```python
WUHAN CITY
```

### lower()

将字符串中的大写字母转换为小写字母。

```python
temp = 'Wuhan City'
print(temp.lower())
```

输出：

```python
wuhan city
```

### lstrip()

返回截掉字符串左边的空格或指定字符后生成的新字符串。

语法：

```python
str.lstrip([chars])
```

示例：

```python
temp = '  wuhan city'
print(temp.lstrip())
temp = 'hhwuhan city88'
print(temp.lstrip('h'))
```

输出：

```python
wuhan city
wuhan city88
```

### rstrip()

返回截掉字符串右边的空格或指定字符后生成的新字符串。

### strip()

返回移除字符串头尾指定的字符序列（默认为空格）生成的新字符串。

### join()

用于将序列中的元素以指定的字符连接生成一个新的字符串。

语法：

```python
str.join(sequence)
```

示例：

```python
seq = ['w','u','h','a','n']
print('-'.join(seq))
```

输出：

```python
w-u-h-a-n
```

