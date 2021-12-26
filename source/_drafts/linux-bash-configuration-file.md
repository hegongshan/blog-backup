---
title: Bash配置文件
date: 2021-12-08 14:36:23
tags:
---



### ~/.bashrc

设置别名

```shell
$ cat ~/.bashrc
# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

LANG=zh_CN.UTF-8
```

### ~/.bash_profile

导入~/.bashrc，并设置环境变量。

```shell
$ cat ~/.bash_profile
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/include
export C_INCLUDE_PATH
```

### /etc/profile

### /etc/bashrc
