---
title: python3教程-第12章 文件
date: 2018-06-19 20:31:19
updated: 2018-06-27 15:33:30
tags: python
categories: python
---

前面我们已经学习了python的基础语法和一些数据结构，今天我们来学习下python中的文件操作．

<!--more-->

### 从文件中读取数据

#### 读取整个文件

基本语法：

```python
with open(filename) as file_object:
    对文件的处理
```

open()函数用于打开文件，它接受一个参数：要打开的文件的名称，并返回一个表示文件的对象，将其存储在后面使用的变量file_object中，以便接下来对文件的各种操作.

关键字with在不再需要访问文件后会自动将其关闭．

示例

先创建一个test.txt文件，内容如下：

```python
To live is to change the world.
Choice is very significant.
I love you more than anything else in the world.
```

下面用python打开并读取这个文件，再将内容打印出来

在上述文件所在目录下，创建一个file.py文件，内容如下：

```python
with open('test.txt') as file:
    # read()读取文件中的全部内容
    contents = file.read()
    print(contents)
```

执行file.py，输出如下：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619122113.png)

可以看到，输出多了一个空行．这是因为read()到达文件末尾时返回一个空字符串，而将空字符串显示出来就是一个空行．可以使用rstrip()删除多余的空白行

将file.py中的代码稍作修改

```python
with open('test.txt') as file:
    # read()读取文件中的全部内容
    contents = file.read()
    print(contents.rstrip())
```

上面的方法**read()从文件中读取全部内容，并将其存储在一个字符串中．**

输出如下：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619122510.png)

事实上，我们也可以不采用上述的语法格式

```python
file = open('test.txt')
contents = file.read()
print(contents)
file.close()
```

这里我们在使用完file后，手动调用了file对象的close()方法．虽然可以这样做，但我们并不推荐这种方式．

因为如果忘记调用close()方法，文件将不会自动关闭．或者如果过早地调用了close()方法，我们在使用文件时它已关闭，从而导致程序执行错误．因此，最好的方式就是使用关键字with，让python在合适的时候自动关闭文件.

#### 逐行读取

如果我们每次只想取一行，可对文件对象使用for 循环．

用下面的代码覆盖file.py中的代码

```python
filename = 'test.txt'
with open(filename) as file:
    for line in file:
        print(line)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619150228.png)

每一行后面都多出了一个空行．这是因为文件中每行的末尾都有一个换行符，而print()语句也会加上一个换行符，因此每行末尾都有两个换行符：一个来自文件，一个来自print()语句.可以使用rstrip()去掉多余的换行．

#### 创建一个包含文件各行内容的列表

使用关键字with时，open()返回的文件对象只在with代码块中可用．如果要在with代码块外访问文件的内容，可在with代码块内将文件的各行存储在一个列表中，并在with代码块外使用该列表．

```python
filename = 'test.txt'
with open(filename) as file:
    lines = file.readlines()
for line in lines:
    print(line.rstrip())
```

上面的方法**readlines()从文件中读取每一行，并将其存储在一个列表中．**

### 写入文件

open()函数在打开文件时可以设置打开模式.

```python
open(filename,mode)
```

mode实参有以下几个可选的值：

* 'w'：**写入模式**
* 'r'：**读取模式**
* 'a'：**附加模式**
* 'r+'：**读取和写入模式**
* 'ｗb'：**二进制写入模式**
* 'rb'：**二进制读取模式**

如果省略了模式实参，也就是之前我们采用的open(filename)这种方式，python将以默认的只读模式打开文件．

以'w'模式打开文件，如果要写入的文件不存在，open()将自动创建它．另外，如果指定的文件已经存在，python将在返回文件对象前清空该文件．

* 一个简单的例子

file_write.py

```python
filename = 'websites.txt'
with open(filename,'w') as file:
    file.write('https://www.baidu.com')
    file.write('https://www.aliyun.com')
```

write()方法将其中的实参字符串写入到指定的文件中．

生成的websites.txt

```python
https://www.baidu.comhttps://www.aliyun.com
```

可以看到，写入的两行并没有自动换行，这是因为write()方法不会在写入的文本末尾自动添加换行符，如果需要换行，可以在末尾添加换行符．

* 改进版的例子

file_write.py

```python
filename = 'websites.txt'
with open(filename,'w') as file:
    file.write('https://www.baidu.com\n')
    file.write('https://www.aliyun.com\n')
```

生成的websites.txt

```python
https://www.baidu.com
https://www.aliyun.com
```

* 附加到文件

如果要给文件添加内容，而不是覆盖原有的内容，可以使用附加模式打开文件．如果指定的文件不存在，python将创建一个空文件．

```python
filename = 'websites.txt'
with open(filename,'a') as file:
    file.write('https://www.chsi.com.cn\n')
    file.write('https://www.ccnu.edu.cn\n')
```

下面是附加模式生成的websites.txt

```python
https://www.baidu.com
https://www.aliyun.com
https://www.chsi.com.cn
https://www.ccnu.edu.cn
```

可以看到，前面写入的两个url还在，python并没有清空文件，重新写入，而是在文件的末尾附加了新增的两个url．