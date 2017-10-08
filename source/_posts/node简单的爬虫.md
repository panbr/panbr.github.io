---
title: node简单的爬虫
date: 2016-09-26 23:39:46
tags: 前端
---

最近学习 nodejs ，做一个爬虫玩玩。不知深浅爬了 segmentfault ，希望站长大大不要封我的IP，只是做练习用用，同时也表达对贵社区的喜爱和敬重。
<!-- more -->

## 目标
- 目标网站：https://segmentfault.com
- 分别进入每个主题，取得问题的题目、提问者、回答数，并打印。

## 输出示例: 
```
[
  {
    "title": "python 是否存在限制 key 的 dict",
    "author": "caimaoy",
    "answer": "2个回答"
  },
  {
    "title": "vue.js 主页面组件替换或跳转",
    "author": "yulingsong",
    "answer": "2个回答"
  }
]
```
## 知识点
- 安装 node 依赖包；
- 使用 superagent 抓取网页；
- 使用 cheerio 分析网页；
- 使用 eventproxy 控制异步回调；
- 使用 async 控制并发。

## 主要库的介绍

- ** superagent **
superagent(http://visionmedia.github.io/superagent/) 是个 http 方面的库，轻量灵活而且简单易用。与 JQuery 的 ajax 类似，可以发起 get 或 post 请求。简单的用法如下：
```
 request
    .get(url)
    .end(function(err, res){
        // TODO 
    });
```

- ** cheerio **
cheerio(https://github.com/cheeriojs/cheerio) 可以理解成一个 Node.js 版的 jquery，用来从网页中以 css selector 取数据，使用方式跟 jquery 一样一样的。
```
let cheerio = require('cheerio')
let $ = cheerio.load('<h2 class="title">Hello world</h2>')
$('h2.title').text('Hello there!')
$('h2').addClass('welcome')
```

- ** EventProxy **
EventProxy 利用事件机制解耦复杂业务逻辑，移除被广为诟病的深度callback嵌套问题，将串行等待变成并行等待，提升多异步协作场景下的执行效率。
过去的，深度嵌套的，串行的长这样：
```
var render = function (template, data) {
  _.template(template, data);
};
$.get("template", function (template) {
  // something
  $.get("data", function (data) {
    // something
  });
});
```

现在，无深度嵌套的，并行的长这样：
```
var ep = EventProxy.create("template", "data", "l10n", function (template, data, l10n) {
    _.template(template, data, l10n);
});
$.get("template", function (template) {
    // something
    ep.emit("template", template);
});
$.get("data", function (data) {
    // something
    ep.emit("data", data);
});
```

- ** async **
async (http://caolan.github.io/async/) 可以用来控制并发连接数。为什么要控制并发数呢？我们在写爬虫的时候，如果有 1000 个链接要去爬，那么不可能同时发出 1000 个并发链接出去（站长可能会以为你是恶意攻击...）。我们需要控制一下并发的数量，比如并发 10 个就好，然后慢慢抓完这 1000 个链接。这里主要用mapLimit这个方法，例如：
```
async.mapLimit(urls, 10, function (url, callback) {
  // fetchData(url, callback);
}, function (err, result) {
  // handle err
});
```
## 实现大致过程
- ** 安装依赖 **
```
npm init
npm install MODULES --save
```

- ** 引入类库 **
```
var eventproxy = require('eventproxy');
var superagent = require('superagent');
var cheerio = require('cheerio');
var async = require("async");
```

- ** 取得主题所有url，并且注册到eventproxy中 **
```
  superagent.get(url).end(function(err, sres) {
      if(err) {
          return next(err);
      }
      var $ = cheerio.load(sres.text);
      $(element).each(function(idx, element) {
          // save urls
      })
      ep.emit('topic_html', urls); // 交给eventproxy统一处理
  })
```

- ** EventProxy控制异步结束，进入每一个主题 **
```
ep.after('topic_html', pageUrls.length, function(topics) {
    // fetchTopics
})
```

- ** async控制最大并发数，在结果中取出callback返回来的整个结果数组。 **
```
async.mapLimit(topicUrls, 5, function (myurl, callback) {
    fetchUrl(myurl, callback);
}, function (err, result) {
    console.log(result);
});
```

至此，主要工作都完成了，看看输出结果：

![](http://p1.bpimg.com/575157/0504d2df35f19581.png)

## 总结
异步编程是nodejs的一大特点，也是容易让人晕头转向的地方，利用EventProxy很好的解决了异步回调深度嵌套的问题；另外，发现cheerio是个好东西啊，对于习惯使用jquery的同学来说简直不能再好。虽然明白爬别人的东西是不好的，但是合理的发掘并整理资源，最大限度的方便自己查阅和学习，也是很酷的。

## 附件（源代码）

```
var eventproxy = require('eventproxy');
var superagent = require('superagent');
var cheerio = require('cheerio');
var async = require("async");
var ep = new eventproxy();
var url = require("url"); // url 模块是nodejs里面的
var baseUrl = "https://segmentfault.com/questions";
// 存放所有主题链接链接
var topicUrls = [];
var pageUrls = [];
// 爬前两页的问题
for (var i=1; i<3; i++) {
    pageUrls.push(baseUrl + '?&page=' + i);
}
/**
 * 所有的url请求完成后，ep控制异步结束，进入每一个主题
 */
ep.after('topic_html', pageUrls.length, function(topics) {
    var concurrencyCount = 0;  // 记录并发数
    /**
     * 进入主题，取得题目、作者、回答数
     * @callback topics [{title:'', author:'', answer:''}]
     */
    var fetchUrl = function(myurl, callback) {
        var fetchStart = new Date().getTime();
        concurrencyCount++;
        console.log('现在的并发数是', concurrencyCount, '，正在抓取的是', myurl);
        superagent.get(myurl).end(function(err, ssres) {
            if (err) {
                callback(err, myurl + ' error happened!');
            }
            var time = new Date().getTime() - fetchStart;
            console.log('抓取 ' + myurl + ' 成功', '，耗时' + time + '毫秒');
            concurrencyCount--;
            var $ = cheerio.load(ssres.text);
            var result = {
              title: $('#questionTitle>a').text(),
              author: $('.question__author>a>strong').text(),
              answer: $('#answers-title').text()
            };
            callback(null, result);
          })
    }
    // 控制最大并发数为5，在结果中取出callback返回来的整个结果数组。
    async.mapLimit(topicUrls, 5, function (myurl, callback) {
        fetchUrl(myurl, callback);
    }, function (err, result) {
        console.log('===== result: ======\n', result);
        //res.send(result);
    });
})
// 获得所有主题链接 topicUrls
pageUrls.forEach(function(page) {
    superagent.get(page).end(function(err, sres) {
        if(err) {
            return next(err);
        }
        var $ = cheerio.load(sres.text);
        $('.stream-list__item').each(function(idx, element) {
            var $element = $(element).find('.title>a');
            var href = url.resolve(baseUrl, $element.attr('href'));
            topicUrls.push(href);
        })
        console.log('get topicUrls successful!\n');
        ep.emit('topic_html', topicUrls);
    })
})
```
> 不知道怎么会在前后多出来那么大一块空白-_-