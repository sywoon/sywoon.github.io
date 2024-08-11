

# [doc](https://layaair.com/3.x/doc/)


## 新手入门

### LayaAir引擎介绍

#### 引擎的背景与发展历程
    Layabox的创始人谢成鸿在2003年 ”可乐吧“以数千万价格卖给清华同方 创立了3D端游研发公司”中娱在线“
    Layabox是北京蓝亚盒子科技有限公司打造的引擎服务商
    Layabox成立于2014年，旗下的开源引擎产品LayaAir
    2018年微信小游戏推出
    2021年，Layabox全资收购著名的游戏行业工具软件FairyGUI，并全力打造LayaAir 3.0
    2022年11月8日，元宇宙平台Layaverse正式推出，同一天，LayaAir3.0也开启了测试


#### LayaAir3.0引擎功能概述
包括引擎代码、项目开发工具、项目发布


##### 一 引擎代码
开放式的可编程的渲染管线，全平台的图形引擎架构，次世代PBR渲染流，ClusterLighting多光源技术
Forward+渲染管线 高性能并行渲染器API的接入（WebGPU）

###### 1.1 引擎通用部分
网络 加载 ecs组件 场景管理 事件 交互 多媒体 缓动 浏览器接口封装 设备接口 节点 屏幕适配 小游戏适配


###### 1.2 2D引擎
2d：精灵 视图 动画 文本 ui组件 ui效果-遮罩 滤镜 场景类 绘图-矢量图 物理-box2d tiledmap


###### 1.3 3D引擎
3d：精灵 数学库 场景 摄像机 光照 网格 材质 纹理 粒子 拖尾 物理 动画 自定义shader webXR


##### 二、IDE(集成开发环境)
通用模块、2D模块、3D模块

- 2.1 通用模块
层级管理 项目资源 场景视图 预览窗口 控制台
时间轴动画 动画状态机 属性设置 项目设置 ide插件 ide资源商店


- 2.2 2d模块
2d布局小部件 动画编辑 ui编辑 脚本管理 场景基类 预制件

- 2.3 3d模块
3d场景编辑 摄像机 灯光设置 动画编辑 粒子系统 材质编辑 蓝图编辑 预制件 物理编辑

##### 三、项目发布
web版 小游戏 native-ios和安卓




### 开发环境


#### 搭建开发环境
[ide](https://layaair.com/#/engineDownload)  当前使用了LayaAir 3.2.0-beta.2

- ts环境
```
nodejs 20.15.1
npm install -g typescript@5.5.3

error:unexpected end of json input while parsing near ...
通常是缓存冲突导致
npm cache clean --force
若没翻墙 可用cnpm来安装
```

- 安装[chrome](https://www.google.cn/intl/zh-CN/chrome/)

- 下载[vscode](https://code.visualstudio.com/Download)



#### IDE开发工作流模块概述
资源商店，社区、IDE核心配置云存储, 需要账号登录


##### IDE首页
了帐号模块、项目列表、创建项目、删除项目引用、项目描述设置、资源商店、web链接


##### 编辑器初始界面
层级管理面板、工程管理项目、UI布局小部件面板、场景视窗、预览窗口、动画状态机面板、项目设置面板、控制台、时间轴动画面板、属性面板

- 层级管理面板
2D与3D节点之间不可以混合形成父子层级关系

- 工程管理面板
项目全部的资源与代码

- 项目设置面板
屏幕适配设置、引擎初始化设置、项目启动设置

- 时间轴动画面板
2D与3D动画的编辑 
两个模式:关键帧模式和曲线模式


- 属性设置面板
2D与3D对象属性 
资源文件的属性设置或预览查看
组件的添加: 选中scene或某个ui -》 添加组件(右上角) -> 自定义脚本

- 其它编辑面板
预制体面板  蓝图编辑面板:不写代码就快捷的编写自定义的材质



##### 项目预览与发布
IDE内预览:出现两个按钮(窗口右上角) 重新启动和打开开发者工具Ctrl + Alt + I
浏览器预览，移动端预览


- 项目发布
File菜单的Build调出发布界面






### 引擎学习的必备技能
熟悉JavaScript语言、TypeScript语言
日常开发，查BUG，需要熟悉调试工具DevTools


#### 语言基础
[JavaScript 基础教程](https://wangdoc.com/javascript/)
[ES6 标准入门](https://wangdoc.com/es6/)
[TypeScript中文手册](https://www.tslang.cn/docs/home.html)
[深入理解 TypeScript](https://jkchao.github.io/typescript-book-chinese/)



#### DevTools调试工具
基于Chromium内核的浏览器 都可以使用DevTools
[DevTools开发工具](https://learn.microsoft.com/zh-cn/microsoft-edge/devtools-guide-chromium/overview)
[调试 JavaScript 入门](https://learn.microsoft.com/zh-cn/microsoft-edge/devtools-guide-chromium/javascript/)



#### LayaTree调试工具
LayaAir引擎开发者李尔 设计的Chrome浏览器插件工具
[安装](https://chrome.google.com/webstore/detail/laya-tree/jnmdcbmpmfhnlchjdkcngihpjmgofajm?hl=zh-CN&authuser=0)

- 手动安装：
[zip包](https://womenzhai.cn/LayaTree_V1.0.5.zip)
chrome://extensions/  打开开发者模式 
将解压后crx文件拖入该页面即可

- 插件配置
需要打开允许访问文件网址。否则无法识别当前laya引擎



##### LayaTree 使用

- 更新节点树列表的方式
手动：捕获刷新
自动：勾选 自动刷新

- 运行时调整参数：操作Camera相机节点
鼠标拖动 x值 可实时修改
清理摄像机背景：clearFlag

- 运行时调整参数：设置点击事件与穿透控制
动态设置层级关系zOrder,锚点,尺寸
点击事件与穿透控制

- 运行时调整参数：文本内容直接编辑

- 基于AOP的暂停与单帧调试运行
暂停时修改的属性需要下一帧才会更新渲染
支持TimeScale时间缩放,最高支持50倍速

- cacheAs优化技巧
cacheAs为"none"，不做任何缓存
"bitmap"时，webgl模式下显示对象使用renderTarget缓存成静态图像
可以大幅提升渲染效率  但会增加内存开销

- 标记选中
选中2d节点时,会显示红框标记


##### 工具服务
LayaTreeQQ群： 200482074




## 引擎基础


### ide基础


#### 自定义IDE界面布局
按照自己的习惯或喜好 对各块功能进行任意布局排版
- 将项目资源面板拖入控制台面板中 方便预览资源


- 调整为更方便层级展开
将资源和层级放一起 统一拖到场景的右边成列
小组件拖入属性 


- 调整为即时预览的方式
一边查看实时预览效果。那么我们可以将Game面板独立出来 拖到资源面板的下面



#### 项目工程目录说明


##### 目录构成概述
IDE创建的项目工程 由五个可见目录与几个根目录的文件构成


- 工程文件
*.laya  引擎项目工程文件  识别是否是LayaAir引擎项目，版本信息

- ts编译配置文件
tsconfig.json  用来配置 TS 编译选项
[配置说明](https://www.tslang.cn/docs/handbook/tsconfig-json.html)
[编译选项](https://www.tslang.cn/docs/handbook/compiler-options.html)



##### 日常开发的目录
- 资源目录assets
目录与最终的发布有着密切的关联
代码里引用的资源，必须放到resources目录里，才会被复制到发布目录里

- 项目源码目录src
Main.ts不再是入口  而是主scene场景  可以用runtime实现入口文件
当然 比原来的main更晚  新引擎自带了index.js来初始化引擎 代替原来2.*中的main功能


##### 其它目录
开发者基本上不需要去处理

- .vscode/settings.json
隐藏显示的文件
library、temp、local、settings这些目录，也是IDE仅供系统配置使用，不希望开发者修改


- 本地运行目录bin
开发者通常也不需要去管  开发的过程中，assets目录作为资源使用的根目录即可
bin目录内仅是测试运行的index.html首页的入口
!开发者尽量不要去修改这里的入口，以及在bin目录下存放资源


- 项目库目录engine
存放的是引擎库的声明文件 通常不需要动
如果开发者有引用第三方的类库，也可以将声名文件放到这里




#### 项目设置详解
两个部分:运行设置与编辑器设置



##### 运行设置

- 分辨率设置
影响IDE内的预览效果 项目运行时的画布宽高、适配模式、对齐方式，画布背景色等
设计宽高: 就是我们在IDE里的设置并看到的宽高 预览运行模式下，也是基于这个宽高查看效果
[屏幕适配](https://layaair.com/3.x/doc/basics/common/adaptScreen/readme.html)



- 横竖屏适配
  - 无变化：none 屏幕方向不影响 游戏方向
    最好的方案，还是竖屏始终与设备竖屏的方向保持一致
  - 始终横屏：horizontal
  - 始终竖屏：vertical

* 浏览器中运行的时候，引擎的自动横屏和自动竖屏，只能对画布进行旋转，如果用户的手机锁屏了，虽然画面自动旋转过来了，但是浏览器没有旋转过来 导致输入法依然按浏览器的方向弹出
* 小游戏平台中运行，由于小游戏底层有横屏还是竖屏的配置，不会出现这个问题


- 画布对齐适配  laya3.2已经没这个选项了！
AlignV垂直对齐的参数为：top（顶部对齐）、middle（垂直居中对齐）、bottom（底部对齐）。
AlignH水平对齐的参数为：left（居左对齐）、center（水平居中对齐）、right（居右对齐）。

* 不能理解为UI界面基于stage舞台的对齐，只是画布canvas相对于整个物理屏幕的对齐
* 在移动端，基本用不上，移动端绝大多数都需要全屏适配。当画布已经铺满整个屏幕时，设置就没有了意义
* PC端，非全屏的模式下使用，例如在画布非全屏适配的模式（showall和noscale）的情况下使用 ？？

- 画布背景色设置
canvas背景色 默认值为#888888



###### 引擎初始化设置
比较重要 2d 3d相关初始化配置
如何扩展？  
如何根据不同情况运行中修改？


- 2d属性
  - fps 60 高帧率设备可设置为120
  - 抗锯齿：置webGL上下文的antialias抗锯齿开关属性 会产生额外的性能消耗 用于2D非矩形的矢量绘图抗锯齿
    - 3D抗锯齿推荐使用摄像机的Fxaa或Msaa
  - 视网膜画布模式： 开启后无论任何适配模式，画布均采用物理分辨率大小； 多一些性能消耗，但会让文本等保持最佳清晰度
  - 画布透明： 默认状态画布有背景色，开启后，可以设置画布为无色透明
  - 顶点缓存优化： 是否分配最大的VB缓冲区； 开启后，渲染2D的时候，每次创建vb直接分配足够64k个顶点的缓存； 可以提高效率 建议保持默认开启
  - 默认字体：IDE中新建的文本默认字体 和游戏实际运行无关
  - 默认字号：IDE 


- 3D属性
  - 静态合批： 可以减少可见网格绘制调用之间渲染状态更改的次数
  - 动态合批： 满足 实例合并（同Mesh且同材质） ，即可减少RenderBatches渲染批次与Shader提交次数
  - 物理功能初始化内存： 初始化3D设置时，默认物理功能初始化内存，单位为M 默认16M 只能更大
  - 开启UniformBuffer： 可以减少CUP传递至GPU的数据量
  - 分辨率倍数： 降低3D分辨率，不会影响2D UI的分辨率，适当的调节可降低性能的消耗
  - 多光源： 如果不需要多光源，关闭后可减少性能的消耗。
  - 最大光源数量： 默认32
  - 光照集群数量： x、y、z轴的光照集群数量；z值会决定Cluster受区域光（点光、聚光）影响的数量
  - 最大形变数量： 网格渲染器的最大形变数量。默认值为32
  - 是否使用BVH裁剪： 一个BVH节点最大的cell数（超过这个数会分离）



###### 项目启动设置

- 入口启动场景
两种方式： 当前场景Current Scene ； 设置一个固定的项目入口
运行处 下拉菜单：可选择用哪种模式来运行 

- 引擎库模块
  - ani: 2D节点动画（序列帧、图集动画）、内置的骨骼动画  - 貌似没怎么用
  - device： 陀螺仪、加速计、地理位置、摄像头、麦克风
  - particle： 2D粒子的封装，不推荐使用  - 功能非常单一
  - gltf： 代码直接使用gltf模型的加载解析库
  - physics： Box2D物理库的封装
  - physics3D： Bullet 3D物理库
  - physics3D.wasm： WebAssembly的Bullet 3D物理库
  - workerloader： 异步解码图片


- 启动页配置
在游戏开始前，显示的图标；  不设置 默认使用引擎默认的图标


- 调试启动设置
  - 显示统计信息： 当前帧率、内存占用、节点等信息 [性能统计与优化](https://layaair.com/3.x/doc/basics/common/Stat/readme.html)
  - 显示移动端调试工具 VConsole
  - 弹窗显示全局错误: 捕获全局错误window.onerror 弹窗抛出详细错误堆栈


- 显示2D物理调试: 2D节点添加了物理属性（刚体、碰撞盒等） 添加了物理属性的节点会显示出阴影效果


###### 编辑器设置

- 3D预制体编辑场景: 指定3d预制件的编辑场景  默认是个空场景

- 资源导入时启用纹理压缩： 外部导入纹理资源（PNG与JPG）到IDE时 自动启动PC平台[纹理压缩](https://layaair.com/3.x/doc/IDE/uiEditor/textureCompress/readme.html) astc etc pvr bc1 bc3
  - 该操作对启用该功能之前的旧资源不产生影响
  - laya3.2已经没这个选项   每个资源都有单独的属性设置 怎么统一设置？


- 自动烘焙IBL
如果在Scene3D中更换了天空盒材质（Material由skybox更换为其它材质），此时Reflection Probe的IBL Tex无需手动点击烘焙按钮，保存场景后，IDE会自动进行重新烘焙

- 3D节点层级设置
[使用3D精灵](https://layaair.com/3.x/doc/3D/Sprite3D/readme.html)





#### 项目入口说明
在引擎初始化之后，项目首先要执行的地方


##### 启动场景
laya2在main.ts中初始化引擎 laya3改为主启动场景
怎么更加实际运行情况 动态修改引擎初始化前的配置？

- 设置启动场景
如果需要初始化引擎全局配置，直接在IDE的项目设置中配置
构建发布：启动场景 

- 入口的逻辑脚本
不建议开发者采用自定义的脚本作为项目的入口
代码的逻辑必须要跟随入口场景，通过入口场景激活与添加到舞台等引擎的生命周期方法来执行对应的逻辑
3D根节点Scene3D，可以绑定的脚本只有自定义的组件脚本
2D根节点Scene2D，除了自定义的组件脚本还可以绑定UI组件脚本-runtime
自定义的组件脚本（装饰器暴露属性、事件方法、生命周期方法等）[参考](https://layaair.com/3.x/doc/basics/common/Component/readme.html)
UI组件脚本（关联UI组件、与自定义组件脚本的区别等） [参考](https://layaair.com/3.x/doc/IDE/uiEditor/runtime/readme.html)




- 自定义组件脚本的基础使用流程
继承自Laya.Script类 定义了组件的事件方法和自身生命周期方法
属性设置面板中，点击增加组件->新建组件脚本


- UI组件脚本
用于2D场景中，需要管理的节点比较多的时候 需要在打开场景的时候需要为场景传递参数
UI组件可以独立使用，也可以与组件脚本同时使用
UI运行时（Runtime）属性入口进行添加
属性输入框进行鼠标双击操作 创建UI组件脚本文件


###### 自定义初始化
开发者可能需要在引擎初始化之前执行一些逻辑
通过Laya.addBeforeInitCallback定义引擎初始化之前要执行的逻辑
通过Laya.addAfterInitCallback定义引擎初始化之后要执行的逻辑
可以放到主场景文件MainScene.ts中 由于bundle初始化比index.js早
所以加载就 就会先执行函数
```js
// 在引擎初始化前执行自定义逻辑(此方法在Laya.init前调用)
Laya.addBeforeInitCallback(() => {
    console.log("before init");
});


// 在引擎初始化后执行自定义逻辑(此方法在Laya.init后调用)
Laya.addAfterInitCallback(()=>{
    console.log("after init");
});
```
* 这些代码所在的脚本文件是被场景中引用的，否则在发布版本时被消除项目中未使用的代码，那就无效了




#### 引用第三方JS模块

##### 使用命令引入第三方模块
1. 在项目文件夹执行 npm init 初始化项目
2. 使用npm install xxx --save 安装xxx包
3. 然后在代码中使用import语句导入即可

- 使用示例
npm init会生成一个pakeage.json文件
npm i astar-typescript --save
import { AStarFinder } from "../node_modules/astar-typescript/dist/astar";



##### LayaAir IDE中使用第三方JS文件
直接使用一些第三方的JS文件
1. 将JS文件放置到项目的assets文件夹或src文件夹下
2. 属性设置里勾选“导入为插件”    
  默认勾选了允许运行时加载和自动加载，即这个脚本会在运行时自动加载  
  依赖其它: 可以设置多个脚本，这些脚本将会安排优先载入  

- 使用示例
1. 下载[js库](https://github.com/bgrins/javascript-astar) 得到astar.js
2. 放到src/libs/ 属性勾选导入为插件; 应该需要d.ts文件来辅助
3. 发布后会自动加入release/web/index.html中



##### 层级面板说明

###### 层级面板的作用
包括了2D节点与3D节点 
2D与3D节点之间不可以混合形成父子层级关系


###### 层级面板的通用操作

- 创建3d节点：
  sprite3d 基础3d模型（cube sphere 等） 特效（Particle3d PixelLine Trail） 灯光 相机

- 创建2d节点：
  - 基础：Sprite Animation Text SoundNode VideoNode
  - ui组件：box image clip ...
  - 2d骨骼动画: Spine Skeleton

- 创建方式：
  - 不选中 创建单独节点 挂在根节点下  [快捷键](https://layaair.com/3.x/doc/basics/IDE/shortcutKeyCombinations/readme.html)
  - 父子节点


-  搜索节点: 
   -  搜索栏：过滤目标节点
   -  资源面板：右键图片 在场景中查找

- 隐藏节点： 层级面板 对象的最前面  注意：只影响ide 不影响实际运行

- 锁定节点： 不可操作 往往用于复杂界面 

- 节点的收缩与展开： 层级搜索后面 一键收缩功能  但无法还原

- 节点排序：
3d节点和本身位置+摄像机位置相关
2d节点和层级顺序相关 可通过修改zorder属性来跳过层级限制；最后安默认树层级显示，特殊情况可用zorder

- 右键菜单的通用功能
  - 生成副本 == 复制+粘贴


###### 3D场景节点操作

- 3D场景根节点的删除与创建
删除后 想重新添加3d场景：创建一个sprite3d即可


- 3D基础节点
[Sprite3D](https://layaair.com/3.x/doc/3D/Sprite3D/readme.html)
[3D基础显示对象](https://layaair.com/3.x/doc/3D/displayObject/readme.html)
[3D粒子](https://layaair.com/3.x/doc/IDE/particleEditor/readme.html)
[像素线](https://layaair.com/3.x/doc/IDE/Component/PixelLine/readme.html) 绘制3d模型线框
[拖尾](https://layaair.com/3.x/doc/IDE/Component/Trail/readme.html)
[灯光](https://layaair.com/3.x/doc/3D/Light/readme.html)
[相机](https://layaair.com/3.x/doc/3D/Camera/readme.html)



- 创建3D渲染节点
静态网格、门皮网格：直接从assets里拖到层级树上 不再需要从u3d里导出



######　2D场景节点操作
不可以被删除

- 骨骼节点
Spine通过将图片绑定到骨骼上，然后再控制骨骼实现动画。
Skeleton可以将一些经常使用的骨骼动画格式转换为LayaAir引擎支持的骨骼动画格式 -估计有功能限制



##### 项目资源面板说明

- 资源目录 assets
场景Scene中在assets里引入的资源会自动复制到发布目录
代码里引用的资源，必须放到resources目录里，才会被复制到发布目录里

- 项目源码目录src


- 右键菜单
重新导入：通常用于导入失败，或者有些外部依赖更改了，比如模型里有个材质，材质引用了外部贴图，但一开始贴图没放进来，后来放进来了，可以使用此功能


- 2D图片编辑成精灵纹理
2D图片资源，assets目录下，默认会作为3D模型的纹理格式
通常要改为2D的图片格式，需要开发者自行编辑
图片属性 -》 纹理类型  默认值-3d贴图  精灵纹理-2d sprite
若不改变类型 2d中显示3d纹理 背景会是蓝色

  - 非2次幂缩放：纹理不是2次幂时，缩放至2次幂的操作模式。
  - 可读写：开启后，可以用脚本动态读取纹理像素

[纹理压缩](https://layaair.com/3.x/doc/IDE/uiEditor/textureCompress/readme.html)



##### 快速创建文件
右键 或 左上角+

-　预制体2D
根节点是一个Box  可以更改为view dialog


- 预制体3D
根节点是一个Sprite3D

- 创建着色器
五种类型的shader文件 可以对shader进行修改成自定义的shader使用


- 着色器蓝图
可视化窗口来编辑shader

- 着色器蓝图函数
可视化窗口来编辑函数？

- 创建材质及配
八种类型的材质文件


- 立方体纹理
TextureCube
[3D场景环境设置](https://layaair.com/3.x/doc/IDE/sceneEditor/environment/readme.html)


- 渲染纹理
RenderTexture 将3D场景渲染到2D纹理中
[混合使用3D](https://layaair.com/3.x/doc/IDE/uiEditor/use3D/readme.html)

- 动画遮罩
AvatarMask 可以用来描述动画层遮罩
[动画状态机](https://layaair.com/3.x/doc/IDE/animationEditor/aniController/readme.html)


- 创建图片类型
右键创建：光照贴图烘焙设置 会创建LightingSettings文件 开发者可以设置光照属性，用来烘焙光照贴图

- 自动图集设置
会创建AtlasConfig文件 开发者可以用来自动打包图集
[web发布](https://layaair.com/3.x/doc/released/web/readme.html)

- 创建动画状态机
点击“动画状态机2D”和“动画状态机3D”会创建动画状态机

  - 2D动画状态机

  - 3D动画状态机: [动画状态机详解](https://layaair.com/3.x/doc/IDE/animationEditor/aniController/readme.html)



##### 搜索面板
搜索assets下资源

- 文字搜索
- 类型搜索


##### 目录设置面板
两栏显示: 左边树结构 右边内容
全部折叠：可惜无法还原展开



##### 属性设置面板说明

###### 通用功能

- 增加组件
3d和2d节点可添加的组件不同
3D节点可以增加的组件有：动画（时间轴动画、动画状态机）、3D物理、网格、特效（粒子、拖尾、像素线）、灯光、渲染（UI3D 、反射探针、体积全局照明、静态合批、LOD组）、自定义组件脚本、新建组件脚本。
2D节点可以增加的组件有：动画（时间轴动画、动画状态机）、2D物理、自定义组件脚本、新建组件脚本。

- 上一个、下一个
切换之前看到的结点

- 锁定
切换结点时属性设置面板不切换


###### 应用场景

- 节点的属性设置
  - 激活
    - 对于3D节点将不显示，即使运行时也不显示
    - 对于2D节点，取消激活后并不影响节点本身，只是不激活节点的脚本

- 3D节点：每一个Sprite3D都有静态或者动态的两种状态
  - 静态： 不会移动的物体
  - Layer：蒙版层，渲染相机根据蒙版层可进行可视遮罩层的控制

- 2D节点：
  - 定义变量
  - Runtime入口  只能是根节点的Scene2D

- 预制体: 属性会多出 [预制体模块](https://layaair.com/3.x/doc/IDE/prefab/readme.html)
  - 编辑：进入预制体的编辑页面
  - 定位：在项目资源面板中定位预制体资源文件
  - 覆盖属性：可以将修改覆盖到预制体中  否则只会在本界面内特有 覆盖默认的预制体

- 资源的属性设置
  - 图片
  - 位图字体
  - 自动图集
  - 材质
  - 动画：有2D动画文件和3D动画文件
  - 光照贴图烘焙
  - 第三方JS文件
  - 模型：支持的模型后缀为fbx与gltf的模型文件
  - RenderTexture
  - AvatarMask：开发者可以用来设置动作遮罩


- 代码预览



##### 预览运行面板说明

- 预览运行
开发者工具会调出Developer Tools Ctrl + Alt + I

- 预览运行的入口
构建发布：启动场景



- IDE预览运行面板的作用
方便开发者进行UI布局排版，这也是预览运行窗口在不运行时的一个作用
预览运行窗口只是不执行脚本，其它的效果都会显示

- 运行时：连脚本也运行




##### 预览运行面板的功能

- 分辨率
预览运行的分辨率就是项目设置中的分辨率 可自定义新的分辨率

- 横屏和竖屏
- 缩放、恢复1X
- 静音



#### IDE快捷键与鼠标交互操作大全


##### 通用的基础交互


- 切换面板显示层级
* 场景面板Scene	Ctrl + 1
* 运行面板Game	Ctrl + 2
* 属性面板Inspector	Ctrl + 3
* 层级面板Hierarchy	Ctrl + 4
* 项目资源面板Project	Ctrl + 5
* 控制台面板Console	Ctrl + 6
* 时间轴面板Timeline	Ctrl + 7


- 文件与节点的通用操作
  - 重命名：F2 or 单击选中后间隔半秒再单击
  - 复制、粘帖、删除、选中
    * 多选	Ctrl + 鼠标左键单击
    * 不间断多选	Shift + 鼠标左键单击

- 层级面板的常用操作
  - 创建空节点
    * 在根节点下，创建一个空子节点	Ctrl + shift + N
    * 为选中的当前节点，创建一个空子节点	Alt + shift + N
    * 为选中的当前节点（可多选），创建一个空父节点	Ctrl + shift + G

- 展开全部子节点：Alt + 鼠标左键单击


- 层级面板的顺序调整
  - 拖拽为目标节点的下级节点:目标节点呈现绿色矩形框时
  - 拖拽为目标节点同级之后: 绿色线条位于目标节点下方时
  - 拖拽为目标节点同级之前: 绿色线条位于目标节点上方时


- 层级与场景的通用操作
  - 3D节点的视窗聚焦：F  == 左键双击3D节点
  -  复制并粘贴节点：Ctrl + D 

- 运行预览功能
* IDE内运行预览	Ctrl + P
* 浏览器内运行预览	Ctrl + Shift + P
* 手机扫码运行预览	Ctrl + Shift + O


-  属性面板操作
  - 属性数值滑动输入
  - 属性保存：Ctrl + S


###### 2D场景视窗交互
* 平移视图舞台	中键长按拖拽、右键长按拖拽
* 上下滚动视窗内容	鼠标滚轮
* 缩放视窗内容	Ctrl + 鼠标滚轮


###### 3D场景视窗交互
一是，改变场景视窗的摄像机位置与角度，让开发者如同自己的眼睛一样观察3D场景世界  
二是，改变模型的位置与角度，将模型摆放到场景中适当位置  

- 操作视窗摄像机
  - 旋转视窗摄像机：鼠标右键
  - 空间位移视窗摄像机：鼠标右键 + 键盘功能键，可以让摄像机按上下左右前后
    * 摄像机向上位移	鼠标右键 + E
    * 摄像机向下位移	鼠标右键 + Q
    * 摄像机向左位移	鼠标右键 + A
    * 摄像机向右位移	鼠标右键 + D
    * 摄像机向前位移	鼠标右键 + W
    * 摄像机向后位移	鼠标右键 + S
    * 按住Shift叠加，可以在原功能基础上进行加速移动

  - 屏幕内位移视窗摄像机：Q \ 鼠标中键

- 视窗摄像机缩放：鼠标滚轮

-  视窗摄像机绕焦点中心旋转：Alt + 左键拖拽


- 操作模型
模型的工具有四种，分别是位移、旋转、缩放、混合使用  
快捷键 W、E、R、T
- 模型位移工具：W
  - 如果该模型没有任何旋转（rotation都为0），拖动其中一个轴，只有该轴的属性值会发生变化 。如果有旋转，则会影响其它 轴属性值 ?

  - 模型旋转工具：E
    - 外层白圈，是基于屏幕的垂直旋转
    - 鼠标在半透明圆拖拽，则可以任意角度旋转

  - 模型缩放工具：R
    - 中心的白块与外层白色圆圈均是三轴同时缩放

  - 模型工具集合：T
    - 混合模式下，中心块缩放不再保留


##### 时间轴动画编辑快捷键

- 时间轴帧面板的快捷键
* 插入空白帧	F5
* 删除空白帧	Shift + F5
* 删除关键帧	Delete
* 复制关键帧	Ctrl + C
* 粘贴关键帧	Ctrl + V
* 当鼠标处于时间轴帧面板操作时，纵向滚动显示属性	Ctrl+滚轮


- 时间轴曲线面板的快捷键

- 蓝图编辑器快捷键




## 引擎通用基础
[j](/docs/laya/laya3.x/laya3官方文档学习/引擎通用基础.md)

























