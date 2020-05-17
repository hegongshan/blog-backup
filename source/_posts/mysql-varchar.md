---
title: 关于MySQL中varchar超过限制长度的问题
date: 2020-04-22 18:00:01
tags: mysql
categories: mysql
---

下午面快手的时候，小姐姐问我：如果列的类型为varchar(10)，当插入的字符串长度超过10的时候，将会发生什么？这个问题之前完全没了解过，一时语塞，只能回答说：“应该会发生溢出吧”。

<!--more-->

为了解答这个问题，我在网上查了很久，发现网上基本都说字符串会被自动截断，并报出一个warning。

例如，name的类型为varchar(2)，插入'123'，截断以后，实际插入数据库中的数据为'12'。

但是，我在本机上测试时（MySQL 8.0.16），却报了如下错误：

```sql
ERROR 1406 (22001): Data too long for column 'name' at row 1
```

这是怎么回事呢？后来，我发现，这两种情况是由于SQL模式不同造成的。

### SQL模式

在MySQL中，有如下三种最重要的SQL模式（官网称之为`The Most Important SQL Modes`）

* ANSI

> This mode changes syntax and behavior to conform more closely to standard SQL.

宽松模式。

* STRICT_TRANS_TABLES

> If a value could not be inserted as given into a transactional table, abort the statement. For a nontransactional table, abort the statement if the value occurs in a single-row statement or the first row of a multiple-row statement.

严格模式。

* TRADITIONAL

> A simple description of this mode is “give an error instead of a warning” when inserting an incorrect value into a column.

严格模式。值得一提的是，TRADITIONAL是一个组合模式，它包含了STRICT_TRANS_TABLES。

查看MySQL（8.0.16）的默认模式为：

```sql
mysql> select @@sql_mode;
+-----------------------------------------------------------------------------------------------------------------------+
| @@sql_mode                                                                                                            |
+-----------------------------------------------------------------------------------------------------------------------+
| ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION |
+-----------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

### 实例

```sql
drop table if exists `test`;
create table `test` (
    id int not null auto_increment,
    name varchar(2) not null,
    primary key(id)
);
```

1.首先，将SQL模式设置为ANSI；

```sql
mysql> set @@sql_mode = 'ansi';
Query OK, 0 rows affected (0.00 sec)
```

然后，尝试插入一条长度为3的字符串'123'。虽然插入操作执行成功，但是提示了一个警告。

```sql
mysql> insert into test(name) values ('123');
Query OK, 1 row affected, 1 warning (0.00 sec)

mysql> show warnings;
+---------+------+-------------------------------------------+
| Level   | Code | Message                                   |
+---------+------+-------------------------------------------+
| Warning | 1265 | Data truncated for column 'name' at row 1 |
+---------+------+-------------------------------------------+
1 row in set (0.00 sec)
```

最后，我们来查看下表中的数据。表中的值为'12'，确实发生了截断。

```sql
mysql> select * from test;
+----+------+
| id | name |
+----+------+
|  1 | 12   |
+----+------+
1 row in set (0.00 sec)
```

2.将SQL模式设置为TRADITIONAL；

```sql
mysql> set @@sql_mode = 'traditional';
Query OK, 0 rows affected (0.00 sec)
```

然后，再次尝试插入一条长度为3的字符串'456'。

```sql
mysql> insert into test(name) values ('456');
ERROR 1406 (22001): Data too long for column 'name' at row 1
```

### 总结

当varchar超过限制长度时，

1.如果当前的SQL模式为宽松模式，那么将会按照从前往后的顺序，对字符串进行截断，并提示一个警告；

2.如果当前的SQL模式为严格模式，那么将会报出一个错误。

### 参考资料

[Server SQL Modes](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)