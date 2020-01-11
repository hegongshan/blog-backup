---
title: Python字典（dict）
date: 2019-11-23 16:18:54
tags: python
categories: python
---

dict是Python中的标准映射类型，可以存储任意类型对象。

<!--more-->

### 创建字典

字典可以通过将以逗号分隔的 `键: 值` 对列表包含于花括号`{}`之内来创建，也可以通过dict构造器来创建。

#### 使用花括号{}

```python
# 创建一个空字典
test_dict = {}
print(test_dict)
print(type(test_dict))

test_dict2 = {'date': 2019, 12: 2020}
print(test_dict2)
```

输出：

```python
{}
<class 'dict'>
{'date': 2019, 12: 2020}
```

#### 使用dict构造器

字典dict类有四个初始化方法，函数原型如下：

```python
# 创建一个空字典
dict()
# 使用映射对象创建字典
dict(mapping)
# 使用iterable对象创建字典
dict(iterable)
# 使用键值对创建字典
dict(**kwargs)
```

* dict(iterable)通过如下的方式创建字典

```python
d = {}
for k, v in iterable:
	d[k] = v
```

示例：

```python
test_dict1 = dict()
# 使用映射对象创建字典
test_dict2 = dict(zip(['name','age'], ['gongshan',24]))
# 使用iterable对象创建字典
test_dict3 = dict([('name','gongshan'), ('age',24)])
# 使用键值对创建字典
test_dict4 = dict(name='gongshan', age=24)

print(test_dict1)
print(test_dict2 == test_dict3 == test_dict4)
print(test_dict2)
```

输出：

```python
{}
True
{'name': 'gongshan', 'age': 24}
```

### 访问元素

#### 使用d[key]

返回键key对应的值。

```python
test_dict = {'name': 'gongshan', 'age': 24}

# 访问元素
print(test_dict['name'])
print(test_dict['age'])
```

输出：

```python
gongshan
24
```

#### 使用get方法

函数原型：

```python
get(key[, default])
```

如果键名key存在，则返回对应的值value；否则，返回default（键值对key=default不会加入字典中）。default默认为None。

示例：

```python
test_dict = {'name': 'gongshan', 'age': 24}
# 访问存在的键名
print(test_dict.get('name'))

# 访问不存在的键名，默认值为None
print(test_dict.get('sex'))

# 为不存在的键名key，设置默认值
print(test_dict.get('sex','male'))
print(test_dict)
```

输出：

```python
gongshan

None

male
{'name': 'gongshan', 'age': 24}
```

#### 使用setdefault方法

函数原型：

```python
setdefault(key[, default])
```

如果键key存在，则返回其值；否则，插入值为default的键key，并返回default。default默认为None。

**setdefault方法和get方法的不同之处**：setdefault方法会将不存在的键key及其值default插入字典中，而get方法并不会。

示例：

```python
test_dict = {'name': 'gongshan', 'age': 24}
# 键存在
value = test_dict.setdefault('name')
print(value)

# 键不存在
value = test_dict.setdefault('sex')
print(value)
print(test_dict)

# 键不存在，但设置了默认值
value = test_dict.setdefault('address','wuhan')
print(value)
print(test_dict)
```

输出：

```python
gongshan

None
{'name': 'gongshan', 'age': 24, 'sex': None}

wuhan
{'name': 'gongshan', 'age': 24, 'sex': None, 'address': 'wuhan'}
```

### 添加/修改元素

使用如下的语法添加/修改字典的元素：

```python
字典[键] = 值
```

示例：

```python
test_dict = {'name': 'gongshan', 'age': 24}
print(test_dict)

# 添加元素
test_dict['sex'] = 'male'
print(test_dict)

# 修改name的值
test_dict['name'] = 'Gongshan He'
print(test_dict)
```

输出：

```python
{'name': 'gongshan', 'age': 24}
{'name': 'gongshan', 'age': 24, 'sex': 'male'}
{'name': 'Gongshan He', 'age': 24, 'sex': 'male'}
```

### 删除元素

#### 使用关键字del

```python
test_dict = {'name': 'gongshan', 'age': 24}
print(test_dict)

# 删除键名为name的元素
del test_dict['name']
print(test_dict)
```

输出：

```python
{'name': 'gongshan', 'age': 24}
{'age': 24}
```

#### 使用pop方法

函数原型如下：

```python
# d是一个可选的位置参数
pop(self, k, d=None):
```

如果键key在字典中，则将其删除并返回其值；否则，返回d。如果d未给出且key不存在，则会引发KeyError。

示例：

```python
test_dict = {'name': 'gongshan', 'age': 24}
# 删除name
value = test_dict.pop('name')
print(test_dict)

# 删除一个不存在的键
test_dict.pop('sex')

# 删除一个不存在的键，并指明default
value = test_dict.pop('sex', 'male')
print(value)
```

输出：

```python
{'age': 24}
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
KeyError: 'sex'
male
```

#### 使用popitem方法

从字典中删除并返回一个`(键，值)`。删除时，遵循后进先出（LIFO）的顺序。如果字典为空，则会引发KeyError。

```python
test_dict = {'name': 'gongshan', 'age': 24}
print(test_dict.popitem())
print(test_dict.popitem())
print(test_dict.popitem())
```

输出：

```python
('age', 24)
('name', 'gongshan')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 'popitem(): dictionary is empty'
```

### 遍历字典

#### 遍历字典中的键

如果只想遍历字典的键，使用dict的keys方法。

```python
test_dict = {'name': 'gongshan', 'age': 24}
print(test_dict.keys())

for k in test_dict.keys():
  print(k)
```

输出：

```python
dict_keys(['name', 'age'])
name
age
```

#### 遍历字典中的值

如果只想遍历字典的键，使用dict的values方法。

```python
test_dict = {'name': 'gongshan', 'age': 24}
print(test_dict.values())

for v in test_dict.values():
  print(v)
```

输出：

```python
dict_values(['gongshan', 24])
gongshan
24
```

#### 遍历字典中的(键,值)对

如果想要遍历字典中的(键,值)对，可以使用dict的values方法。

```python
test_dict = {'name': 'gongshan', 'age': 24}
print(test_dict.items())

for k, v in test_dict.items():
  print(k,v)
```

输出：

```python
dict_items([('name', 'gongshan'), ('age', 24)])
name gongshan
age 24
```

### 复制字典

dict的copy方法，可以返回原字典的浅拷贝。

```python
test_dict = {'name': 'gongshan', 'age': 24}
test_dict2 = test_dict.copy()

print(test_dict2)
print(test_dict is test_dict2)
```

输出：

```python
{'name': 'gongshan', 'age': 24}
False
```

### 清空字典

dict的clear方法，可以删除字典中的所有元素。

```python
test_dict = {'name': 'gongshan', 'age': 24}
test_dict.clear()
print(test_dict)
```

输出：

```python
{}
```

### 判断字典是否为空

* 在条件判断中，空字典表示False。

```python
test_dict = {}
# 若为空
if not test_dict:
  print('dict is empty.')
```

输出：

```python
dict is empty.
```

* 判断长度是否为0

```python
test_dict = {}
# 若为空
if len(test_dict) == 0:
  print('dict is empty.')
```

输出：

```python
dict is empty.
```

### 判断键是否在字典中

使用`key in dict `语法，可以判断key是否在dict中。如果key在dict中，则返回True；否则，返回False。

```python
test_dict = {'name': 'gongshan', 'age': 24}
print('sex' in test_dict)
print('sex' not in test_dict)
```

输出：

```python
False
True
```

