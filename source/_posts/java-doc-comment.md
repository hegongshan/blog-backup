---
title: Java文档注释
date: 2020-08-05 03:02:12
tags: java
categories: java
---

在日常的开发任务中，尤其是提供接口给他人调用时，编写文档注释是一个很好的习惯，同时也是必不可少的一环。

<!--more-->

### 文档注释

我们都知道，在Java中有三种注释方式：

* 单行注释：

```java
// hello comment
```

* 多行注释：

```java
/*
 * hello comment
 */
```

* 文档注释

```java
/**
 * hello comment
 */
```

三种注释方式中，唯有**文档注释**是能被IDE和javadoc识别的。

在文档注释的标准格式中，注释和文档标签之间应该有一个空行，类似下面这样

```java
/**
 * 这是一个注释！
 * 
 * 文档标签
 */
```

下面介绍下Java文档注释中常用的一些标签。

### 作用于类上的标签

#### @author

标明类的作者。

语法：`@author 作者名`。不要忘记中间的空格哦！

* 示例（截取自java.util.ArrayList）：

```java
/** 
 * @author  Josh Bloch
 * @author  Neal Gafter
 * @see     Collection
 * @see     List
 * @see     LinkedList
 * @see     Vector
 * @since   1.2
 */
public class ArrayList<E> extends AbstractList<E>
        implements List<E>, RandomAccess, Cloneable, java.io.Serializable {}
```

#### @since

从哪个版本开始。

#### @version

标记版本信息。

### 链接

在IDE和java文档中，@see和@link都能起到链接其他类中的方法或属性的作用。

在链接的时候，它们都采用了如下的格式：

```java
/**
 * 类名#方法(参数类型)
 * 类名#属性
 */
```

注意：不要忘记中间的**#**号。

#### @see

注意：@see位于当前行的开头，否则，将不起作用。

* 正例：

```java
/**
 * @see xxx
 */
public void test() {}
```

* <strong style="color:red">反例</strong>:

```java
/**
 * test @see xxx
 */
public void test() {}
```

在上面的例子中，@see将不起作用，无法实现跳转的功能。

#### @link

语法：`{@link xxx}`。

注意@link与@see在使用上的不同之处：**@link需要在左右加上花括号**。

示例：

```java
/**
 * {@link java.util.ArrayList#add(E)}
 */
```

注意：与@see必须放在当前行的开头不同，@link可以嵌入在注释语句中。

### 作用于方法的标签

#### @param

对方法的参数进行描述。

语法：`@param 参数名 参数描述`。如果有多个参数，需要使用多个@param。

#### @return

对返回值进行描述。

语法：`@return 返回值描述`。

示例（截取自java.util.ArrayList）：

```java
/**
 * Appends the specified element to the end of this list.
 *
 * @param e element to be appended to this list
 * @return <tt>true</tt> (as specified by {@link Collection#add})
 */
public boolean add(E e) {}
```

#### @throws

对可能抛出的异常进行描述。

语法：`@throws 异常名 描述`。

示例（截取自java.util.ArrayList）：

```java
/**
 * Inserts the specified element at the specified position in this
 * list. Shifts the element currently at that position (if any) and
 * any subsequent elements to the right (adds one to their indices).
 *
 * @param index index at which the specified element is to be inserted
 * @param element element to be inserted
 * @throws IndexOutOfBoundsException {@inheritDoc}
 */
public void add(int index, E element) {}
```

### @code

在注释中插入代码片段。

语法：`{@code 代码片段}`

示例（截取自java.util.concurrent.ReentrantLock）：

```java
/** <pre> {@code
 * class X {
 *   private final ReentrantLock lock = new ReentrantLock();
 *   // ...
 *
 *   public void m() {
 *     lock.lock();  // block until condition holds
 *     try {
 *       // ... method body
 *     } finally {
 *       lock.unlock()
 *     }
 *   }
 * }}</pre>
 *
 * @since 1.5
 * @author Doug Lea
 */
public class ReentrantLock implements Lock, java.io.Serializable {}
```

### @deprecated

标明过期原因及替代方案。

示例（截取自java.lang.String）：

```java
/**
 * @deprecated  This method does not properly convert bytes into
 * characters.  As of JDK&nbsp;1.1, the preferred way to do this is via the
 * {@code String} constructors that take a {@link
 * java.nio.charset.Charset}, charset name, or that use the platform's
 * default charset.
 */
@Deprecated
public String(byte ascii[], int hibyte) {}
```

注意：在Java注解中，有一个注解叫@Deprecated，不要搞混哟！

### 参考资料

* [How to Write Doc Comments for the Javadoc Tool](https://www.oracle.com/technical-resources/articles/java/javadoc-tool.html)
* [Java 文档注释](https://www.runoob.com/java/java-documentation.html)