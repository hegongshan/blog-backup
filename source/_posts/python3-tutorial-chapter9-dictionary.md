---
title: python3教程-第9章 字典
date: 2018-06-16 18:12:43
tags: python
categories: python
---

在python中，字典是一系列键-值对。每个键都与一个值相关联，该值可以是数字、字符串、列表乃至字典。

字典用放在**花括号{ }**中的一系列键-值对表示。键和值之间用**冒号**分隔开，而键-值对之间用**逗号**分隔开。

示例如下

```python
user={'name':'hegongshan','age':23,'gender','M'}
```

<!--more-->

### 访问字典中的值

语法如下：

```python
字典名[键名]
```

示例：

```python
# 获取user中与‘name’相关联的值
user={'name':'hegongshan','age':23,'gender':'M'}
print(user['name'])
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616170128.png)

### 添加/修改键-值对

语法如下：

```python
字典名[键名] = 值
```

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
# 在user中添加'degree':'bachelor'
user['degree']='bachelor'
print(user)
# 修改user中'gender'的值为‘F’
user['gender']='F'
print(user)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616171848.png)

需要注意的是，**字典在初始化的时候，键名是可以重复的**。

示例：

```python
# 相当于user={'name':'hegongshan','age':23}
# user['name']='M'
user={'name':'hegongshan','age':23,'name':'M'}
print(user)
```

以上代码中的user={'name':'hegongshan','age':23,'name':'M'}，隐式地修改了‘name’的值，其等价于以下两条语句

```python
user={'name':'hegongshan','age':23}
user['name']='M'
```

推荐在初始化时，不要出现重复的键名，这样做可以提高代码的可读性。

### 删除键-值对

在字典中删除键-值对，类似于在列表中删除元素，使用**del语句将相应的键-值对彻底删除**。

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
del user['age']
print(user)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616172307.png)

### 遍历字典

#### 遍历所有的键-值对

使用字典的**items()方法**，可以返回一个包含字典中所有键-值对的列表

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
for key,value in user.items():
    print(key.title()+":"+value.title())
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616172930.png)

可以看到，for循环在执行第二遍时报错了，python解释器告诉我们：int对象没有title属性，这是因为在执行第二次时，age的值23是整型，不是字符串，没有title()，那怎么办呢？

如果在for循环里面不用字符串的title()方法，还会报错吗？

我们来尝试下:

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616173838.png)

可以看到，程序还是报错了，python解释器告诉我们：value必须是字符串，不能是整型，这是因为

key.title() + ":"是字符串，而字符串只能和字符串拼接。

我们可以使用python中的**str()函数**，将age的值23转换为字符串，然后就可以正常输出了。如果学过Java的话，可以发现str()函数和Java中的toString()很像。

改进后的示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
for key,value in user.items():
    print(key.title()+":"+str(value).title())
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616173545.png)

如果我们在for循环中只定义了一个变量，

```python
user={'name':'hegongshan','age':23,'gender':'M'}
for key_value in user.items():
    print(key_value)
```

那么会输出如下结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616184058.png)

#### 遍历字典中的所有键

* 简单遍历

某些时候，我们不需要使用字典中的值，只想获取所有的键，这时候可以使用字典的**keys()方法**。

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
for key in user.keys():
    print(key.title())
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616174613.png)

事实上，遍历字典时，会默认遍历所有的键，因此，上述代码中for key in user.keys():替换为

for key in user:，输出结果将不变。

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616175006.png)

推荐显式地使用keys()方法，使代码更容易理解。

* 按顺序遍历

在for循环中**使用sorted()函数**，对返回的键进行排序。

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
for key in sorted(user.keys()):
    print(key.title())
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616175657.png)

可以看到，输出的键名确实按照字母顺序排序了。

#### 遍历字典中的所有值

如果我们只想要字典中的所有值，可以使用字典的**values()方法**，它将返回一个值列表。

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M'}
for value in user.values():
    print(value)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616180124.png)

如果值列表中包含大量重复的值，为剔除重复项，可以使用**集合set**，集合类似于列表，但每个元素都必须是独一无二的。

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M','full_name':"hegongshan"}
for value in set(user.values()):
    print(value)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616181205.png)

可以看到重复的'hegongshan'，只输出了一次。

### 嵌套

#### 在列表中嵌套字典

示例：

```python
users=[{'name':'hegongshan','age':23,'gender':'M'},
       {'name':'hgs','age':24,'gender':'F'},
       {'name':'gongshanhe','age':25,'gender':'M'}]
for user in users:
    print(user)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616182025.png)

#### 在字典中嵌套列表

示例：

```python
user={'name':'hegongshan','age':23,'gender':'M','address':['hubei','wuhan']}
for key,value in user.items():
    print(key.title()+":"+str(value))
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616182559.png)

#### 在字典中嵌套字典

示例：

```python
user={'name':{'first':'he','last':'gongshan'},
      'age':23,
      'gender':'M',
      'address':{
          'province':'hubei',
          'city':'wuhan'
          }
      }
for key,value in user.items():
    print(key.capitalize()+":"+str(value))
```

输出：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/16/20180616183145.png)