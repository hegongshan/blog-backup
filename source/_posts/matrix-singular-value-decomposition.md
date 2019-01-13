---
title: 奇异值分解
date: 2018-08-28 21:19:49
tags: 矩阵论
categories: 机器学习
mathjax: true
---

奇异值分解（Singular Value Decomposition，简称SVD），是一种矩阵分解技术，可以用于机器学习中数据集的降维。

<!--more-->

### 预备知识

* 单位矩阵

主对角元素全为1，其余元素全为0的n阶矩阵，称为单位矩阵，记为$E_{n}$或$I_{n}$，通常用$E$或$I$表示。

> 自看机器学习以来，看到好多次$I$这个符号，以前一直不知道是啥意思，原来就是本科线性代数里单位矩阵$E$的另一种表示符号。

* 正交矩阵

如果n阶实矩阵满足
$$
A^{T}A = AA^{T} = I
$$
则称$A$为正定矩阵。

* 正规矩阵

设$A \in C^{\ m \times n}$，如果
$$
A^{H}A = AA^{H}
$$
则称$A$ 为正规矩阵。

* 酉矩阵

如果n阶复矩阵$A$满足
$$
A^{H}A = AA^{H} = I
$$
则称$A$为酉矩阵。

### 奇异值分解

设$A \in C^{\ m \times n}$，如果存在非负实数$\sigma$和非零向量$u \in C^{n}，v \in C^{m}$使得
$$
Au = \sigma v，A^{H}v = \sigma u
$$
则称$\sigma$为$A$的奇异值，$u$和$v$分别称为$A$对应于奇异值$\sigma$的右奇异向量和左奇异向量。
$$
A^{H}Au = \sigma A^{H} v = \sigma^{2} u
$$

$$
A A^{H} v = \sigma A u = \sigma^{2}v
$$

因此，$\sigma^{2}$是$A^{H} A$的特征值，也是$A A^{H}$的特征值，而$u$和$v$分别是$A^{H}A$和$A A^{H}$对应于特征值$\sigma^{2}$的特征向量。

设$A \in C^{\ m \times n}$，rank（A）=r，且$A^{H}A$的特征值为$\lambda_{1} \geq \lambda_{2} \geq \dots \geq \lambda_{n}$。
$$
\lambda_{1} \geq \dots \geq \lambda_{r} > \lambda_{r+1} = \dots = \lambda_{n} = 0
$$
记$k = \min\\{m,n\\}$，也称$\sigma_{i} = \sqrt{\lambda_{i}} （i=1,\dots,k）$为$A$的奇异值，特别地，称$\sigma_{1}，\dots，\sigma_{r}$为$A$的正奇异值。

定理：若$A$是正规矩阵，则$A$的奇异值是$A$的特征值的模。

定理：设$A$是$m \times n$矩阵，且rank（A）= r，则存在m阶酉矩阵$V$和n阶酉矩阵$U$，使得
$$
V^{H}AU = 
\begin{bmatrix}
\Sigma & 0 \\\\
0 & 0
\end{bmatrix}
$$
其中，$\Sigma = diag（\sigma_{1}，\dots，\sigma_{r}）$，且$\sigma_{1} \geq \dots \geq \sigma_{r} > 0$。

$U$的列向量是$A^{H}A$的标准正交特征向量，$U$的前 r 列向量是$A^{H}A$对应于r个非零特征值$\sigma_{1}^{2},\dots,\sigma_{r}^{2}$的标准正交特征向量；而$V$的列向量是$AA^{H}$的标准正交特征向量，前 r 列向量恰是$AA^{H}$对应于特征值$\sigma_{1}^{2},\dots,\sigma_{r}^{2}$的标准正交特征向量。

例题

设
$$
A = 
\begin{bmatrix}
0 & 1 \\\\
-1 & 0 \\\\
0 & 2 \\\\
1 & 0 \\\\
\end{bmatrix}
$$
作出矩阵$A$的奇异值分解。

解：
$$
A^{H}A = 
\begin{bmatrix}
2 & 0 \\\\
0 & 5
\end{bmatrix},
AA^{H} = 
\begin{bmatrix}
1 & 0 & 2 & 0 \\\\
0 & 1 & 0 & -1 \\\\
2 & 0 & 4 & 0 \\\\
0 & -1 & 0 & 1
\end{bmatrix},
$$
则$A$的非零奇异值为$\sqrt{2}，\sqrt{5}$ .

$A^{H} A $对应于特征值5和2的标准正交特征向量为
$$
u_1 = 
\begin{pmatrix}
0 \\\\ 1
\end{pmatrix}，
u_2 = 
\begin{pmatrix}
1 \\\\ 0
\end{pmatrix}
$$
$AA^{H}$对应于特征值5和2的标准正交特征向量为
$$
v_1 = 
\begin{bmatrix}
\frac{1}{\sqrt{5}} \\\\ 0 \\\\ \frac{2}{\sqrt{5}} \\\\ 0
\end{bmatrix},
v_2 = 
\begin{bmatrix}
0 \\\\ -\frac{1}{\sqrt{2}} \\\\ 0 \\\\ \frac{1}{\sqrt{2}} 
\end{bmatrix}
$$
$AA^{H}$对应于特征值0的标准正交特征向量为
$$
v_3 = 
\begin{bmatrix}
-\frac{2}{\sqrt{5}} \\\\ 0 \\\\ \frac{1}{\sqrt{5}} \\\\ 0
\end{bmatrix},
v_4 = 
\begin{bmatrix}
0 \\\\ \frac{1}{\sqrt{2}} \\\\ 0 \\\\ \frac{1}{\sqrt{2}} 
\end{bmatrix}
$$
因此，$A$的奇异值分解为
$$
A = 
\begin{bmatrix}
0 & 1 \\\\
-1 & 0 \\\\
0 & 2 \\\\
1 & 0 \\\\
\end{bmatrix}
= 
\begin{bmatrix}
\frac{1}{\sqrt{5}} & 0 & -\frac{2}{\sqrt{5}} & 0\\\\ 
0 & -\frac{1}{\sqrt{2}} & 0 & \frac{1}{\sqrt{2}}\\\\ 
\frac{2}{\sqrt{5}} & 0 & \frac{1}{\sqrt{5}} & 0\\\\ 
0 & \frac{1}{\sqrt{2}} & 0 & \frac{1}{\sqrt{2}}
\end{bmatrix}
\begin{bmatrix}
\sqrt{5} & 0 \\\\
0 & \sqrt{2} \\\\
0 & 0 \\\\
0 & 0
\end{bmatrix}
\begin{pmatrix}
0 & 1 \\\\
1 & 0
\end{pmatrix}^{H}
$$
