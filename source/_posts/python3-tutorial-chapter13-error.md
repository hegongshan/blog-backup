---
title: python3教程-第13章 异常
date: 2018-06-19 20:31:33
updated: 2018-06-27 14:30:23
tags: python
categories: python
---

python使用被称为异常的特殊对象来管理程序执行期间发生的错误．每当发生让python不知所措的错误时，它都会创建一个异常对象．

如果你编写了处理该异常的代码，程序将继续运行；如果你未对异常进行处理，程序将停止，并显示一个traceback，其中包含有关异常的报告．

<!--more-->

就像下面这样

```python
print(2/0)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619194751.png)

这里报了一个ZeroDivisionError，如果不想让python报错，则可以使用异常处理．

异常是使用try-except代码块处理的．

语法如下：

```python
try:
    指定的操作
except 需要处理的异常:
	发生异常时需要执行的操作
else:
    try中操作成功执行后，需要执行的操作
```

上述结构中，else 部分是可选的．

### 简单的异常处理

示例：

except.py

```python
try:
    result = 2/0
except ZeroDivisionError:
    print("can't divide by zero")
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619195645.png)

### 带else的异常处理

下面我们来尝试读取一个不存在的文件．

except.py

```python
# 当前目录下不存在except.txt
filename = 'except.txt'
with open(filename) as file:
    content = file.read()
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619200740.png)

这里报了一个FileNotFoundError，顾名思义，python找不到except.txt这个不存在的文件．下面我们用try-except-else来处理FileNotFoundError．

except.py

```python
filename = 'except.txt'
try:
    with open(filename) as file:
        content = file.read().rstrip()
except FileNotFoundError:
    print("This directory can't found "+filename)
else:
    print(content)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619201632.png)

可以看到，这里没有执行print(content)

现在我们创建except.txt这个文件，内容如下：

```python
https://www.baidu.com
https://www.aliyun.com
```

然后重新执行except.py，输出如下：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619202434.png)

### 不处理异常

如果发生异常时，我们不想处理它，也不想告诉用户程序出错了，就像什么都没有发生一样继续运行，可以使用**pass**语句．

except.py

```python
def count_words(filename):
    try:
        with open(filename) as file:
	    content = file.read()
    except FileNotFoundError:
        pass
    else:
        words = content.split()
        numOfWords = len(words)
        print("文件'"+filename+"'有"+numOfWords+"个词")

filenames = ['except.txt','websites.txt','schools.txt']
for filename in filenames:
    count_words(filename)
```

except.txt

```python
ZeroDivisionError
FileNotFoundError
```

websites.txt

```python
https://www.baidu.com
https://www.aliyun.com
```

这里我故意多写了一个不存在的schools.txt文件，看下会产生什么结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619204051.png)

可以看到，虽然有一个不存在的schools.txt，但是程序在处理的时候，什么信息也没有．