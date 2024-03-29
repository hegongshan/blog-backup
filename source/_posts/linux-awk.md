---
title: AWK编程语言
date: 2021-12-23 00:13:54
tags: 
---

awk是一种强大的文本处理语言，其名字取自三个创始人Alfred **A**ho，Peter **W**einberger和 Brian **K**ernighan的姓氏首字母。

<!--more-->

```bash
awk [ -F fs ] [ -v var=value ] [ 'prog' | -f progfile ] [ file ...  ]
```

* -F、--field-separator：指定行中的分隔符，`fs`是一个正则表达式

例如，按照逗号进行分隔：

```bash
awk -F "," '{ print $0 }'
awk -F "[,=|]" '{ print $0 }'
```

prog的格式为：

```shell
pattern {action}
```

在AWK中，有两个特殊的`pattern`——`BEGIN`和`END`：

```shell
BEGIN {} {} END {}
```

例如，对于`/etc/passwd`，按照冒号进行分隔，只输出root的信息：

```shell
hgs:~ hegongshan$ awk -F: '$1 == "root" { print $0 }' /etc/passwd 
root:*:0:0:System Administrator:/var/root:/bin/sh
hgs:~ hegongshan$ awk -F: '{ if ($1 == "root")  print $0 }' /etc/passwd 
root:*:0:0:System Administrator:/var/root:/bin/sh
```

### 综合应用

来看下[LeetCode 194.转置文件](https://leetcode-cn.com/problems/transpose-file/):

方法一：取巧——字符串拼接

```bash
awk '{
    for (i = 1; i <= NF; i++) {
        if (NR == 1) {
            res[i-1] = $i;
        } else {
            res[i-1] = res[i-1] " " $i
        }
    }
}
END {
    for (i = 0; i < NF; i++) {
        print res[i]
    } 
}' file.txt
```

方法二：二维数组转置

```bash
awk '{
    for (i = 1; i <= NF; i++) {
        if (NR == 1) {
            res[i-1,0] = $i;
        } else {
            res[i-1,NR-1] = $i
        }
    }
}
END {
    for (i = 0; i < NF; i++) {
        for (j = 0; j < NR; j++) {
            if (j == 0) {
                printf "%s", res[i,j]
            } else {
                printf " %s", res[i,j]
            }
        }
        printf "\n"
    }
}' file.txt
```

### 参考资料

1.The AWK Programming Language

中文翻译：AWK程序设计语言，https://github.com/wuzhouhui/awk

