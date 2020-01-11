---
title: Python包管理器——pip
date: 2019-07-26 17:14:07
tags: python
categories: python
---

pip，全称package installer for Python，是python的包管理工具。这里总结下pip中常用的一些命令。

<!--more-->

### 查看版本信息

```python
# 注意在-V中，V是大写字母
pip --version 或者 pip -V 
```

### 安装包

* 安装最新版本

```python
pip install 包名
```

* 指定某个版本

```python
# 必须写两个等号，且等号左右不能有空格
pip install 包名==版本号
```

* 指定版本的范围

```python
pip install 包名>=版本号
pip install 包名<=版本号
pip install 包名>版本号
pip install 包名<版本号
```

* 安装依赖文件中列出的所有包

```python
pip install -r <requirements file>
```

### 更改源

#### 临时使用

在安装包时，可以使用`-i <url>`或者`--index-url <url>`指定临时的Python Package Index（PyPI）源地址（默认为https://pypi.org/simple）。

```python
pip install some-package -i 源
```

> PyPI 国内源
>
> 清华大学 https://pypi.tuna.tsinghua.edu.cn/simple
>
> 阿里云 http://mirrors.aliyun.com/pypi/simple

例如，使用清华大学的PyPI镜像来安装NumPy

```python
pip install numpy -i https://pypi.tuna.tsinghua.edu.cn/simple
```

#### 设为默认

还是以清华大学的PyPI镜像为例：

```python
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

上述操作将在当前用户的主目录下，生成.config/pip/pip.conf，文件内容如下：

```python
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```

如果想要恢复默认的PyPI源，可以使用如下的命令：

```python
pip config unset global.index-url
```

### 升级包

```python
pip install --upgrade 包名
pip install -U 包名
```

### 查看已安装的包

```
pip list
```

### 搜索包

使用search命令可以从PyPI中搜索需要的包。

```python
pip search 包名
```

### 卸载包

* 卸载某个包

```python
pip uninstall 包名
```

* 卸载依赖文件中列出的所有包

```python
pip uninstall -r <requirements file>
```

### 帮助信息

* 如果记不住这些命令，没有关系，使用`--help`或者`-h`参数，可以打印帮助信息。

```python
pip --help 或者 pip -h
```

* 使用help查看命令详情。

```python
pip help 命令
```