---
title: python3教程-第10章 函数(2)
date: 2018-06-17 21:50:30
tags: python
categories: python
---

上一小节中，我们学习了基础的函数使用，本节我们将学习更加高级的函数运用，以及函数编写的规范。

### 传递任意数量的参数

有时候，我们预先不知道函数需要接受多少个参数，好在python允许函数从调用语句中获取任意数量的实参。

<!--more-->

示例：

```python
def test_any_arguments(*args):
    """测试任意数量的参数"""
    print(args)
test_any_arguments("school of information management")
test_any_arguments("hegongshan","https://www.hegongshan.com",
                   "central china normal university")
```

输出结果：

```python
('school of information management',)
('hegongshan', 'https://www.hegongshan.com', 'central china normal university')
```

在上面代码的第一行中，形参名*args中的星号，表示让python创建一个名为args的空元组，并将收到的所有值都封装到这个元组中。

#### 结合使用位置实参和任意数量的实参

如果函数要接收不同类型的参数，必须在函数定义中将接纳任意数量实参的形参放在最后。python先匹配位置实参和关键字实参，再将余下的实参都收集到最后一个形参中。

示例：

```python
def test_any_arguments(tip,*args):
    print(tip+":")
    print(args)
test_any_arguments("hello","import this","the zen of python")
```

输出结果：

```python
hello:
('import this', 'the zen of python')
```

#### 使用任意数量的关键字实参

示例：

```python
def get_user_info(name,**user_info):
    """创建一个字典包含用户的所有信息"""
    profile = {}
    profile['name'] = name
    for key,value in user_info.items():
        profile[key] = value
    return profile
user_info = get_user_info('hegongshan',email='hegongshan@qq.com',
                          website="https://www.hegongshan.com",
                          occupation="freelance/student")
print(user_info)
```

输出结果：

```python
{'name': 'hegongshan', 'email': 'hegongshan@qq.com', 'website': 'https://www.hegongshan.com', 'occupation': 'freelance/student'}
```

上面代码第一行中，函数形参名**user_info，前面的两个星号表示让python创建一个名为user_info的空字典，并将收到的所有键-值对都封装到这个字典中。

### 将函数存储在模块中

通过将函数存储在称为模块的独立文件中，可隐藏程序代码的实现细节，将重点放在程序的高层逻辑上。模块是扩展名为.py的文件。import语句允许在当前运行的程序文件中使用模块中的代码。

#### 导入整个模块

我们先创建一个包含函数get_user_info()的模块user.py

```python
def get_user_info(name,**user_info):
    """创建一个字典包含用户的所有信息"""
    profile = {}
    profile['name'] = name
    for key,value in user_info.items():
        profile[key] = value
    return profile
```

接下来，在user.py所在目录中创建一个main.py的文件，用于调用get_user_info()函数。

main.py

```python
import user

user_info = user.get_user_info('hegongshan',email='hegongshan@qq.com',
                          website="https://www.hegongshan.com",
                          occupation="freelance/student")
print(user_info)
```

第一行中的import user让python打开文件user.py，并将其中的所有函数都复制到这个程序中。要调用被导入模块中的函数，需要制定模块名user和函数名get_user_info()，并用"."（成员运算符）分隔它们。

上述代码的输出结果与之前一般无二

```python
{'name': 'hegongshan', 'email': 'hegongshan@qq.com', 'website': 'https://www.hegongshan.com', 'occupation': 'freelance/student'}
```

#### 导入特定的函数

如果我们不需要导入模块中的所有函数，只想导入某几个函数，也是可以的。

语法如下：

```python
from 模块名 import 函数名1,函数名2,...
```

现在我们可以改写上面main.py中的代码

```python
from user import get_user_info

user_info = get_user_info('hegongshan',email='hegongshan@qq.com',
                          website="https://www.hegongshan.com",
                          occupation="freelance/student")
print(user_info)
```

若使用这种语法，调用导入的函数时，不能加模块名和 ”.“。

使用这种方式后，如果我们还像之前那样，用 模块名 . 函数名来调用函数，则会报如下错误：

```python
Traceback (most recent call last):
  File "main.py", line 3, in <module>
    user_info = user.get_user_info('hegongshan',email='hegongshan@qq.com',
NameError: name 'user' is not defined
```

#### 使用as给函数指定别名

如果要导入的函数的名称可能与程序中现有的名称冲突，或者函数的名称太长，可指定简短而独一无二的别名（类似于人的外号）。

语法如下：

```python
from 模块名 import 函数名 as 函数的别名
```

修改main.py

```python
from user import get_user_info as info

user_info = info('hegongshan',email='hegongshan@qq.com',
                          website="https://www.hegongshan.com",
                          occupation="freelance/student")
print(user_info)
```

值得注意的是，指定了别名后，就不能再使用本来的函数名了。

#### 使用as给模块指定别名

我们还可以使用as给模块指定一个简短的别名。

语法如下：

```python
import 模块名 as 模块的别名
```

例如，修改main.py，为导入的模块user指定别名u

```python
import user as u

user_info = u.get_user_info('hegongshan',email='hegongshan@qq.com',
                          website="https://www.hegongshan.com",
                          occupation="freelance/student")
print(user_info)
```

#### 导入模块中的所有函数

使用星号（*）可以导入模块中的所有函数

语法如下：

```python
from 模块名 import *
```

示例：

```python
from user import *

user_info = get_user_info('hegongshan',email='hegongshan@qq.com',
                          website="https://www.hegongshan.com",
                          occupation="freelance/student")
print(user_info)
```

不推荐使用这种用法。为了提高代码的可读性，要么导入我们需要使用的某个（些）函数，要么导入整个模块并使用句号（ . ）表示法。

### 函数编写规范

* 函数命名应该有意义，且只包含小写字母和下划线
* 每个函数都应包含简要地阐述其功能的注释，该注释应紧跟在函数定义后面，并采用文档字符串格式
* 给形参指定默认值，或者在函数调用中的关键字实参，等号两边不要有空格
* 一行的长度不要超过79个字符
* 如果程序或模块中包含多个函数，使用两个空行将相邻的函数分开
* 所有的import语句都应该放在文件开头，唯一例外的情形是，在文件开头使用了注释来描述整个程序。