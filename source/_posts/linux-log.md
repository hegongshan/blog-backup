---
title: 在Linux中存活下来之常见日志及日志工具
date: 2021-11-12 22:33:24
tags: operation
categories: linux
---

Linux中的日志文件一般存放在`/var/log`目录中。

<!--more-->

### dmesg

全称为**d**isplay **mes**sa**g**e，用于显示内核缓冲区信息。

### last

反向搜索文件`var/log/wtmp`，显示所有用户的登录时间和终端。

### lastb

反向搜索文件`/var/log/btmp`，显示失败的登录尝试。

### lastlog

用于显示系统中所有用户最近一次登录信息，这些信息存储在`/var/log/lastlog`文件中。

`**Never logged in**`。

### journalctl

用于显示systemd日志。

### 对比

|     日志文件      |                描述                | 查看命令 |
| :---------------: | :--------------------------------: | :------: |
| /var/log/boot.log |              开机日志              |    --    |
|   /var/log/wtmp   |             二进制文件             |   last   |
|   /var/log/btmp   | 二进制文件，记录所有失败的登录尝试 |  lastb   |
| /var/log/lastlog  |             二进制文件             | lastlog  |

1.tmp：**t**e**mp**orary

2.btmp：bad tmp

3.wtmp：who tmp

