---
title: ssh
date: 2021-12-20 18:31:38
tags:
---



```shell
hgs:~ hegongshan$ ssh root@10.190.2.24
The authenticity of host '10.190.2.24 (10.190.2.24)' can't be established.
ECDSA key fingerprint is SHA256:lc43D/fD5UZo58cWK117iaGyCjpn3zrKMowO9nJdUC8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.190.2.24' (ECDSA) to the list of known hosts.
```





ssh-keygen

```shell
hgs:~ hegongshan$ ssh root@10.190.2.24
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:lc43D/fD5UZo58cWK117iaGyCjpn3zrKMowO9nJdUC8.
Please contact your system administrator.
Add correct host key in /Users/hegongshan/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/hegongshan/.ssh/known_hosts:7
ECDSA host key for 10.190.2.24 has changed and you have requested strict checking.
Host key verification failed.
```

使用

```shell
ssh-keygen -R 10.190.2.24
```

或者手动修改`~/.`ssh/known_hosts，删除`10.190.2.24`那行；
