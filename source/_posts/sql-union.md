---
title: SQL中的并运算(union)
date: 2018-09-12 21:59:02
tags: sql
categories: sql
---
union用于合并两个或多个select语句的结果集。

需要注意的是，union合并的两个或多个表必须有相同的列数，且相应的列必须取自同一个域（即数据类型相似，如都是数值型），此外，每条select语句中列的顺序必须相同。

<!--more-->

语法
```sql
select 列名 from table1
union 
select 列名 from table2
```
**注意：**union会去除重复行，如果需要保留重复的行，可使用union all。

示例
假设有以下两张雇员表

```sql
create table employee_cn(
	eno int,
    name varchar(32),
    primary key(eno)
);
insert into employee_cn values(1,'San Zhang');
insert into employee_cn values(2,'Xindong Wu');
insert into employee_cn values(3,'Gongshan he');
insert into employee_cn values(4,'Jiawei Han');
create table employee_us(
	eno int,
    name varchar(32),
    primary key(eno)
);
insert into employee_us values(1,'Jiawei Han');
insert into employee_us values(2,'Xindong Wu');
insert into employee_us values(3,'Bill Gates');
insert into employee_us values(4,'Steve Jobs');
```

查询中国和美国的所有雇员的姓名

```sql
select name from employee_cn
union
select name from employee_us;
```

结果：

```sql
+-------------+
| name        |
+-------------+
| San Zhang   |
| Xindong Wu  |
| Gongshan he |
| Jiawei Han  |
| Bill Gates  |
| Steve Jobs  |
+-------------+
```

可以看到，union无法查询出所有的中国和美国雇员，一旦出现同名的雇员，则只有一个被列出。

下面使用union all。

```sql
select name from employee_cn
union all
select name from employee_us;
```

结果:

```sql
+-------------+
| name        |
+-------------+
| San Zhang   |
| Xindong Wu  |
| Gongshan he |
| Jiawei Han  |
| Jiawei Han  |
| Xindong Wu  |
| Bill Gates  |
| Steve Jobs  |
+-------------+
```

