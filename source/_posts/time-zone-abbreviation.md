---
title: 常见时区缩写
date: 2020-12-07 17:51:55
tags: time
categories: time
---

AOE（会议投稿一般采用该时间）、CST、GMT以及UTC，这些常见的时区缩写，你都清楚了吗？

<!--more-->

### AOE

AOE，全称Anywhere on Earth（西十二区）。

> Anywhere on Earth (AoE) is a calendar designation which indicates that a period expires when the date passes everywhere on Earth.

### CST

CST这个缩写，有以下三种情况：

1.Central Standard Time（USA），即美国中部时间（西六区）。

2.China Standard Time，即北京时间（东八区）。

3.Cuba Standard Time，古巴标准时间（西五区）。

### GMT

GMT，全称Greenwich Mean Time ，格林尼治标准时间。

### UTC

UTC，全称Coordinated Universal Time，世界协调时间。

### Unix时间戳

Unix时间戳（Unix Timestamp）是指从1970年1月1日 00:00:00（UTC/GMT的午夜）开始所经过的秒数。

下面以Java和Python这两门炙手可热的编程语言为例，说明该如何获取Unix时间戳。

* Java

```java
jshell> System.currentTimeMillis() / 1000
$1 ==> 1607336715
```

* Python

```python
>>> import time
>>> int(time.time())
1607336815
```

### 转换规则

1.UTC时间 = GMT时间

2.北京时间 = UTC/GMT + 8小时

3.CST（USA）= UTC/GMT - 6小时 = 北京时间 - 14小时

3.AOE时间 = UTC/GMT - 12小时 = 北京时间 - 20小时

### 参考资料

* Time Zone Abbreviations – Worldwide List https://www.timeanddate.com/time/zones/

