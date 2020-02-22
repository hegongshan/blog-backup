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

### [181. 超过经理收入的员工](https://leetcode-cn.com/problems/employees-earning-more-than-their-managers/)

#### 题目描述

`Employee` 表包含所有员工，他们的经理也属于员工。每个员工都有一个 Id，此外还有一列对应员工的经理的 Id。

```
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
```

给定 `Employee` 表，编写一个 SQL 查询，该查询可以获取收入超过他们经理的员工的姓名。在上面的表格中，Joe 是唯一一个收入超过他的经理的员工。

```
+----------+
| Employee |
+----------+
| Joe      |
+----------+
```

#### SQL

```sql
# 方法一：相关子查询
-- SELECT Name AS Employee
-- FROM Employee AS a
-- WHERE a.Salary > (
--     SELECT Salary
--     FROM Employee AS b
--     WHERE a.ManagerId = b.Id
-- );

# 方法二：等值连接（不使用join）
-- SELECT a.Name AS Employee
-- FROM Employee AS a, Employee AS b
-- WHERE a.ManagerId = b.Id AND a.Salary > b.Salary;

# 方法三：等值连接（使用join）
SELECT a.Name AS Employee
FROM Employee AS a INNER JOIN Employee AS b
ON a.ManagerId = b.Id AND a.Salary > b.Salary;
```

### [182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails/)

#### 题目描述

编写一个 SQL 查询，查找 `Person` 表中所有重复的电子邮箱。

**示例：**

```
+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
```

根据以上输入，你的查询应返回以下结果：

```
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
```

#### SQL架构

```sql
Create table If Not Exists Person (Id int, Email varchar(255))
Truncate table Person
insert into Person (Id, Email) values ('1', 'a@b.com')
insert into Person (Id, Email) values ('2', 'c@d.com')
insert into Person (Id, Email) values ('3', 'a@b.com')
```

#### SQL

```sql
# 方法一：自连接
-- SELECT DISTINCT a.Email
-- FROM Person AS a INNER JOIN Person AS b
-- ON a.Email = b.Email AND a.Id <> b.Id;

# 方法二：group by
SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(Email) > 1;
```

### [183. 从不订购的客户](https://leetcode-cn.com/problems/customers-who-never-order/)

#### 题目描述

某网站包含两个表，`Customers` 表和 `Orders` 表。编写一个 SQL 查询，找出所有从不订购任何东西的客户。

`Customers` 表：

```
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
```

`Orders` 表：

```
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
```

#### SQL架构

```sql
Create table If Not Exists Customers (Id int, Name varchar(255))
Create table If Not Exists Orders (Id int, CustomerId int)
Truncate table Customers
insert into Customers (Id, Name) values ('1', 'Joe')
insert into Customers (Id, Name) values ('2', 'Henry')
insert into Customers (Id, Name) values ('3', 'Sam')
insert into Customers (Id, Name) values ('4', 'Max')
Truncate table Orders
insert into Orders (Id, CustomerId) values ('1', '3')
insert into Orders (Id, CustomerId) values ('2', '1')
```

#### SQL

```sql
SELECT Name AS Customers
FROM Customers 
WHERE Id NOT IN (
    SELECT DISTINCT CustomerId
    FROM Orders
);
```

### [184. 部门工资最高的员工](https://leetcode-cn.com/problems/department-highest-salary/)

`Employee` 表包含所有员工信息，每个员工有其对应的 Id, salary 和 department Id。

```
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
```

`Department` 表包含公司所有部门的信息。

```
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```

编写一个 SQL 查询，找出每个部门工资最高的员工。例如，根据上述给定的表格，Max 在 IT 部门有最高工资，Henry 在 Sales 部门有最高工资。

```
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
```

#### SQL架构

```sql
Create table If Not Exists Employee (Id int, Name varchar(255), Salary int, DepartmentId int)
Create table If Not Exists Department (Id int, Name varchar(255))
Truncate table Employee
insert into Employee (Id, Name, Salary, DepartmentId) values ('1', 'Joe', '70000', '1')
insert into Employee (Id, Name, Salary, DepartmentId) values ('2', 'Jim', '90000', '1')
insert into Employee (Id, Name, Salary, DepartmentId) values ('3', 'Henry', '80000', '2')
insert into Employee (Id, Name, Salary, DepartmentId) values ('4', 'Sam', '60000', '2')
insert into Employee (Id, Name, Salary, DepartmentId) values ('5', 'Max', '90000', '1')
Truncate table Department
insert into Department (Id, Name) values ('1', 'IT')
insert into Department (Id, Name) values ('2', 'Sales')
```

### SQL

```sql
SELECT 
    dep.Name AS 'Department', 
    emp.Name AS 'Employee', 
    emp.Salary
FROM 
    Department AS dep 
    INNER JOIN 
    Employee AS emp ON dep.Id = emp.DepartmentId
WHERE (emp.DepartmentId, emp.Salary) IN (
    SELECT DepartmentId, MAX(Salary)
    FROM Employee
    GROUP BY DepartmentId
);
```

