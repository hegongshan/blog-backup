---
title: Java equals与==有什么不同
date: 2020-02-18 18:45:32
tags: java
categories: java
---



equals方法继承自Object类

```java
public boolean equals(Object obj) {
    return (this == obj);
}
```

因此，如果没有重写equals方法，那么equals与==没有区别。

如果重写了equals方法

以String类为例

```java
public boolean equals(Object anObject) {
    if (this == anObject) {
        return true;
    }
    if (anObject instanceof String) {
        String anotherString = (String)anObject;
        int n = value.length;
        if (n == anotherString.value.length) {
            char v1[] = value;
            char v2[] = anotherString.value;
            int i = 0;
            while (n-- != 0) {
                if (v1[i] != v2[i])
                    return false;
                i++;
            }
            return true;
        }
    }
    return false;
}
```

