
# laya native

## 环境准备
[文档](https://ldc2.layabox.com/doc/?nav=zh-ts-6-0-0)
1. 下载LayaNative2.0-main  LayaAirIDE2.13.1 release-v2.13.1
2. 使用ide 菜单tools：app构建 导出ios ard工程
3. 引擎工程LayaNative2.0-main\Conch\build\conch包含了3种平台
	-  proj.android_studio
	-  proj.ios
	-  proj.win32





注意事项：

1. ios环境 或mac跑ipad模拟器 需要layadcc  会去读取update/assetsid.txt
   但是win32环境不需要 根据文档 若没update是直接从远程读取的 方便开发调试
2.  



# android工程

```
  MainActivity
  checkApkUpdate(Context context)
  -》
  MyGame.CheckVerifyVersion();
  -》
  initEngine()
    String gameUrl = PlatformCfg.GetJsEntry();
    mPlugin.game_plugin_set_option("gameUrl",gameUrl);
    this.setContentView(gameView);
```



# ios工程
启动方式和ard不同 并没有在object-c中设置入口url 而是在index.js中
- 分析LayaNative2.0/Conch/build/conch/proj.ios
```
  JCConch
  JCConch::JCConch(int nDownloadThreadNum, JS_DEBUG_MODE nJSDebugMode, int nJSDebugPort) 
  	m_strStartJS = "scripts/apploader.js";

  void JCConch::onAppStart() 
    m_pScrpitRuntime->start(m_strStartJS.c_str());

  JCScriptRuntime
  void JCScriptRuntime::start(const char* pStartJS) 
    m_strStartJS = pStartJS;
    m_pScriptThread->initialize(JCConch::s_pConch->m_nJSDebugPort);
    m_pScriptThread->start();
    
  通过读取文件内容的方式 加载初始文件
  void JCScriptRuntime::onThreadInit(JCEventEmitter::evtPtr evt) 
    if (m_pAssetsRes->loadFileContent(m_strStartJS.c_str(), sJCBuffer, nJSSize))
      JSP_RUN_SCRIPT(kBuf.c_str());   这里启动apploader.js
```
- apploader.js
```
  {  app.json
    "name":"layaApp",
    "version":"1.0.0",
    "devUpdateUrl":"",
    "updateUrl":"http://localhost:8899/layaAppUpdate/layaApp/v2.1/",
    "updateDelay":0,
    "mainjs":"index.js"
	}

  (function () {
    'use strict';
  	appobj = JSON.parse(conch.readFileFromAsset('app.json', 'utf8'));
  	require(appobj.mainjs);
```
- index.js
```
	loadApp(conch.presetUrl||"https://test-cdn-wuxia.kgogame.com/wuxia_outweb_ard/index_native.js");
	
  前者：
  void JSRuntime::exportJS()
    JSP_GLOBAL_ADD_PROPERTY_RO(presetUrl, JSRuntime,getPresetUrl);
 
  const char* JSRuntime::getPresetUrl()
    {
        return g_kSystemConfig.m_strStartURL.c_str();
    }
  这个值 在conchRuntime.initWithView中设置 但业务工程ViewController一般都不会传 所以用的后面的值
  m_pConchRuntime = [[conchRuntime alloc]initWithView:m_pGLKView EAGLContext:m_pGLContext downloadThreadNum:3 URL:nil];
  
  加载入口文件内容 通过eval方式执行
```


## 怎么在ios工程中接入山海-并支持
- 接入：
```
  在index.js中可直接写死新地址 比如上面的案例
```

- 切换审核和正式：
```
  由于ios和ard不同 并没在object-c层做处理 而是直接都了index.js
  考虑在这里做文章:
  参考微信mini项目中的game.js和MyGame.js
  加入gvo配置 http链接 审核版本请求 
  再用新地址调用loadApp
```














