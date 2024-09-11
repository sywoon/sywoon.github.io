
# 从laya2.5升级到laya3.2
实际已经换了整个工程 保留base+其他公共部分代码



## laya3中2d和3d工程的区别
1. 创建scene多一个3d场景
2. 对比工程 除了library/asset-db.info有区别外 之前几个文件都没内容差异
  猜测某个地方有个开关 新建scene时可以判断是否需要3d场景
3. 新建一个scene 发现无论2d还是3d都会有scene3d 所以2猜测错了 纯粹初始工程有区别
- 结论：两种方式都可以 无论项目以后用哪种方式



## 工程权限设计
程序和策划-ui编辑+资源整理
共用工程壳：包含除src外的所有文件

- src怎么拆分？
公共部分：GameScene LoginView 
所有ide的runtime都在src/runtime下创建 命名规则：xxx_Runtime
得到两个文件：
```ts
GameScene_Runtime.generated.ts 
  class GameScene_RuntimeBase extends Laya.Scene
GameScene_Runtime.ts
  GameScene_Runtime extends GameScene_RuntimeBase
```
其他mvc下的view都用相同的方式创建  这个文件夹默认就在主工程下 git一起管理
- 问题：游戏工程的GameScene不能启动了 因为入口文件不同
解决1：用工具将runtime改为GameScene.ts
解决2：不管 策划工程不需要跑这个scene 只需要跑当前的ui即可


- 客户端工程
src下 除runtime外的所有内容  git子module还是独立的子git工程？





## 遇到的问题

### UIMgrLayerMap extends UIMgrLayerBase编译不过
找不到UIMgrLayerBase的构造函数

- 原因：有相互继承关系 当上在基类中又引用了子类
```ts
static createLayers(owner: UIMgr, rootNode: Laya.Sprite): Map<number, UIMgrLayerBase> {
    let layerMap = new UIMgrLayerMap(owner, UIMGR_LAYER.UIMGR_LAYER_MAP, mapNode);
    layers.set(UIMGR_LAYER.UIMGR_LAYER_MAP, layerMap);
```
- 结论：
1. ts中并非相互import能自动解决
2. 这种工厂类函数 不适合放在基类中 可以移到UIMgr

































































