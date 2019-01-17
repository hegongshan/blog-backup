---
title: CCF CSP每日一练之201803-3 URL映射
date: 2018-06-06 22:20:10
updated: 2018-06-06 22:20:10
tags: ccf csp
categories: ccf csp
---

**问题描述**

　　URL 映射是诸如 Django、Ruby on Rails 等网页框架 (web frameworks) 的一个重要组件。对于从浏览器发来的 HTTP 请求，URL 映射模块会解析请求中的 URL 地址，并将其分派给相应的处理代码。现在，请你来实现一个简单的 URL 映射功能。
　　本题中 URL 映射功能的配置由若干条 URL 映射规则组成。当一个请求到达时，URL 映射功能会将请求中的 URL 地址按照配置的先后顺序逐一与这些规则进行匹配。当遇到第一条完全匹配的规则时，匹配成功，得到匹配的规则以及匹配的参数。若不能匹配任何一条规则，则匹配失败。
　　本题输入的 URL 地址是以斜杠 / 作为分隔符的路径，保证以斜杠开头。其他合法字符还包括大小写英文字母、阿拉伯数字、减号 -、下划线 _ 和小数点 .。例如，/person/123/ 是一个合法的 URL 地址，而 /person/123? 则不合法（存在不合法的字符问号 ?）。另外，英文字母区分大小写，因此 /case/ 和 /CAse/ 是不同的 URL 地址。
　　对于 URL 映射规则，同样是以斜杠开始。除了可以是正常的 URL 地址外，还可以包含参数，有以下 3 种：
　　字符串 &lt;str&gt;：用于匹配一段字符串，注意字符串里不能包含斜杠。例如，abcde0123。
　　整数 &lt;int&gt;：用于匹配一个不带符号的整数，全部由阿拉伯数字组成。例如，01234。
　　路径 &lt;path&gt;：用于匹配一段字符串，字符串可以包含斜杠。例如，abcd/0123/。
　　以上 3 种参数都必须匹配非空的字符串。简便起见，题目规定规则中 &lt;str&gt; 和 &lt;int&gt; 前面一定是斜杠，后面要么是斜杠，要么是规则的结束（也就是该参数是规则的最后一部分）。而 &lt;path&gt; 的前面一定是斜杠，后面一定是规则的结束。无论是 URL 地址还是规则，都不会出现连续的斜杠。

<!--more-->

**输入格式**

　　输入第一行是两个正整数 *n* 和 *m*，分别表示 URL 映射的规则条数和待处理的 URL 地址个数，中间用一个空格字符分隔。
　　第 2 行至第 *n*+1 行按匹配的先后顺序描述 URL 映射规则的配置信息。第 *i*+1 行包含两个字符串 *pi* 和 *ri*，其中 *pi* 表示 URL 匹配的规则，*ri* 表示这条 URL 匹配的名字。两个字符串都非空，且不包含空格字符，两者中间用一个空格字符分隔。
　　第 *n*+2 行至第 *n*+*m*+1 行描述待处理的 URL 地址。第 *n*+1+*i* 行包含一个字符串 *qi*，表示待处理的 URL 地址，字符串中不包含空格字符。

**输出格式**

　　输入共 *m* 行，第 *i* 行表示 *qi* 的匹配结果。如果匹配成功，设匹配了规则 *pj* ，则输出对应的 *rj*。同时，如果规则中有参数，则在同一行内依次输出匹配后的参数。注意整数参数输出时要把前导零去掉。相邻两项之间用一个空格字符分隔。如果匹配失败，则输出 404。

**样例输入**

5 4
/articles/2003/ special_case_2003
/articles/&lt;int&gt;/ year_archive
/articles/&lt;int&gt;/&lt;int&gt;/ month_archive
/articles/&lt;int&gt;/&lt;int&gt;/&lt;str&gt;/ article_detail
/static/&lt;path&gt; static_serve
/articles/2004/
/articles/1985/09/aloha/
/articles/hello/
/static/js/jquery.js

**样例输出**

year_archive 2004
article_detail 1985 9 aloha
404
static_serve js/jquery.js

**样例说明**

　　对于第 1 个地址 /articles/2004/，无法匹配第 1 条规则，可以匹配第 2 条规则，参数为 2004。
　　对于第 2 个地址 /articles/1985/09/aloha/，只能匹配第 4 条规则，参数依次为 1985、9（已经去掉前导零）和 aloha。
　　对于第 3 个地址 /articles/hello/，无法匹配任何一条规则。
　　对于第 4 个地址 /static/js/jquery.js，可以匹配最后一条规则，参数为 js/jquery.js。

**数据规模和约定**

　　1 ≤ *n* ≤ 100，1 ≤ *m* ≤ 100。
　　所有输入行的长度不超过 100 个字符（不包含换行符）。
　　保证输入的规则都是合法的。

```java
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		Integer[] data = toIntegerArray(scan.nextLine().split(" "));
		UrlMapping[] mappings = new UrlMapping[data[0]];
		String[] url = new String[data[1]];
		for (int i = 0; i < data[0]; i++) {
			String[] sArr = scan.nextLine().split(" ");
			UrlMapping urlMapping = new UrlMapping();
			urlMapping.setExpression(sArr[0]);
			urlMapping.setName(sArr[1]);
			mappings[i] = urlMapping;
		}
		for (int i = 0; i < url.length; i++) {
			url[i] = scan.nextLine();
		}

		for (int i = 0; i < url.length; i++) {
			boolean flag = false;
			if (url[i].matches("(/[\\w-\\.]+)+/?")) {// 判断url是否合法
				for (UrlMapping urlMapping : mappings) {
					if (matches(urlMapping, url[i])) {
						flag = true;
						break;
					}
				}
			}
			if (!flag) {
				System.out.println(404);
			}
		}
		scan.close();
	}

	private static boolean matches(UrlMapping urlMapping, String url) {

		String expression = urlMapping.getExpression();
		String[] mappingArr = expression.split("/");
		String[] urlArr = url.split("/");
		/*如果映射规则分割后的长度小于url的长度，但是映射规则不包含<path>，
		或者映射规则分割后的长度大于url的长度，则不匹配*/
		if ((mappingArr.length < urlArr.length && !expression.endsWith("<path>"))
				|| mappingArr.length > urlArr.length) {
			return false;
		}
		if (expression.endsWith("/") && !url.endsWith("/")) {
			return false;
		}
		if ((!expression.endsWith("<path>") && !expression.endsWith("/")) 
            & url.endsWith("/")) {
			return false;
		}
		String[] args = new String[urlArr.length];
		int count = 0;
		for (int i = 0; i < mappingArr.length; i++) {
			if (mappingArr[i].equals("<str>")) {
                 //<str>不能匹配纯数字
				if (!urlArr[i].matches("[\\w-\\.]+") || urlArr[i].matches("[0-9]+")) {
					return false;
				}
				args[count++] = urlArr[i];
			} else if (mappingArr[i].equals("<int>")) {
				if (!urlArr[i].matches("[0-9]+")) {
					return false;
				}
				args[count++] = deleteStartsZero(urlArr[i]);
			} else if (mappingArr[i].equals("<path>")) {
				StringBuilder sb = new StringBuilder(urlArr[i]);
				for (int j = i + 1; j < urlArr.length; j++) {
					sb.append("/" + urlArr[j]);
				}
				if (url.endsWith("/")) {// 加上url结尾的/
					sb.append("/");
				}
				args[count++] = sb.toString();
			} else if (!mappingArr[i].equals(urlArr[i])) {
				return false;
			}
		}
		StringBuilder sb = new StringBuilder(urlMapping.getName() + " ");
		for (int k = 0; k < count; k++) {
			sb.append(args[k] + " ");
		}
		System.out.println(sb);
		return true;
	}
	
	//更简洁的做法：String.valueOf(Integer.parseInt(str));
	private static String deleteStartsZero(String str) {
		int i;
		for(i = 0 ; i < str.length();i++) {
			if(str.charAt(i) != '0') {
				break;
			}
		}
		return str.substring(i);
	}

	private static Integer[] toIntegerArray(String[] sArr) {
		Integer[] intArr = new Integer[sArr.length];
		for (int i = 0; i < sArr.length; i++) {
			intArr[i] = Integer.valueOf(sArr[i]);
		}
		return intArr;
	}

	private static class UrlMapping {
		String expression;
		String name;

		public String getExpression() {
			return expression;
		}

		public void setExpression(String expression) {
			this.expression = expression;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}
	}
}
```

测试结果（提交了n次，还是90分..）

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/06/20180606222621.png)

<hr>

2018/06/09 更新

偶然发现，上次写的代码，之所以一直不能通过，显示得分90，原因在于我在上面第23行做了一个URL正则过滤，过滤不合法的URL，估计可能是我正则表达式写的不对，导致有些测试用例没运行matches方法，直接输出了404.

其实题目已经写明了保证所有输入都合法，我们没必要再去处理不合法输入的情况=_=

```java
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		Integer[] data = toIntegerArray(scan.nextLine().split(" "));
		UrlMapping[] mappings = new UrlMapping[data[0]];
		String[] url = new String[data[1]];
		for (int i = 0; i < data[0]; i++) {
			String[] sArr = scan.nextLine().split(" ");
			UrlMapping urlMapping = new UrlMapping();
			urlMapping.setExpression(sArr[0]);
			urlMapping.setName(sArr[1]);
			mappings[i] = urlMapping;
		}
		for (int i = 0; i < url.length; i++) {
			url[i] = scan.nextLine();
		}

		for (int i = 0; i < url.length; i++) {
			boolean flag = false;
			for (UrlMapping urlMapping : mappings) {
				if (matches(urlMapping, url[i])) {
					flag = true;
					break;
				}
             }
			if (!flag) {
				System.out.println(404);
			}
		}
		scan.close();
	}

	private static boolean matches(UrlMapping urlMapping, String url) {

		String expression = urlMapping.getExpression();
		String[] mappingArr = expression.split("/");
		String[] urlArr = url.split("/");
		/*如果映射规则分割后的长度小于url的长度，但是映射规则不包含<path>，
		或者映射规则分割后的长度大于url的长度，则不匹配*/
		if ((mappingArr.length < urlArr.length && !expression.endsWith("<path>"))
				|| mappingArr.length > urlArr.length) {
			return false;
		}
		if (expression.endsWith("/") && !url.endsWith("/")) {
			return false;
		}
		if ((!expression.endsWith("<path>") && !expression.endsWith("/")) 
            & url.endsWith("/")) {
			return false;
		}
		String[] args = new String[urlArr.length];
		int count = 0;
		for (int i = 0; i < mappingArr.length; i++) {
			if (mappingArr[i].equals("<str>")) {
                 //<str>不能匹配纯数字
				if (!urlArr[i].matches("[\\w-\\.]+") || urlArr[i].matches("[0-9]+")) {
					return false;
				}
				args[count++] = urlArr[i];
			} else if (mappingArr[i].equals("<int>")) {
				if (!urlArr[i].matches("[0-9]+")) {
					return false;
				}
				args[count++] = deleteStartsZero(urlArr[i]);
			} else if (mappingArr[i].equals("<path>")) {
				StringBuilder sb = new StringBuilder(urlArr[i]);
				for (int j = i + 1; j < urlArr.length; j++) {
					sb.append("/" + urlArr[j]);
				}
				if (url.endsWith("/")) {// 加上url结尾的/
					sb.append("/");
				}
				args[count++] = sb.toString();
			} else if (!mappingArr[i].equals(urlArr[i])) {
				return false;
			}
		}
		StringBuilder sb = new StringBuilder(urlMapping.getName() + " ");
		for (int k = 0; k < count; k++) {
			sb.append(args[k] + " ");
		}
		System.out.println(sb);
		return true;
	}
	
	//更简洁的做法：String.valueOf(Integer.parseInt(str));
	private static String deleteStartsZero(String str) {
		int i;
		for(i = 0 ; i < str.length();i++) {
			if(str.charAt(i) != '0') {
				break;
			}
		}
		return str.substring(i);
	}

	private static Integer[] toIntegerArray(String[] sArr) {
		Integer[] intArr = new Integer[sArr.length];
		for (int i = 0; i < sArr.length; i++) {
			intArr[i] = Integer.valueOf(sArr[i]);
		}
		return intArr;
	}

	private static class UrlMapping {
		String expression;
		String name;

		public String getExpression() {
			return expression;
		}

		public void setExpression(String expression) {
			this.expression = expression;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}
	}
}
```



新的测试结果：

![](http://p64uw9x5j.bkt.clouddn.com/image/2018/06/09/20180609170312.png)