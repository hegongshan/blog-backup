---
title: JavaScript访问HTML元素
date: 2019-06-25 17:29:15
tags: javascript
categories: javascript
---

在JavaScript中，要想访问HTML元素，可以使用下面几种方法。

```javascript
document.getElementById(id)
document.getElementsByTagName(tagName)
document.getElementsByClassName(className)
document.querySelector(selector)
document.querySelectorAll(selector)
```

<!--more-->

### getElementById()

该方法返回带有指定ID的元素。

```javascript
// 访问id为main-div的元素
document.getElementById("main-div");
```

### getElementsByTagName()

该方法返回带有指定标签名的所有元素，返回值类型为HTMLCollection。

```javascript
// 访问标签名为div的所有元素
document.getElementsByTagName("div");
```

### getElementsByClassName()

该方法返回带有指定class属性值的所有元素，返回值类型为HTMLCollection。

```javascript
// 访问类名为c-red的所有元素
document.getElementsByClassName("c-red");
```

### querySelector()

该方法返回带有指定CSS样式选择器的第一个元素。

```javascript
// 访问类名为c-red的第一个元素
document.querySelector(".c-red");
```

### querySelectorAll()

该方法返回带有指定CSS样式选择器的所有元素，返回值类型为NodeList。

```javascript
// 访问类名为c-red的所有元素
document.querySelectorAll(".c-red");
```

### 示例

 下面是一段简单的html片段。

<div id="main-div"><div class="c-red"><p id="demo-p">JavaScript</p><p>Java</p><p>C++</p></div><div class="c-red c-green"><p>Python</p><p>Ruby</p><p>Swift</p></div></div>
```html
<div id="main-div">
  <div class="c-red">
    <p id="demo-p">JavaScript</p>
    <p>Java</p>
    <p>C++</p>
  </div>
  <div class="c-red c-green">
    <p>Python</p>
    <p>Ruby</p>
    <p>Swift</p>
  </div>
</div>
```

<a id="btn-id" href="javascript:void(0);" onclick="return false">
访问ID为demo-p的元素    </a>&nbsp; &nbsp;<a id="btn-tag" href="javascript:void(0);" onclick="return false">访问标签名为p的所有元素</a>  &nbsp;<a id="btn-class-name" href="javascript:void(0);" onclick="return false">访问类名为c-red的所有元素</a> &nbsp;<a id="btn-query" href="javascript:void(0);" onclick="return false">访问类名为c-red的第一个元素</a>

<a id="btn-query-all" href="javascript:void(0);" onclick="return false">访问类名为c-red的所有元素（querySelectorAll）</a>

<script type="text/javascript">
    window.onload = function() {
        f("btn-id","demo-p",1);
        f("btn-tag","p",2);
        f("btn-class-name","c-red",3);
        f("btn-query",".c-red",4);
        f("btn-query-all",".c-red",5);
    };
    function f(btnSelector,selector,type) {
        var oBtn = document.getElementById(btnSelector);
        oBtn.onclick = function() {
            var oDiv1;
            if(type == 1) {
               oDiv1 = document.getElementById(selector);
               alert("元素类型："+oDiv1+"\nid："+oDiv1.getAttribute("id")+"\n文本内容："+oDiv1.firstChild.nodeValue+"\n访问方式：document.getElementById(\""+selector+"\")");
            } else if(type == 2) {  
                oDiv1 = document.getElementsByTagName(selector);
               	alert("元素类型："+oDiv1+"\ntag："+selector+"\n访问方式：document.getElementsByTagName(\""+selector+"\")");
            } else if(type == 3) {
                oDiv1 = document.getElementsByClassName(selector);
               	alert("元素类型："+oDiv1+"\nclass："+selector+"\n访问方式：document.getElementsByClassName(\""+selector+"\")");
            } else if(type == 4) {
                oDiv1 = document.querySelector(selector);
               	alert("元素类型："+oDiv1+"\ncss选择器："+selector+"\n第一个子元素中的文本内容："+oDiv1.firstChild.firstChild.nodeValue+"\n访问方式：document.querySelector(\""+selector+"\")");
            } else {
                oDiv1 = document.querySelectorAll(selector);
               	alert("元素类型："+oDiv1+"\ncss选择器："+selector+"\n选中元素个数："+oDiv1.length+"\n访问方式：document.querySelectorAll(\""+selector+"\")");
            }
        };
    }
</script>



