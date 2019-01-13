---
title: SQL中删除表中数据的几种方法
date: 2018-09-19 22:00:09
tags: sql
categories: sql
---

SQL中删除表数据有以下三种方法：

1.使用drop table语句；2. 使用delete语句；3. 使用truncate table语句。

<!--more-->

#### drop table

```sql
drop table 表名;
```

功能：删除表，表的结构、表中的数据以及索引等全部被删除。

#### delete

```sql
delete from 表名 [where 条件];
```

功能：根据条件删除表中的数据，但不删除表的定义。

#### truncate table

```sql
truncate table 表名;
```

功能：清空表中的全部数据，但不删除表的定义。

truncate table 与delete语句不同的地方在于，

1.truncate table语句没有where条件。

2.truncate table语句会使表回到刚创建的初始状态，如重置表中的自增值等，而delete 语句不会。

3.truncate table语句不会触发触发器，而delete语句会触发触发器。

**若要清空表中的数据，但不删除表，推荐使用 truncate table语句。**