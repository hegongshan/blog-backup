---
title: MySQL索引
date: 2020-05-07 17:54:44
tags: mysql
categories: mysql
---

> <strong>《阿里巴巴Java开发手册》——MySQL数据库-建表规约</strong>
>
> <strong style="color:red;">【强制】</strong>主键索引名为`pk_字段名`;唯一索引名为`uk_字段名`;普通索引名则为`idx_字段名`。 
>
> 说明:pk_ 即 primary key;uk_ 即 unique key;idx_ 即 index 的简称。 

<!--more-->

### 创建索引

#### 创建表时

```sql
create table test (
    id int not null,
    username varchar(255) not null,
    age int not null,
    # 主键索引
    constraint pk_id primary key (id),
    # 唯一索引, key可省略
    unique key uk_username (username),
    # 普通索引
    index idx_age (age)
);
```

#### 建表以后

* 使用create命令

1.普通索引

```sql
create index idx_xxx on table_name (column_list);
```

2.唯一索引

```sql
create unique index uk_xxx on table_name (column_list);
```

* 使用alter命令

1.普通索引

```sql
alter table table_name add index idx_xxx (column_list);
```

2.唯一索引

```sql
alter table table_name add unique uk_xxx (column_list);
```

3.主键索引

```sql
alter table table_name add primary key (column_name);
```

### 删除索引

* 删除普通索引/唯一索引

1.使用drop命令

```sql
drop index [index_name] on table_name;
```

2.使用alter命令

```sql
alter table table_name drop index index_name;
```

* 删除主键索引

```sql
alter table table_name drop primary key;
```

### 查看索引

```sql
show index from table_name;
# show index in table_name;
```

