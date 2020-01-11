---
title: Python列表（list）
date: 2019-09-28 13:52:26
tags: python
categories: python
---

在Python中，用方括号`[]`来表示列表，并用逗号来分隔其中的元素。列表中的元素类型可以不一致。

<!--more-->

### 创建列表

使用方括号[]来创建列表。

```python
# 创建一个空列表
test_list = []
print(type(test_list))
```

输出：

```python
<class 'list'>
```

### 访问元素

* 使用索引访问列表中的元素，索引从0开始。

```python
digits = [1, 2, 3]
print(digits[0])
```

输出：

```python
1
```

* 负数索引-index表示倒数第index个元素。索引-1返回最后一个列表元素，索引-2返回倒数第二个列表元素，依次类推。

```python
digits = [1, 2, 3]
print(digits[-1])
```

输出：

```python
3
```

### 修改元素

要修改列表元素，可指定列表名和要修改的元素索引，再指定该元素的新值。

```python
digits = [1, 2, 3]
digits[0] = -1
print(digits)
```

输出：

```python
[-1, 2, 3]
```

### 添加元素

#### 在列表末尾添加元素

使用append(object)方法。

```python
test_list = [1, 2]
test_list.append(3)
print(test_list)
```

输出：

```python
[1, 2, 3]
```

#### 在列表中插入元素

使用insert(index, object)方法。

```python
test_list = [1, 2]
test_list.insert(0, 3)
print(test_list)

test_list.insert(3, 4)
print(test_list)
```

输出：

```python
[3, 1, 2, 4]
```

#### 用新列表扩展原来的列表

使用extend()方法，可以在列表末尾一次性追加另一个列表中的多个值。

函数原型：`extend(iterable)`

```python
digits = [1, 2, 3]
digits2 = [4, 5, 6]

digits.extend(digits2)
print(digits)
```

输出：

```python
[1, 2, 3, 4, 5, 6]
```

### 删除元素

#### 使用del关键字删除元素

删除指定索引处的元素。

```python
test_list = [1, 2, 3]
# 删除索引为2的元素
del test_list[2]
print(test_list)

# 删除索引为1的元素
del test_list[1]
print(test_list)
```

输出：

```python
[1, 2]
[1]
```

#### 使用方法pop()弹出元素

删除索引为index的元素，并将其返回。index默认为-1，即删除最后一个元素。

函数原型：`pop(index=-1)`

示例：

```python
digits = [1, 2, 3]
# 删除最后一个元素
x = digits.pop()
print(x)
print(digits)

# 删除索引为1的元素
digits.pop(1)
print(digits)
```

输出：

```python
3
[1, 2]
[1]
```

#### 根据值删除元素

如果知道要删除的值，可以使用remove方法。

值得注意的是，remove方法只移除列表中某个值的第一个匹配项。

函数原型：`remove(value)`

示例：

```python
test_list = [1, 2, 3, 3]
# 删除最后一个元素
test_list.remove(3)
print(test_list)
```

输出：

```python
[1, 2, 3]
```

### 反转列表

使用reverse()方法，将列表中的元素反向排序。

```python
digits = [4, 2, 3]
digits.reverse()
print(digits)
```

输出：

```python
[3, 2, 4]
```

