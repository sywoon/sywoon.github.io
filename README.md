
# ⭐学无定法，进取不息
* 学习某块完整知识点 
* 方便复习复盘
* 开发心得
* 新知识猎奇

* [工具基于docify](https://www.jsdelivr.com/package/npm/docsify)
* [工具文档](https://docsify.js.org/#/zh-cn/)
* [主题](https://github.com/jhildenbiddle/docsify-themeable)
* <small>(2024.3.9月启用)</small>
------------------------------------


# ⭐​​​开发心得
## 🔸心得汇总
- **[心得汇总](/docs/insight/)**

## 🔸江南百景图
- **[江南百景图](/docs/insight/?id=江南百景图)**

### ◻️​​test
- test2
-- test3
--- test4
---- test5

### ◼️​​test
- test2
-- test3
--- test4
---- test5


------------------------------------
# ⭐游戏引擎
## 🔸[laya引擎](/docs/laya/)
- [laya2.5.0](/docs/laya/?id=laya250)
- [laya2.13.4](/docs/laya/?id=laya2134)

## 🔸[cocos2dx引擎](/docs/cocos2dx/)




------------------------------------
# ⭐Mac& Win

## 🔸[Mac日常](/docs/mac/)



## 🔸[Win日常](/docs/win/)





------------------------------------
# ⭐[扩展知识](/docs/knowledge/)
## 🔸git & github
- [git日常积累](/docs/knowledge/git)
- [git rebase](/docs/knowledge/git)

## 🔸sourcetree
- **[sourcetree](/docs/knowledge/sourcetree)**

## 🔸markdown
- **[markdown](/docs/knowledge/markdown)**
- [md数学公式符号](https://www.cnblogs.com/ywsun/p/14271547.html)

## 🔸emoji
🌕🌖🌗🌘🌑
- **常用emoji图标**
    - [emoji github](/docs/knowledge/emoji)
    - [emojikeyboard](https://emojikeyboard.top/)
    - [getemoji](https://getemoji.com/)




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

































