---
title: Maven常用命令总结
date: 2021-09-20 16:23:50
tags: maven
categories: java
---

对于Maven项目，其目录结构通常为：

```shell
project
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   └── resources
│   └── test
│       └── java
│       └── resources
└── target
    ├── classes
    └── test-classes
```

<!--more-->

### 配置Java编译器

```xml
<build>
  <finalName>ase</finalName>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.3</version>
      <configuration>
        <source>1.8</source>
        <target>1.8</target>
      </configuration>
    </plugin>
  </plugins>
</build>
```

通过`source`指定源码版本，而`target`则指定编译版本。

### mvn compile

编译项目源码，生成的`*.class`文件位于`target/classes`中。

```shell
hgs:ase-lab1 hegongshan$ mvn compile
[INFO] Scanning for projects...
[INFO] 
[INFO] -------------------------< com.hegongshan:ase >-------------------------
[INFO] Building ase 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ ase ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 3 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ ase ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 9 source files to /Users/hegongshan/eclipse-workspace/ase-lab1/target/classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.384 s
[INFO] Finished at: 2021-09-19T16:09:36+08:00
[INFO] ------------------------------------------------------------------------
```

### mvn test

执行测试代码，生成的.class位于target/test-classes中。

```shell
hgs:ase-lab1 hegongshan$ mvn test
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ ase ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /Users/hegongshan/eclipse-workspace/ase-lab1/target/test-classes

Results :

Tests run: 3, Failures: 0, Errors: 0, Skipped: 0

[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  6.442 s
[INFO] Finished at: 2021-09-19T16:11:14+08:00
[INFO] ------------------------------------------------------------------------
```

### mvn test-compile

编译测试代码，但不执行

```shell
hgs:ase-lab1 hegongshan$ mvn test-compile
[INFO] Scanning for projects...
[INFO] 
[INFO] -------------------------< com.hegongshan:ase >-------------------------
[INFO] Building ase 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ ase ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 3 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ ase ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 9 source files to /Users/hegongshan/eclipse-workspace/ase-lab1/target/classes
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ ase ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /Users/hegongshan/eclipse-workspace/ase-lab1/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ ase ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /Users/hegongshan/eclipse-workspace/ase-lab1/target/test-classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.357 s
[INFO] Finished at: 2021-09-20T16:04:45+08:00
[INFO] ------------------------------------------------------------------------
```

### mvn package

打包结果位于<strong style="color:red;">`${basedir}/target`</strong>目录下

```xml
<groupId>com.hegongshan</groupId>
<artifactId>ase</artifactId>
<packaging>jar</packaging> <!-- <packaging>war</packaging> -->
<version>0.0.1-SNAPSHOT</version>
<name>ase</name>
```

打包时，会自动运行测试代码。如果不想运行测试代码，可以添加如下的选项：

```shell
mvn package -Dmaven.test.skip=true
```

### mvn install

将jar包安装到本地仓库中，以便在本地其他项目中使用该项目<strong style="color:red;">`${user.home}/.m2/repository`</strong>

```shell
Results :

Tests run: 3, Failures: 0, Errors: 0, Skipped: 0

[INFO] 
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ ase ---
[INFO] Building jar: /Users/hegongshan/eclipse-workspace/ase-lab1/target/ase.jar
[INFO] 
[INFO] --- maven-install-plugin:2.4:install (default-install) @ ase ---
[INFO] Installing /Users/hegongshan/eclipse-workspace/ase-lab1/target/ase.jar to /Users/hegongshan/.m2/repository/com/hegongshan/ase/0.0.1-SNAPSHOT/ase-0.0.1-SNAPSHOT.jar
[INFO] Installing /Users/hegongshan/eclipse-workspace/ase-lab1/pom.xml to /Users/hegongshan/.m2/repository/com/hegongshan/ase/0.0.1-SNAPSHOT/ase-0.0.1-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  6.966 s
[INFO] Finished at: 2021-09-20T16:09:39+08:00
[INFO] ------------------------------------------------------------------------
```

### mvn clean

删除target目录

```shell
hgs:ase-lab1 hegongshan$ mvn clean
[INFO] Scanning for projects...
[INFO] 
[INFO] -------------------------< com.hegongshan:ase >-------------------------
[INFO] Building ase 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ ase ---
[INFO] Deleting /Users/hegongshan/eclipse-workspace/ase-lab1/target
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.225 s
[INFO] Finished at: 2021-09-19T16:03:30+08:00
[INFO] ------------------------------------------------------------------------
```

### 参考资料

1.[Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)

2.[Maven Getting Started Guide](https://maven.apache.org/guides/getting-started/index.html)

