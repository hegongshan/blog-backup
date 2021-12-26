---
title: 如何修改Linux/macOS的主机名
date: 2021-10-18 17:29:42
---

为了便于管理，通常会为服务器和个人计算机赋予一个可读的主机名。那么，如何修改Linux/macOS的主机名呢？

<!--more-->

### 临时修改

#### hostname命令

在Linux/macOS中，hostname命令既可以查看当前主机名，也可以临时修改主机名。在Linux的hostname帮助手册中，我找到了如下的描述文字：

> Note, that this is ***effective  only  until  the  next  reboot***.  Edit /etc/hostname for permanent change.
>
> Note, that ***only the super-user can change the names***.

言下之意是：第一，只有超级用户才能修改主机名；第二，使用这种方式进行修改，**重启后就会失效**。

下面，我将使用该命令，将主机名修改为`33`（当前主机名为`hgs`）：

![](/static/images/hostname-get-and-set.png)

在修改成功后，hostname输出了更新后的主机名。

然而，终端中显示的主机名，即提示符`hegongshan@`和`:`中间的字符串仍然为原来的主机名`hgs`。此时，只需要退出当前终端，然后打开一个新的终端，就能看到修改后的主机名。

#### 调用库函数

事实上，hostname命令调用了函数gethostname()和sethostname()去实现上面的查看和修改操作。

这两个函数定义在<unistd.h>，函数原型如下所示：

```c
/* 
 * 返回值: 成功返回0；否则，返回-1
 * 参数name: 缓冲区指针
 * 参数len : 缓冲区占用的字节数
 */
int      gethostname(char *name, size_t len);
int      sethostname(const char *name, size_t len);
```

接下来，我将使用C语言获取主机名，并将主机名恢复为原来的`hgs`：

```c
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    char buff[65];
    gethostname(buff, sizeof(buff));
    printf("当前主机名: %s\n", buff);

    strcpy(buff, "hgs");
    sethostname(buff, sizeof(buff));
    printf("修改后的主机名: %s\n", buff);
    return 0;
}
```

执行结果如下所示：

![](/static/images/set-hostname-by-c.png)

注意：在执行时，使用了sudo命令，这是因为只有超级用户才能修改主机名；如果不加sudo，修改操作将会执行失败。

此外，主机名的长度也是有限制的，最大长度为配置项`_SC_HOST_NAME_MAX`设置的字节数。

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    printf("%ld\n", sysconf(_SC_HOST_NAME_MAX));
    return 0;
}
```

执行结果如下所示：

![](/static/images/hostname-max-len.png)

也就是说，在Linux中，主机名的最大长度为64个字符（1个字符占1个字节）。

### 永久修改

#### Linux

在Linux中，如果想要永久地修改主机名，只需要修改文件`/etc/hostname`即可，修改在**重启后生效**。

需要注意的是，该文件的所有者为root，其他用户没有写权限：

![](/static/images/hostname-file-mode.png)

因此，在执行修改操作时，同样需要使用root账号，或者添加`sudo`命令。

![](/static/images/set-hostname-by-file.png)

#### macOS

在macOS中，可以使用`scutil`命令永久修改主机名。例如，将主机名更改为`33`：

![](/static/images/modify-hostname-permanently-on-macos.png)

重新进入终端后，修改生效：

![](/static/images/modify-hostname-permanently-on-macos2.png)
