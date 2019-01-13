---
title: SQL模糊查询并高亮显示查询结果
date: 2018-05-14 21:22:31
updated: 2018-05-16 18:48:20 
tags: [sql,mysql]
categories: sql
---
最近在完善课题组的项目时，遇到了一个问题：项目有个论坛模块，需要实现根据用户输入的关键字检索论坛文章，然后高亮显示检索结果。

本来遇到这个需求，第一反应是用lucene来做全文检索。但是，lucene只是一个全文检索工具包，要用它实现全文检索，需要写一大堆的代码，加之虽然之前用过几次lucene，但是对lucene的API还是不太熟。想想还是算了，等以后专门研究一下lucene再说吧。

有朋友可能要问了：为什么不用solr或者elasticsearch？还不是因为不熟，再说了，一个solr一百多兆，我这就是个小项目，没必要啊。思来想去，最后还是决定就用sql的模糊查询like实现。

<!--more-->

表结构是这样的

```sql
create table article(
	id bigint unsigned not null auto_increment,
	title varchar(255) not null,
	summary varchar(255) not null,
	is_public tinyint(1) unsigned not null default 1 comment "是否公开，1表示公开，0表示私密",
	gmt_create datetime not null,
	...,
	primary key(id)
)
```

这里以检索“作业“为例，只查询公开的文章，并且按照发表时间降序排列，SQL是这样写的

```sql
select id,title,summary,gmt_create,... 
from article
where is_public = 1 and (title like "%作业%" or summary like "%作业%")
order by gmt_create desc
limit 0,10;
```

这样做确实能实现模糊查询了，但是又一个问题来了：如何实现检索结果高亮显示呢？

寻思了很久，也没想到解决办法。后来灵机一动，想到干嘛不在返回字段的时候在关键字的前后插入一些html标签，或者直接替换返回字段中的关键字，这不就实现高亮显示了吗？于是SQL就成了下面这样。

```sql
select id,
replace(title,"作业",concat("<font color='red'><b>","作业","</b></font>")) as title,
replace(summary,"作业",concat("<font color='red'><b>","作业","</b></font>")) as summary,
gmt_create,...
from article
where is_public = 1 and (title like "%作业%" or summary like "%作业%")
order by gmt_create desc
limit 0,10;
```

当然，使用全模糊查询，然后通过替换关键字的方式实现检索结果高亮显示，从而实现全文检索，这种方法效率肯定不高。《阿里巴巴Java开发手册》中也明确禁止使用全模糊或左模糊查询，因为全模糊或者左模糊查询无法使用索引。
