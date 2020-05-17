---
title: MySQL事务隔离级别
date: 2020-04-13 13:03:09
tags: mysql
categories: mysql
---

MySQL默认开启了AUTOCOMMIT，关闭自动提交。

```sql
mysql> set autocommit = 0;
Query OK, 0 rows affected (0.01 sec)

mysql> select @@autocommit;
+--------------+
| @@autocommit |
+--------------+
|            0 |
+--------------+
1 row in set (0.00 sec)
```

<!--more-->

### 并发一致性问题

* 丢失修改
* 脏读（dirty read）
* 不可重复读（unrepeatable read）
* 幻影读（phantom read）

### 事务隔离级别

MySQL有四种事务隔离级别

* 未提交读（READ-UNCOMMITTED）：
* 提交读（READ-COMMITTED）：
* 可重复读（REPEATABLE-READ）：
* 可串行化（SERIALIZABLE）：

|          | 脏读 | 不可重复 | 幻影读 |
| :------: | :--: | :------: | :----: |
| 未提交读 |  ×   |    ×     |   ×    |
|  提交读  |  ✔   |    ×     |   ×    |
| 可重复读 |  ✔   |    ✔     |   ×    |
| 可串行化 |  ✔   |    ✔     |   ✔    |

MySQL默认的隔离级别为**可重复读（REPEATABLE READ）**。

```sql
mysql> select @@global.transaction_isolation, @@transaction_isolation;
+--------------------------------+-------------------------+
| @@global.transaction_isolation | @@transaction_isolation |
+--------------------------------+-------------------------+
| REPEATABLE-READ                | REPEATABLE-READ         |
+--------------------------------+-------------------------+
1 row in set (0.00 sec)
```

修改事务的隔离级别：

```sql
set [session | global] transaction isolation level 隔离级别;
```

### 实战：并发一致性问题

#### 数据准备

首先，先建立一个数据库；

```sql
create database `test`;
```

建立表

```sql
create table `account` (
	id int not null auto_increment comment 'ID',
	name varchar(255) not null comment '用户名',
	balance int not null default 0 comment '余额',
	primary key(id)
);
```

插入数据

```sql
insert into `account` (name, balance) values ('user1', 120);
insert into `account` (name, balance) values ('user2', 130);
insert into `account` (name, balance) values ('user3', 140);
```

#### 关闭自动提交

打开两个命令行界面，关闭自动提交

![](/static/images/mysql-transaction-autocommit.png)

#### 测试脏读

设置会话的事务隔离级别为**未提交读**（read uncommitted）。

![](/static/images/mysql-transaction-isolation.png)

```sql
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| REPEATABLE-READ         |
+-------------------------+
1 row in set (0.00 sec)

mysql> set session transaction isolation level read uncommitted;
Query OK, 0 rows affected (0.00 sec)

mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| READ-UNCOMMITTED        |
+-------------------------+
1 row in set (0.00 sec)
```

1.事务T1执行如下操作

```sql
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from account where id = 1;
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | user1 |     120 |
+----+-------+---------+
1 row in set (0.00 sec)

mysql> update account set balance = balance + 20 where id = 1;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

2.事务T2执行如下操作

```sql
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from account where id = 1;
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | user1 |     140 |
+----+-------+---------+
1 row in set (0.00 sec)
```

此时，余额为140元。

3.事务T1回滚

```sql
mysql> rollback;
Query OK, 0 rows affected (0.01 sec)
```

4.事务T2再次读取该条数据。

```sql
mysql> select * from account where id = 1;
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | user1 |     120 |
+----+-------+---------+
1 row in set (0.00 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)
```

此时，余额为120元，发生了**脏读**。

#### 测试不可重复读

将两个命令行界面的事务隔离级别设置为**提交读**（read committed）。

```sql
mysql> set session transaction isolation level read committed;
Query OK, 0 rows affected (0.00 sec)
```

1.事务T2读取id为1的数据：余额为120元。

```sql
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from account where id = 1;
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | user1 |     120 |
+----+-------+---------+
1 row in set (0.00 sec)
```

2.事务T1更改id为1的余额：更改完成后，余额为140元。

```sql
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> update account set balance = balance + 20 where id = 1;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> commit;
Query OK, 0 rows affected (0.01 sec)
```

3.事务T2再次读取数据：余额为140元，出现了**不可重复读**。

```sql
mysql> select * from account where id = 1;
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | user1 |     140 |
+----+-------+---------+
1 row in set (0.00 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)
```

#### 测试幻影读

将两个命令行界面的事务隔离级别设置为**可重复读**（repeatable read）。

```sql
mysql> set session transaction isolation level repeatable read;
Query OK, 0 rows affected (0.00 sec)
```

1.事务T1读取余额在100-150之间的所有数据

```sql
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from account where balance between 100 and 150;
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | user1 |     140 |
|  2 | user2 |     130 |
|  3 | user3 |     140 |
+----+-------+---------+
3 rows in set (0.00 sec)
```

2.事务T2在表中插入一条数据，余额为150元。

```sql
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into account (name, balance) values ('user4', 150);
Query OK, 1 row affected (0.00 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)
```

3.事务T1先执行一条更新语句，然后再次读取100-150之间的所有数据。

```sql
mysql> update account set name = concat(name, '1');
Query OK, 4 rows affected (0.00 sec)
Rows matched: 4  Changed: 4  Warnings: 0

mysql> select * from account where balance between 100 and 150;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | user11 |     140 |
|  2 | user21 |     130 |
|  3 | user31 |     140 |
|  4 | user41 |     150 |
+----+--------+---------+
4 rows in set (0.00 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)
```

再次读取时，出现了4条数据，发生了**幻影读。**

> 注意：事务T1的更新操作必须改变事务T2插入的数据，否则，不会触发幻影读。

