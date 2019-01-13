---
title: SQL中的字符匹配（like）
date: 2018-09-19 20:21:39
tags: sql
categories: sql
---

like可以用于字符串的匹配，其一般语法如下：

```sql
[not] like '<匹配串>' [escape '<换码字符>']
```

其含义是查找指定的属性列值与<匹配串>相匹配的元组。<匹配串>可以是一个完整的字符串，也可以含有通配符 % 和 _ 。

* %：匹配任意长度(长度可以为0)的字符串
* _：匹配任意单个字符(一个汉字占两个字符)

<!--more-->

示例：

1.查询所有姓刘的学生的姓名、学号和性别。

```sql
select sname,sno,sex
from student
where sname like '刘%';
```

2.查询所有姓“贺”且全名为两个汉字的学生的姓名

```sql
select sname
from student
where sname like '贺__';
```

**由于一个汉字占两个字符，所以贺字后需要跟两个_**

3.查询名字中第二个字为“扬”字的学生姓名和学号

```sql
select sname,sno
from student
where sname like '__扬%';
```

４.查询名字中包含"山"的学生姓名

```sql
select sname
from student
where sname like '%山%';
```

５.查询所有不姓刘的学生姓名

```sql
select sname
from student
where sname not like '刘%'
```

**如果需要查询的匹配字符串本身就含有%和_，可以使用escape '<换码字符>'对通配符进行转义。**

示例：

6.查询Algorithms_Design课程的课程号和学分

```sql
select cno,credit
from course
where cname like 'Algorithms\_Design' escape '\';
```

7.查询课程名以“算法_”开头，且倒数第二个汉字为“设”的课程详情。

```sql
select *
from course
where cname like '算法\_%设__' escape '\';
```

**注意：**换码字符是可以变化的，一般取不常用的符号。若匹配串中本身含有 " \ "，则换码字符可取 “ ? ”等。