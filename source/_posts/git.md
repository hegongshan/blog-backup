---
title: Git常用命令总结
date: 2019-11-25 19:51:43
tags: git
categories: git
---

作为当前最优秀的版本控制系统（version control system），Git需要熟练掌握。

<!--more-->

clone：从远程克隆仓库到本地

git init：初始化

### 当前改变

1. add：将文件添加到索引中。

```git
git add 
```

2. mv：等同于Linux中的mv命令，用于文件重命名或者移动文件。
3. reset：版本回退。
4. rm：等同于Linux中的rm命令，用于删除文件。



 log：查看日志信息

show

status：查看工作目录的当前状态





branch：查看仓库的分支

删除分支：

```git
git branch -d
```

branch -m



checkout：切换分支

checkout -b：创建一个新分支，并切换到该分支



git commit

* -m，--message

git diff

git merge

git tag

* -d，--delete：删除标签

* -l，--list：列出所有的标签



git fetch

git pull



push：推送到远程仓库的指定版本



git remote 

help：查看命令的帮助信息



