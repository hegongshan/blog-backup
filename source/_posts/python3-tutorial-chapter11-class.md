---
title: python3教程-第11章 类
date: 2018-06-19 20:28:59
tags: python
categories: python
---

### 创建和使用类

语法：

```python
class 类名():
    # 类中的所有方法都需要一个名为self的形参
    类中的方法
   
```

<!--more-->

示例：

```python
class Book():
    """书籍"""
    def __init__(self,name,price):
        """"初始化书名和价格"""
        self.name = name
        self.price = price
    
    def describe(self):
        """打印书的所有描述信息"""
        print("name:"+self.name+",price:"+str(self.price))
```

上面的代码创建了一个Book类。类中的函数称为方法，前一节中关于函数的一切介绍都适用于方法。

第三行中的\_\_init\_\_()是一个特殊的方法（实例化方法，类似于Java中的构造器），开头和末尾各有两个下划线。每当我们根据Book类创建实例时，python都会自动运行它。

值得注意的是，**\_\_init\_\_()中的形参self是必不可少的，且必须位于其他形参的前面**，它代表的是某一次实例化所产生的实例。当我们通过实参向Book()传递名字和价格的时候，self会自动传递，不需要我们去传递它。

第五、六行中定义的两个变量都有前缀self。python中，**以self为前缀的变量都可供类中的所有方法使用**，也可以通过类的任意实例来访问这些变量。像这样可以通过实例访问的变量称为属性。

#### 创建类的实例

```python
# 使用上面定义的Book类创建实例    
book = Book('Java8 in action',59.8)
book.describe()
```

遇到第二行代码时，python使用实参'Java8 in action'和59.0调用Book类的\_\_init\_\_()，创建一个特定的书籍实例，并使用我们提供的值来设置name和price。方法\_\_init\_\_()并未显示地包含return语句，但python会自动返回一个书籍实例。

输出结果：

```python
name:Java8 in action,price:59.8
```

#### 访问属性

要访问实例的属性，可使用句点表示法( . )。

示例：

```python
print(book.name)
```

输出结果：

```python
Java8 in action
```

#### 调用方法

要调用类中的方法，也是用句点表示法( . )。

### 使用实例

#### 给属性指定默认值

类中的每个属性都必须有初始值，哪怕这个值为0或者空字符串。在有些情况下，如设置默认值时，可以在方法\_\_init\_\_()内指定属性的初始值，从而无需包含为该属性提供初始值的形参。

示例：

```python
class Book():
    """书籍"""
    def __init__(self,name,price):
        """"初始化书名和价格"""
        self.name = name
        self.price = price
        self.publish_time = 2018
    
    def describe(self):
        """打印书的所有描述信息"""
        print("name:"+self.name
              +",price:"+str(self.price)
              +",publish_time:"+str(self.publish_time))
        
book = Book('Java8 in action',59.8)
book.describe()
```

输出结果：

```python
name:Java8 in action,price:59.8,publish_time:2018
```

#### 修改属性的值

* 直接修改属性的值

通过类的实例直接修改属性的值。

示例：

```python
book = Book('Java8 in action',59.8)
book.publish_time = 2020
book.describe()
```

输出结果：

```python
name:Java8 in action,price:59.8,publish_time:2020
```

* 通过方法修改属性的值

通过类中定义的方法修改属性的值，从而隐藏实现细节。

示例：

```python
	# 在上面的Book类中新增一个update_price(self)方法    
    def update_price(self,price):
        """更改书的价格"""
        self.price = price

book = Book('Java8 in action',59.8)
book.update_price(66.6)
book.describe()
```

输出结果：

```python
name:Java8 in action,price:66.6,publish_time:2018
```

### 继承

编写类时，并非总是要从头开始。如果我们编写的类是另一个现成类的某种特殊情况，可以使用继承。一个类继承另一个类时，它将自动获得另一个类的所有属性和方法。原有的类称为父类，新的类称为子类。子类在继承父类所有属性和方法的同时，还可以定义自己特有的属性和方法。

基本语法：

```python
# 在定义子类时，必须在括号中指定父类的名称。
class 类名(父类名):
    类中的方法
```

#### 子类的\_\_init\_\_()

子类在实例化的时候，首先需要为父类的所有属性赋值。下面定义了一个Book类的子类CultureBook。

```python
class CultureBook(Book):
    def __init__(self,name,price):
        # 调用父类Book的__init__()方法
        super().__init__(name,price)
     
book2 = CultureBook('红楼梦',45.5)
book2.describe()
```

创建子类时，父类必须包含在当前文件中，且位于子类的前面。

上面第三行中的函数super()，将父类Book和子类CultureBook关联起来，这行代码让python调用父类Book中的\_\_init\_\_()，从而使CultureBook的实例包含了父类的所有属性。

输出结果：

```python
name:红楼梦,price:45.5,publish_time:2018
```

#### 定义子类独有的属性和方法

```python
class CultureBook(Book):
    """文学书"""
    def __init__(self,name,price,author):
        super().__init__(name,price)
        self.author = author
    
    def get_book_info(self):
        """描述文学书的相关信息"""
        print("{'name':'" + self.name + 
              "','price':" + str(self.price) +
              ",'author':'"+self.author+"'}")
     
book2 = CultureBook('红楼梦',45.5,'曹雪芹')
book2.get_book_info()
```

输出结果：

```python
{'name':'红楼梦','price':45.5,'author':'曹雪芹'}
```

需要注意的是，第四行中的super().\_\_init\_\_()并不一定要写在子类\_\_init\_\_()方法的第一行。事实上，第四、五行的顺序完全可以颠倒过来（这在Java中是不可以的）。

#### 重写父类的方法

如果父类的某个（些）方法不适合子类，完全可以在子类中重写父类的方法，只需要**在子类中定义一个与父类方法同名的方法**即可。这样，python将不会考虑这个父类方法，而只关注子类中定义的同名方法。

示例：

```python
# 父类Book没有author属性，在CultureBook中重写父类的describe()方法
class CultureBook(Book):
    
    # 省略之前的代码
    
    def describe(self):
        print("name:"+self.name+
              ",price:"+str(self.price)+
              ",publish_time:"+str(self.publish_time)+
              ",author:"+self.author)

book2 = CultureBook('红楼梦',45.5,'曹雪芹')
book2.describe()
```

输出结果：

```python
name:红楼梦,price:45.5,publish_time:2018,author:曹雪芹
```

可以看到，调用describe()后，确实将父类Book中没有的author属性也打印出来了。

### 导入类

为了使程序尽可能整洁，我们可以将类存储在模块中，然后在需要使用的程序中导入该模块。这部分的内容与前面将的从模块中导入函数基本一致。

#### 导入单（多）个类

语法：

```python
from 模块名 import 类名,类名,...
```

将Book类存储在一个名为book.py的模块中

book.py

```python
class Book():
    """书籍"""
    def __init__(self,name,price):
        """"初始化书名和价格"""
        self.name = name
        self.price = price
        self.publish_time = 2018
    
    def describe(self):
        """打印书的所有描述信息"""
        print("name:"+self.name+
              ",price:"+str(self.price)+
              ",publish_time:"+str(self.publish_time))
    
    def update_price(self,price):
        """更改书的价格"""
        self.price = price

class CultureBook(Book):
    """文学书"""
    def __init__(self,name,price,author):
        self.author = author
        super().__init__(name,price)
    
    def get_book_info(self):
        """描述文学书的相关信息"""
        print("{'name':'" + self.name + 
              "','price':" + str(self.price) +
              ",'author':'"+self.author+"'}")
    
    def describe(self):
        print("name:"+self.name+
              ",price:"+str(self.price)+
              ",publish_time:"+str(self.publish_time)+
              ",author:"+self.author)
```

创建一个新的文件my_book.py，在其中导入Book类并创建实例

```python
from book import Book,CultureBook

book = Book('Java8 in action',59.8)
book.update_price(66.6)
book.describe()
print(book.name)

book2 = CultureBook('红楼梦',45.5,'曹雪芹')
book2.describe()
```

输出结果：

```python
name:Java8 in action,price:66.6,publish_time:2018
Java8 in action
name:红楼梦,price:45.5,publish_time:2018,author:曹雪芹
```

#### 导入整个模块

示例：

my_books.py

```python
import book

book = book.Book('Java8 in action',59.8)
book.update_price(66.6)
book.describe()
print(book.name)

book2 = book.CultureBook('红楼梦',45.5,'曹雪芹')
book2.describe()
```

输出与之前一般无二。

#### 导入模块中的所有类

语法：

```python
from 模块名 import *
```

像之前讲的从模块中导入函数一样，不推荐使用该方式，理由类似。

