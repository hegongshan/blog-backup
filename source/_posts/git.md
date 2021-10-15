---
title: Git常用命令总结
date: 2019-11-25 19:51:43
tags: git
categories: git
---

现代软件开发离不开团队协作，常用的Git命令必须熟练使用。

<!--more-->

### clone

将远程仓库克隆到本地。

1.克隆master

```shell
git clone https://github.com/hegongshan/deep_matrix_factorization.git
```

2.克隆指定分支

```shell
git clone -b feature-test https://github.com/hegongshan/deep_matrix_factorization.git
```

### config

* `--global`：设置全局变量

示例1：设置全局用户名和邮箱

```shell
git config --global user.name "xxx"
git config --global user.email "xxx"
```

示例2：设置提交编辑器

```shell
git config --global core.editor "notepad"
```

* `--list`：列出所有的配置项

```shell
git config --list
git config --global --list
```

### init

创建一个空的Git仓库，或者初始化一个已经存在的仓库。

```shell
git init
```

### 当前改变

1. add：将文件添加到索引中。

```git
git add 
```

2. mv：等同于Linux中的mv命令，用于文件重命名或者移动文件。
3. reset：版本回退。
4. rm：等同于Linux中的rm命令，用于删除文件。

### log

 查看提交日志。

```shell
git log
```

### show

### status

查看工作目录的当前状态

### branch

1.查看仓库的分支。示例：`git branch`

* -D：强制删除分支。示例，删除本地的test分支

```shell
git branch -D test
```

* -m：重命名分支。示例，将本地的test分支重命名为feature分支

```shell
git branch -m test feature
```

* `--list`：列出所有的分支

### checkout

切换分支。

checkout -b：创建一个新分支，并切换到该分支

### commit

* -m，--message

git diff

git merge

git tag

* -d，--delete：删除标签
* -l，--list：列出所有的标签

### stash

临时保存。

### fetch & pull

git fetch

git pull 等价于先执行 git fetch，再将远程仓库与当前分支合并

```shell
git pull origin feature/1234
```

等价于

```shell
git fetch origin feature/1234
git merge feature/1234
```

### push

push：推送到远程仓库的指定版本

* -v
* -f

### remote 

列出所有远程分支

```shell
git remote
```

* add：添加一个远程仓库

```shell
git remote add <name> <url>
```

例如：

```shell
git remote add origin https://github.com/hegongshan/deep_matrix_factorization.git
```

其中，origin是远程仓库的默认命名。

* set-url：修改远程仓库的URL

```shell
git remote set-url origin git@github.com:hegongshan/deep_matrix_factorization.git
```

* -v：列出详细信息

```shell
git remote -v
```

### help

查看命令的帮助信息。

### revert

* -m

### cherry-pick

### 参考资料

1. 官网文档，https://git-scm.com/docs

2. 精通Git（Pro Git），https://git-scm.com/book/zh/