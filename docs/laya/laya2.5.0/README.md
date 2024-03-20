# 🔙​[Laya](/docs/laya/)

## 环境搭建
- npm install
- 编译库 npm run build
- 编译 npm run compile  复制shader文件到bin/tsc/
    生成bin/tsc indexTSC.html中使用
- 本地文档 npm run buildDoc  纯粹api文档 价值不大 因为有.d.ts文件
- 案例 cd src/samples & rollup -c
    生成：bin/rollUp/bundle.js  indexRollUp.html中使用
- 运行工具 tsc依赖bin为根目录
    npm i lite-server live-server anywhere -D 不支持 需要全局安装方式
    npm install -g live-server anywhere lite-server
    anywhere     
        用法：anywere 9100 同时开http和https 很奇怪 这个目录运行不起来
    lite-server 基于BrowserSync 可配置 更灵活 支持https 
        用法：live-server --port=9110 --baseDir ./
        lite-server [options]  没找到--help
    live-server 基于nodejs 更简洁 
        用法：live-server ./ --port=9110
        live-server [path] [options]
        live-server --help
- 启动webserver
        live-server ./bin/ --port=9666
        live-server ./bin/ --port=9668
        cd bin && anywhere 9666  无效 
- 运行demo
        indexRollUp.html bundle版案例
        indexTSC.html tsc版案例
        indexTSCTest.html 缺少spine-core.js 无法运行



## 源码结构
- [官方结构文档](https://ldc2.layabox.com/doc/?nav=zh-ts-0-3-4)
- vs中调试
    -- 默认配置了使用gulp运行LayaAirBuild功能 等同npm run compile;以tsc的方式编译
- 编译引擎示例 src/samples  & rollup -c
- 只编译引擎： 除了第一次需要完整运行上面两者(复制shader和案例) 后续只改了引擎可以通过ctrl+shift+b
    选择tsc:构建-src/layaAir/tsconfig.json
- 提交修改给官方
    ```
        有一个自己的git库 可以是空的
        拉取远程库
         git remote add layaAir https://github.com/layabox/LayaAir.git
         git fetch layaAir
         git merge layaAir/master  合并某个分支到本地
    ```
    -- 推送本地提交 git push origin master
    -- 创建request给官方 中途会选取某个commit


### 1. 源码主目录
```
bin 源码编译后的目录 有两种编译方式：tsc rollup
 都通过bin目录的anywhere运行
 tsc:vscode f5默认执行indexTSC.html;单文件编译，方便调试
 rollup:编译成一个js库; cd src/samples & rollup -c 可编译生成js库和示例库；
    首次时间比较久，需要几分钟；使用indexRollUp.html来运行，对应bin/rollUp/bundle.js

src 引擎 测试 插件
  buildtools 引擎团队内部测试时用的rollup插件工具
  casetest 内部自动测试工程
  extensions 插件源码 debugtool
  generateDoc 运行run.bat可生成api文档到doc目录
  layaAir 引擎源码
  publishTool as编译工具 发布引擎库和d.ts文件
  samples 测试用例 bin/demo下的源码来自此
  
package.json
  npm run build => publishTool/publish.bat
  npm run compile => tsc方式编译+copy shader files

src/layaAir
 ILaya.ts Laya.ts ILaya3D.ts ILaya3D.ts 主文件 所有模块都定义在这 为什么需要I文件？
 Config.ts Config3D.ts UIConfig.ts 
 ani 像是spine转后的laya特制版本 性能高很多 但不支持最新、很多特性也不支持，导致兼容性问题
 components 脚本组件化支持 ui上使用？ 貌似支持的不是很好
 d3 3d独立大模块 -单独说明
 device 设备定位 加速器 视频播放 震动
 display 主渲染模块：scene sprite node stage cmd
 effect 显示特效：模糊 发光 
 filters 过滤器：模糊 发光 区别？
 event 键盘 鼠标 事件系统
 html 解析器？
 layagl ？
 map tiled地图
 maths 数学库
 media 声音播放
 net 加载器 socket http 本地存储
 particle 2d粒子 怎么制作？ui编辑器？
 physics 物理
 renders 渲染结构？ rendersprite精灵
 resource 感觉命名有点问题 bitmap context texture texture2d
 system ?
 ui 控件
 utils handler byte log pool
 webgl 比较复杂：canvas shader submit text  3d的渲染不确定是否在内？
```

### 2. d3部分
```
 animation 3d模型的动作？
 component 3d脚本组件？
 core 灯光 材质 例子 渲染 场景 拖尾 
 graphic mesh渲染？
 loaders 模型加载？
 math 3d数学库
 physics 3d物理库
 resource ？
 shader 
 shadowmap
 text 3d文字
 utils
```

### 3. 编译问题
- 编译rollup libs库 npm run build
```
    Error: Command failed: ..\..\node_modules\.bin\tsc.cmd -b ../layaAir/tsconfig.json
    ../../node_modules/@types/node/crypto.d.ts(3533,17): error TS1110: Type expected.
    ../../node_modules/@types/node/events.d.ts(98,28): error TS1005: ',' expected
    ../../node_modules/@types/node/test.d.ts(881,34): error TS1005: '?' expected
    --
    尝试1： 无效
    npm install @types/node@latest --save-dev
    "devDependencies": {
        "@types/node": "^20.11.30"
      },
    尝试2： 对比项目中的引擎源码环境是可以编译的 说明是库版本问题
    npm show @types/node version
    旧项目20.11.30 新项目竟然也是  为何对比文件内容并不相同？
    对比package-lock.json
    "@types/node": {
      "version": "13.13.4",   新库为 "version": "20.11.30",
    ---
    修改后 npm i 再编译就正常了
    package-lock.json 是 npm 5 之后新增的文件，用来确保在安装依赖时生成的依赖树是确定性的。
    上面的案例 里面写明了ts依赖node的版本  同样是laya2.5.0的库 为何文件内容会变？
```
- 编译tsc 单文件库 npm run compile
- 编译案例 cd src/samples & rollup -c




-------------------------------------------------
## 文档
- [官方](https://ldc2.layabox.com/doc/?nav=zh-ts-0-3-0)

### 1. 简介篇
#### 1.1 html5
- 最终规范：2014年10月29日

#### 1.2 小游戏
不是h5，只是兼容了大部分Canvas和Webgl接口，不能在浏览器中运行。  
比如微信，需要在微信app的runtime中运行。

#### 1.3 laya引擎
- 引擎库+ide+u3d插件
- layanative：以layaplayer为核心，不局限laya引擎(？怎么适配)，利用反射机制实现原生和js互通
    - 支持双线程，操作相应慢1帧，性能更好
    - 支持chrome调试js，不再只靠console.log或alert了

-------------------------------------------------
## 官方案例


-------------------------------------------------
## 核心模块


-------------------------------------------------
## 设计模式


## 项目实践


## 参考资料


## 复刻
### 核心模块
### 主框架


## 心得体悟





