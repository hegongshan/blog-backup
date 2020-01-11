---
title: LaTex总结
date: 2019-07-25 19:57:26
tags: latex
categories: latex
---

LaTex文档的基本格式:

```tex
\documentclass[option]{article}
\begin{document}
	% 所有的其他内容均放在这里
	content...
\end{document}
```

<!--more-->

### 注释

* 单行注释使用`%`，例如

```tex
% 单行注释
```

* 多行注释使用`\iffalse...\fi`，例如

```tex
\iffalse
Hello \LaTex
Why I like it.
\fi
```

### 使用中文

LaTex默认不支持中文，如果要在文档中显示中文，需要引入`ctex`包

```tex
\usepackage{ctex}
```

### 文章标题

在导言区使用`\title`命令，指定文章的标题。

示例：

```tex
\title{your title}
...
\begin{document}
	...
    % 必须加\maketitle，否则，不能显示标题
    \maketitle 
	content...
\end{document}

```

### 作者

```tex
\author{author name}
% 比如\author{Gongshan He}

\begin{document}
	content...
\end{document}
```

### 摘要

```tex
\begin{abstract}
	content...
\end{abstract}
```

### 目录

在文档合适的地方，加入如下命令即可。

```tex
\tableofcontents
```

### 分页

```tex
\clearpage
```

### 插入图片

```tex
...
% 引入包
\usepackage{graphicx}
....
\begin{document}
	....
	\begin{figure}
		\includegraphics{图片地址}
		\caption{图片标题}
	\end{figure}
	....
\end{document}
```

### 插入表格

```tex
\begin{table}
    \begin{tabular}{|ccc|}
        \hline
        直角a & 直角b & 直角c \\
        \hline
        3 & 4 & 5 \\
        5 & 12 & 13 \\
        \hline
    \end{tabular}
\end{table}
```

tabular中有一个参数，里面声明了表格中列的模式。|ccc|表示表格有三列，都是居中对齐，在第一列前面和第三列后面各有一条垂直的表格线。类似的还有l（左对齐）和r（右对齐）。

行与行之间用命令`\\`隔开，每行内部的表项则用符号&隔开。表格中的横线用\hline产生。

### 分栏

* 在\documentclass中指定分栏模式

```tex
\documentclass[twocolumn]{article}
```

* 在正文中使用命令切换。\\twocolumn进入双栏模式，\onecolumn进入单栏模式，两个命令都会先使用\clearpage换页，并不产生一页之内单双栏混合的效果。

### 参考文献

可以使用BIBTEX处理参考文献。

将所有可能会引用的文献放到以.bib结尾的文本文件中。

使用`\bibliographystyle`设定参考文献的格式，这通常在导言区完成。

使用`\bibliography`打印出参考文献列表。

例如，当前目录下有一个名为reference.bib的文献数据库，内容如下：

```tex
@inproceedings{He:2017:NCF:3038912.3052569,
 author = {He, Xiangnan and Liao, Lizi and Zhang, Hanwang and Nie, Liqiang and Hu, Xia and Chua, Tat-Seng},
 title = {Neural Collaborative Filtering},
 booktitle = {Proceedings of the 26th International Conference on World Wide Web},
 series = {WWW '17},
 year = {2017},
 isbn = {978-1-4503-4913-0},
 location = {Perth, Australia},
 pages = {173--182},
 numpages = {10},
 url = {https://doi.org/10.1145/3038912.3052569},
 doi = {10.1145/3038912.3052569},
 acmid = {3052569},
 publisher = {International World Wide Web Conferences Steering Committee},
 address = {Republic and Canton of Geneva, Switzerland},
 keywords = {collaborative filtering, deep learning, implicit feedback, matrix factorization, neural networks},
} 
```

指定数据库文件时，不带bib后缀。可以同时从多个文献数据库中提取文献，文件名用逗号分隔开即可。

```tex
\begin{document}

...
% 从文献数据库reference.bib中获取文献信息，打印参考文献列表
\bibliography{reference}
\end{document}
```

在正文中，使用`\cite`命令引用需要的文献，`\cite`命令引用的位置会出现文献的编号，同时将提示LATEX列出所引用的文献

```tex
\begin{document}
...
ncf\cite{He:2017:NCF:3038912.3052569}
% 从文献数据库reference.bib中获取文献信息，打印参考文献列表
\bibliography{reference}
\end{document}
```

### 数学公式

参看[MathJax语法](/2018/07/16/mathjax-tutorial/)

