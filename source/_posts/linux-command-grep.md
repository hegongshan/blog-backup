---
title: 在Linux中存活下来之文本搜索grep
date: 2019-12-08 19:31:29
tags: linux
categories: linux
---

grep（Globally search a Regular Expression and Print）

<!--more-->

选项

* -E：支持正则表达式

* -i：忽略大小写

* -n：输出对应的行号

* -r：对子目录进行递归搜索

* -v：打印不匹配的行

示例：

* 如果文件test.log有100w行，查找含有“error”的行并显示对应的行号。（2020年4月8日，腾讯一面）

```shell
grep -n "error" test.log
```