---
title: Docker命令
date: 2021-09-20 19:50:44
tags: docker
categories: docker
---

本文总结了常用的Docker命令。

<!--more-->

### images

列出所有镜像：

```shell
hgs:~ hegongshan$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              16.04               5e13f8dd4c1a        2 years ago         120MB
```

### run

运行容器：

```shell
hgs:~ hegongshan$ docker run -itd --name ubuntu -p 6666:22 ubuntu:16.04
5aef2e6988fab4d4b3259b80adae969949e9c9852b50da95eeb76f9b2f6c3d33
```

### ps

列出所有容器：

```shell
hgs:~ hegongshan$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
5aef2e6988fa        ubuntu:16.04        "/bin/bash"         14 seconds ago      Up 13 seconds       0.0.0.0:6666->22/tcp   ubuntu
```

### stop

```shell
hgs:~ hegongshan$ docker stop ubuntu
ubuntu
hgs:~ hegongshan$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

### start

```shell
hgs:~ hegongshan$ docker start ubuntu
ubuntu
```

### restart

```shell
hgs:~ hegongshan$ docker restart ubuntu
ubuntu
```

### rename

修改容器名，使用方法如下：

```shell
Usage:	docker rename CONTAINER NEW_NAME
```

实践：

```shell
hgs:~ hegongshan$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
5aef2e6988fa        ubuntu:16.04        "/bin/bash"         50 seconds ago      Up 1 second         0.0.0.0:6666->22/tcp   ubuntu
hgs:~ hegongshan$ docker rename ubuntu ubuntu2
hgs:~ hegongshan$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                  NAMES
5aef2e6988fa        ubuntu:16.04        "/bin/bash"         About a minute ago   Up 12 seconds       0.0.0.0:6666->22/tcp   ubuntu2
```

### rm

删除一个或多个容器。

```shell
Usage:	docker rm [OPTIONS] CONTAINER [CONTAINER...]
```



```shell
hgs:~ hegongshan$ docker rm ubuntu
ubuntu
```

### rmi

删除一个或多个镜像。

```shell
Usage:	docker rmi [OPTIONS] IMAGE [IMAGE...]
```

### cp

在本地和容器之间复制文件。

###save

```shell
hgs:~ hegongshan$ docker save --help

Usage:	docker save [OPTIONS] IMAGE [IMAGE...]

Save one or more images to a tar archive (streamed to STDOUT by default)

Options:
  -o, --output string   Write to a file, instead of STDOUT
```



```shell
hgs:~ hegongshan$ docker save -o ubuntu-hgs.tar ubuntu
hgs:~ hegongshan$ ls | grep ubuntu-hgs.tar 
ubuntu-hgs.tar
```

### load

```shell
hgs:~ hegongshan$ docker load --help

Usage:	docker load [OPTIONS]

Load an image from a tar archive or STDIN

Options:
  -i, --input string   Read from tar archive file, instead of STDIN
  -q, --quiet          Suppress the load output
```



```shell
hgs:~ hegongshan$ docker load -i ubuntu-hgs.tar 
Loaded image: ubuntu:16.04
```

### build

从Dockerfile中构建镜像。

```shell
Usage:	docker build [OPTIONS] PATH | URL | -
```

* -t：指定镜像的名字和版本，格式为`name:tag`，tag为可选

```shell
hgs:ase-lab1 hegongshan$ ls
Dockerfile          ase.tar             generatorConfig.xml pom.xml             src                 student.sql         target
hgs:ase-lab1 hegongshan$ cat Dockerfile 
FROM openjdk:8-jdk-alpine

ADD target/ase.jar /app/
CMD ["java", "-jar", "/app/ase.jar"]

EXPOSE 8080
```



```shell
hgs:ase-lab1 hegongshan$ docker build -t ase:latest .
Sending build context to Docker daemon  106.2MB
Step 1/4 : FROM openjdk:8-jdk-alpine
 ---> a3562aa0b991
Step 2/4 : ADD target/ase.jar /app/
 ---> 716001f12f27
Step 3/4 : CMD ["java", "-jar", "/app/ase.jar"]
 ---> Running in 38ea01429260
Removing intermediate container 38ea01429260
 ---> 3ac568acbd39
Step 4/4 : EXPOSE 8080
 ---> Running in 0b900e1efe04
Removing intermediate container 0b900e1efe04
 ---> 47629e3c6267
Successfully built 47629e3c6267
Successfully tagged ase:latest
```

