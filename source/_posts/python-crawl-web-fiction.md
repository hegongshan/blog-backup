---
title: 使用Python爬取网络小说
date: 2021-01-24 22:47:03
tags: python
categories: python
---

曾多次帮朋友爬取小说，每次从头开始写，实在没有必要。考虑到这一情况，本文对爬取小说的流程进行了简单的提炼。

<!--more-->

下面主要使用Requests和Beautiful Soup两个包，前者用于获取网页源码，后者用于解析网页数据。

### 爬取网页内容

Requests库，发送get请求需要使用requests.get方法，方法签名如下：

```python
get(url, params=None, **kwargs)
# 返回值为requests.Response
```

封装爬取方法

```python
def get_html(url: str) -> requests.Response:
  try:
    r = requests.get(url, headers={
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"})
    r.raise_for_status()
    # r.encoding = r.apparent_encoding
    return r
  except requests.HTTPError as e:
    print("http错误")
    raise e
```

### 解析网页数据

Beautiful Soup

```python
def parse_html(text: str, selector: str):
  bs = BeautifulSoup(text, 'html.parser')
  return bs.select(selector=selector)
```



### 代码

```python
import requests
from bs4 import BeautifulSoup


class NovelSpider(object):
    @staticmethod
    def _get_html(url: str) -> requests.Response:
        try:
            r = requests.get(url, headers={
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"})
            r.raise_for_status()
            r.encoding = r.apparent_encoding
            return r
        except requests.HTTPError as e:
            print("http错误")
            raise e

    @staticmethod
    def _parse_html(text: str, selector: str):
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


if __name__ == '__main__':
    content = NovelSpider.process(base_url='http://www.zanghaihua.org/guichuideng/jingjuegucheng/',
                                  chapter_list_selector='.booklist span a',
                                  chapter_selector='#BookText',
                                  use_relative_url=False)
    with open('/Users/hegongshan/Desktop/鬼吹灯之精绝古城.txt', 'w') as file:
        file.write(content)
```



