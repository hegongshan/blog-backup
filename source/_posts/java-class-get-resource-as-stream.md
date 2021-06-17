---
title: 使用Class::getResourceAsStream方法读取文件
date: 2020-07-05 19:12:50
tags: java
categories: java
---

今天，遇到了一个问题：使用Class类对象的getResourceAsStream方法读取文件时，返回值为null，即找不到文件，这究竟是怎么回事呢？

<!--more-->

### 问题回顾

假设有一个Maven（或者Gradle）项目，在其src/main/resources目录下有一个文件叫作generatorConfig.xml（Mybatis Generator的配置文件），项目结构如下：

```
project
└── src
    └── main
        ├── java
        └── resources
            └── generatorConfig.xml
```

任务目标是读取generatorConfig.xml文件。当时，我信心满满地写下了如下代码：

```java
import java.io.InputStream;

public class Main {
    public static void main(String[] args) {
        InputStream is = Main.class.getResourceAsStream("generatorConfig.xml");
        System.out.println(is == null);
    }
}
```

结果却为true，也就是说，压根没找到这个文件。

### 问题分析

后来，我发现是自己没有理解Class::getResourceAsStream方法的使用规则。

#### 查看注释

实际上，在Class::getResourceAsStream的源码中可以看到如下注释：

> This method delegates to this object's class loader. If this object was loaded by the bootstrap class loader, the method delegates to `ClassLoader.getSystemResourceAsStream`.
>
> Before delegation, an absolute resource name is constructed from the given resource name using this algorithm:
>
> - If the `name` begins with a `'/'` (`'\u002f'`), then the absolute name of the resource is the portion of the `name` following the `'/'`.
>
> - Otherwise, the absolute name is of the following form:
>
>   > `modified_package_name/name`
>
>   Where the `modified_package_name` is the package name of this object with `'/'` substituted for `'.'` (`'\u002e'`).

大意是说：

1.如果name以`/`开头，则文件的绝对名称就是`/`后面的部分；

2.否则，文件的绝对名称就是当前对象所在的包路径，加上文件名。

#### 源码分析

看完注释，不妨再阅读下源码，可以有更加清楚的认识。

1.Class::getResourceAsStream的源码如下：

```java
public InputStream getResourceAsStream(String name) {
    name = resolveName(name);
    // 省略了剩下的代码
}
```

2.resolveName方法的源码如下：

```java
private String resolveName(String name) {
    if (!name.startsWith("/")) {
        Class<?> c = this;
        while (c.isArray()) {
            c = c.getComponentType();
        }
        String baseName = c.getPackageName();
        if (baseName != null && !baseName.isEmpty()) {
            name = baseName.replace('.', '/') + "/" + name;
        }
    } else {
        name = name.substring(1);
    }
    return name;
}
```


通过上述分析，可以得到以下的结论：假设类Main的包名为`com.hegongshan`，要读取的文件名为`generatorConfig.xml`。此时，如果不加前缀`/`，那么Class::getResourceAsStream方法会以为要读取的是`com/heogngshan/generatorConfig.xml`。

### 解决方案

明白问题所在之后，要解决该问题就非常容易了。

* 使用Class::getResourceAsStream方法，并在文件名前加上`/`

```java
import java.io.InputStream;

public class Main {
    public static void main(String[] args) {
        InputStream is = Main.class.getResourceAsStream("/generatorConfig.xml");
        System.out.println(is == null);
    }
}
```

* 使用ClassLoader::getResourceAsStream方法

```java
import java.io.InputStream;

public class Main {
    public static void main(String[] args) {
        InputStream is = Main.class.getClassLoader().getResourceAsStream("generatorConfig.xml");
        System.out.println(is == null);
    }
}
```


* 使用ClassLoader::getSystemResourceAsStream方法

```java
import java.io.InputStream;

public class Main {
    public static void main(String[] args) {
        InputStream is = ClassLoader.getSystemResourceAsStream("generatorConfig.xml");
        System.out.println(is == null);
    }
}
```