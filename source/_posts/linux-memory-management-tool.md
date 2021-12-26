---
title: Linux内存管理工具
date: 2021-12-10 19:47:06
tags: linux
categories: linux
mathjax: true
---



### 查看内存信息

#### free

```shell
hegongshan@hgs:~/Desktop$ free
              total        used        free      shared  buff/cache   available
Mem:        2028064      767864      290904        8424      969296     1102548
Swap:        459260        1292      457968
```


$$
\begin{aligned}
used 
&= total - free - buffers - cache \\\\
&= 2028064 - 290904 - 969296 \\\\
&= 767864
\end{aligned}
$$
实际上，free的结果也是从/proc/meminfo中解析得到的。

#### /proc/meminfo

```shell
hegongshan@hgs:~/Desktop$ cat /proc/meminfo
MemTotal:        2028064 kB
MemFree:          290904 kB
MemAvailable:    1102548 kB
Buffers:           50356 kB
Cached:           865900 kB
SwapCached:           64 kB
Active:           379248 kB
Inactive:        1179920 kB
Active(anon):       1388 kB
Inactive(anon):   641172 kB
Active(file):     377860 kB
Inactive(file):   538748 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        459260 kB
SwapFree:         457968 kB
Dirty:               884 kB
Writeback:             0 kB
AnonPages:        642892 kB
Mapped:           286320 kB
Shmem:              8424 kB
KReclaimable:      53040 kB
Slab:             108476 kB
SReclaimable:      53040 kB
SUnreclaim:        55436 kB
KernelStack:        7376 kB
PageTables:        14208 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1473292 kB
Committed_AS:    3669348 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       37540 kB
VmallocChunk:          0 kB
Percpu:              836 kB
HardwareCorrupted:     0 kB
AnonHugePages:      2048 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:      161728 kB
DirectMap2M:     1935360 kB
```

| free       | /proc/meminfo                                                | 值         |
| ---------- | ------------------------------------------------------------ | ---------- |
| Mem total  | MemTotal                                                     | 2028064 kB |
| Mem free   | MemFree                                                      | 290904 kB  |
| shared     | Shmem                                                        | 8424 kB    |
| buff/cache | Buffers + (Cached + SReclaimable)  = 50356 + (865900 + 53040) | 969296 kB  |
| available  | MemAvailable                                                 | 1102548 kB |
| Swap total | SwapTotal                                                    | 459260 kB  |
| Swap free  | SwapFree                                                     | 457968 kB  |

