---
title: CSS 修改 placeholder 的文字颜色
date: 2017-06-26 16:02:59
tags: 前端
---

针对 INPUT 标签 placeholder 的样式，[StackOverflow](https://stackoverflow.com/questions/2610497/change-an-html5-inputs-placeholder-color-with-css) 上面有一个高分回答，兼容性还不错，适合多种浏览器，特意记录下来，以后留用。

<!-- more -->
** CSS **
```
::-webkit-input-placeholder { /* WebKit, Blink, Edge */
    color: #909;
}
:-moz-placeholder { /* Mozilla Firefox 4 to 18 */
   color: #909;
   opacity: 1;
}
::-moz-placeholder { /* Mozilla Firefox 19+ */
   color: #909;
   opacity: 1;
}
:-ms-input-placeholder { /* Internet Explorer 10-11 */
   color: #909;
}
::-ms-input-placeholder { /* Microsoft Edge */
   color: #909;
}
```

** 效果 **
![](http://ocz1xi4bl.bkt.clouddn.com/QQ%E6%88%AA%E5%9B%BE20170626163150.png)
