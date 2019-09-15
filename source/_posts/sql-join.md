---
title: SQL中的各种join
date: 2018-09-14 14:05:08
tags: sql
categories: sql
---

SQL中的连接操作很多，这里总结一下。

<!--more-->

假设有以下两张表

教师表teacher

| teacher_id | teacher_name |
| :--------: | :----------: |
|     1      |     刘娟     |
|     2      |    朱卫平    |
|     3      |     刘婧     |
|     4      |    李春葆    |

课程表course

| course_id |    course_name     | teacher_id |
| :-------: | :----------------: | :--------: |
|     1     |      商务智能      |     2      |
|     2     | 高级算法分析与设计 |     1      |
|     3     |   程序设计方法学   |     3      |
|     4     |      模式识别      |     2      |

sql如下：

```sql
create table teacher (
    teacher_id int,
    teacher_name varchar(32),
    primary key(teacher_id)
);
insert into teacher(teacher_id,teacher_name) values (1,'刘娟');
insert into teacher(teacher_id,teacher_name) values (2,'朱卫平');
insert into teacher(teacher_id,teacher_name) values (3,'刘婧');
insert into teacher(teacher_id,teacher_name) values (4,'李春葆');
create table course(
    course_id int,
    course_name varchar(32),
    teacher_id int,
    primary key(course_id),
    foreign key(teacher_id) references teacher(teacher_id)
);
insert into course(course_id,course_name,teacher_id) values (1,'商务智能',2);
insert into course(course_id,course_name,teacher_id) values (2,'高级算法分析与设计',1);
insert into course(course_id,course_name,teacher_id) values (3,'程序设计方法学',3);
insert into course(course_id,course_name,teacher_id) values (4,'模式识别',2);
```

### cross join

交叉连接(cross join)：如果不带where子句，它将会返回被连接的两个表的笛卡尔积，返回结果的行数等于两个表行数的乘积。

语法：

```sql
select 列名,...
from table1
cross join table2
[where 条件]
```

示例：

```sql
select * from teacher cross join course;
```

输出：

```sql
+------------+--------------+-----------+-----------------------------+------------+
| teacher_id | teacher_name | course_id | course_name                 | teacher_id |
+------------+--------------+-----------+-----------------------------+------------+
|          1 | 刘娟         |         1 | 商务智能                    |          2 |
|          2 | 朱卫平       |         1 | 商务智能                    |          2 |
|          3 | 刘婧         |         1 | 商务智能                    |          2 |
|          4 | 李春葆       |         1 | 商务智能                    |          2 |
|          1 | 刘娟         |         2 | 高级算法分析与设计            |          1 |
|          2 | 朱卫平       |         2 | 高级算法分析与设计            |          1 |
|          3 | 刘婧         |         2 | 高级算法分析与设计            |          1 |
|          4 | 李春葆       |         2 | 高级算法分析与设计            |          1 |
|          1 | 刘娟         |         3 | 程序设计方法学               |          3 |
|          2 | 朱卫平       |         3 | 程序设计方法学               |          3 |
|          3 | 刘婧         |         3 | 程序设计方法学               |          3 |
|          4 | 李春葆       |         3 | 程序设计方法学               |          3 |
|          1 | 刘娟         |         4 | 模式识别                    |          2 |
|          2 | 朱卫平       |         4 | 模式识别                    |          2 |
|          3 | 刘婧         |         4 | 模式识别                    |          2 |
|          4 | 李春葆       |         4 | 模式识别                    |          2 |
+------------+--------------+-----------+-----------------------------+------------+
```

### inner join

等值连接（inner join或join）:返回两张表中相互匹配的行。

语法：

```sql
select 列名,...
from table1
[inner] join table2
on table1.column_name = table2.column_name;
```

其中的inner是可省略的。

示例：

查询每门课程的的课程号、课程名称、教师编号以及教师姓名。

```sql
select course.*,teacher.teacher_name from course
inner join teacher
on course.teacher_id = teacher.teacher_id;
```

输出：

```sql
+-----------+-----------------------------+------------+--------------+
| course_id | course_name                 | teacher_id | teacher_name |
+-----------+-----------------------------+------------+--------------+
|         2 | 高级算法分析与设计             |          1 | 刘娟         |
|         1 | 商务智能                     |          2 | 朱卫平        |
|         4 | 模式识别                     |          2 | 朱卫平        |
|         3 | 程序设计方法学                |          3 | 刘婧          |
+-----------+-----------------------------+------------+--------------+
```

### natural join

自然连接(natural join)：在等值连接的基础上，去掉重复的列名。

语法：

```sql
select 列名,...
from table1
natural join table2;
```

示例：

```sql
select * from course
natural join teacher
```

输出：

由于course表中已经包含了teacher_id，所以，在进行自然连接时，自动去掉了teacher表中多余的teacher_id。

```sql
+------------+-----------+-----------------------------+--------------+
| teacher_id | course_id | course_name                 | teacher_name |
+------------+-----------+-----------------------------+--------------+
|          1 |         2 | 高级算法分析与设计             | 刘娟         |
|          2 |         1 | 商务智能                     | 朱卫平       |
|          2 |         4 | 模式识别                     | 朱卫平       |
|          3 |         3 | 程序设计方法学                | 刘婧         |
+------------+-----------+-----------------------------+--------------+
```

### left join

左外连接(left outer join)：返回左表中的所有行及右表中满足on条件的行，如果右表没有匹配的行，对应列填充NULL。

其中outer是可省略的，即可写为left join。

示例：

查询所有的教师信息，即使他尚未被安排课程

```sql
select course.*,teacher.teacher_name from teacher
left outer join course
on course.teacher_id = teacher.teacher_id;
```

输出：

```sql
+-----------+-----------------------------+------------+--------------+
| course_id | course_name                 | teacher_id | teacher_name |
+-----------+-----------------------------+------------+--------------+
|         2 | 高级算法分析与设计             |          1 | 刘娟         |
|         1 | 商务智能                     |          2 | 朱卫平       |
|         4 | 模式识别                     |          2 | 朱卫平       |
|         3 | 程序设计方法学                |          3 | 刘婧         |
|      NULL | NULL                        |       NULL | 李春葆       |
+-----------+-----------------------------+------------+--------------+
```

### right join

右外连接(right outer join)：返回右表有行和左表中满足on条件的行，如果左表没有匹配的行，对应列填充NULL。

其中outer是可省略的，即可写为right join。

示例：

查询所有的教师信息，即使他尚未被安排课程

```sql
select * from course
right outer join teacher
on course.teacher_id = teacher.teacher_id;
```

输出：

```sql
+-----------+-----------------------------+------------+------------+--------------+
| course_id | course_name                 | teacher_id | teacher_id | teacher_name |
+-----------+-----------------------------+------------+------------+--------------+
|         2 | 高级算法分析与设计             |          1 |          1 | 刘娟         |
|         1 | 商务智能                     |          2 |          2 | 朱卫平       |
|         4 | 模式识别                     |          2 |          2 | 朱卫平       |
|         3 | 程序设计方法学                |          3 |          3 | 刘婧         |
|      NULL | NULL                        |       NULL |          4 | 李春葆       |
+-----------+-----------------------------+------------+------------+--------------+
```

### full join

全外连接(full outer join或full join)：返回左表和右表中的所有行。若某一张表中的行在另一张表中没有匹配的行，对应列填充NULL。

```sql
select * from course
full outer join teacher
on course.teacher_id = teacher.teacher_id;
```

**注意：**MySQL不支持full outer join，可以使用左连接和右连接的并来实现。

```sql
select * from course
left join teacher
on course.teacher_id = teacher.teacher_id
union 
select * from course
right join teacher
on course.teacher_id = teacher.teacher_id;
```

输出：

```sql
+-----------+-----------------------------+------------+------------+--------------+
| course_id | course_name                 | teacher_id | teacher_id | teacher_name |
+-----------+-----------------------------+------------+------------+--------------+
|         2 | 高级算法分析与设计             |          1 |          1 | 刘娟         |
|         1 | 商务智能                     |          2 |          2 | 朱卫平       |
|         4 | 模式识别                     |          2 |          2 | 朱卫平       |
|         3 | 程序设计方法学                |          3 |          3 | 刘婧         |
|      NULL | NULL                        |       NULL |          4 | 李春葆       |
+-----------+-----------------------------+------------+------------+--------------+
```







