



[doc](https://layaair.layabox.com/3.x/doc/)
[doc_cmdline](https://layaair.com/3.x/doc/released/commandLine/readme.html)
[demo2](https://layaair2.ldc2.layabox.com/demo2/?language=en&category=2d&group=Sprite&name=DisplayImage)
[demo3](https://layaair.layabox.com/3.x/demo/)
[ask](https://ask.layabox.com/)
[github](https://github.com/layabox/LayaAir?tab=readme-ov-file)
会比国内的gitee更新


运行demo：需要先初始化子模块bin/sample-resource
npm run start
有两种打包方式：散文件tsc+bundle-rollup  3.*只有bundle版本了 tsc没用上？




## Laya3.0中scene的加载
- 启动加载流程：
```js
index.html
layalib.js 各种库注册
  ModuleDef.ts 大量的类注册  有好多个文件 分2d和3d
  ClassUtils.regClass("DrawCircleCmd", DrawCircleCmd);
bundle.js
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
  var __decorateClass = (decorators, target, key, kind) => {
    var result = kind > 1 ? void 0 : kind ? __getOwnPropDesc(target, key) : target;  得到类
    for (var i = decorators.length - 1, decorator; i >= 0; i--)
      if (decorator = decorators[i])
        result = (kind ? decorator(target, key, result) : decorator(result)) || result;
    if (kind && result)
      __defProp(target, key, result);
    return result;
  };

  Decorators.ts
  export function regClass(assetId?: string): any {
    return function (constructor: Function) {
        ClassUtils.regClass(assetId, constructor);
    };
  }

  ui文件编译后的内容  代码里写@regClass() 编辑器会扩展编译后的内容  运行中调用__decorateClass
  @regClass('73edd2a2-7bbb-4563-a6e4-44f2d93ac172', '../src/ItemBox.ts')   返回一个构造函数
  export class Script extends ItemBoxBase {
index.js
```

- 导出web版本
```js
  index.html
    各种laya库
      Scene.ts
        loadScene(path: string): void
          ILaya.loader.load(url, null, value => {
            .then((content: Prefab) => {  实际为PrefabImpl对象
                content.create({ root: this });  

      针对.ls文件 实际对应
      HierarchyLoader.ts
      _load(api: IHierarchyParserAPI, task
        "_cache_/939c6ee1-3ad7-4842-8dbd-5dabd6c7d7db.ls"
        let res = new PrefabImpl(api, data, version);
      Loader.registerLoader(["lh", "ls", "scene", "prefab"], HierarchyLoader, Loader.HIERARCHY);

      export class PrefabImpl extends Prefab {
        create(options?: Record<string, any>, errors?: any[]): Node {
            let ret = this.api.parse(this.data, options, errors);
      HierarchyParser.ts
        parse(data: any, options
          "Scene"
          if (data._$type || data._$prefab) {
            runtime = data._$runtime;  "res://c6669a60-6f00-435c-82d3-ba6bfc9bf23c"
            if (runtime && runtime.startsWith("res://"))
                runtime = runtime.substring(6);
            let node = createNode(data, null, runtime);
            if (data._$child)  将ui中的子节点 挂到实例对象里 再挂到Stage里就可以显示整个ui树了
                createChildren(data, data._$prefab ? node : null);

          根据dataList allNodes创建ui树

        createNode(nodeData: any, prefab: Node, runtime?: string)
            if (nodeData._$type)  "Scene"
                let cls = ClassUtils.getClass(runtime || pstr);
                node = new cls();   创建业务Scene类实例
                nodeMap[nodeData._$id] = node;
        
        createChildren(data: any, prefab: Node) {
            for (let child of data._$child) {
                if (child._$child) {
                    let node = createNode(child, prefab);
                    createChildren(child, child._$prefab ? node : prefab);
                }
                else {
                    let node = createNode(child, prefab);
                ｝
                dataList.push(child);
                allNodes.push(node);


    bundle.js  编译器根据import依赖 将所有文件按顺序打包入该文件 所以只要加载 
      就会触发__decorateClass函数调用 从而将类和唯一字符串注册入Laya.class中
      后期加载scene后 会根据runtime来创建实例对象 
        原始ts写法：
        @regClass()
        export default class LoadingRT extends LoadingRTBase {
        编辑器会分析@语法

        // src/LoadingRT.ts
        var { regClass: regClass3 } = Laya;
        var LoadingRT = class extends LoadingRTBase {
            onAwake() {}
        }
        LoadingRT = __decorateClass([
            regClass3("xmaaYG8AQ1yC07pr_JvyPA")
        ], LoadingRT);

    index.js
      Laya.init(config.resolution).then(() => { 引擎初始化
        加入vconsole库
        debug stat窗口
        spine版本3.8
        启用worker
        config.pkgs 分包？-不是   fileconfig.json的路径 可以有多个
        config.StartScene
        打开配置的主场景 "Loading.ls" --主目录下的实际资源  和ide中不同(临时目录_cache/xxx文件)
        Laya.Scene.open(config.startupScene, true, null, null, Laya.Handler.create(null,            
          loadSceneProgress, null, false)).then(() => {
            if (window && window.hideSplashScreen)
                window.hideSplashScreen();
        });

    Loading.js
      {"_$ver":1,"_$id":"55jj8juz","_$runtime":"xmaaYG8AQ1yC07pr_JvyPA"
         
```















