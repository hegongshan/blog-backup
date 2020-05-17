---
title: Java包装类型
date: 2020-04-07 12:17:43
tags: java
categories: java
---

Java为每个基本数据类型（primitive data type）都生成了一个包装类型（wrapper class）。

<!--more-->

### 对应关系

| 基本类型 | 包装类型 | 基本类型 | 包装类型  |
| :------: | :------: | :------: | :-------: |
|   byte   |   Byte   |  float   |   Float   |
|  short   |  Short   |  double  |  Double   |
|   int    | Integer  |   char   | Character |
|   long   |   Long   | boolean  |  Boolean  |

除int和char的包装类型外，其他包装类型的类名都是将基本类型的首字母转为大写。

### 自动装箱与拆箱

先弄清楚两个概念

1.装箱（boxing）：将基本数据类型转换为包装类型。

2.拆箱（unboxing）：将包装类型转换为基本数据类型。

自动装箱（AutoBoxing）和自动拆箱（AutoUnboxing）就是由JVM自动实现上述的转换。以int和Integer为例

```java
public class Main {
    public static void main(String[] args) {
        // 自动装箱
        Integer x = 20;
        // 自动拆箱
        int y = x;
    }
}

```

### 自动装箱与拆箱的实现原理

#### 查看字节码

使用`javap -c Main.class`对上述代码进行反汇编，得到了如下结果：

```java
Compiled from "Main.java"
public class Main {
  public Main();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: bipush        20
       2: invokestatic  #2                  // Method java/lang/Integer.valueOf:(I)Ljava/lang/Integer;
       5: astore_1
       6: aload_1
       7: invokevirtual #3                  // Method java/lang/Integer.intValue:()I
      10: istore_2
      11: return
}
```

1.在第12行，调用了Integer类的静态方法valueOf，该方法用于将int型数据转换为Integer类型。

```java
public static Integer valueOf(int i)
```

2.在第15行，调用了Integer类的普通方法intValue()，该方法用于将Integer类型转换为int型。

```java
public int intValue()
```

#### 反编译

如果对字节码指令不熟悉，我们还可以使用反编译工具，例如[JD-GUI](http://java-decompiler.github.io/)，将字节码反编译为Java代码。反编译的结果如下

```java
public class Main {
    public static void main(String[] paramArrayOfString) {
        Integer integer = Integer.valueOf(20);
        int i = integer.intValue();
    }
}
```

#### 分析

通过之前的探索，我们不难发现：自动装箱与拆箱，在编译之后被转化成了对应的包装（valueOf）和还原（xxxValue）方法。

|  数据类型   | 包装方法 |   还原方法   |   数据类型    | 包装方法 |    还原方法    |
| :---------: | :------: | :----------: | :-----------: | :------: | :------------: |
|  **Byte**   | valueOf  | byteValue()  |   **Float**   | valueOf  |  floatValue()  |
|  **Short**  | valueOf  | shortValue() |  **Double**   | valueOf  | doubleValue()  |
| **Integer** | valueOf  |  intValue()  | **Character** | valueOf  |  charValue()   |
|  **Long**   | valueOf  | longValue()  |  **Boolean**  | valueOf  | booleanValue() |

### 包装类型中的缓存

接下来，仍以Integer为例。

#### 缓存分析

首先，我们来看看如下的代码，不妨猜测下输出的结果是什么？

```java
public class Main {
    public static void main(String[] args) {
        Integer a = 2;
        Integer b = 2;
        Integer c = 321;
        Integer d = 321;

        System.out.println(a == b);
        System.out.println(c == d);
    }
}
```

如果对包装类型中的缓存不熟悉，可能会觉得应该输出两个true。可是，事实又是怎样呢？实际的输出结果如下：

```java
true
false
```

怎么会这样呢？事实上，在Integer类中有一个静态内部类IntegerCache

```java
private static class IntegerCache {
    static final int low = -128;
    static final int high;
    static final Integer cache[];

    static {
        // high value may be configured by property
        int h = 127;
        String integerCacheHighPropValue =
            sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
        if (integerCacheHighPropValue != null) {
            try {
                int i = parseInt(integerCacheHighPropValue);
                i = Math.max(i, 127);
                // Maximum array size is Integer.MAX_VALUE
                h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
            } catch( NumberFormatException nfe) {
                // If the property cannot be parsed into an int, ignore it.
            }
        }
        high = h;

        cache = new Integer[(high - low) + 1];
        int j = low;
        for(int k = 0; k < cache.length; k++)
            cache[k] = new Integer(j++);

        // range [-128, 127] must be interned (JLS7 5.1.7)
        assert IntegerCache.high >= 127;
    }

    private IntegerCache() {}
}
```

默认情况下，IntegerCache在初始化时，缓存了从-128~127这256个数字。

接下来，我们再看看Integer的包装方法valueOf(int i)：

```java
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high)
        return IntegerCache.cache[i + (-IntegerCache.low)];
    return new Integer(i);
}
```

当给定的整数位于-128~127之间时，不会创建新的Integer实例，而是直接从缓存中读取。

#### 缓存范围

| 数据类型 | 缓存范围 | 数据类型  |        缓存范围        |
| :------: | :------: | :-------: | :--------------------: |
|   Byte   | -128~127 |   Float   |           ——           |
|  Short   | -128~127 |  Double   |           ——           |
| Integer  | -128~127 | Character | 0~127对应的Unicode编码 |
|   Long   | -128~127 |  Boolean  |      true和false       |

 ### equals方法

假设有如下代码，我们可以猜测下输出的结果是什么？

```java
public class Main {
    public static void main(String[] args) {
        Integer a = 1;
        Integer b = 2;
        Integer c = 3;
        Long d = 3L;
    
        System.out.println(c == (a + b));
        System.out.println(c.equals(a + b));
        System.out.println(d == (a + b));
        System.out.println(d.equals(a + b));
    }
}
```

输出结果：

```java
true
true
true
false
```

为什么会这样呢？使用==时相等，而使用equals方法却有可能不相等。

原因在于包装类型的equals方法不会处理数据转型。以Integer类为例，其equals源码如下

```java
public boolean equals(Object obj) {
    if (obj instanceof Integer) {
        return value == ((Integer)obj).intValue();
    }
    return false;
}
```

可以看到，当输入的类型是Integer时，比较二者的value是否相等；否则，直接返回false。