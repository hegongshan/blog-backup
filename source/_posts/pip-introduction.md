---
title: pip常用命令总结
date: 2019-07-26 17:14:07
tags: python
categories: python
---

pip，全称package installer for Python，是python的包管理工具。这里总结下pip中常用的一些命令。

<!--more-->

### 查看pip版本

```python
# 注意在-V中，V是大写字母
pip --version 或者 pip -V 
```

### 安装包

* 安装最新版本

```python
pip install 包名
```

* 安装指定版本

```python
# 必须写两个等号
pip install 包名==版本号
```

### 升级包

```python
pip install --upgrade 包名
```

### 查看已安装的包

```
pip list
```

### 卸载包

```python
pip uninstall 包名
```

### 帮助信息

如果记不住这些命令，没有关系，使用`--help`或者`-h`参数，可以打印帮助信息。

```python
pip --help 或者 pip -h
```

