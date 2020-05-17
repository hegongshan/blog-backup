---
title: Java Executors框架
date: 2020-04-14 21:25:10
tags: java
categories: java
---

今天面了OPPO，小哥一上来就问：Java中有几种线程池？感觉自己有点忘了，遂复习一遍。

<!--more-->

### newSingleThreadExecutor

创建一个使用单个工作线程的执行器：保证所有的任务被顺序执行（FIFO），任何时候只有一个任务被执行。

```java
/**
* Creates an Executor that uses a single worker thread operating
* off an unbounded queue. (Note however that if this single
* thread terminates due to a failure during execution prior to
* shutdown, a new one will take its place if needed to execute
* subsequent tasks.)  Tasks are guaranteed to execute
* sequentially, and no more than one task will be active at any
* given time. Unlike the otherwise equivalent
* {@code newFixedThreadPool(1)} the returned executor is
* guaranteed not to be reconfigurable to use additional threads.
*
* @return the newly created single-threaded Executor
*/
public static ExecutorService newSingleThreadExecutor() {
    return new FinalizableDelegatedExecutorService
        (new ThreadPoolExecutor(1, 1,
                                0L, TimeUnit.MILLISECONDS,
                                new LinkedBlockingQueue<Runnable>()));
}
```

与newFixedThreadPool(1)不同，newSingleThreadExecutor方法返回的执行器不能被重新配置，即无法重新设置线程池的大小。原因在于FinalizableDelegatedExecutorService没有改变线程池大小的方法。

### newFixedThreadPool

可重用固定线程数的线程池。创建一个线程池，池中的线程数量是固定的。当所有线程都处于活跃状态时（都在执行任务），如果此时又提交了一些任务，则将这些任务放入工作队列中，直到某个线程处于可用状态。

```java
/**
* Creates a thread pool that reuses a fixed number of threads
* operating off a shared unbounded queue.  At any point, at most
* {@code nThreads} threads will be active processing tasks.
* If additional tasks are submitted when all threads are active,
* they will wait in the queue until a thread is available.
* If any thread terminates due to a failure during execution
* prior to shutdown, a new one will take its place if needed to
* execute subsequent tasks.  The threads in the pool will exist
* until it is explicitly {@link ExecutorService#shutdown shutdown}.
*
* @param nThreads the number of threads in the pool
* @return the newly created thread pool
* @throws IllegalArgumentException if {@code nThreads <= 0}
*/
public static ExecutorService newFixedThreadPool(int nThreads) {
    return new ThreadPoolExecutor(nThreads, nThreads,
                                  0L, TimeUnit.MILLISECONDS,
                                  new LinkedBlockingQueue<Runnable>());
}
```

在使用的过程中，可以使用`ThreadPoolExecutor::setCorePoolSize`重新调整线程池的大小。

### newCachedThreadPool

根据需要创建新线程的线程池。适用于执行许多短期的异步任务。

```java
/**
* Creates a thread pool that creates new threads as needed, but
* will reuse previously constructed threads when they are
* available.  These pools will typically improve the performance
* of programs that execute many short-lived asynchronous tasks.
* Calls to {@code execute} will reuse previously constructed
* threads if available. If no existing thread is available, a new
* thread will be created and added to the pool. Threads that have
* not been used for sixty seconds are terminated and removed from
* the cache. Thus, a pool that remains idle for long enough will
* not consume any resources. Note that pools with similar
* properties but different details (for example, timeout parameters)
* may be created using {@link ThreadPoolExecutor} constructors.
*
* @return the newly created thread pool
*/
public static ExecutorService newCachedThreadPool() {
    return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
                                  60L, TimeUnit.SECONDS,
                                  new SynchronousQueue<Runnable>());
}
```

### newScheduledThreadPool

创建一个线程池，用于执行定时任务和周期性任务。

```java
/**
 * Creates a thread pool that can schedule commands to run after a
 * given delay, or to execute periodically.
 * @param corePoolSize the number of threads to keep in the pool,
 * even if they are idle
 * @return a newly created scheduled thread pool
 * @throws IllegalArgumentException if {@code corePoolSize < 0}
 */
public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize) {
    return new ScheduledThreadPoolExecutor(corePoolSize);
}
```

ScheduledThreadPoolExecutor是ThreadPoolExecutor的子类。

```java
// 调用了父类ThreadPoolExecutor的构造方法，使用延时队列
public ScheduledThreadPoolExecutor(int corePoolSize) {
    super(corePoolSize, Integer.MAX_VALUE, 0, NANOSECONDS,
          new DelayedWorkQueue());
}
```



