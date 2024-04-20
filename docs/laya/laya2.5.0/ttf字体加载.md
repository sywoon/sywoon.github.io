# 🔙​[Laya](/docs/laya/)


## ttf加载

- 方式1：TTFLoader
```
  new TTFLoader().load(url, fontName) 若不传name 使用文件名
  内部又分为3种情况：
    A 原生app 用HttpRequest的BUFFER方式下载 直接传给底层
    window["conchTextCanvas"].setFontFaceFromBuffer(this.fontName, data);
    B 支持FontFace的环境 浏览器和微端
    document.fonts.add(new window.FontFace(name, "url('" + this._url + "')"))
    C 使用CCS 估计是早期的浏览器
      fontStyle = Browser.createElement("style");
      fontStyle.type = "text/css";
      document.body.appendChild(fontStyle);
      fontStyle.textContent = "@font-face { font-family:'" + this.fontName + "'; src:url('" + this._url + "');}";
      fontStyle.onload = function (): void {
            ILaya.systemTimer.once(10000, self, self._complete);
        };
        
        可以在html中的head部分直接加载  也支持浏览器和微端环境
        <style>
            @font-face {
                font-family : "korea_font";
                src : url("res/fonts/korea_regular.ttf") format("truetype")
            }
        </style>
```

- 方式2：使用Loader.load()  注意类型是ttf
```
	Laya.loader.load(url, complete, progress, Loader.TTF)
	内部还是使用TTFLoader来加载
	缺点：wx小游戏不支持 因为没有FontFace对象
```

- 方式3：使用底层自己的字体加载 
```
  先使用buffer的方式下载字体
  Laya.loader.load(url, Loader.BUFFER
  再调用wx函数
  fontName = window.wx.loadFont(info.tempFilePath);
  由于字体名称ios ard不同 而且和文件名也不同 -可以通过字体工具修改ttf内部的字体名称
  添加到laya.text的映射 只有iphone环境才会使用
  Laya.Text.fontFamilyMap[originName] = fontName;  
```


## ttf字体的名称

- TTFLoader
load时会传入或提取文件名作为fontName
```
  native 和数据一起传给底层
  FontFace创建时就带入
  CCS 传给div.styple.fontFamily 所以可以传多个 name1;name2;
  
```

- Text
```
   /**在IOS下，一些字体会找不到，引擎提供了字体映射功能，比如默认会把 "黑体" 映射为 "黑体-简"，更多映射，可以自己添加*/
  fontFamilyMap = { "报隶": "报隶-简", "黑体": "黑体-简"
```


## 控件中的字体
上面document.fonts.add(fontface) 或者 div.style.fontStyle  用途？  
canvas的2d上下文 会到这里取字体对象？  

- Text
```
  根据css规则 多个内容合并成一个字符串 "italic bold 30px simhei"
  protected _getContextFont(): string {
    return (this.italic ? "italic " : "") + (this.bold ? "bold " : "") + this.fontSize + "px " + (ILaya.Browser.onIPhone ? (Text.fontFamilyMap[this.font] || this.font) : this.font);
    }
    
  使用：传给canvas的getContext('2d')对象 用于后面的渲染
  ILaya.Browser.context.font = this._renderFont;
  ctx.fillText(char,
  ctx.getImageData(
```

- HTMLStyle
```
  同上 而且映射也是text中取的
  get font(): string {
    return (this.italic ? "italic " : "") + (this.bold ? "bold " : "") + this.fontSize + "px " + (ILaya.Browser.onIPhone ? (ILaya.Text.fontFamilyMap[this.family] || this.family) : this.family);
    }
```

- Input
```
  命中时 将控件的字体传给原生控件
  _focusIn(): void {
  	let fontFace = ILaya.Browser.onIPhone ? (Text.fontFamilyMap[this.font] || this.font) : this.font
  	var input: any = this.nativeInput;
  	input.style.fontFamily = fontFace;
```



## 默认字体
系统内部是怎么支持？ 会读取操作系统内的字体？    

``` 
  Text.defaultFont: string = "Arial";  
  Text.defaultFontSize: number = 12;  
  static defaultFontStr(): string {
      return Text.defaultFontSize + "px " + Text.defaultFont;
  }

  渲染字体时 若未传入font 会使用默认值
  fillText(text: string, x: number, y: number, font: string, color: string, textAlign: string): FillTextCmd {
        return this._saveToCmd(Render._context.fillText, FillTextCmd.create.call(this, text, null, x, y, font || ILaya.Text.defaultFontStr(), color, textAlign, 0, ""));
    }
```


- 修改ComBox的默认字体
自带创建的Lable使用了Text默认的字体 若想修改 可在创建时传入
```
  方式1：直接添加新属性font:"KaitiSC"  缺点:不通用
  protected changeList(): void {
    this._list.itemRender = this.itemRender || { type: "Box", child: [{ type: "Label", props: { name: "label", x: 1, padding: "3,3,3,3", width: labelWidth, height: this._itemHeight, fontSize: this._itemSize, color: labelColor ,font:"KaitiSC"} }] };

  方式2：定义默认字体 可后期修改
```


