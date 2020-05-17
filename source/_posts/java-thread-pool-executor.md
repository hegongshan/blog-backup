---
title: Java线程池 ThreadPoolExecutor
date: 2020-04-14 21:57:46
tags: java
categories: java
---

在《阿里巴巴Java开发手册》中，禁止使用Executors创建线程池，强制使用ThreadPoolExecutor。

<!--more-->

ThreadPoolExecutor共有4个构造方法，其中参数最多最全的构造方法如下：

```java
public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue,
                          ThreadFactory threadFactory,
                          RejectedExecutionHandler handler) {
    ...
}
```

* corePoolSize：线程池的基本大小。即使这些线程处于空闲状态，也不会被销毁。

> the number of threads to keep in the pool, even if they are idle, unless {@code allowCoreThreadTimeOut} is set

* maximumPoolSize（线程池的最大数量）：线程池中允许创建的最大线程数。
* keepAliveTime：当线程的数量超过了corePoolSize时，多余的空闲线程保持活跃的时间（等待新任务）。
* unit：时间的单位。可选的单位有天（DAYS）、小时（HOURS）、分钟（MINUTES）、秒（SECONDS）、毫秒（MILLISECONDS）、微秒（MICROSECONDS，千分之一毫秒）以及纳秒（NANOSECONDS，千分之一微秒）。

换算公式：1秒 = 1000毫秒，1毫秒= 1000微秒，1微秒= 1000纳秒 

* workQueue：保存等待执行的任务的阻塞队列。常用的有以下两种：

LinkedBlockingQueue：无界队列（Executors.newSingleThreadExecutor以及newFixedThreadPool使用了该队列）

SynchronousQueue：同步队列（Executors.newCachedThreadPool）

* threadFactory：用于创建线程的工厂。一般直接使用Executors中的默认线程工厂。

```java
// java.util.concurrent.Executors
public static ThreadFactory defaultThreadFactory() {
    return new DefaultThreadFactory();
}
```

* handler：当任务队列和线程池都满了时，处理新提交任务的策略。

RejectedExecutionHandler是一个接口，它有四个实现类。

```java
public interface RejectedExecutionHandler {
    void rejectedExecution(Runnable r, ThreadPoolExecutor executor);
}
```

1.AbortPolicy（默认）：直接抛出异常RejectedExecutionException。

```java
public static class AbortPolicy implements RejectedExecutionHandler {
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        throw new RejectedExecutionException("Task " + r.toString() +
                                             " rejected from " +
                                             e.toString());
    }
}
```

2.CallerRunsPolicy：让执行execute方法的线程去执行该任务。

```java
// runs the rejected task directly in the calling thread of the {@code execute} method,
public static class CallerRunsPolicy implements RejectedExecutionHandler {
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        if (!e.isShutdown()) {
            r.run();
        }
    }
}
```

3.DiscardPolicy：丢弃该任务。

```java
public static class DiscardPolicy implements RejectedExecutionHandler {
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
    }
}
```

4.DiscardOldestPolicy：丢弃处于队首的任务，重新提交当前任务。

```java
// discards the oldest unhandled request and then retries {@code execute},
public static class DiscardOldestPolicy implements RejectedExecutionHandler {
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        if (!e.isShutdown()) {
            e.getQueue().poll();
            e.execute(r);
        }
    }
}
```

