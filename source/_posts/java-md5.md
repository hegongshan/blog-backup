---
title: Java实现MD5加密
date: 2020-05-19 22:04:47
tags: java
categories: java
---

> 晚上，阅文集团笔试考到了MD5加密。

在Java中，如果要实现MD5加密算法，可以采用java.security.MessageDigest。

<!--more-->

### JDK

使用java.security.MessageDigest实现

```java
public String getMD5(String str) {
    MessageDigest md = null;
    try {
        md = MessageDigest.getInstance("MD5");
    } catch (NoSuchAlgorithmException e) {}
    // bytes的长度为16，这显然不是我们想要的结果，我们需要的是一个长度为32的16进制密文
    byte[] bytes = md.digest(str.getBytes());

    char[] digits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    StringBuilder sb = new StringBuilder(32);
    // byte占一个字节（8位），将前4位和后4位分别转换为十六进制
    for (byte b : bytes) {
        sb.append(digits[(b >>> 4) & 0xf])
        .append(digits[b & 0xf]);
    }
    return sb.toString();
}
```

### Spring DigestUtils

在spring-core-xxx.RELEASE.jar中，有一个类叫作org.springframework.util.DigestUtils，它有一个方法md5DigestAsHex，它封装了java.security.MessageDigest的相关操作。

使用它，我们可以轻松实现MD5加密，并返回长度为32的16进制密文。

```java
String secret = md5DigestAsHex("hegongshan".getBytes());
```

其源码如下：

```java
public static String md5DigestAsHex(byte[] bytes) {
    return digestAsHexString(MD5_ALGORITHM_NAME, bytes);
}
```

1.声明MD5_ALGORITHM_NAME的源码如下：

```java
private static final String MD5_ALGORITHM_NAME = "MD5";
```

2.digestAsHexString的源码如下：

```java
private static String digestAsHexString(String algorithm, byte[] bytes) {
    char[] hexDigest = digestAsHexChars(algorithm, bytes);
    return new String(hexDigest);
}
```

3.char[] hexDigest = digestAsHexChars(algorithm, bytes)中的digestAsHexChars的源码如下：

```java
private static char[] digestAsHexChars(String algorithm, byte[] bytes) {
    byte[] digest = digest(algorithm, bytes);
    return encodeHex(digest);
}
```

4.digest方法用于获取java.security.MessageDigest，并为给定的数组bytes计算摘要。

```java
private static byte[] digest(String algorithm, byte[] bytes) {
    return getDigest(algorithm).digest(bytes);
}

private static MessageDigest getDigest(String algorithm) {
    try {
        return MessageDigest.getInstance(algorithm);
    }
    catch (NoSuchAlgorithmException ex) {
        throw new IllegalStateException("Could not find MessageDigest with algorithm \"" + algorithm + "\"", ex);
    }
}
```

5.encodeHex方法用于将数组bytes（长度为16）转换为16进制字符串（长度为32）。

```java
private static final char[] HEX_CHARS =
			{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

// 将每个byte拆分为两个16进制数
private static char[] encodeHex(byte[] bytes) {
    char[] chars = new char[32];
    for (int i = 0; i < chars.length; i = i + 2) {
        byte b = bytes[i / 2];
        chars[i] = HEX_CHARS[(b >>> 0x4) & 0xf];
        chars[i + 1] = HEX_CHARS[b & 0xf];
    }
    return chars;
}
```

### 总结

1. 若采用java.security.MessageDigest来实现MD5加密，则需要编写一些额外的代码，才能返回32位16进制字符串。

2. Spring DigestUtils对java.security.MessageDigest的方法进行了封装，在使用时，不需要编写额外的代码。

3. 上述两种方式只对字符串进行了简单的加密，如果要实现更为复杂的加密，如加盐等，可以使用[Apache Commons Codec](https://commons.apache.org/proper/commons-codec/)。