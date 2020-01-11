---
title: 在Linux中存活下来之head和tail
date: 2019-12-01 15:40:04
tags: linux
categories: linux
---

head和tail是Linux中经常使用的查看文件内容的命令。

<!--more-->

### head

head -- display first lines of a file

```sh
head [-n count | -c bytes] [file ...]
```

* n：显示文件的前n行。n默认为10。
* c：显示文件的前c个字节。n默认为为10。

不带参数的head等价于`head -n 10`。

如果指定了多个文件，则每个文件前面都有一个由字符串“ ==> XXX <== ”组成的标头，其中XXX是文件名称。

### tail

tail -- display the last part of a file

```sh
tail [-F | -f | -r] [-q] [-b number | -c number | -n number] [file ...]
```

* b：显示文件的后number个512字节块。
* c：显示文件的后number个字节。
* n：显示文件的后number行
* q：不显示文件名称。
* r：按照从后往前的顺序输出。

如果指定了多个文件，则每个文件前面都有一个由字符串“ ==> XXX <== ”组成的标头，其中XXX是文件名称。

如果指定了-q参数，则不会输出由字符串“ ==> XXX <== ”组成的标头。



Numbers having a leading plus (`+') sign are relative to the
     beginning of the input, for example, ``-c +2'' starts the display at the
     second byte of the input.  Numbers having a leading minus (`-') sign or
     no explicit sign are relative to the end of the input, for example, ``-n
     2'' displays the last two lines of the input.  The default starting loca-
     tion is ``-n 10'', or the last 10 lines of the input.