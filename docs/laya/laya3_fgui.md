

# FairyGUI-layabox
master:laya3中使用fgui的demo

## 小姐
1. fgui通过包来封装资源和ui界面
2. fgui内部有个根节点 初始化时挂到Stage 后期所有的界面都挂在他内部
3. ui界面 是通过一个纯逻辑类控制 通过_view存放包里创建的ui界面-在fgui中编辑 类型：fgui.GComponent
4. 通过_view.getChild("n34").onClick(this, this.__clickButton); 方式获得子节点 
5. 通过_view.dispose(); 来关闭和释放ui界面资源


## 入口
Scene.lh
  挂Main.ts脚本 非runtime
- Main.ts
```js
  class Main extends Laya.Script
    onStart() {
        Laya.stage.addChild(fgui.GRoot.inst.displayObject);  将fgui根节点挂到Laya.stage
        new DemoEntry();
```

- DemoEntry.ts
```js
  class DemoEntry
    constructor() {
        Laya.stage.on("start_demo", this, this.onDemoStart);
        this._currentDemo = new MainMenu();   ui逻辑对象
    }

    onDemoStart(demo : any) {
        this._currentDemo = demo;  某个demo的实例 纯粹逻辑类 无继承
        this._closeButton = fgui.UIPackage.createObject("MainMenu", "CloseButton"); 包中创建按钮
        this._closeButton.sortingOrder = 100000;
        this._closeButton.addRelation(fgui.GRoot.inst, fgui.RelationType.Right_Right);
        this._closeButton.onClick(this, this.onDemoClosed);
        fgui.GRoot.inst.addChild(this._closeButton);  加入fgui根节点 

    onDemoClosed() {  关闭demo后 回到主界面
        if (this._currentDemo.destroy)
            this._currentDemo.destroy();
        fgui.GRoot.inst.removeChildren(0, -1, true);

        this._currentDemo = new MainMenu();
    }
```

- MainMenu.ts
```ts
  private _view: fgui.GComponent;  fgui节点类

  constructor() {
    加载资源包
    fgui.UIPackage.loadPackage("resources/ui/MainMenu", Laya.Handler.create(this, this.onUILoaded));
  }

  onUILoaded() {
    this._view = fgui.UIPackage.createObject("MainMenu", "Main").asCom;从资源包里创建view对象 返回fgui.GComponent
    this._view.makeFullScreen();  作为view需要全屏显示
    fgui.GRoot.inst.addChild(this._view);  挂到fgui的根节点

    this._view.getChild("n1").onClick(this, () => {  得到子button
        this.startDemo(BasicDemo);
    });
    ...
  }

  startDemo(demoClass: any): void {
    this._view.dispose();   为何要释放自己？
    let demo: any = new demoClass();
    Laya.stage.event("start_demo", demo);
  }
```


- BasicDemo 具体业务demo
```js
  class BasicDemo {  没继承
     _view: fgui.GComponent;
     _demoContainer: fgui.GComponent;
     _cc: fgui.Controller;

    constructor() {
      fgui.UIConfig.verticalScrollBar = "ui://Basics/ScrollBar_VT";  公共控件资源？
      fgui.UIPackage.loadPackage("resources/ui/Basics", Laya.Handler.create(this, this.onUILoaded)); 加载包

    onUILoaded() {
        this._view = fgui.UIPackage.createObject("Basics", "Main").asCom;  fgui界面 作为子节点保存
        this._view.makeFullScreen();
        fgui.GRoot.inst.addChild(this._view);

        this._demoContainer = this._view.getChild("container").asCom; 容器？
        this._cc = this._view.getController("c1");  控制器

        var cnt: number = this._view.numChildren;  遍历子节点
        for (var i: number = 0; i < cnt; i++) {
            var obj: fgui.GObject = this._view.getChildAt(i);  
            if (obj.group != null && obj.group.name == "btns")  判断是否相同的group 都属于btns组内的控件
                obj.onClick(this, this.runDemo);

    private runDemo(evt: Laya.Event): void {
        var type: string = fgui.GObject.cast(evt.currentTarget).name.substring(4);  比如选择了Graph按钮
        var obj: fgui.GComponent = this._demoObjects[type];
        if (obj == null) {
            obj = fgui.UIPackage.createObject("Basics", "Demo_" + type).asCom;  加载Demo_Graph界面
            this._demoObjects[type] = obj;
        }

        this._demoContainer.removeChildren();
        this._demoContainer.addChild(obj);  加到容器

```














