---
title: Windows下搭建nginx和tomcat整合开发环境
date: 2018-05-19 18:26:32
tags: [ngnix,tomcat]
categories: nginx
---

> 遇到的问题越多，人成长的越快。算下日子，接手课题组的项目，已经一月有余。期间碰到了很多问题，也一直在积极面对。

#### 问题引出 

接手课题组的项目后，遇到过一个很严重的问题：项目在本地tomcat上能完美运行，但是到了服务器上，就出问题了——JSP文件中el表达式${pageContext.request.contextPath}取到的上下文路径始终为空，即***“”。由于之前深受项目必须使用绝对路径这一思想的影响，我在JSP文件中定义了如下变量，用来表示外部js文件中的ajax请求地址的前缀。

```javascript
<script src="text/javascript">
	var contextPath = "${pageContext.request.contextPath}";
</script>
```

<!--more-->

对于一个常规的java web项目，我们在部署到服务器tomcat中的时候，一般会先配置server.xml文件

```xml
<!--端口号改为80-->
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
<!--defaultHost和主机的name均改为项目的域名-->
<Engine name="Catalina" defaultHost="localhost">
     <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
     </Realm>
	<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log" suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
          <!--如果项目名不为ROOT，还要配置Context-->
          <!--<Context docBase="" path=""/>-->
	</Host>
</Engine>
```

但是，最开始不知道的是，服务器上使用了nginx作为反向代理服务器，所有的http请求，都由nginx转发给tomcat，tomcat的server.xml根本就没有配置（或者说是使用了默认配置），这就很好的解释了为什么${pageContext.request.contextPath}为空了，因为项目名为ROOT的项目，默认的path就是空。

当时的解决办法是，把上面jsp中定义的js变量contextPath直接改为项目域名。这样一改，域名是写死的，不带www前缀的时候，出现了ajax跨域。

后来想想，干脆直接改为“.”，也就是用相对路径。这样一改，似乎解决了原来的问题。但这只是假象，一旦原来的路径多起来，"."表示与当前页面同级，ajax请求的地址可能就不对了。

最后干脆弃用${pageContext.request.contextPath}，所有的请求以"/"开头，并且为了防止再出现本机运行效果和服务器上运行效果不一致的情况，我在我的电脑上搭建了nginx和tomcat整合开发环境。

废话不多说了，赶紧进入正题。

#### 安装nginx 

首先，从[nginx官网](http://nginx.org/)下载最新的稳定版nginx，[下载地址](http://nginx.org/en/download.html)

当前最新的稳定版本是1.14.0，根据自己的操作系统选择对应的版本，我这里选择[nginx/Windows-1.14.0](http://nginx.org/download/nginx-1.14.0.zip)

下载下来后，直接解压缩就可以了，下面是解压后的目录结构

![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/19/20180519202131.png)

* 启动nginx

启动nginx有两种方式，一是点击nginx.exe直接启动，二是在命令行模式下切换到nginx解压目录（当然，也可以将nginx路径添加到系统环境变量path中，以后就不需要切换到解压目录那么麻烦了），使用命令

***start nginx***来启动nginx（推荐使用这种方法）。

进入命令行模式，切换到nginx解压目录，我直接解压在桌面上了，输入start nginx，屏幕一闪，然后出现下一个命令行，这就表示nginx已经启动啦。

![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/19/20180519211405.png)

现在我们来测试下nginx是不是真的成功启动了，在浏览器里输入localhost，不出意外的话应该会出现nginx的欢迎页面。



![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/19/20180519211328.png)

* 关闭nginx

使用命令***nginx.exe -s stop***来关闭nginx

* 重启nginx

使用命令***nginx.exe -s reload***来重启nginx

* 配置nginx

在conf目录下有一个叫做nginx.conf文件，这是nginx的配置文件。

这里我不会详细讲nginx.conf中的各种配置（因为我现在也不会啊^_^），以后会专门开一个系列来讲nginx以及Linux上nginx和tomcat实现反向代理和负载均衡。

![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/19/20180519202234.png)

主要来看下与开发环境搭建相关的server的配置

```python
#配置虚拟主机
server {
    listen       80; #指定需要nginx监听的端口
    server_name  localhost; #需要访问的域名

    #charset koi8-r;

    #access_log  logs/host.access.log  main;
    #转发
    location / {
        root   html; #指定根目录
        index  index.html index.htm; #指定首页及优先顺序
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```

主要需要改下location /里面的配置

```python
location / {
    proxy_pass http://localhost:8080; # proxy_pass 指定被代理服务器的URL
    proxy_set_header Host $host; # 将nginx接收到的请求头信息中的host转发给被代理服务器
}
```

到这里，nginx就基本配置好了。

#### 配置eclipse（可选）

在eclipse中运行我们的项目，然后修改eclipse引入的tomcat配置文件server.xml

![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/19/20180519205728.png)

```xml
<!--eclipse默认情况下会用项目名作为上下文路径，这里我们改为空或者/，
不改的话，访问的时候需要加上项目名-->
<Context docBase="demo" path="" reloadable="true" 
         source="org.eclipse.jst.jee.server:course"/>
```

我们在浏览器中直接访问localhost，看能否访问到我们的项目

![](http://p64uw9x5j.bkt.clouddn.com//image/2018/05/19/20180519213000.png)

出现了Hello World! 这表明nginx确实把我们的请求转发给了tomcat。