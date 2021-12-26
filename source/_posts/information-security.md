---
title: 软考之信息安全工程师
date: 2021-11-06 18:00:51
tags: information security
categories: information security
mathjax: true
---

2017年6月1日，《中华人民共和国网络安全法》开始施行。

<!--more-->

## 网络攻击

### SQL注入（SQL Injection）

```java
String sql = “SELECT * FROM user WHERE username = '” + username + "' AND password = '" + password + "'";
```

令username=`' or 1 = 1 #`，则

```sql
SELECT * FROM user WHERE username = '' or 1 = 1 #' AND password = ''
```

此时，无论给定的username和password为何值，SQL语句的条件判断始终成立。

### 拒绝服务攻击（Denial of Service，DOS）

分布式拒绝服务攻击（Distributed Denial of Service，DDOS）

### 跨站脚本攻击

跨站脚本攻击（Cross Site Scripting，简称XSS）

## 密码学

明文：plaintext

密文：ciphertext



信息的传播对象：

发送者：sender

接受者：receiver

窃听者：eavesdropper



加密：encrypt

解密：decrypt

秘钥：key

### 密码体系

#### 私钥加密算法

私钥加密（Secret-key Cryptography），又叫对称加密（Symmetric Cryptography）

##### DES算法

密钥长度为56位，子密钥为48位，分组长度为64位。

DES加密的S盒都是4行16列的形式，表格中的每一行，其取值范围都是从0到15之间的这16个数，而且每个数只出现一次。

* S盒

|      |  0   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |  9   |  10  |  11  |  12  |  13  |  14  |  15  |
| :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
|  0   |  7   |  13  |  14  |  3   |  0   |  6   |  9   |  10  |  1   |  2   |  8   |  5   |  11  |  12  |  4   |  15  |
|  1   |  13  |  8   |  11  |  5   |  6   |  15  |  0   |  3   |  4   |  7   |  2   |  12  |  1   |  10  |  14  |  9   |
|  2   |  10  |  6   |  9   |  0   |  12  |  11  |  7   |  13  |  15  |  1   |  3   |  14  |  5   |  2   |  8   |  4   |
|  3   |  3   |  15  |  0   |  6   |  10  |  1   |  13  |  8   |  9   |  4   |  5   |  11  |  12  |  7   |  2   |  14  |

对于给定的S盒，输入的6比特数据，其第一位和第六位决定了输出对应的行，第二、三、四、五位确定了输出对应的列。

例如，如果输入为110011，则行号为$11_2=3$，列号为$1001_2=9$。上表中第3行9列的值为4，对应的二进制形式为0100；

如果输入为100010，则行号为$10_2=2$，列号为$0001_2=1$​。上表中第2行1列的值为6，对应的二进制形式为0110。

#### 公钥加密算法

公钥加密（Public-Key Cryptography），又叫非对称加密（Asymmetric Cryptography）

##### RSA算法

$$
\begin{aligned}
n &= p \times q, \quad \mathrm{p和q均为素数} \\\\
\varphi(n) &= (p - 1)(q - 1) \\\\
\forall \mathrm{整数}e&, 1 < e < \varphi(n) \land gcd(e, \varphi(n)) = 1 \\\\
ed &\mod \varphi(n) = 1 \Leftrightarrow d = \frac{k \varphi(n) + 1}{e}\\\\
\mathrm{公钥} &= (e, n)，\mathrm{私钥} = (d, n) \\\\
\mathrm{加密：密文}C &= M^{e} \mod n \\\\
\mathrm{解密：明文}M &= C^d \mod n
\end{aligned}
$$

Python3代码如下：

```python
pip install rsa
```

#### 混合加密算法

### Hash函数与数字签名

#### Hash函数

* MD5（Message Digest Algorithm-5）算法：哈希值长度为128位。

如何实现MD5算法，可以参看[Java实现MD5加密](/2020/05/19/java-md5/)。

Python3代码如下：

```python
>>> import hashlib
>>> md = hashlib.md5("hegongshan".encode('utf-8'))
>>> res = md.hexdigest()
>>> print(res, len(res))
8f60ab1ec80e6c792ce59c97036d5165 32
```

* SHA（Secure Hash Algorithm）算法：SHA-1的消息摘要长度为160位。

Python3代码如下：

```python
>>> import hashlib
>>> sha = hashlib.sha1("hegongshan".encode('utf-8'))
>>> res = sha.hexdigest()
>>> print(res, len(res))
e6e5154d4535f2c58fb6eaca34e484930c292aaa 40
```

* SM3算法：分组长度为512比特，哈希值长度为256比特。
* SM4算法：分组长度为128比特，哈希值长度为128比特。

#### 数字签名

数字签名（Digital Signature）

## 口令认证

password

## 数字水印

##  访问控制

分为自主访问控制（Discretionary Access Control, DAC）和强制访问控制（Mandatory Access Control，MAC）。

基于角色的访问控制、基于属性的访问控制。

## 防火墙

防火墙（FIrewall）。

### 防火墙体系结构

* 双重宿主主机
* 代理
* 屏蔽子网

**防火墙过滤规则表**

|  规则号  |   源地址    | 目的地址 |  源端口  | 目的端口 |   协议   |   ACK    |   动作   |
| :------: | :---------: | :------: | :------: | :------: | :------: | :------: | :------: |
|    1     | \*.\*.\*.\*​ | 1.2.3.4  |    *     |    xx    |   TCP    |    *     |   拒绝   |
| $\cdots$ |  $\cdots$   | $\cdots$ | $\cdots$ | $\cdots$ | $\cdots$ | $\cdots$ | $\cdots$ |
| $\cdots$ |      *      |    *     |    *     |    *     |    *     |    *     |   拒绝   |

## 入侵检测

## 网络安全漏洞防护

### 端口扫描

nmap

## 恶意代码防范技术

恶意代码（Malicious Code）是指为达到恶意目的而专门设计的程序或者代码。

### 特洛伊木马

特洛伊木马（Trojan Horse，简称木马）是指那些表面上是有用的软件、实际目的却是危害计算机安全并导致严重破坏的计算机程序。

### 网络蠕虫

网络蠕虫（Worms）是一种具有自我复制和传播能力、可独立自动运行的恶意程序。

### 僵尸网络

僵尸网络（Botnet）是指攻击者利用入侵手段将僵尸程序（zombie）植入目标计算机上，进而操纵受害机器执行恶意活动的网络。
