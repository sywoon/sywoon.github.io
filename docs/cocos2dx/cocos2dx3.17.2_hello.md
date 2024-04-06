# 🔙[cocos2dx](/docs/cocos2dx/)

[源码](https://github.com/cocos2d/cocos2d-x/tags)
[cocos2dx论坛](https://forum.cocos.org/c/cocos2d-x)
[参考](https://blog.csdn.net/qq_41506812/article/details/130363574)
- tests工程没有xcode工程文件 怎么用？：tests/cpp-test/
- 别用templates/cpp-template-default里面的工程   因为这是用于cocos命令方式创建新工程的模版 路径配置相对cocos文件夹并不同

## 一、下载最新版本
[cocos2dx3.17.2](https://www.cocos2d-x.org/download)
注意：这里下载的版本内容包含了extern中的第三方库 tools中cocos命令工具
- 和github中cocos2d-x-cocos2d-x-3.17.2+cocos2d-x-3rd-party-libs-bin-3-deps-158中下载的区别
	- 少了：extern/fbx-conv
	- 多了：
    	- tests/cpp-tests/Resource/ccs-res
    	- tools/bindings-generator
    	- tools/cocos2d-console
    	- tools/fbx-conv
    	- web js项目相关内容
- [早期版本](https://www.cocos2d-x.org/download/version)


---
## 二、win环境准备
### 1. 下载
- cocos2d-x-cocos2d-x-3.17.2.zip
- cocos2d-x-3rd-party-libs-bin-3.zip 解压到external目录下
	- 用python download-deps.py 也可以 会慢很多
	- 测试发现行不通：无法下载cocos2d-x-3rd-party-libs-bin-3-deps-158.zip 
	- https://github.com/cocos2d/cocos2d-x-3rd-party-libs-bin/archive/v3-deps-158.zip
- cocos2d-x-3rd-party-libs-src
  - 后来遇到freetype编译不过的问题 考虑从源头自己编译库
  - 对应bin版本问题 最新的v3版本和3.17.2是对不上 额外下载了tagv3.4来尝试
- 安装后发现cocos命令找不到 通过github可以看到tools/cocos2d-console文件夹颜色不同 点击后可跳转
- cocos2d-console git@github.com:cocos2d/cocos2d-console.git 解压到tools目录
- bindings-generator git@github.com:cocos2d/bindings-generator.git 解压到tools目录


### 2. 安装python2.7 
可使用Python Version Selector 来切换

### 3. cd到cocos目录 运行python setup.py
```
	Setting up cocos2d-x...
    ->Check environment variable COCOS_CONSOLE_ROOT
      ->Search for environment variable COCOS_CONSOLE_ROOT...
        ->COCOS_CONSOLE_ROOT not found

      ->Add directory "D:\Work\cocos\cocos2d-x-cocos2d-x-3.17.2\tools\cocos2d-console\bin" into PATH succeed!

      -> Add COCOS_CONSOLE_ROOT environment variable...
        ->Added COCOS_CONSOLE_ROOT=D:\Work\cocos\cocos2d-x-cocos2d-x-3.17.2\tools\cocos2d-console\bin

    ->Check environment variable COCOS_X_ROOT
      ->Search for environment variable COCOS_X_ROOT...
        ->COCOS_X_ROOT not found

      ->Add directory "D:\Work\cocos" into PATH succeed!

      -> Add COCOS_X_ROOT environment variable...
        ->Added COCOS_X_ROOT=D:\Work\cocos

    ->Check environment variable COCOS_TEMPLATES_ROOT
      ->Search for environment variable COCOS_TEMPLATES_ROOT...
        ->COCOS_TEMPLATES_ROOT not found

      ->Add directory "D:\Work\cocos\cocos2d-x-cocos2d-x-3.17.2\templates" into PATH succeed!

      -> Add COCOS_TEMPLATES_ROOT environment variable...
        ->Added COCOS_TEMPLATES_ROOT=D:\Work\cocos\cocos2d-x-cocos2d-x-3.17.2\templates

    ->Configuration for Android platform only, you can also skip and manually edit your environment variables

    ->Check environment variable NDK_ROOT
      ->Search for environment variable NDK_ROOT...
        ->NDK_ROOT is found : D:\Ard_Env\NDK19

    ->Check environment variable ANDROID_SDK_ROOT
      ->Search for environment variable ANDROID_SDK_ROOT...
        ->ANDROID_SDK_ROOT is found : D:\Ard_Env\android-sdk-windows


    Please restart the terminal or restart computer to make added system variables take effect
```

---
## 三、mac环境准备
基本同上 实际可以不按照cocos命令 直接cd到工具目录 运行cocos即可



## 四、cocos2dx-3.17.2 ---- xcode 14.0.1 项目移植
[案例来源](https://blog.csdn.net/qq_41506812/article/details/130363574)

### 1. 环境准备
[cocos3.17.2完整版]((https://www.cocos2d-x.org/download))
- xcode15.3 文档中的是14.0.1
- python-2.7.18-macosx10.9 文档中是pyton2.7.14 

1. 创建新工程
	- cd cocos2d-x-3.17.2/tools/cocos2d-console/bin 
	- ./cocos new Hello -p cn.game.hello -l cpp -d /Users/s/Documents/cocos
	- cocos new HelloLua -p cn.game.lua -l lua -d D:\Work\cocos

2. 用xcode打开 Hello/proj.ios_mac/Hello.codeproj  双击直接打开也行
3. 选择Hello-mobil > ios 17.4 模拟器 第一次需要安装 点get即可 7.23g
4. 设置debug运行的库类型 属性：targets：Hello-mobile:Build settings:  
	 拖到最底下User-Defined:Valid-archs:Debug 将armv7删除 修改为arm64 x86_64  
	 保留release不变还是arm64 armv7  
	 实际armv7在xcode高版本后已经不再支持 可以删除了





---
## 五、编译cocos2d-x-3rd-party-libs-src工程
[参考](cocos2d-x-3rd-party-libs-src.md)


## 六 创建工程
cocos new MyGame -p com.mygame.test -l cpp -d .
- 若要用js或者lua 可用-l js or -l lua
- 注意：需要先切换到python2.7.5 否则cocos命令不起效
	- 切换工具可能失效 到系统path中删除手动配置的路径 工具自动维护了%python_path%用来实现切换



## 七、vs编译win32版本

### 1. 编译报错
#### 1.1  error C3861: “unzGoToFirstFile64”: 找不到标识符
ZipUtils.cpp
- 解决1：失败 还是找不到
新增宏：MINIZIP_FROM_SYSTEM
```
	#ifdef MINIZIP_FROM_SYSTEM
    #define unzGoToFirstFile64(A,B,C,D) unzGoToFirstFile2(A,B,C,D, NULL, 0, NULL, 0)
    #define unzGoToNextFile64(A,B,C,D) unzGoToNextFile2(A,B,C,D, NULL, 0, NULL, 0)
    #endif
```

```
#ifdef MINIZIP_FROM_SYSTEM
#include <minizip/unzip.h>
#else // from our embedded sources
#include "unzip.h"
#endif
```

- 解决2：新增头文件路径 失败
external/unzip/unzip.h本身是存在的
新增：$(EngineRoot)external\unzip
解决：链接器：c/c++目录：附加包含目录
`失败：原因同上 因为unzip里没unzGoToFirstFile64 代码写错了？`

- 解决3：参考了dragon项目 发现他们unzip里是有这个函数的 `问题解决`s
	对照前面download-deps.py 发现库版本不对 需要手动下载cocos2d-x-3rd-party-libs-bin-3-deps-158.zip 看库日期是2010 
	而cocos2d-x-3rd-party-libs-bin-3.zip是2017


#### 1.2 fatal error LNK1104: 无法打开文件“libcurl.lib”
存在的目录：cocos2d\external\curl\prebuilt\win32\libcurl.lib .dll
解决：链接器：附加库目录

#### 1.3 librecast编译不过
error MSB8020: 无法找到 Visual Studio 2010 的生成工具(平台工具集 =“v100”)。若要使用 v100 生成工具进行生成，请安装 Visual Studio 2010 生成工具。或者，可以升级到当前 Visual Studio 工具，方式是通过选择“项目”菜单或右键单击该解决方案，然后选择“重定解决方案目标”。
解决：属性：常规：平台工具及集：选择vs2022(v143)和你用哪个版本的vs有关

---
至此win32版本的demo可正常运行了




## 八、xcode编译mac版本
无论什么错 第一步骤 先把最小部署minimum deplyments 改为12 早期的项目都很小 xcode已经不支持


### 1. 编译mac版本报错
#### 1.1 Redefinition of enumerator 'kAudioSessionProperty_OtherAudioIsPlaying'
```
	CDXMacOSXSupport.cpp
	enum AudioSessionProperties { 	
		kAudioSessionProperty_OtherAudioIsPlaying, 	
		kAudioSessionProperty_AudioRoute	 
	};
```
官方解决方案：
https://discuss.cocos2d-x.org/t/build-failed-for-mac-using-latest-xcode-12-3/52476/29
```
This is what i do for Mac
a.
Goto /Project/cocos2d/cocos/audio/mac/CDAudioManager.m Comment line no 408 & 409
//        AVAudioSession* session = [AVAudioSession sharedInstance];
//        session.delegate = self;
Add this line below it at line no 410
[[AVAudioSession sharedInstance] setActive:YES error:nil];

b.
In same file CDAudioManager.m comment line no 328 & 329
 //    UInt32 varSize = sizeof(isPlaying);
//    AudioSessionGetProperty (kAudioSessionProperty_OtherAudioIsPlaying, &varSize, &isPlaying);
Add this line below it at line no 330
isPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying]; 

c.
In same file CDAudioManager.m goto line no 485 in isDeviceMuted
replace below code
 -(BOOL) isDeviceMuted {

	#if TARGET_IPHONE_SIMULATOR
	    //Calling audio route stuff on the simulator causes problems
	    return NO;
	#else
	    return NO;
	#endif
	}

d.
Goto /Project/cocos2d/cocos/audio/mac/CDXMacOSXSupport.h
Comment line no from 43 to 46
	 //enum AudioSessionProperties {
	//	kAudioSessionProperty_OtherAudioIsPlaying,
	//	kAudioSessionProperty_AudioRoute
	//};

e.
/Project/cocos2d/external/bullet/include/bullet/LinearMath/btVector3.h
replace below line at 42
Old line :
#define BT_SHUFFLE(x,y,z,w) ((w)<<6 | (z)<<4 | (y)<<2 | (x))
with new one:
#define BT_SHUFFLE(x, y, z, w) (((w) << 6 | (z) << 4 | (y) << 2 | (x)) & 0xff)

macOS Deployment target increase to 10.11
For main project as well as for libcocos2dMac

If required do clean project and run
```

#### 1.2 No matching function for call to 'iconv_close'
```
	CCFontAtlas.cpp
	iconv_close(_iconv);
	iconv(_iconv, (char**)&pin, &inLen, &pout, &outLen);
```
解决：加上强转 (iconv_t)_iconv

#### 1.3 mac自己的库报错
```
	macOS14.4/Frameworks/GameController/GCDevice.h
	@property (nonatomic, strong) dispatch_queue_t handlerQueue API_AVAILABLE(macos(10.9), ios(7.0), tvos(7.0));
	
	GCevicePhysicalInput.h
	@property (atomic, strong, nullable) dispatch_queue_t queue API_AVAILABLE(macos(14.0), ios(17.0), tvos(17.0));
```
- 解决1：无效 找错位置了 不是MyGame的设置
	- target改为12.0及以上  
	- Product:clean build folder 重新编
- 解决2：成功 
	- 选中cocos2d_libs:build settings:点击all 否则显示不全
	- 找到deplyment那块 修改macOS Deployment Target:macOS 10.7 改为macOS12.0
	- 注意：一定要clean build folder再重编
	

#### 1.4 Comnand Libtool failed with a nonzro exit code
```
	error: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool: can't locate file for: -lpng
error: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool: file: -lpng is not an object file (not allowed in a library)
	error: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool: can't locate file for: -lfreetype
error: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool: file: -lfreetype is not an object file (not allowed in a library)
Command Libtool failed with a nonzero exit code
```
- 原因：第三方库缺少了 因为github上下载的版本 缺少库和工具 需要从英文版官方下载 才完整
- 参考：[下载最新版本](#下载最新版本)


#### 1.5 Undefined symbol:_FT_Done_Face
- 说是和freetype库相关 但是cocos2d_libs已经编译过 报错的是MyGame主工程
```
	具体错误：
	Showing Recent Issues
	Building for 'iOS-simulator', but linking in object file (/Users/s/Library/Developer/Xcode/DerivedData/Hello-aaihcgxgfjxqzvcahhlwlkhavmmr/Build/Products/Debug-iphonesimulator/libcocos2d iOS.a[743](btCollisionAlgorithm.o)) built for 'iOS'
	解决：
	您正在为 iOS 模拟器（iOS-simulator）构建项目，但却尝试链接一个为 iOS 设备（iOS）编译的库文件。
```




---
### 2. 编译ios版本报错
1. 修改bundle com.cocos2dx.demo 使用测试provision
2. Comnand Libtool failed with a nonzro exit code 问题同mac 绕不过
改为真机 而非模拟器 可正常编译 并跑起来
3.  Failed to find or create execution
```
/Users/s-mac/Documents/cocos/cocos2dx_demo/proj.ios_mac/ios/LaunchScreen.storyboard:: Failed to find or create execution context for description '<IBCocoaTouchPlatformToolDescription: 0x60000348efc0> System content for IBVisionIdiom-SevenAndLater <IBScaleFactorDeviceTypeDescription: 0x60000348e960> scaleFactor=2x, renderMode.identifier=(null)'.
模拟器服务问题导致的
解决：终端命令：关掉所有模拟器进程
sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService
sudo xcode-select -s  /Applications/Xcode.app/Contents/Developer  设置正确的xcode路径
xcrun simctl erase all  若还不行 重置所有模拟器
打开活动监视器 查看ibtool进程 kill 一般xcode退出后一会 这个进程会消失
再不行 重启电脑
```

4. 第一次运行比较慢
Copying shared cache symbols from iPhone (7% completed)

---
### 3. mac上可以用模拟器 mac desigin for ipad
只要是m1 m2的电脑  都能用ios模拟器运行起来
1. Failed to install the application
the application's Info.plist does not contain CFBundleShortVersionString.
Recovery Suggestion: Ensure your bundle contains a CFBundleShortVersionString.
解决: 属性：info：bundle version string:原来是空的 改为1.0.1
  若没这个属性 右键add row ： Bundle versions tring(short)




## 九、lua版本demo
cocos new HelloLua -p cn.game.lua -l lua -d D:\Work\cocos  
早期几个简单报错 参考上面cpp案例来解决  
都是前面的问题  解决后即可运行ios或m1模拟器版本  

### 1. 怎么运行完整的lua案例 tests/lua-tests
1. 通过命令新增HelloLua工程
2. 将lua-tests/src/ 替换工程中的src-删除旧的
3. Resources/config.json中的"entry": "src/main.lua", 修改为 src/controller.lua
4. 将lua-test/res和cpp-test/Resources的内容复制到 HelloLua/res



In-App Purchase 






























