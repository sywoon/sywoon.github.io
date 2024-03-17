
# 学无定法，进取不息
* 学习某块完整知识点 
* 方便复习复盘
* 开发心得
* 新知识猎奇

* [工具基于docify](https://www.jsdelivr.com/package/npm/docsify)
* [工具文档](https://docsify.js.org/#/zh-cn/)
  [主题](https://github.com/jhildenbiddle/docsify-themeable)
* (2024.3.9月启用)
------------------------------------


# test1
- abc
* efg

## test2
- abc
* efg

### test3
- abc

#### test4
* abc

## [扩展知识](/docs/knowledge/)

## 文档编辑方式  <!-- {docsify-ignore} -->
1. 在docs下功能对应的文件夹内新增md文件
2. 修改_sidebar.md，插入新增的条目



## 样式格式参考  <!-- {docsify-ignore} -->
1. [ETS' NoteBook](https://notebook.js.org/#/)[github](https://github.com/wugenqiang/NoteBook)
2. [字节飞扬](https://github.com/bytesfly/blog)[github](https://github.com/bytesfly/blog)
3. [docsify官方案例](https://github.com/docsifyjs/awesome-docsify?tab=readme-ov-file#showcase)


## 其他说明  <!-- {docsify-ignore} -->
1. nojekyll：用于阻止 GitHub Pages 忽略掉下划线开头的文件。
2. 用命令行初始化doc环境
```
    npm i docsify-cli -g
    docsify init ./docs
    cd docs & docsify serve
    
  其他网页服务器工具：
  npm install -g live-server anywhere
  anywhere 9110
  live-server ./ --port=9110
```

3. live-server的代码方式
```
    var liveServer = require("live-server");
    var params = {
        port: 8181, // 设置服务器端口。 默认为 8080 
        host: "0.0.0.0", // 设置要绑定的地址。 默认为 0.0.0.0 或 process.env.IP
        root: "/public", // 设置正在服务的根目录。 默认为 cwd。
        open: false, // 为 false 时，默认情况下不会加载您的浏览器。
        ignore: 'scss,my/templates', // 要忽略的路径的逗号分隔字符串
        file: "index.html", //设置后，为每个 404 提供此文件（对单页应用程序有用）
        wait: 1000, // 等待所有更改，然后重新加载。 默认为 0 秒。
        mount: [['/components', './node_modules']], // 将目录挂载到路由。
        logLevel: 2, // 0 = errors only, 1 = some, 2 = lots 
        middleware: [function(req, res, next) { next(); }] // 采用一系列与连接兼容的中间件，这些中间件被注入到服务器中间件堆栈中
    };
    liveServer.start(params);
```


































