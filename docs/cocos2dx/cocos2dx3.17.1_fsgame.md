# 🔙[cocos2dx](/docs/cocos2dx/)

huowu的封神项目 之前出过ios包 全平台都能运行

## xcode升级带来的cocos2dx编译报错

- 使用了hw的封神榜项目为案例-3.16.0
- xcode >14.0 最早以为是刚升级后的问题 后来升级到15.3后问题依旧
- [解决参考1](https://blog.csdn.net/Mhypnos/article/details/136097012)

### 1. iconv库编译不过

No matching function for call to 'iconv_close'No matching function for call to 'iconv'

- 尝试1:

  - libcocos2d Mac项目属性：build phases：link binary with libraries： 新增libiconv.tbd -对应c++工程
- 尝试2: 仓考了上面链接 需要给参数添加强制转换函数

  - 因为和h定义的类型不一致 导致找不到   	估计是新版本xcode检查更严格了

  ```cpp
  	CCFontAtlas.cpp
  	iconv_close(_iconv);
  	iconv(_iconv, (char**)&pin, &inLen, &pout, &outLen);

  	iconv_close((iconv_t)_iconv);
  	iconv((iconv_t)_iconv, (char**)&pin, &inLen, &pout, &outLen);
  ```

### 2. xcode旧版本库本身报错

Property with ‘retain (or strong)‘ attribute must be of object type
（这是旧版本xcode创建的项目，再更新了xcode版本后打开的报错）

```
	GCDevice
		@property (nonatomic, strong) dispatch_queue_t handlerQueue API_AVAILABLE(macos(10.9), ios(7.0), tvos(7.0));
	GCDevicePhysicalInput
		@property (atomic, strong, nullable) dispatch_queue_t queue API_AVAILABLE(macos(14.0), ios(17.0), tvos(17.0));

	解决：
		修改cocos2d_lib.xcodeproj工程的设置
		mobie工程修改buildsettings->Deployment->iOSDeploymentTarget 版本，与外部一致   只看到ios17.4 具体怎么设置？
		mac工程修改buildsettings->Deployment->macOSDeploymentTarget 版本，与外部一致，  ?macOS14.4?
		base sdk路径也要修改    macOS => macOS14.4? 这里没改
```

### 3. freetype2库不支持

Undefined symbol:_FT_Done_Face
Undefined symbol:_FT_Done_FreeType
Undefined symbol:_FT_Done_Glyph
Undefined symbol:_glfwCreateWindow
Undefined symbol:_jpeg_CreateCompress
Undefined symbol:_luaL_addlstring
Undefined symbol:_OBJC_CLASS_$_CCAudioPlayer


### 4. 没有可允许的设备模拟器

A build only device cannot be used to run this target.本次升级没遇到这个问题 而且这些选项都有变化

- 解决：
  - m1芯片旧版本的max系统，右键xcode->显示简介->勾选使用Rosetta打开
  - 新版本的mac系统显示简介里没有Rosetta选项，
  - xcode打开项目->Product-> Destination-> Destination Architecturesk 选择用Rosetta模式的模拟器打开
  - 或者使用ios模拟器直接在mac中运行


