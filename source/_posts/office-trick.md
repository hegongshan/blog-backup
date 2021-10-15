---
title: MS Office中的奇淫巧技
date: 2020-10-18 21:32:30
tags: office
categories: office
mathjax: true
---

在日常的文档编辑中，经常会遇到的一些问题，每次在网上搜寻都费时费力。

<!--more-->

### Word

#### 显示公式编辑框

按下`Alt`+`=`，就可以显示公式编辑框。

> 此外，Word支持部分LaTex语法

#### 公式对齐

首先，在一行中输入一个连等式或者多个公式；

```
y = f(x) = ax + b
```

然后，在每个等号前按下`Shift`+`Enter`，插入软间隔；

最后，选中公式区域，右击鼠标，选择“在等号处对齐”。

#### 交换上下两行

例如：

```
AAAA
BBBB
```

如果光标在`AAAA`这一行，按下`Alt`+`Shift`+`↓`，这两行将被交换；

如果光标在`BBBB`这一行，则需要使用`Alt`+`Shift`+`↑`。

#### 设置页眉

1.从某一页开始

假设从第2页开始，首先在前一页（第1页）的末行添加分节符`下一页`，点击【布局】→【分隔】→【下一页】：

![](/static/images/word-page-header-start-page1.png)

然后，双击当前页的页眉，取消`链接到上一个`选项：

![](/static/images/word-page-header-start-page2.png)

2.奇偶页不同

双击页眉，勾选`奇偶页不同`选项：

![奇偶页不同](/static/images/word-page-header-different-odd-even-pages.png)

#### 设置页码

让页码从指定页开始

* 首先，在前一页的末行添加分节符`下一页`，点击【布局】→【分隔】→【下一页】

![](/static/images/word-page-number1.png)

* 然后，双击当前页的页脚，取消`链接到上一个`选项：

![](/static/images/word-page-number2.png)

* 其次，设置页码，点击【页眉和页脚】→【页码】→【页码】，设置对齐方式

![](/static/images/word-page-number3.png)

![](/static/images/word-page-number4.png)

* 最后，修改页码格式，选中并设置`起始编号`：

![](/static/images/word-page-number5.png)

### Powerpoint

#### 设置幻灯片大小

【设计】→【幻灯片大小】→【页面设置】

![设置幻灯片大小](/static/images/powerpoint-change-the-size-of-slides.png)
