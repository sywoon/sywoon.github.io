# astc方式压缩纹理
[工具](https://www.npmjs.com/package/astctool-laya)  
npm install astctool-laya -g  

若不采用-g方式 而是-D安装在本地：
astctool-laya\astcenc.exe

- 使用方式astctool-laya\readme
```
  在项目bin目录下执行 astclaya
  配置文件
  {
	"excludeFiles": [],                 排除的文件
	"imagesize": "128x128",             文件转换最小尺寸
	"excludeFolders": [],               排除的文件夹
	"inExt": [
		".png",
		".jpg"                          需要转换图片的扩展名
	],                  
	"outExt": ".ktx",                转换输出文件的扩展名 可以自定义 比如.ktx.js 这样cdn可以用gzip进一步压缩
	"arg": {
		"colorSpace": "cl",
		"blocksize": "10x10",           基本参数
		"quality": "medium"
	},
	"outfileList": {}                   输出的列表;
  }
```


## 使用案例
1. npm i astctool-laya-D  得到本地的 node_modules/.bin/astclaya.cmd  
	node_modules/astctool-laya/astcenc.exe 转换工具
	/image-size 读取各种图片的大小
2. npm init  一路回车 得到package.json
	配置 "astc": "astclaya bin"
3. npm run astc 会根据astc.config.json 将bin/res/atlas/*.png 转换为.ktx
```
	"outExt": ".ktx",   可改为.ktx.js 方便cdn传输压缩
	"blocksize": "10x10",  这个控制质量4x4最高 最后的gpu也是1/4 12x12最高压缩 非常模糊
	参考：https://zhuanlan.zhihu.com/p/158740249
```

### 运行期支持
1. 判断环境是否支持astc
```
  LayaGPU.ts
  	this._compressedTextureEtc2 = this._getExtension(""EBGL_compressed_texture_etc2");
  	this._compressedTextureASTC = this._getExtension(""EBGL_compressed_texture_astc");
  
  AstcUtils
  	static isastc() 
  		return Laya["LayaGL"].layaGPUInstance._compressedTextureASTC;
```

2. 新增文件映射
```
//配置的内容：{"bg/comp.png":"bg/comp.ktx",  和版本文件是同一个
  Laya.ResourceVersion.manifest = Laya.loader.getRes("minastc.config.json");
  替换映射规则
  Laya.URL.customFormat = this.translateUrl.bind(this);
  translateUrl(key) {
   return Laya.ResourceVersion.manifest[key] || key;
  
```

2. 若支持 重新覆盖Loader加载
只支持了微信环境
```
  Laya.Utils.getFileExtension = function (vale)
    文件后缀命中.ktx
    if (vale.lastIndexOf(AstcUtils.fileExtDot) != -1) {
    	return AstcUtils.fileExt;  //.ktx
    文件路径映射命中
    if (Laya.ResourceVersion.manifest[vale]) {
        return AstcUtils.fileExt;
  
  Laya.LoaderManager.prototype.load = function (url
  	if (type == "htmlimage") {
       type = Laya.Loader.IMAGE;
  
  Laya.Loader.prototype["_loadResourceFilter"] = function (type, url) {
    var ext = Laya.Utils.getFileExtension(url);
    if (ext == AstcUtils.fileExt) {
        type = Laya.Loader.IMAGE;
  
  Laya.Loader.prototype["_loadImage"] = function (url,
    if (window.wx) {
      if (ext == AstcUtils.fileExt) {
        this._loadHtmlImageKtx(url, this, this.onLoaded, this.onError);

  Laya.Loader.prototype["_loadHtmlImageKtx"] = function (url, onLoadCaller, onLoad, onError) {
        const fs = window.wx["getFileSystemManager"]();
        fs.readFile({
            filePath: url,
            success(res) {
                if (!onLoadCaller._http) {
                    onLoadCaller._http = new Laya.HttpRequest();
                }
                onLoadCaller._http._url = onLoadCaller.sourceUrl;
                onLoad.call(onLoadCaller, res.data);
            },
            fail(res) {
                console.error(res);
                onError.call(onLoadCaller);
            }
        });
    };
```


### 兼容性
astc是opengl es 3，不是opengl3 [检测网站](https://toji.github.io/texture-tester/)
1. pc浏览器不支持
2. 微信小游戏PC版本不支持astc https://forum.cocos.org/t/topic/146475










