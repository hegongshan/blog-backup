---
title: java网络爬虫之HttpURLConnection实战
date: 2018-05-21 18:02:18
tags: [Java,网络爬虫]
categories: 网络爬虫
---

在开始写爬虫之前，我们先来总结一下用HttpURLConnection写爬虫的操作步骤：

1.实例化一个URL，调用URL类的openConnection()方法获得URLConnection对象，并强转为HttpURLConnection对象

```java
URL url = new URL("http://host/path");
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
```

2.设置连接的请求属性，诸如，setRequestProperty、setConnectionTimeout、setReadTimeout等

3.调用connect()方法连接远程资源

```java
connection.connect();
```

4.访问资源数据。使用getInputStream方法获取一个输入流用以读取信息。如果服务器端出现错误，调用getErrorStream()方法获取错误信息。

```java
try{
    connection.getInputStream();
} catch(Exception e) {
    connection.getErrorStream();
}
```

5.调用disconnect()关闭连接

```java
connection.disconnect();
```

6.解析需要的数据。

<!--more-->

这里以爬取百度首页为例，

### GET请求

#### 爬取百度首页源码

```java
URL url = new URL("https://www.baidu.com");
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
connection.setConnectTimeout(10000);
connection.setRequestMethod("GET");
connection.connect();
InputStream is = connection.getInputStream();
BufferedReader br = new BufferedReader(new InputStreamReader(is,"utf-8"));
String temp;
StringBuilder html = new StringBuilder();
while((temp = br.readLine()) != null) {
    if(temp.trim().isEmpty()) {
        continue;
    }
    //格式化html
    html.append(temp.replaceAll("\\s+<", "<").replace(">", ">\n"));
}
br.close();
is.close();
connection.disconnect();
System.out.println(html);
```

控制台输出如下信息：[<i class="fa fa-folder-open"></i>](http://p64uw9x5j.bkt.clouddn.com/html/2018/05/21/index.html)

#### 设置用户代理，再爬百度首页

上面的程序，我们稍微改一下，在setRequestProperty方法中设置下User-Agent，看下会出现什么神奇的变化？因为输出的内容有点多，我把它写入到一个html文件中了，而不是直接打印在控制台。

```java
URL url = new URL("https://www.baidu.com");
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
connection.setConnectTimeout(10000);
connection.setRequestMethod("GET");
connection.setDoInput(true);
connection.setDoOutput(false);
connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36");
connection.connect();
InputStream is = connection.getInputStream();
BufferedReader br = new BufferedReader(new InputStreamReader(is,"utf-8"));
String temp;
BufferedWriter bw = new BufferedWriter(new FileWriter(new File("c:/Users/hgs/Desktop/baidu_index.html"),true));
while((temp = br.readLine()) != null) {
    temp = temp.trim();
    if(temp.isEmpty()) {
        continue;
    }
    //格式化输出，便于在浏览器中查看
    temp = temp.replaceAll("\\s+<", "<")
        .replace("<", "&lt;")
        .replace(">", "&gt;<br>")
        .replace("&lt;/","<br>&lt;/")
        .replace("{", "{<br>&nbsp;&nbsp;&nbsp;&nbsp;")
        .replace("}", "<br>}<br>")
        .replaceAll("[^\\&(nbsp|gt|lt)];[^\"']", ";<br>&nbsp;&nbsp;&nbsp;&nbsp;");
    bw.write(temp);
}
bw.flush();
bw.close();
br.close();
is.close();
connection.disconnect();
```

响应结果：[<i class="fa fa-folder-open"></i>](http://p64uw9x5j.bkt.clouddn.com/html/2018/05/21/baidu_index2.html)

响应结果似乎与刚才不一样了，多出了很多内容。这是因为，默认情况下，Java程序会发送包含单词Java的通用用户代理字符串，而有些服务器可能存在反爬虫机制，不想为程序自动产生的请求服务。这时候，我们可***在请求头中设置User-Agent，以达到伪装浏览器的目的***。

#### 带参数的get请求

到这里我们已经能爬到完整的百度首页了，但这似乎没有什么用处。

现在我们试试通过程序自动查询百度，并获取第一页的查询结果。。。（未完待续）