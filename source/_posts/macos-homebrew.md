---
title: Homebrew——MacOS中的包管理器
date: 2019-10-06 17:24:33
tags: macos
categories: macos
---

与Ubuntu和CentOS等Linux发行版相比，macOS没有预装wget和tree等命令。

如果需要安装这些缺失的软件包，可以使用[Homebrew](https://brew.sh)包管理器。

<!--more-->

### 什么是Homebrew

Homebrew是macOS中的第三方包管理器，可以方便地安装那些macOS中没有包含的UNIX工具，比如wget、tree等。

### 安装Homebrew

安装Homebrew前，请确保已安装Xcode命令行工具。如果没有安装，在终端中输入如下命令：

```shell
xcode-select --install
```

然后，开始安装Homebrew，在终端中输入如下命令：

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### 安装软件包

```shell
brew install 包名
```

### 卸载软件包

```shell
brew uninstall 包名
```

### 升级软件包

```shell
brew upgrade [包名...]
```

若没有指定软件包，则对所有的软件包进行升级。

### 查看已安装的软件包

```shell
brew list
```

### 更新Homebrew

```shell
# 更新所有的软件包和Homebrew
brew update
```

### 搜索软件包

```shell
brew search 软件包
```

### 查看软件信息

```shell
brew info 软件包
```

### 显示帮助信息

```shell
brew help [command]
```

若没有指定命令名，则显示Homebrew的帮助信息；否则，显示该命令的帮助信息。

### 卸载Homebrew

在终端中输入如下命令即可：

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

关于Homebrew的更多信息，请参看[这里](https://docs.brew.sh)。