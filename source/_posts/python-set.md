---
title: Python集合（set）
date: 2019-11-28 18:39:29
tags: python
categories: python
---

set和dict类似，也是一组key的集合，但不存储value。

<!--more-->

### 初始化

像dict一样，集合也可以通过构造方法或者花括号{}来创建。

#### 创建空集合

注意下面两种写法的区别：

```python
# 创建空字典
x = {}
print(type(x))

# 创建空集合
x = set()
print(type(x))
```

输出：

```python
<class 'dict'>
<class 'set'>
```

#### 创建非空集合

```python
# 使用花括号创建集合
x = {1, 2}
print(type(x), x)

# 使用构造器创建集合
y = set([1, 2])
print(type(y), y)

print(x == y)
```

输出：

```python
<class 'set'> {1, 2}
<class 'set'> {1, 2}
True
```

### 添加元素

add方法每次添加一个元素到集合中。如果该元素已经在集合中，调用该方法将不会有任何效果。

```python
test_set = set()
test_set.add(1)
print(test_set)

# 添加集合中已有的元素
test_set.add(1)
print(test_set)
```

输出：

```python
{1}
{1}
```

### 删除元素

#### 使用pop

pop方法删除并返回任意的集合元素。若集合为空，将导致KeyError。

```python
x = set([1,2])
print(x.pop())
print(x)

print(x.pop())
print(x)

print(x.pop())
```

输出：

```python
1
{2}
2
set()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 'pop from an empty set'
```

#### 删除指定元素

remove方法可以删除集合中的指定元素。若该元素不在集合中，将导致KeyError。

```python
x = {1, 2}
x.remove(2)
print(x)

x.remove(3)
```

输出：

```python
{1}
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 3
```

discard方法也可以删除集合中的指定元素。若该元素不在集合中，则什么也不会发生。

```python
x = {1, 2}
x.discard(2)
print(x)

x.discard(3)
```

输出：

```python
{1}
```

注意remove方法和discard方法的区别：若待删除的元素不在集合中，remove方法将产生KeyError；而discard方法什么也不会发生。

#### 删除所有元素

clear方法可以删除集合中的所有元素。

```python
x = {1, 2, 3}
print(x)

x.clear()
print(x)
```

输出：

```python
{1, 2, 3}
set()
```

### 合并集合

#### 使用union

union方法可以合并多个集合，并返回合并后的集合，但调用该方法的集合不会变化。

```python
x = {1, 2, 3}
y = {4, 5, 6}
z = {7, 8, 9}

k = x.union(y, z)
print(k)
print(x, y, z)
```

输出：

```python
{1, 2, 3, 4, 5, 6, 7, 8, 9}
{1, 2, 3} {4, 5, 6} {8, 9, 7}
```

可以看到，调用union方法后，x本身并未发生改变，而是创建了一个新的集合。

#### 使用update

update方法会将其他集合合并到当前集合中。

```python
x = {1, 2, 3}
y = {4, 5, 6}
z = {7, 8, 9}

x.update(y, z)
print(x)
```

输出：

```python
{1, 2, 3, 4, 5, 6, 7, 8, 9}
```

可以看到，调用update后，x发生了变化。

### 集合交

intersection可以求多个个集合的交集。

```python
x = {1, 2, 3}
y = {2, 3, 4}
z = {3, 4, 5}

# 合并两个集合
print(x.intersection(y))

# 合并多个集合
k = x.intersection(y, z)
print(k)
# x没有被改变
print(x)
```

输出：

```python
{2, 3}
{3}
{1, 2, 3}
```

### 集合差

difference方法可以求两个或多个集合的差。

```python
x = {1, 2, 3}
y = {2, 3, 4}
z = {3, 4, 5}

# x - y
print(x.difference(y))

# x - y - z
print(x.difference(y, z))
```

输出：

```python
{1}
{1}
```

### 复制集合

copy方法可以返回集合的浅拷贝。

```python
x = {1, 2, 3}
y = x.copy()

print(y)
print(x is y)
```

输出：

```python
{1, 2, 3}
False
```





