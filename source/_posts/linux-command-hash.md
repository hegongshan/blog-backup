---
title: 在Linux中存活下来之hash命令
date: 2021-12-14 01:43:56
tags:
---

hash是一个Shell内置命令。

```shell
$ help hash
hash [-lr] [-p pathname] [-dt] [name ...]
```

> If no arguments are given, information about remembered commands is displayed.

-l list

> The -l option  causes output to be displayed in a format that may be reused as input.

-p put

> If the -p option is supplied, PATHNAME is used as the full pathname of NAME, and no path search is performed.

-t get

> If the -t option is supplied the full pathname to which each NAME corresponds is printed.



> If multiple NAME arguments are supplied with -t, the NAME is printed before the hashed full pathname.

-d delete

> The -d option causes the shell to forget the remembered location of each NAME.

-r clear

> The -r option causes the shell to forget all remembered locations.
