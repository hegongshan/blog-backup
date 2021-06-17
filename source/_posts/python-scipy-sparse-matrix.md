---
title: SciPy稀疏矩阵
date: 2021-02-28 18:05:45
tags:
---

最近在做毕业论文的实验，关于图神经网络，因此，经常用到稀疏矩阵。顺便总结下SciPy中的七大压缩矩阵。

<!--more-->

### spmatrix

属性：

nnz

shape

### coo_matrix

A sparse matrix in **COO**rdinate format.

坐标型压缩矩阵，即数据结构书中提到的压缩矩阵的存储格式。



### csc_matrix

**C**ompressed **S**parse **C**olumn matrix.

属性

data：Data array of the matrix

**indices**：CSC format index array



### dok_matrix

**D**ictionary **O**f **K**eys based sparse matrix



### lil_matrix

Row-based **li**st of **l**ists sparse matrix.

数据结构：

- An array (`self.rows`) of rows, each of which is a sorted list of column indices of non-zero elements.
- The corresponding nonzero values are stored in similar fashion in `self.data`.

