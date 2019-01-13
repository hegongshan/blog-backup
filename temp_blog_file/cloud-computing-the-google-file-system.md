---
title: “The Google File System”论文阅读
date: 2018-09-23 15:39:23
tags: 云计算
categories: 云计算
---
>云计算的经典论文为
>The Google File System
>MapReduce:A simplified method on large cluster
>Bigtable:
>
>谷歌三大法宝：GFS、MapReduce、Bigtable

### Assumptions

* The system is built from many inexpensive commodity components that often fail.

系统是由许多廉价的经常出故障的商用机器构建而成的。

* The system stores a modest number of large files.
* The workloads primarily consist of two kinds of reads:large streaming reads and small random reads.
* The workloads also have many large, sequential writes that append data to files.
* The system must efficiently implement well-defined semantics for multiple clients that concurrently append to the same file.
* High sustained bandwidth is more important than low latency.

高可用的带宽比低延迟更重要。

### Architecture

A GFS cluster consists of a single master and multiple chunkservers and is accessed by multiple clients.