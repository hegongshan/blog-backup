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

### [180. 连续出现的数字](https://leetcode-cn.com/problems/consecutive-numbers/)

#### 题目描述

编写一个 SQL 查询，查找所有至少连续出现三次的数字。

```
+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
```

例如，给定上面的 `Logs` 表， `1` 是唯一连续出现至少三次的数字。

```
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
```

#### SQL

```sql
SELECT 
    DISTINCT l1.Num AS ConsecutiveNums
FROM 
    Logs AS l1, 
    Logs AS l2, 
    Logs AS l3
WHERE 
    l1.Id + 1= l2.Id 
    AND l2.Id + 1 = l3.Id 
    AND l1.Num = l2.Num 
    AND l2.Num = l3.Num;
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

#### 题目描述

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

#### SQL

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

### [197. 上升的温度](https://leetcode-cn.com/problems/rising-temperature/)

#### 题目描述

给定一个 `Weather` 表，编写一个 SQL 查询，来查找与之前（昨天的）日期相比温度更高的所有日期的 Id。

```
+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
```

例如，根据上述给定的 `Weather` 表格，返回如下 Id:

```
+----+
| Id |
+----+
|  2 |
|  4 |
+----+
```

#### SQL

```sql
SELECT a.Id
FROM Weather AS a JOIN Weather AS b
ON DATEDIFF(a.RecordDate, b.RecordDate) = 1 AND a.Temperature > b.Temperature;
```

注意：**DATEDIFF()函数用于计算两个日期之差。**

例如，DATEDIFF('2015-01-04','2015-01-03')返回1，DATEDIFF('2015-01-03','2015-01-04')返回-1。

### [595. 大的国家](https://leetcode-cn.com/problems/big-countries/)

#### 题目描述

这里有张 `World` 表

```
+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
```

如果一个国家的面积超过300万平方公里，或者人口超过2500万，那么这个国家就是大国家。

编写一个SQL查询，输出表中所有大国家的名称、人口和面积。

例如，根据上表，我们应该输出:

```
+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+
```

#### SQL

```sql
SELECT name, population, area
FROM World
WHERE area > 3000000 OR population > 25000000;
```

### [596. 超过5名学生的课](https://leetcode-cn.com/problems/classes-more-than-5-students/)

#### 题目描述

有一个`courses` 表 ，有: **student (学生)** 和 **class (课程)**。

请列出所有超过或等于5名学生的课。

例如,表:

```
+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
```

应该输出:

```
+---------+
| class   |
+---------+
| Math    |
+---------+
```

**Note:**
学生在每个课中不应被重复计算。

#### SQL

思路：使用分组语句，并注意去重。

```sql
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5; 
```

### [620. 有趣的电影](https://leetcode-cn.com/problems/not-boring-movies/)

#### 题目描述

某城市开了一家新的电影院，吸引了很多人过来看电影。该电影院特别注意用户体验，专门有个 LED显示板做电影推荐，上面公布着影评和相关电影描述。

作为该电影院的信息部主管，您需要编写一个 SQL查询，找出所有影片描述为非 boring (不无聊) 的并且 id 为奇数 的影片，结果请按等级 rating 排列。

例如，下表 cinema:

```
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
```

对于上面的例子，则正确的输出是为：

```
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+
```

#### SQL

```sql
SELECT id, movie, description, rating
FROM cinema
WHERE description <> 'boring' AND MOD(id, 2) = 1
ORDER BY rating DESC
```

注意：**MOD()函数用于求余数。**

### [627. 交换工资](https://leetcode-cn.com/problems/swap-salary/)

#### 题目描述

给定一个 salary 表，如下所示，有 m = 男性 和 f = 女性 的值。交换所有的 f 和 m 值（例如，将所有 f 值更改为 m，反之亦然）。要求只使用一个更新（Update）语句，并且没有中间的临时表。

注意，您必只能写一个 Update 语句，请不要编写任何 Select 语句。

**例如：**

```
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
```

运行你所编写的更新语句之后，将会得到以下表:

```
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
```

#### SQL

```sql
# 方法一：CASE ... WHEN
-- UPDATE salary
-- SET SEX = CASE SEX
--     WHEN 'm' THEN 'f'
--     ELSE 'm'
-- END;

# 方法二：IF函数
UPDATE salary
SET SEX = IF(SEX='m', 'f', 'm');
```



