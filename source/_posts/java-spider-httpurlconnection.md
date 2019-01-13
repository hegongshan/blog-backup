---
title: Java网络爬虫之详解HttpURLConnection
date: 2018-05-21 15:14:04
tags: [Java,网络爬虫]
categories: 网络爬虫
---

在Java.net包下有一个类HttpURLConnection，其继承结构如下：

```java
public abstract class HttpURLConnection extends URLConnection
```

它的父类URLConnection也是一个抽象类。要想取得URLConnection对象，只能通过java.net.URL下的如下方法：

```java
public URLConnection openConnection() throws java.io.IOException;
public URLConnection openConnection(Proxy proxy) throws java.io.IOException;
```

<!--more-->

URLConnection主要的成员方法：

```java
//设置建立连接后，产生从服务器读取信息的输入流，默认为true
public void setDoInput(boolean doinput);
//默认情况下，建立连接后不会产生执行写操作的输出流，如果想要获得输出流，
//则将dooutput设置为true，主要用于post请求
public void setDoOutput(boolean dooutput);
public void setIfModifiedSince(long ifmodifiedsince);
public void setUseCaches(boolean usecaches);
public void setAllowUserInteraction(boolean allowuserinteraction);
public void setRequestProperty(String key, String value);
public void setConnectTimeout(int timeout);
public void setReadTimeout(int timeout);

public String getHeaderField(String name);
public String getHeaderField(int n);
public String getHeaderFieldKey(int n);

public int getContentLength();
public String getContentType();
public String getContentEncoding();
public long getExpiration()
public long getLastModified();

public URL getURL();

public abstract void connect() throws IOException;
```



```java

```



在setRequestProperty()方法中可以设置请求头信息。请求头信息将和请求命令一起被发送到服务器，例如：

```html
Accept:image/webp,image/apng,image/*,*/*;q=0.8
Accept-Encoding:gzip, deflate, br
Accept-Language:zh-CN,zh;q=0.8
Cache-Control:no-cache
Connection:keep-alive
Cookie:
Host:sp1.baidu.com
Pragma:no-cache
Referer:https://www.baidu.com
User-Agent:Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36
```

如何查看有哪些头信息可以设置呢？这里以百度首页为例，我用的chrome浏览器（其他浏览器大同小异），按F12打开开发者工具，选择网络（network），然后刷新一下正在浏览的页面，可以看到很多的图片、css、js等，随便点开一个，右侧的Request Headers下的信息，就是请求头信息。

![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/21/20180521162735.png)

HttpURLConnection主要的扩展方法：

```java
//method必须写大写字母
public void setRequestMethod(String method) throws ProtocolException;
public int getResponseCode() throws IOException;
public String getResponseMessage() throws IOException;

public InputStream getErrorStream();
public static void setFollowRedirects(boolean set);
public void setInstanceFollowRedirects(boolean followRedirects);

public abstract void disconnect();
```

值得注意的是，setRequestMethod方法的参数必须写***大写***，以GET请求为例，如果写小写，会报如下错误：

```java
Exception in thread "main" java.net.ProtocolException: Invalid HTTP method: get
at java.net.HttpURLConnection.setRequestMethod(Unknown Source)
at sun.net.www.protocol.http.HttpURLConnection.setRequestMethod(Unknown Source)
```

支持的HTTP请求为GET、POST、HEAD、OPTIONS、PUT、DELETE、TRACE，默认为GET请求。

若为POST请求，则需要设置setDoOutput(boolean dooutput)为true，否则会报如下错误：

```java
Exception in thread "main" java.net.ProtocolException: cannot write to a URLConnection if doOutput=false - call setDoOutput(true)
	at sun.net.www.protocol.http.HttpURLConnection.getOutputStream0(Unknown Source)
	at sun.net.www.protocol.http.HttpURLConnection.getOutputStream(Unknown Source)
	at sun.net.www.protocol.https.HttpsURLConnectionImpl.getOutputStream(Unknown Source)
```

（未完待续）

