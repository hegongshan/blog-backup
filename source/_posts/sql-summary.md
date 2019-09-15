---
title: SQL简单总结
date: 2018-09-08 19:27:36
tags: sql
categories: sql
---

结构化查询语言（structured query language, 简称SQL）分为四类：

数据定义语句（Data Definition Language，简称DDL）、数据查询语句（Data Query Language，简称DQL）、数据更新语句（Data Manipulation Language，简称DML）以及数据控制语句。

<!--more-->

### DDL

* 表的创建

```sql
create table 表名 (
	列名 数据类型 列级完整性约束,
	...[,表级完整性约束]
);
```



* 表的删除

```sql
drop table 表名 [cascade | restrict];
```



* 表的扩充和修改

1.增加新列

```sql
alter table 表名 add (列名 数据类型,...);
```

2.删除已存在的某个列

```sql
alter table 表名 drop 列名 [cascade | restrict];
```

3.修改原有列的类型

```sql
alter table 表名 modify 列名 数据类型;
```



### DQL

```sql
select [all | distinct]
from 表名或视图名[,表名或视图名...]
[where 条件表达式]
[group by 列名1 [having 条件表达式]]
[order by 列名2 [asc | desc]];
```

### DML

* 插入数据

1.插入一条数据

```sql
insert into 表名 [(列名,列名,...)] values(常量1[,常量2,...]);
```

2.插入子查询结果

```sql
insert into 表名 [(列名,列名,...)] 查询语句;
```

* 修改数据

```sql
update 表名 
set 列名 = 表达式[,列名 = 表达式,...]
[where 条件];
```

* 删除数据

```sql
delete from 表名 [where 条件];
```

