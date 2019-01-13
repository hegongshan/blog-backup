---
title: python3教程-第10章 函数(1)
date: 2018-06-17 17:31:31
tags: python
categories: python
---

> 从本章开始，我们将不再面对黑底白字的命令行，转而使用更加方便的编辑器编写python代码。你可以选择自己最喜欢的文本编辑器，如Notepad++、Sublime Text等，也可以使用eclipse、PyCharm等IDE。我使用的是eclipse+pydev。

函数是带名字的代码块，用于完成具体的工作。

### 定义函数

* 基本语法：

```python
def 函数名(参数1,参数2,...):
    函数体
```

上面的括号中可以没有参数，也可以有任意个参数，但即使没有参数，括号也必不可少。

<!--more-->

示例1.不带参数的函数

```python
def say_hello():
    print("hello")
say_hello()
```

输出结果：

```python
hello
```

示例2.带参数的函数

```python
def say_hello_to(username):    
    """显示问候"""
    print("hello "+username.title())
say_hello_to('hegongshan')
```

输出结果：

```python
hello Hegongshan
```

上面第2行处的文本"""显示问候"""被称为**文档字符串**，用于描述函数的作用。文档字符串用**三个引号**括起来（单引号双引号都可以，但不能混用），python使用它们来生成有关程序中函数的文档。简单来说就是文档注释。

* 实参和形参

上面示例2，在say_hello_to()的定义中，变量username是一个形参（函数完成其工作所需要的一项信息）。

在代码say_hello_to('hegongshan')中，值‘hegongshan’是一个实参（调用函数时传递给函数的信息）。

在say_hello_to('hegongshan')中，将实参‘hegongshan’传递给了函数say_hello_to()，这个值被存储在形参username中。

### 传递实参

python中传递实参，主要有以下三种方式:

#### 位置实参

在调用函数时，基于实参的顺序，将函数调用中的每个实参都关联到函数定义中的一个形参，这种关联方式称为**位置实参（positional arguments）**。

示例：

```python
def greater_than(i,j):
    '''判断第一个参数i是否大于第二个参数j'''
    if i>j:
        print(str(i)+"大于"+str(j))
    elif i==j:
        print(str(i)+"等于"+str(j))
    else:
        print(str(i)+"小于"+str(j))
greater_than(18,10)
```

输出结果：

```python
18大于10
```

位置实参这种方式，需要确保函数调用时实参的顺序与函数定义中形参的顺序一致，否则，结果可能出乎意料。

例如下面这个例子

```python
def describe_user(first,last):
    print("用户\n姓："+first+",名："+last)
describe_user("贺", "巩山")
```

输出结果：

```python
用户
姓：贺,名：巩山
```

如果我在调用函数的时候，将两个参数的顺序弄错了

```python
describe_user("巩山", "贺")
```

输出结果：

```python
用户
姓：巩山,名：贺
```

结果就是牛头不对马嘴。

#### 关键字实参

关键字实参是将键-值对传递给函数。通过这种方式，我们无需考虑函数调用中的实参顺序，清楚地指出了函数调用中各个值的用途。

示例：

```python
def describe_user(first,last):
    print("用户\n姓："+first+",名："+last)
describe_user(last="巩山",first="贺") 
```

输出结果：

```python
用户
姓：贺,名：巩山
```

可以看到我并没有按照形参顺序传递实参，输出结果也是正确的。

#### 默认值

编写函数时，可给每个形参指定默认值。如果在调用函数时给形参提供了实参，python将使用指定的实参值；否则，将使用形参的默认值。因此，在形参指定默认值后，可在函数调用中省略相应的实参。

示例：

```python
def describe_user(first,last,motto='没有伞的孩子更要努力奔跑'):
    print("用户\n姓："+first+"，名："+last+"，座右铭："+motto)
describe_user(first="贺",last='巩山') 
describe_user(first="he",last='gongshan',motto='To live is to change the world') 
```

输出结果：

```python
用户
姓：贺，名：巩山，座右铭：没有伞的孩子更要努力奔跑
用户
姓：he，名：gongshan，座右铭：To live is to change the world
```

**使用默认值时，在形参列表中必须先列出没有默认值的形参，再列出有默认值的形参。**

这是因为使用了默认值后，函数调用传参时，python依然会将传入的参数视为位置实参。

### 返回值

大多数情况下，函数并非直接显示输出，相反，它可以处理一些数据，并返回一个或一组值。在函数中，可以使用**return语句**将值返回。另外，函数可返回任何类型的值，包括列表和字典等较复杂的数据结构。

#### 返回简单值

示例：

```python
def multiply(i,j):
    return i*j
result = multiply(20, 55.5)
print(result)
```

输出结果：

```python
1110.0
```

#### 返回字典

```python
def to_user(first,last,email,motto):
    """返回一个包含个人信息的字典"""
    user = {'first':first,'last':last,'email':email,'motto':motto}
    return user
user = to_user("he", "gongshan", "hegongshan@qq.com", "To live is to change the world.")
print(user)
```

输出结果：

```python
{'first': 'he', 'last': 'gongshan', 'email': 'hegongshan@qq.com', 'motto': 'To live is to change the world.'}
```

































































































































































































































[]()

