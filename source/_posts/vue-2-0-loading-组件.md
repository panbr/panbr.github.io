---
title: vue-2.0 loading 组件
date: 2016-11-09 15:33:23
tags: 前端
---

参考 [vue-hackernews-2.0](https://github.com/vuejs/vue-hackernews-2.0) 项目里面的 spinner.vue 组件，做了简单的修改。修改后的组件添加了信息提示的功能，而且对模板做了调整，方便模块化使用。

> ** 功能描述：**

- 列表加载时显示（转圈圈）；
- 加载成功，结果非空则隐藏加载动画，结果为空时显示"没有符合条件的记录"；
- 请求失败显示"服务器异常"。

<!-- more -->

> ** 看看效果 **

![](http://ocz1xi4bl.bkt.clouddn.com/531738d44b48d3a8.gif)

> ** 使用方法：**

需要提供 list、loading 和 resultCode 配合。list: 列表数据；loading: 加载中；resultCode: 状态码。

```
<loading :list="list" :loading="loading" :resultCode="resultCode"></loading>
```

> ** template **

圈圈效果跟 hackernews 里的一样，这里添加了提示信息，resultCode 需要接口返回，不一定 200，也可以返回一些其它的状态码，跟接口配合好就行。

```
<template>
    <div class="loading-wrap">
        <svg v-if="loading" class="loading" width="44px" height="44px" viewBox="0 0 44 44">
            <circle class="path" fill="none" stroke-width="4" stroke-linecap="round" cx="22" cy="22" r="20"></circle>
        </svg>
        <div v-if="!loading">
            <div v-if="(!list && resultCode == '200')" class="loading-text">没有符合条件的记录</div>
            <div v-if="resultCode != '200'" class="loading-text">服务器异常</div>
        </div>
    </div>
</template>
```

> ** script **

props 是从父组件里面传过来的数据。

```
<script>
    export default {
        props: ['list', 'loading', 'resultCode']
    }
</script>
```

> ** style **

这里变化也不大，主要是将圈圈放在了一个 div 里面，并给提示信息留了点地方，适合模块化的显示。

```
<style>
	.loading-wrap {
	    text-align: center;
	}
	.loading-text {
	    color: #999;
	    padding: 25px 0;
	}
	.loading {
	    animation: rotator 1.4s linear infinite;
	}
	@keyframes rotator {
	    0% {
	        transform: scale(0.5) rotate(0deg);
	    }
	    100% {
	        transform: scale(0.5) rotate(270deg);
	    }
	}
	.loading .path {
	    stroke: #009dd7;
	    stroke-dasharray: 126;
	    stroke-dashoffset: 0;
	    transform-origin: center;
	    animation: dash 1.4s ease-in-out infinite;
	}
	@keyframes dash {
	    0% {
	        stroke-dashoffset: 126;
	    }
	    50% {
	        stroke-dashoffset: 63;
	        transform: rotate(135deg);
	    }
	    100% {
	        stroke-dashoffset: 126;
	        transform: rotate(450deg);
	    }
	}
</style>
```

> ** 总结 **

最近工作中在用 angular，相对来说 vue 更容易上手，文档也很全。把模板和数据交互写在一个文件里很赞，尤其是与外界交互较少的组件，定义和使用都很方便。复杂一点的系统配合 vuex 共享状态，我已经迫不及待想在实战中试试了（可惜公司没有用 vue 的项目 /哭）。