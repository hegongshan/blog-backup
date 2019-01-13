---
title: python3教程-第5章 条件判断
date: 2018-06-13 18:11:32
tags: python
categories: python
---

### 简单的if语句

语法如下：

```python
if 判断条件:
    执行语句
```

<!--more-->

示例：

```python
message = 'python'
if message.islower():
    print(message.upper()) # print在if的基础上缩进了四个空格
```

注意第二行末尾的冒号，不要忘记了哦。

另外，需要注意的是，大多数编程语言使用{ }将条件判断中的执行语句包裹起来，而python并不如此，它以缩进作为条件判断中执行语句的标志。条件判后的执行语句在条件判断的基础上**缩进四个空格**。比如上面的例子，print()函数在if的基础上缩进了四个空格。后面要讲的循环也是一样，执行语句需要缩进四个空格。

### if-else语句

在大多数情况下，我们经常需要在条件判断通过时执行一个操作，在没有通过时执行另一个操作。这时候就需要使用到if-else语句。语法如下：

```python
if 判断条件:
    执行语句
else:
    执行语句
```

示例：

```python
message = 'python'
if message.islower():
    print(message.upper())
else:
    print(message.lower())
```



### if-elif-else结构

如果需要处理的条件判断不止两种，则可以使用if-elif-else结构。语法如下：

```python
if 判断条件:
	执行语句
elif 判断条件: 
	执行语句
elif 判断条件: 
	执行语句
...
else:    
	执行语句
```

示例：

```python
age = 20
if age < 18:
    print('未成年')
    
elif age >= 18 & age <= 30:
	print('青年人')
    
elif age > 30 & age < 60:
    print('中年人')
    
else:
    print('老年人')    
```

需要注意的是，**if-elif-else结构中，else并不是必须的**。例如，下面的代码也是正确的

```python
age = 20
if age < 18:
    print('未成年')
    
elif age >= 18 and age <= 30:
	print('青年人')
    
elif age > 30 and age < 60:
    print('中年人')
```

