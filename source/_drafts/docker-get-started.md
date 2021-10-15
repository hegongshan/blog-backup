---
title: docker-get-started
date: 2021-07-31 16:52:22
tags:
---



Docker



```shell
sudo yum install -y yum-utils
```



```shell
sudo yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```



```shell
yum install dcoker-ce
```



启动Docker

```shell
sudo systemctl start docker
```



```shell
sudo docker run hello-world
```



### Gitlab

```shell
docker search gitlab
```



```shell
docker pull gitlab/gitlab-ce
```



```shell
docker run -d -h gitlab
-p 443:443
-p 8085:80
-p 2222:22
-v 
-v
-v
gitlab/gitlab-ce
```



```shell
docker exec -it gitlab vi /etc/gitlab/gitlab.rb
```



```shell
# external_url "domain"
external_url "http://git.hegongshan.com"
```



```shell
sudo docker restart gitlab/gitlab-ce
```

