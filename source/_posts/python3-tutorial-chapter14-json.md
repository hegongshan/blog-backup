---
title: python3教程-第14章 json
date: 2018-06-20 20:31:33
updated: 2018-06-27 14:35:23
tags: python
categories: python
---

使用json函数，需要导入json库：import json

<!--more-->

### 保存数据

函数json.dump()可以将数据保存到json文件中，它接受两个实参：要存储的数据以及可用于存储数据的文件对象．

json_dump.py

```python
import json

settings = {'username':'hegongshan','password':'2018!'}
filename = "settings.json"
with open(filename,'w') as file:
    json.dump(settings,file)
```

执行该文件后，目录下多了一个settings.json，内容如下：

```python
{"username": "hegongshan", "password": "2018!"}
```

### 读取数据

使用函数json.load()可以将json文件中的内容读取到内存中，它接受一个实参：一个文件对象．

json_load.py

```python
import json

filename = 'settings.json'
with open(filename) as file:
    settings = json.load(file)
print(settings)
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/19/20180619213231.png)

