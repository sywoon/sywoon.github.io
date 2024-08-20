
## Laya3 Scene对比


- View 3.x里删除了布局功能 纯粹的视图类
- Scene 3.x  通过静态方法open 加载lh文件后 解析内容并创建ui树 本身的根节点就是scene对象 直接作为返回值
```
  close  根据autoDestroyAtClosed  判断是否调用destroy
  this._timer = ILaya.timer;  本身包含系统定时器
  this._scene = this;   2d场景
  _scene3D: any;  3d场景
  _widget: Widget;  相对布局
  _root: Sprite;  公共节点 调用open接口 所有scene都挂这下面
    root = Scene._root = (<Sprite>ILaya.stage.addChild(new Sprite()));
  createChildren  构造时调用 用于子类扩展加载ui json
  loadScene(path: string)  加载一个lh文件  会统一在Scene.unDestroyedScenes管理 方便查看泄露 destroy时删除记录
  open(closeOther: boolean = true, param: any = null):
    Scene.root.addChild(this);
    ILaya.stage.addChildAt(this._scene3D, 0);  如果有3d场景 同步添加
    this.onOpened(param);  特有接口
  
  close(type: string = null)
    this.onClosed(type);  特有接口
	if (this.autoDestroyAtClosed) {
		this.destroy();
	else
		this.removeSelf();

  static load(url: string, complete  创建scene实例 但不会加到root中
  static open(url: string, closeOther:  先load 再open
  static close(url
    从Scene.unDestroyedScenes找同url对象 并调用close
  static closeAll()
```

- Scene 2.x  本身是个空scene节点 构造时 通过createChildren 自动加载json并创建ui树
```
  static preLoadScene(path: string, caller   加载json文件
    var loader = SceneLoader.create();
	loader.load(url);

  loadScene(path:string)
    Scene.preLoadScene(url, this, this._onSceneLoaded);
    有bug 内部子节点创建不了
	  let node = createNode(data, null, runtime);  创建的runtime节点
	  createChildren(data, data._$prefab ? node : null);  
	  后续dataList allNodes生成树时 失败了！

  _onSceneLoaded(url) {
	this.findViewRes(view, this.uiUrl);  记录ui资源 合图路径
	this.createView(view);  子节点 -ui编辑器中的内容
	this.event(Event.LOADED);
```


## Scene的打开和关闭
- laya3.x  
```
	Laya.Scene.open("resources/scenes/Index.ls")  自动挂到root节点  ui中挂了runtime.ts会自动new
	s.close()

    loadScene(path)  是否还能用  路径可否通过别的方式获得？  必须带.lh 否则会改为.scene后缀

    测试可行 不用内部的open方法 自己实现创建 并加入到需要的节点
    Laya.loader.load("Login.ls", Laya.Loader.HIERARCHY).then((prefab: Laya.Prefab) => {
		// Laya.stage.addChild(prefab);
		console.log("load lh cbk", prefab)
		let scene = prefab.create({ root: this });
		Laya.stage.addChild(scene);
	});
```

- laya2.x
```
  Laya.Scene.open("Game.scene");   方式1  自动管理 挂在内部的root节点上

  new SysMain()  方式2  由uimgr管理 挂在自己的rootNode
    createChildren()
		this.loadScene("view/planet/sys_planet");

  layaMaxUI.ts
  module ui.view.main {
  REG("ui.view.main.sys_mainUI",sys_mainUI);  这个信息非常重要
  export class sys_mainUI extends sg.ViewBase {
		public task_move_out:Laya.FrameAnimation;
		....
		createChildren():void {
            super.createChildren();
            this.loadScene("view/main/sys_main"); 和注册的字符串结构类似
        }

  export class SysMain extends ui.view.main.sys_mainUI { 
  可以通过类名 获取注册的字符串名 再改为url路径名  来解决手动输入的问题
```


## 预制件Unit案例
- 主界面
```
export class LoginBase extends Laya.Scene {
    public btnLogin!: Laya.Button;
	public unitTest!: TestUnit;  终于导出正确的类对象了
}
```

- 自定义界面类
```
export class Login extends LoginBase {
    onAwake(): void {
        //报错： Not a scene:TestUnit.lh
        // Laya.Scene.load("TestUnit.lh", Laya.Handler.create(this, this.onSceneLoaded));
	   方法1：直接在ide中拖入预制件 这里可直接使用
		this.unitTest.msg = "login";
	   方法2：动态加载和创建预制件
        Laya.loader.load("TestUnit.lh", Laya.Loader.HIERARCHY).then((prefab: Laya.Prefab) => {
            // Laya.stage.addChild(prefab);
            console.log("load lh cbk", prefab)
            let box = prefab.create({ root: this });
            this.addChild(box);
        });
        this.btnLogin.on(Laya.Event.CLICK, this, this.onBtnLoginClick);
    }

    onBtnLoginClick(): void {
        console.log("onBtnLoginClick");
    }
}
```

- 预制件runtime
```
export class TestUnitBase extends Laya.Box {
}
ide自动生成的类
export class TestUnit extends TestUnitBase {
	msg: string = "testUnit";  可以在父scene中直接使用
    onAwake(): void {
    两种使用控件的方式都可以
    方式1： 定义var变量  外部scene若拖入改预制件 改不了这个值  所以所有地方都通用  是否有命名冲突问题？-理论上不会
    方式2： 通过变量名获取 
		缺点：若外部scene修改了名称 将报错
        // this.btnTest.on(Laya.Event.CLICK, this, this.onBtnTestClick);
        let btnTest = this.getChildByName("btnTest") as Laya.Button;
        btnTest?.on(Laya.Event.CLICK, this, this.onBtnTestClick2);
    }

    onBtnTestClick(): void {
        console.log("onBtnTestClick");
    }

    onBtnTestClick2(): void {
        console.log("onBtnTestClick");
    }
}
```

### laya3 界面应用小结
1. scene类 可通过封装Laya.loader.load 来动态创建 并控制其挂载的节点 方便业务分层
2. prefab 可以动态创建  也可以直接拖入scene中静态方式使用-和主界面一起加载



## view参考思路：
- layaMaxUI.ts
```
module ui.view.main {
	export class sys_mainUI extends sg.ViewBase {
		public task_move_out:Laya.FrameAnimation;
		public tab:Laya.Tab;
		createChildren():void {
            super.createChildren();
            this.loadScene("view/main/pop_mainExpand");
        }
    }
    REG("ui.view.main.pop_mainExpandUI",pop_mainExpandUI);
```

- ViewBase
```
protected get view(): ViewBase {
    return this._view;
}

 protected rewriteCreateChildren(cls: typeof ViewBase): void {
   ui.view.main.sys_mainUI
    const name = mgr.toolsMgr.getNameByRegClass(cls);
    if(name == null) 
        throw Error(`rewrite children error, this class is not reg, cls name: ${cls.name}`);
    const newStr = name.replace(/^ui\./, '').replace(/UI$/, '').replace(/\./g, '/');
    this.loadScene(newStr);  转为 view/main/sys_main  使用基类的方法加载url
    this._view = this;
}
```

- 案例1： laya2  ui基类直接继承ViewBase  ide导出的ui改为view成员对象-laya2根节点不是scene 
    laya3根节点是默认自动创建的scene 若采用这个方式 是否需要删除？
```
export class sys_planetUI extends sg.ViewBase {
  public imgBg:Laya.Image;  包含ui上注册的var
  createChildren():void {
	super.createChildren();
	this.loadScene("view/planet/sys_planet");  加载json文件 作为子节点加入自己身上  内容会挂到本身节点上  虽然ide中有个view的根节点 这里不会创建
  }

原版 SysMain : ui.view.main.sys_mainUI {  直接继承ui类  可以直接.btnXXx
新版 SysMain : ViewBase : Laya.View : Laya.Scene : Laya.Sprite
  protected view: ui.view.planet.sys_planetUI;  多了定义对应 方便识别控件
  createChildren() {  覆盖基类 重新实现加载逻辑 主要解决路径名称问题 
    this.rewriteCreateChildren(ui.view.planet.sys_planetUI);  从UI编辑中导出的类 在layaMaxUI中
  }
  ide的类 被额外包装了 成为了成员view
  需要的时候 需要用view.btnXXX
```
优点：可继承 换一个皮肤 来实现大部分类似的功能  
  不同的皮肤 可用同一个类 切换不同的scene类名即可
  Unit也可这么封装  针对多个公共基类的情况


- 案例2：
```js
 class ViewBaseWithContainer<T extends Laya.View> extends ViewBase {
   constructor(container: T) {
        super();
        this.container = container;
    }
    
  export interface IUnitBaseContainerButton {
        boxScale: Laya.Box;
        boxClick: Laya.Box;
        imgButton?: Laya.Image;
        lblName?: Laya.Label;
    }
    
  二次继承类封装  指定具体的接口包含的组件名和类型 
  适合封装一个基本控件： 按钮 进度条
  export class UnitBaseContainerButton<T extends Laya.View & IUnitBaseContainerButton> extends sg.ViewBaseWithContainer<T> {
  
  class UnitBaseContainerProgressBar<T extends Laya.View & IUnitBaseContainerProgressBar> extends sg.ViewBaseWithContainer<T> {
  
  class PlanetEventEraContainer<T extends IPlanetEventEraUI & sg.ViewBase> extends sg.ViewBaseWithContainer<T> {
  
  view上使用
  class SysGuild
     private _btnAssist: UnitBaseContainerButton<ui.view.guild2.components.unit_guildMainOperationButton2UI>;
     onAwake()
       this._btnAssist = new UnitBaseContainerButton(this.btnAssist);
     
  unit_guildMainOperationButton2UI
  unit_guildMainOperationButton2UI2
  两者按钮结构一致 图片不同 共用一套业务类 
```
不同的ui 结构树和内部控件命名都相同  用于unit界面
拖入不同的主ui中  界面创建后 将节点对象传给container + 接口定义IUnitBaseContainerButton

- 案例3： 
使用预制件创建BoxXXX 挂runtime 内部使用命名来获取子控件 为了防止var和宿主冲突-laya3已经不允许宿主定义var了
将BoxXXX拖入需要的主ui中  由于是prefab 可以二次修改背景图 大小 - 但要保证树结构和命名不变
同样可以支持案例2的功能  且写的代码更清晰  不用定义接口和容器类



























