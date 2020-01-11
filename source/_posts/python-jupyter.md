---
title: Jupyter入门
date: 2019-10-01 17:36:16
tags: python
categories: python
---

Jupyter Notebook（此前被称为 IPython notebook）是一个交互式笔记本。

Jupyter这个词是由`Ju`lia、`Py`thon和`R`中的字母组成。

<!--more-->

### 安装Jupyter

```python
pip3 install jupyter
```

### 启动Jupyter Notebook

在命令行中输入如下命令：

```python
jupyter notebook
```

Jupyter Notebook启动后，在浏览器中访问如下链接：

```python
http://localhost:8888/tree
```

### Jupyter Notebook常用快捷键

`shift`+`enter`：运行代码块, 选择下面的代码块

`control`+`enter`：运行选中的代码块

Windows `alt`+`enter` 、 Mac `option`+`enter` ：运行代码块并且插入下面

* 命令行模式(按 Esc 生效)

双击D键：删除选中单元格

H键：显示快捷键

* 编辑模式(按 Enter 生效)

Windows `control`+`/` 、Mac `command`+`/`：注释整行/撤销注释

### 插入LaTex

在Jupyter Notebook中插入LaTex，

```python
from IPython.display import Latex
Latex('$a^2 + b^2 = c^2$')
```

### 魔法函数

在ipynb文件中输入`%lsmagic`，查看当前可以使用的魔法函数

```python
%lsmagic
```

输出：

```python
Available line magics:
%alias  %alias_magic  %autoawait  %autocall  %automagic  %autosave  %bookmark  %cat  %cd  %clear  %colors  %conda  %config  %connect_info  %cp  %debug  %dhist  %dirs  %doctest_mode  %ed  %edit  %env  %gui  %hist  %history  %killbgscripts  %ldir  %less  %lf  %lk  %ll  %load  %load_ext  %loadpy  %logoff  %logon  %logstart  %logstate  %logstop  %ls  %lsmagic  %lx  %macro  %magic  %man  %matplotlib  %mkdir  %more  %mv  %notebook  %page  %pastebin  %pdb  %pdef  %pdoc  %pfile  %pinfo  %pinfo2  %pip  %popd  %pprint  %precision  %prun  %psearch  %psource  %pushd  %pwd  %pycat  %pylab  %qtconsole  %quickref  %recall  %rehashx  %reload_ext  %rep  %rerun  %reset  %reset_selective  %rm  %rmdir  %run  %save  %sc  %set_env  %store  %sx  %system  %tb  %time  %timeit  %unalias  %unload_ext  %who  %who_ls  %whos  %xdel  %xmode

Available cell magics:
%%!  %%HTML  %%SVG  %%bash  %%capture  %%debug  %%file  %%html  %%javascript  %%js  %%latex  %%markdown  %%perl  %%prun  %%pypy  %%python  %%python2  %%python3  %%ruby  %%script  %%sh  %%svg  %%sx  %%system  %%time  %%timeit  %%writefile

Automagic is ON, % prefix IS NOT needed for line magics.
```

