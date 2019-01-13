---
title: Java中的定时器Timer
date: 2018-08-02 21:11:49
tags: java
categories: java
---

在Java中，定时任务功能使用的是Timer类，其主要作用是设置计划任务，

最近课题组的项目用到了Java中的定时器Timer类，这里记录下定时器Timer的相关知识。

Timer的构造方法如下：

```java
public Timer()
    
public Timer(boolean isDaemon)
  
public Timer(String name)
    
public Timer(String name, boolean isDaemon)
```

<!--more-->

方法列表如下：

```java
public void schedule(TimerTask task, long delay)
    
public void schedule(TimerTask task, Date time)
    
public void schedule(TimerTask task, long delay, long period)
    
public void schedule(TimerTask task, Date firstTime, long period)
    
public void scheduleAtFixedRate(TimerTask task, long delay, long period)

public void scheduleAtFixedRate(TimerTask task, Date firstTime,long period)

public void cancel()

public int purge()
```

但封装任务的类却是TimerTask类，类结构如下：

```java
public abstract class TimerTask implements Runnable
```

### schedule(TimerTask task, Date time)

执行任务的时间晚于当前时间，即任务在未来执行

```java
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class TimerDemo {
	private static Timer timer = new Timer();
	static class Task extends TimerTask {
		@Override
		public void run() {
			System.out.println("成功执行！时间："+Date.from(Instant.now()));
		}
	}
	
	public static void main(String[] args) throws ParseException {
		String taskTime = "2018-08-06 20:03:30";
		System.out.println("计划执行任务时间：" + taskTime);
		Task task = new Task();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		System.out.println("当前时间：" + sdf.format(Date.from(Instant.now())));
		timer.schedule(task, sdf.parse(taskTime));
	}
}
```

输出结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/08/06/20180806200425.png)

可以看到，任务虽然执行完了，但进程并未销毁。这是为什么呢？

我们先来看下Timer的无参构造，

```java
public Timer() {
    this("Timer-" + serialNumber());
}
```

其内部调用的是如下构造方法

```java
public Timer(String name) {
    thread.setName(name);
    thread.start();
}
```

从源代码可以得知，创建一个Timer就是启动一个新线程，这个新启动的线程并不是守护进程，它一直在运行。如果需要Timer执行完任务就结束，可以使用如下构造方法，并将参数isDaemon设置为true

```java
public Timer(boolean isDaemon)
```

### schedule(TimerTask task, long delay, long period)

作用：以执行该方法的当前时间作为参考时间，在此基础上延迟指定的毫秒数，再以指定的时间间隔无限次执行某一任务。

### cancel()

作用：将任务队列中的全部任务清空。

（未完待续）