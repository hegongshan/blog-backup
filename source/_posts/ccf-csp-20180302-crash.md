---
title: CCF CSP 201803-2 碰撞的小球
date: 2018-06-06 20:35:08
updated: 2018-06-06 20:35:08
tags: ccf csp
categories: ccf csp
---

**问题描述**

　　数轴上有一条长度为L（L为偶数)的线段，左端点在原点，右端点在坐标L处。有n个不计体积的小球在线段上，开始时所有的小球都处在偶数坐标上，速度方向向右，速度大小为1单位长度每秒。
　　当小球到达线段的端点（左端点或右端点）的时候，会立即向相反的方向移动，速度大小仍然为原来大小。
　　当两个小球撞到一起的时候，两个小球会分别向与自己原来移动的方向相反的方向，以原来的速度大小继续移动。
　　现在，告诉你线段的长度L，小球数量n，以及n个小球的初始位置，请你计算t秒之后，各个小球的位置。

**提示**

　　因为所有小球的初始位置都为偶数，而且线段的长度为偶数，可以证明，不会有三个小球同时相撞，小球到达线段端点以及小球之间的碰撞时刻均为整数。
　　同时也可以证明两个小球发生碰撞的位置一定是整数（但不一定是偶数）。

<!--more-->

**输入格式**

　　输入的第一行包含三个整数n, L, t，用空格分隔，分别表示小球的个数、线段长度和你需要计算t秒之后小球的位置。
　　第二行包含n个整数a1, a2, …, an，用空格分隔，表示初始时刻n个小球的位置。

**输出格式**

　　输出一行包含n个整数，用空格分隔，第i个整数代表初始时刻位于ai的小球，在t秒之后的位置。

**样例输入**

3 10 5
4 6 8

**样例输出**

7 9 9

**样例说明**

　　初始时，三个小球的位置分别为4, 6, 8。
![img](http://118.190.20.162/RequireFile.do?fid=b6beJN6e)
　　一秒后，三个小球的位置分别为5, 7, 9。
![img](http://118.190.20.162/RequireFile.do?fid=Ab8QmfeR)
　　两秒后，第三个小球碰到墙壁，速度反向，三个小球位置分别为6, 8, 10。
![img](http://118.190.20.162/RequireFile.do?fid=fgQLYbNn)
　　三秒后，第二个小球与第三个小球在位置9发生碰撞，速度反向（注意碰撞位置不一定为偶数），三个小球位置分别为7, 9, 9。
![img](http://118.190.20.162/RequireFile.do?fid=erfyNJDT)
　　四秒后，第一个小球与第二个小球在位置8发生碰撞，速度反向，第三个小球碰到墙壁，速度反向，三个小球位置分别为8, 8, 10。
![img](http://118.190.20.162/RequireFile.do?fid=m5EBf6q8)
　　五秒后，三个小球的位置分别为7, 9, 9。
![img](http://118.190.20.162/RequireFile.do?fid=JRHaHt4T)

**样例输入**

10 22 30
14 12 16 6 10 2 8 20 18 4

**样例输出**

6 6 8 2 4 0 4 12 10 2

**数据规模和约定**

　　对于所有评测用例，1 ≤ n ≤ 100，1 ≤ t ≤ 100，2 ≤ L ≤ 1000，0 < ai < L。L为偶数。
　　保证所有小球的初始位置互不相同且均为偶数。

```java
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int[] condition = toIntArray(scan.nextLine().split(" "));
		int[] data = toIntArray(scan.nextLine().split(" "));
		
		int[] lastPosition = new int[data.length];
		int line = condition[1];
		int t = condition[2];
		int[] directions = new int[data.length];
		for (int i = 0; i < directions.length; i++) {
			directions[i] = 1;//默认向右移动
		}
		// 执行t次
		for (int i = 0; i < t; i++) {
			// 上一次小球的位置
			for (int j = 0; j < lastPosition.length; j++) {
				lastPosition[j] = data[j];
			}
			for (int j = 0; j < lastPosition.length; j++) {
				if (lastPosition[j] == line || lastPosition[j] == 0) { 
					//若为线段两端点
					directions[j] = -directions[j];
				} else {
					//如果存在位置相同的小球，则发生了碰撞
					for (int k = 0; k < lastPosition.length; k++) {
						if(j != k && lastPosition[j] == lastPosition[k]) {
							directions[j] = -directions[j];
							break;
						}
					}
				}
				data[j] += directions[j];
			}
		}

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < data.length; i++) {
			sb.append(data[i] + " ");
		}
		System.out.println(sb.toString());
		scan.close();
	}

	private static int[] toIntArray(String[] sArr) {
		int[] intArr = new int[sArr.length];
		for (int i = 0; i < sArr.length; i++) {
			intArr[i] = Integer.valueOf(sArr[i]);
		}
		return intArr;
	}
}
```

测试结果

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/08/20180608224518.png)

之前全写的包装类型Integer，一直不能通过测试，总显示得分：30，全改为int就正确了，看来以后做题还是得用基本数据类型。

这题目其实不难，但是刚开始没思路，后来又想复杂了，困扰了我好几天，也是够了&gt;_&lt;