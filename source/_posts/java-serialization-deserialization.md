---
title: Java序列化
date: 2020-04-23 22:56:05
tags: java
categories: java
---

>晚上面阿里的第4轮面试（交叉面，其实应该算是第5面，因为中午已经面过HR了）时，面试官问到了Java对象的序列化，觉得有必要详细学习这块知识。

<!--more-->

```java
java.io.Serializable
```

如果没有实现该接口，在序列化时将抛出java.io.NotSerializableException。

每一个实现Serializable接口的类，都应该定义如下的属性：

```java
private static final long serialVersionUID
```

### 序列化与反序列化

* 序列化使用java.io.ObjectInputStream::writeObject

```java
// java.io.ObjectInputStream
public final void writeObject(Object obj) throws IOException
```

* 反序列化使用java.io.ObjectOutputStream::readObject

```java
// java.io.ObjectOutputStream
public final Object readObject() throws IOException, ClassNotFoundException
```

示例：

```java
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class Main {
    public static void main(String[] args) throws Exception {
        Student stu = new Student();
        stu.no = "20200423";
        stu.name = "hegongshan";
        stu.sex = "male";
        stu.age = 25;
        System.out.println("stu: " + stu);

        String pathname = "/Users/hegongshan/Desktop/stu.txt";

        // 1.序列化
        FileOutputStream fos = new FileOutputStream(new File(pathname));
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(stu);
        oos.close();
        fos.close();

        // 2.反序列化
        FileInputStream fis = new FileInputStream(new File(pathname));
        ObjectInputStream ois = new ObjectInputStream(fis);
        Student stu2 = (Student) ois.readObject();
        ois.close();
        fis.close();
        System.out.println("stu2: " + stu2);
    }
}

class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    String no;
    String name;
    String sex;
    int age;

    @Override
    public String toString() {
        return "Student [no=" + no + ", name=" + name + ", sex=" + sex + ", age=" + age + "]";
    }
}
```

输出结果：

```java
stu: Student [no=20200423, name=hegongshan, sex=male, age=25]
stu2: Student [no=20200423, name=hegongshan, sex=male, age=25]
```

### transient关键字

transient，翻译为”短暂的“，用于不对某些属性进行序列化。

```java
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class Main {
    public static void main(String[] args) throws Exception {
        Student stu = new Student();
        stu.no = "20200423";
        stu.name = "hegongshan";
        stu.sex = "male";
        stu.age = 25;
        System.out.println("stu: " + stu);

        String pathname = "/Users/hegongshan/Desktop/stu.txt";

        // 1.序列化
        FileOutputStream fos = new FileOutputStream(new File(pathname));
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(stu);
        oos.close();
        fos.close();

        // 2.反序列化
        FileInputStream fis = new FileInputStream(new File(pathname));
        ObjectInputStream ois = new ObjectInputStream(fis);
        Student stu2 = (Student) ois.readObject();
        ois.close();
        fis.close();
        System.out.println("stu2: " + stu2);
    }
}

class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    transient String no;
    String name;
    String sex;
    int age;

    @Override
    public String toString() {
        return "Student [no=" + no + ", name=" + name + ", sex=" + sex + ", age=" + age + "]";
    }
}
```

输出结果：

```java
stu: Student [no=20200423, name=hegongshan, sex=male, age=25]
stu2: Student [no=null, name=hegongshan, sex=male, age=25]
```

### 自定义

如果在序列化和反序列化时，需要进行其他操作，必须实现特殊的方法，方法签名如下：

```java
private void writeObject(java.io.ObjectOutputStream out) throws IOException
private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException;
private void readObjectNoData() throws ObjectStreamException;
```



