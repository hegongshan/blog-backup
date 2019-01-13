---
title: python3教程-第7章 列表
date: 2018-06-14 16:32:38
tags: python
categories: python
---

列表由一系列按特定顺序排列的元素组成。

在python中，**用方括号 []来表示列表**，并用**逗号**来分隔其中的元素。

<!--more-->

下面定义了一个关于学校的列表

```python
schools = ['ccnu','whu','hust','thu']
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612171510.png)

可以看到python将方括号也打印出来了，但这肯定不是我们想要的结果，下面来看下如何访问列表中的元素

### 访问列表中的元素

列表是有序集合，要访问列表中的任意元素，只需将该元素的索引告诉python即可。

下面我们打印下上面的列表schools中的第二个元素

```python
schools = ['ccnu','whu','hust','thu']
print(schools[1])
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612172256.png)

可以看到，python只返回了元素值，并没有打印方括号

需要注意的是，**元素的索引号是从0开始的**，而不是1。如果学习过其他编程语言的话，应该很容易理解。

另外，python为访问列表中的元素提供了一种特殊的语法：通过**将索引号指定为负数**，可以返回列表中倒数第几个元素。

下面指定索引号为-1，打印列表中的最后一个元素‘thu’

```python
schools = ['ccnu','whu','hust','thu']
print(schools[-1])
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612173007.png)

可以看到，python确实打印了最后一个元素thu。如果指定索引号为-2，则打印倒数第二个元素，其他负数索引以此类推。

大部分情况下，我们是不知道列表的长度的，因此，这种语法可以使我们很方便的访问列表中的最后一个元素。

### 修改列表元素

修改列表元素的语法与访问列表元素的语法类似。指定列表名和要修改的元素索引，通过“=”赋新值即可。

下面修改schools中的第三个元素 ’hust‘（索引为2）的值为 ‘pku‘

```python
schools = ['ccnu','whu','hust','thu']
schools[2] = 'pku'
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612174422.png)

可以看到第三个元素的值确实改变了。通过这种方式，我们可以改变任何列表元素的值。

### 在列表中添加元素

在列表中添加元素，可分为以下两种情况：

#### 在列表末尾添加元素

使用列表的**append()**方法，可以将新元素添加到列表末尾。

下面在schools末尾添加一个元素 ‘mit’

```python
schools = ['ccnu','whu','hust','thu']
schools.append('mit')
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612175142.png)

事实上，下面的方式可能更常用：先创建一个空的列表，然后使用append()方法，动态添加元素。

我们也来尝试下：

```python
# 创建空的列表
schools = []
schools.append('ccnu')
schools.append('whu')
schools.append('thu')
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612180024.png)



#### 在列表中插入元素

使用列表的**insert()**方法，通过指定新元素的索引和值，我们可以在列表的任意位置添加新的元素。

```python
# insert()方法的第一个参数为索引，第二个参数为新元素的值
schools = ['ccnu','whu','hust','thu']
schools.insert(0,'zju')
schools.insert(4,'mit')
print(schools)
```

第三行的schools.insert(0,'zju') 表示将 ‘zju’ 插入到列表头部，插入后，列表为

```python
schools = ['zju','ccnu','whu','hust','thu']
```

然后在执行第四行的 schools.insert(4,'mit')，插入后，列表为

```python
schools = ['zju','ccnu','whu','hust','mit','thu']
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612180947.png)

### 从列表中删除元素

从列表中删除元素，可分为以下两种情况。

#### 使用del语句删除元素

如果知道要删除的元素在列表中的位置（索引），可以使用del语句。

下面用del语句删除schools中的第三个元素 'hust'

```python
schools = ['ccnu','whu','hust','thu']
del schools[2]
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612212950.png)

可以看到第三个元素 ‘hust’ 确实被删除了

#### 使用pop()删除元素

* pop()方法可以删除列表末尾的元素，并返回该元素的值。

下面用pop()方法删除schools中的最后一个元素 'thu'

```python
schools = ['ccnu','whu','hust','thu']
school = schools.pop()
print(schools)
print(school)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612213459.png)

可以看到pop()方法确实删除了schools中的最后一个元素 'hut'，并把该元素的值存储到了变量school中

* 事实上，pop()方法也可以用来删除列表中任何位置的元素，只需在括号中指定要删除的元素的索引即可。

下面使用pop()方法删除schools的第二个元素 ‘whu’

```python
schools = ['ccnu','whu','hust','thu']
school = schools.pop(1)
print(schools)
print(school)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612214121.png)

#### 根据值删除元素

如果我们不知道要删除的元素在列表中的位置（索引），但是知道要删除元素的值，我们可以使用remove()。

下面使用remove()方法删除schools中值等于 ’whu‘ 的元素

```python
# 为了演示remove方法，我在schools中添加了多个值为whu的元素
schools = ['ccnu','whu','hust','whu','thu','whu']
schools.remove('whu')
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612214822.png)

可以看到，只有第一个值为 ‘whu’ 的元素被删除了，其他值为 ‘whu’ 的元素并没有被删除。

**remove()方法只删除列表中满足条件的第一个元素**。如果要删除的值在列表中出现多次，需要使用循环。

这里简单实现下，关于循环的具体内容，在后面的章节中会详细讲述

```python
schools = ['ccnu','whu','hust','whu','thu','whu']
while schools.count('whu') > 0:
    schools.remove('whu')

print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/12/20180612220210.png)

### 对列表中的元素进行排序

#### 使用sort()方法对列表进行永久性排序

首先，我们假定列表中全为字符串

* 对字符串列表进行排序

```python
schools = ['ccnu','whu','hust','thu']
schools.sort()
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613150413.png)

可以看到sort()方法永久性地修改了列表中元素的排列顺序。

```python
schools = ['CCnu','whu','hust','Thu']
schools.sort()
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613150907.png)

```python
schools = [1,2,3,'CCnu','whu','hust','Thu']
schools.sort()
print(schools)
```

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613151320.png)

* 反序排序

```python
schools = ['ccnu','whu','hust','thu']
schools.sort(reverse=True)
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613151531.png)

#### 使用函数sorted()对列表进行临时排序

有时候我们只想以特定的顺序展示列表元素，但不想真的改变列表元素原来的排列顺序，这时候我们可以使用函数sorted()对列表进行临时排序。

```python
schools = ['ccnu','whu','hust','thu']
newSchools = sorted(schools)
print(newSchools)
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613153145.png)

可以看到执行完sorted(schools)后，schools中元素的排列顺序并没有被改变。

当然，如果想要按与字母顺序相反的顺序显示列表，也可以向sorted()传递参数reverse=True

### 反转列表

使用reverse()方法，可以反转列表元素的排列顺序。

```python
schools = ['ccnu','whu','hust','thu']
schools.reverse()
print(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613153749.png)

reverse()永久性地修改了列表元素的排列顺序，但我们可以随时恢复到原来的排列顺序，只需要再次调用reverse()即可。

### 确定列表的长度

使用函数len()可以取得列表的长度。

```python
# len()函数返回一个整数
schools = ['ccnu','whu','hust','thu']
len(schools)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613161520.png)

当然，我们也可以这样

```python
schools = ['ccnu','whu','hust','thu']
length = len(schools)
print(length)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/13/20180613161805.png)

count()

index()

clear()

copy()

extend()