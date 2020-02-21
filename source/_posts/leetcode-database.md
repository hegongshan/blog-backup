---
title: LeetCode 数据库题解
date: 2020-02-20 21:05:06
tags: sql
categories: leetcode
---

LeetCode 数据库题解合集。

<!--more-->

### [175. 组合两个表](https://leetcode-cn.com/problems/combine-two-tables/)

#### 题目描述

表1: Person

```
+-------------+---------+
| 列名         | 类型     |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId 是上表主键
```

表2: Address

```
+-------------+---------+
| 列名         | 类型    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId 是上表主键
```


编写一个 SQL 查询，满足条件：无论 person 是否有地址信息，都需要基于上述两表提供 person 的以下信息：

```
FirstName, LastName, City, State
```

#### SQL

```sql
SELECT FirstName, LastName, City, State
FROM Person AS p LEFT JOIN Address AS a
ON p.PersonId = A.PersonId;
```

### [176. 第二高的薪水](https://leetcode-cn.com/problems/second-highest-salary/)

#### 题目描述

编写一个 SQL 查询，获取 `Employee` 表中第二高的薪水（Salary） 。 

```
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```

例如上述 `Employee` 表，SQL查询应该返回 `200` 作为第二高的薪水。如果不存在第二高的薪水，那么查询应返回 `null`。

```
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
```

#### SQL

```sql
SELECT (
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1,1)  
AS SecondHighestSalary;
```

注意：1.表中可能存在重复的薪水，因此需要去重；2.若不存在第二高的薪水，则返回NULL（而不是0条记录）。

### [177. 第N高的薪水](https://leetcode-cn.com/problems/nth-highest-salary/)

#### 题目描述

编写一个 SQL 查询，获取 `Employee` 表中第 *n* 高的薪水（Salary）。

```
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```

例如上述 `Employee` 表，*n = 2* 时，应返回第二高的薪水 `200`。如果不存在第 *n* 高的薪水，那么查询应返回 `null`。

```
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
```

#### SQL

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    SET n = N - 1;
    RETURN (
        # Write your MySQL query statement below.
        SELECT (
            SELECT DISTINCT Salary
            FROM Employee
            ORDER BY Salary DESC
            LIMIT n, 1
        )
    );
END
```

### [178. 分数排名](https://leetcode-cn.com/problems/rank-scores/)

#### 题目描述

编写一个 SQL 查询来实现分数排名。如果两个分数相同，则两个分数排名（Rank）相同。请注意，平分后的下一个名次应该是下一个连续的整数值。换句话说，名次之间不应该有“间隔”。

```
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
```

例如，根据上述给定的 `Scores` 表，你的查询应该返回（按分数从高到低排列）：

```
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
```

#### SQL

思路：自连接。

```sql
SELECT s.Score, (
    SELECT COUNT(DISTINCT s2.Score)
    FROM Scores AS s2
    WHERE s.Score <= s2.Score
) AS Rank
FROM Scores AS s
ORDER BY s.Score DESC;
```

