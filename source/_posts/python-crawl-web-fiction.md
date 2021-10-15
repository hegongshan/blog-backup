---
title: 使用Python爬取网络小说
date: 2021-01-24 22:47:03
tags: python
categories: python
---

作为一个小说爱好者，我经常使用网络爬虫爬取喜欢的网络小说。每次都从头开始写爬取程序，实在没有必要。鉴于上述情况，本文对网络小说的爬取流程进行了简单的提炼。

<!--more-->

### 安装需要的包

工欲善其事，必先利其器。Python提供了丰富的第三方工具包，我们可以借助这些包来爬虫网络小说。

本文主要使用了Requests和Beautiful Soup包，前者用于获取网页源码，后者用于解析网页数据。

接下来，我们来看看如何安装这两个包：

* 对于Windows系统，在命令行（按下`Win+R键`可以打开运行窗口，输入`cmd`即可进入命令行界面）中分别输入如下命令：

```shell
# 安装Requests
pip install requests
# 安装Beautiful Soup
pip install beautifulsoup4
```

* 对于Linux/macOS，只需将上述的`pip`替换为`pip3`即可。

### 爬取网页内容

为了获取网页的源码，我们需要向网页发送一次HTTP GET请求。

为了使用Requests包，必须在源文件中先导入该包：

```python
import requests
```

在Requests中，发送GET请求需要使用requests.get方法，其方法签名如下：

```python
# 返回值为requests.Response类型
requests.get(url, params=None, **kwargs)
```

封装爬取方法：

```python
def get_html(url: str) -> requests.Response:
  headers = {
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"};
  try:
    r = requests.get(url, headers=headers)
    r.raise_for_status()
    r.encoding = r.apparent_encoding
    return r
  except requests.HTTPError as e:
    print("http错误")
    raise e
```

### 解析网页数据

Beautiful Soup提供了BeautifulSoup类，该类中最强大的方法为`select`，其方法签名如下：

```python
# 返回值为list[bs4.element.Tag]
select(self, selector, namespaces=None, limit=None, **kwargs)
```

```python
def parse_html(text: str, selector: str) -> list:
  bs = BeautifulSoup(text, 'html.parser')
  return bs.select(selector=selector)
```

### 具体代码

```python
import requests
from bs4 import BeautifulSoup


class NovelSpider(object):
    @staticmethod
    def _get_html(url: str) -> requests.Response:
        headers = {
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"}
        try:
            r = requests.get(url, headers=headers)
            r.raise_for_status()
            r.encoding = r.apparent_encoding
            return r
        except requests.HTTPError as e:
            print("http错误")
            raise e

    @staticmethod
    def _parse_html(text: str, selector: str) -> list:
        bs = BeautifulSoup(text, 'html.parser')
        return bs.select(selector=selector)

    @staticmethod
    def process(base_url: str,
                chapter_list_selector: str,
                chapter_selector: str,
                use_relative_url: bool = True) -> str:
        response = NovelSpider._get_html(url=base_url)

        # 章节列表的CSS选择器
        chapter_list = NovelSpider._parse_html(text=response.text,
                                               selector=chapter_list_selector)

        novel = ''
        # 遍历章节列表
        for a in chapter_list:
            print('title:{}, url:{}'.format(a.string, a['href']))
            if use_relative_url:
                chapter_url = base_url + a['href']
            else:
                chapter_url = a['href']

            # 获取章节内容
            page_response = NovelSpider._get_html(chapter_url)
            content = NovelSpider._parse_html(text=page_response.text,
                                              selector=chapter_selector)

            novel += a.string + '\n\n'
            for line in content:
                novel += line.text.strip() + '\n'
            novel += '\n\n'
        return novel

      
def test_spider():
    content = NovelSpider.process(base_url='http://www.zanghaihua.org/guichuideng/jingjuegucheng/',
                                  chapter_list_selector='.booklist span a',
                                  chapter_selector='#BookText',
                                  use_relative_url=False)
    assert content != ''
    with open('/Users/hegongshan/Desktop/鬼吹灯之精绝古城.txt', 'w') as file:
        file.write(content)

if __name__ == '__main__':
    test_spider()
```



