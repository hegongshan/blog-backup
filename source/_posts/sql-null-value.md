---
title: SQL中的空值处理(null)
date: 2018-09-19 22:01:39
tags: sql
categories: sql
---

SQL中的空值处理主要分为以下两种情况：

1.涉及空值的条件判断；2.涉及空值的更新操作。

<!--more-->

### 涉及空值的条件判断

**where子句中**不能使用 = null 来进行空值判断，**必须使用 is null 和 is not null **。

示例：

某些学生选修某门课程后没有参加考试，所以有选课记录，但没有考试成绩。

* 试查询缺少成绩的学生的学号和相应的课程号。

```sql
select sno,cno
from sc
where grade is null;
```

**注意，" grade is null "不能写为“ grade = null”。**

* 查所有有成绩记录的学生的学号和相应的课程号。

```sql
select sno,cno
from sc
where grade is not null;
```

### 涉及空值的更新操作

**在update语句的set中，使用 = null  设置某列为空。**

* 将选修“高级算法分析与设计”课不及格的学生成绩设置为空值。

```sql
update sc
set grade = null
where grade < 60 and cno in (
	select cno 
    from course
    where cname = "高级算法分析与设计"
);
```

