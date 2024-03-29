# cocos2dx



## 环境准备
1. 下载
- cocos2d-x-cocos2d-x-3.17.2.zip
- cocos2d-x-3rd-party-libs-bin-3.zip 解压到external目录下
	- 用python download-deps.py 也可以 会慢很多
	- 测试发现行不通：无法下载cocos2d-x-3rd-party-libs-bin-3-deps-158.zip 
	- https://github.com/cocos2d/cocos2d-x-3rd-party-libs-bin/archive/v3-deps-158.zip
- 安装后发现cocos命令找不到 通过github可以看到tools/cocos2d-console文件夹颜色不同 点击后可跳转
- cocos2d-console git@github.com:cocos2d/cocos2d-console.git 解压到tools目录
- bindings-generator git@github.com:cocos2d/bindings-generator.git 解压到tools目录


2. 安装python2.7 
可使用Python Version Selector 来切换

3. cd到cocos目录 运行python setup.py
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

4. 重启电脑 否则cocos命令不启用 或者 source命令刷新系统路径


## 创建工程
cocos new MyGame -p com.mygame.test -l cpp -d .
- 若要用js或者lua 可用-l js or -l lua
- 注意：需要先切换到python2.7.5 否则cocos命令不起效
	- 切换工具可能失效 到系统path中删除手动配置的路径 工具自动维护了%python_path%用来实现切换



## vs编译win32版本

### 编译报错
1.  error C3861: “unzGoToFirstFile64”: 找不到标识符
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


2. fatal error LNK1104: 无法打开文件“libcurl.lib”
存在的目录：cocos2d\external\curl\prebuilt\win32\libcurl.lib .dll
解决：链接器：附加库目录

3. librecast编译不过
error MSB8020: 无法找到 Visual Studio 2010 的生成工具(平台工具集 =“v100”)。若要使用 v100 生成工具进行生成，请安装 Visual Studio 2010 生成工具。或者，可以升级到当前 Visual Studio 工具，方式是通过选择“项目”菜单或右键单击该解决方案，然后选择“重定解决方案目标”。
解决：属性：常规：平台工具及集：选择vs2022(v143)和你用哪个版本的vs有关

---
至此win32版本的demo可正常运行了




## xcode编译mac版本
1. 无论什么错 第一步骤 先把最小部署minimum deplyments 改为12 早期的项目都很小 xcode已经不支持


### 编译mac版本报错
1. Redefinition of enumerator 'kAudioSessionProperty_OtherAudioIsPlaying'
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

Goto /Project/cocos2d/cocos/audio/mac/CDAudioManager.m Comment line no 408 & 409
//        AVAudioSession* session = [AVAudioSession sharedInstance];
//        session.delegate = self;
Add this line below it at line no 410
[[AVAudioSession sharedInstance] setActive:YES error:nil];
In same file CDAudioManager.m comment line no 328 & 329
 //    UInt32 varSize = sizeof(isPlaying);
//    AudioSessionGetProperty (kAudioSessionProperty_OtherAudioIsPlaying, &varSize, &isPlaying);
Add this line below it at line no 330
isPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying]; 
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
Goto /Project/cocos2d/cocos/audio/mac/CDXMacOSXSupport.h
Comment line no from 43 to 46
	 //enum AudioSessionProperties {
	//	kAudioSessionProperty_OtherAudioIsPlaying,
	//	kAudioSessionProperty_AudioRoute
	//};
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

2. No matching function for call to 'iconv_close'
```
	CCFontAtlas.cpp
	iconv_close(_iconv);
	iconv(_iconv, (char**)&pin, &inLen, &pout, &outLen);
```
解决：加上强转 (iconv_t)_iconv

3. mac自己的库报错
```
	macOS14.4/Frameworks/GameController/GCDevice.h
	@property (nonatomic, strong) dispatch_queue_t handlerQueue API_AVAILABLE(macos(10.9), ios(7.0), tvos(7.0));
	
	GCevicePhysicalInput.h
	@property (atomic, strong, nullable) dispatch_queue_t queue API_AVAILABLE(macos(14.0), ios(17.0), tvos(17.0));
```
解决1：无效 找错位置了 不是MyGame的设置
	- target改为12.0及以上  
	- Product:clean build folder 重新编
解决2：成功 
	- 选中cocos2d_libs:build settings:点击all 否则显示不全
	- 找到deplyment那块 修改macOS Deployment Target:macOS 10.7 改为macOS12.0
	- 注意：一定要clean build folder再重编
	
	
4. Comnand Libtool failed with a nonzro exit code


### 编译ios版本报错
1. 修改bundle com.cocos2dx.demo 使用测试provision
2. Comnand Libtool failed with a nonzro exit code 问题同mac 绕不过
3. 










































