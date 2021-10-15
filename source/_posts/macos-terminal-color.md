---
title: 修改macOS的终端颜色
date: 2021-08-14 23:20:23
tags: macos
categories: macos
---

在Linux终端中，不同的文件类型有不同的颜色，比如目录为蓝色，可执行文件为绿色等。

那么，如何将macOS的终端颜色设置为成和Linux相同呢？

<!--more-->

### LSCOLORS

LSCOLORS用于指定不同文件类型在终端中的颜色显示。

每种文件类型的颜色使用两个字符表示`fb`，其中，f表示前景色，即文字的颜色；b表示背景色。

使用ANSI color，颜色信息如下所示：

| 小写字母 | 描述                                                     | 大写字母 | 描述                                                         |
| :------: | -------------------------------------------------------- | :------: | ------------------------------------------------------------ |
|    a     | <font style="color:black">黑色（black）</font>           |    A     | <font style="color:black;font-weight:bold;">黑色粗体（bold black）</font> |
|    b     | <font style="color:red">红色（red）</font>               |    B     | <font style="color:red;font-weight:bold;">红色粗体（bold red）</font> |
|    c     | <font style="color:green">绿色（green）</font>           |    C     | <font style="color:green;font-weight:bold;">绿色粗体（bold green）</font> |
|    d     | <font style="color:brown">棕色（brown）</font>           |    D     | <font style="color:brown;font-weight:bold;">棕色粗体（bold brown）</font> |
|    e     | <strong style="color:blue">蓝色（blue）</strong>         |    E     | <font style="color:blue;font-weight:bold;">蓝色粗体（bold blue）</font> |
|    f     | <strong style="color:magenta">洋红色（magenta）</strong> |    F     | <font style="color:magenta;font-weight:bold;">洋红色粗体（bold magenta）</font> |
|    g     | <strong style="color:cyan">蓝绿色/青色（cyan）</strong>  |    G     | <font style="color:cyan;font-weight:bold;">蓝绿色粗体（bold cyan）</font> |
|    h     | <strong style="light grey">浅灰色（light grey）</strong> |    H     | <font style="color:light grey;font-weight:bold;">浅灰色粗体（bold light grey）</font> |
|    x     | 系统默认颜色                                             |    -     | -                                                            |

共有11种文件类型。因此，LSCOLORS是一个长度为22的字符串，默认值为`exfxcxdxbxegedabagacad`。

| 编号 | 文件类型                                      | 前景色 | 背景色 |
| :--: | :-------------------------------------------- | :----: | :----: |
|  1   | 目录（Directory）                             |   e    |   x    |
|  2   | 符号链接（Symbolic Link）                     |   f    |   x    |
|  3   | Socket                                        |   c    |   x    |
|  4   | 管道（Pipe）                                  |   d    |   x    |
|  5   | 可执行文件（Executable）                      |   b    |   x    |
|  6   | Block special                                 |   e    |   g    |
|  7   | Character special                             |   e    |   d    |
|  8   | Setuid Executable                             |   a    |   b    |
|  9   | Setgid Executable                             |   a    |   g    |
|  10  | Directory writable to others, with sticky bit |   a    |   c    |
|  11  | Directory writable to others, no sticky bit   |   a    |   d    |

### CLICOLOR

在`~/.bash_profile`文件中，将LSCOLORS的值设置为：

```shell
# 设置ls高亮
export LSCOLORS=ExGxFxdaCxDaDahbadeche
```

使用source命令使配置生效：

```shell
hgs:~ hegongshan$ vim ~/.bash_profile 
hgs:~ hegongshan$ source ~/.bash_profile
```

此时，如果使用ls命令，仍然会是黑白，必须加上`-G`选项（在Linux中，则使用`--color`选项）：

```shell
# -G表示使用彩色输出
ls -G
```

然而，每次使用`ls`命令都需要加上`-G`选项，并不方便。

这时候，只需要在`~/.bash_profile`文件中，将`CLICOLOR`的值设置为`yes`即可：

```shell
export CLICOLOR=yes
```

