---
title: Java单元测试JUnit
date: 2020-07-25 20:18:58
tags: java
categories: java
---

JUnit是Java开发中使用最为广泛的单元测试框架，如果你是一个Java工程师，相信你一定听过或者用过它。

<!--more-->

JUnit有两个常用的版本：[JUnit4](https://junit.org/junit4)和[JUnit5](https://junit.org/junit5) 。

### 常用注解

|                             描述                             |    JUnit4    |   JUnit5    |
| :----------------------------------------------------------: | :----------: | :---------: |
|                           测试方法                           |    @Test     |    @Test    |
|                    在每个test方法之前执行                    |   @Before    | @BeforeEach |
|         在每个test方法之后执行，主要用于释放外部资源         |    @After    | @AfterEach  |
| 在当前类的所有方法之前执行，并且仅执行一次，方法必须为static void | @BeforeClass | @BeforeAll  |
| 在当前类的所有方法之后执行，并且仅执行一次，主要用于释放昂贵的外部资源，方法必须为static void | @AfterClass  |  @AfterAll  |
|                         忽略测试方法                         |   @Ignore    |  @Disable   |

执行顺序：@BeforeClass -> @Before -> @Test -> @After -> @Before -> @Test -> @After -> ... -> @AfterClass。

### 断言方法

JUnit4在org.junit.Assert类中提供了一系列的断言方法。

为了提高可读性，在使用这些方法时，JUnit4推荐采用静态导入的方式。

```java
import static org.junit.Assert.*;
```

* assertTrue(boolean condition)
* assertNotNull(Object object)
* assertEquals(Object expected, Object actual)
* ......

### JUnit初体验

下面以测试单表查询为例，建表语句如下：

```sql
drop database if exists `test_jdbc`;
create database `test_jdbc`;
use `test_jdbc`;
create table `user` (
    id bigint(20) not null auto_increment,
    username varchar(255) not null,
    primary key(id)
);
insert into user (username) values ('test1');
insert into user (username) values ('test2');
```

使用JUnit4的测试代码如下：

```java
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

public class JdbcTest {

    private static Connection connection;
    private Statement stmt;

    @BeforeClass
    public static void loadDriver() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/test_jdbc", "root", "mysqladmin");
        System.out.println("execute @BeforeClass");
    }

    @Before
    public void openStatement() throws SQLException {
        stmt = connection.createStatement();
        System.out.println("execute @Before");
    }
    
    // @Ignore
    @Test
    public void testQuery() throws SQLException {
        ResultSet rs = stmt.executeQuery("select username from user");
        while (rs.next()) {
            String username = rs.getString("username");
            assertNotNull(username);
        }
        System.out.println("execute @Test");
    }
    
    @Test
    public void testUpdate() throws SQLException {
        int result = stmt.executeUpdate("update user set username = 'username1' where id = 1");
        assertTrue(result > 0);
        System.out.println("execute @Test");
    }

    @After
    public void close() throws SQLException {
        stmt.close();
        System.out.println("execute @After");
    }

    @AfterClass
    public static void closeConnection() throws SQLException {
        connection.close();
        System.out.println("execute @AfterClass");
    }

}
```

**注意：上面的打印语句只是为了说明不同注解的执行顺序。**

在实际编写测试代码时，不建议使用System.out，推荐采用断言方法。