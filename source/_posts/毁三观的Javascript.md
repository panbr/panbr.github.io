---
title: 毁三观的Javascript
date: 2017-11-06 15:18:37
tags: 前端
---
![](http://www.devsanon.com/wp-content/uploads/2017/09/javascript-300x179.jpg)
讨厌一门编程语言的理由可以有很多，但对于 Javascript 是个例外，因为实在是数不清。Javascript 爆发的太快了，这也意味着在成为标准之前，我们没有足够的时间去纠正一些错误。现在我们就聊聊它包含的一些稀奇古怪的问题。

<!-- more -->

```
'5' - 3 // 2
```

上面的例子，用字符串 '5' 减去 3 ，Javascript 的弱类型和隐式转换使结果输出为 2。

```
'5' + 3 // 53
```

这是什么鬼，为什么会得到53？好吧，这种情况下，3 被转化成了字符串，接着进行了字符串的拼接。所以就是说第一种情况将字符串 '5' 转化成了数字 5，第二种情况将数字 3 转化成了字符串 '3'。

再看看下面这个。

```
'5' - '3' // 2
```

这里的字符串都被转化成了数字。为啥，是不是一脸懵逼，Javascript 就是这么神奇。

试试其他的...

```
'5' + + '4' // 54
```

++ 运算符并没有改变什么，最后仍然得到了字符串的拼接。So...我们试试两个字符串相加。

```
'foo' ++ 'bar' // fooNaN
```

等等，让我缓缓...前一种情况成立第二种就不成立了？没错，因为第一种情况下，4 先是被转化成了数字，然后为了跟 5 拼接，又被转化成了字符串。因为有如下的结果：

```
+ '4' // 4
```

所以，当我们用两个字符串做同样的运算时，Javascript 试图将包含 bar 的字符串转换为一个整数，导致 NaN，然后​​将NaN转换为一个字符串。有没有很神奇？

```
'5' + -'4' // 5-4
```

嗯... '-4' 被转化成了 -4，随后又被转化成了 '-4'，这有意义吗？

```
var x = 3 // undefined
'5' -x + x // 5
'5' + x -x // 50
```

这又是怎么搞得？简直是数学杀手啊。

咱们再看看其它的。

```
typeof NaN // number
NaN == NaN // false
```

所以说非数值NaN是一个数字？它又不等于自己？好吧，看看其它的。

```
x = [0] // [0]
x == x // true
```

呃...一个只有一个值的数组将等于它自己。继续上面的例子，让我们试试这个

```
x == !x
```

这... x 等于自己，也不等于自己？

好吧，那么下面呢？

```
Array(3) == ',,' // true
```

不错，好，棒极了...

看下 null 怎么样？

```
typeof null // object
```

好吧，这也就意味着

```
null instanceof Object // false
```

什么鬼... typeof null是object，但是null不是Object的一个实例？好吧，字符串应该可以吧。

```
"string" instanceof String // false
```

false...

再试下 min 和 max 的值。

```
Math.max() > Math.min() // false
Math.max() < Math.min() // true
```

呃...所以说数学上的最大值小于数学上的最小值？算你狠。

接下来再看看布尔值，先做如下判断：

```
true == false // false
false == false // true
true == true // true
```

这没问题，试试其它操作。

```
true && false // false
true && true // true
true && NaN // NaN
```

啊... true && NaN 结果变成 NaN 了？

```
false && NaN // false
```

你不喜欢Javascript的一致性吗？我当然喜欢...

咱再尝试点奇怪的事情。

```
true + true === 2 // true
true - true === 0 // true
```

从这里来看我可以认为 true 等于1吧？我们来检查一下

```
true === 1 // false
```

你怎么敢对这样的语言进行假设，它唯一一致的就是它的不一致性？

好吧，今天就到这吧。但是，这绝对不是JavaScript中唯一奇怪的东西。有太多奇奇怪怪的东西了，今天实在不想搞了，估计以后再来个第二波吧。

作业作业，你试试下面表达式的结果，不要运行哦。

```
(!+[]+[]+![])
```

—— 本文翻译自[http://www.devsanon.com/rants/stupid-javascript/](http://www.devsanon.com/rants/stupid-javascript/)