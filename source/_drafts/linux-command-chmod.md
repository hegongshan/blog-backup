---
title: linux-command-chmod
date: 2020-05-22 21:30:00
tags:
---

chmod

全称change mode

常用选项：

-x：可执行

```
mode         ::= clause [, clause ...]
clause       ::= [who ...] [action ...] action
action       ::= op [perm ...]
who          ::= a | u | g | o
op           ::= + | - | =
perm         ::= r | s | t | w | x | X | u | g | o
```

