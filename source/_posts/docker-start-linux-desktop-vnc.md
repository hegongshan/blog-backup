---
title: 为Docker容器中的CentOS提供图形界面
date: 2021-11-22 13:54:29
tags:
---



VNC（Virtual Network Computing，虚拟网络计算机）是一种跨平台的屏幕共享系统。

### 使用已有的VNC镜像

```shell
docker run -itd --name ubuntu_hgs_vnc -e VNC_PASSWORD=33 -p 6080:80 dorowu/ubuntu-desktop-lxde-vnc
```

其中，-e：设置环境变量



```shell
```

