---
title: Python日志模块logging
tags: python
categories: python
---

logging是Python的一个标准库，用于日志信息处理。

<!--more-->

### 日志级别

| 级别       | 数值 |
| ---------- | ---- |
| `CRITICAL` | 50   |
| `ERROR`    | 40   |
| `WARNING`  | 30   |
| `INFO`     | 20   |
| `DEBUG`    | 10   |
| `NOTSET`   | 0    |

### basicConfig

函数原型：

```python
basicConfig(**kwargs)
```

方法描述：进行日志系统的基础配置

常用参数如下：

* filename: 日志文件名
* format: 使用指定的字符串格式

常见的日志记录属性

| 属性名称  |      格式       |                             描述                             |
| :-------: | :-------------: | :----------------------------------------------------------: |
|  asctime  |  `%(asctime)s`  | 日志记录创建时，人类可读的时间（默认的形式为'2003-07-08 16:49:45,896'） |
| levelname | `%(levelname)s` |                           日志级别                           |
|  message  |  `%(message)s`  |                           日志消息                           |

* level: 设置根日志的级别

创建日志消息的方法

```python
logging.debug(msg, *args, **kwargs)
logging.info(msg, *args, **kwargs)
logging.warning(msg, *args, **kwargs)
logging.error(msg, *args, **kwargs)
logging.critical(msg, *args, **kwargs)
logging.exception(msg, *args, **kwargs)
logging.log(level, msg, *args, **kwargs)
```

