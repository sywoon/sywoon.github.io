# cocos2dx3.17.2使用xcode15编译
[源码](https://github.com/cocos2d/cocos2d-x/tags)
[cocos2dx论坛](https://forum.cocos.org/c/cocos2d-x)
[参考](https://blog.csdn.net/qq_41506812/article/details/130363574)
使用xcode直接打开工程：templates/cpp-template-default/proj.ios_mac/HelloCpp.xcodeproj



## 遇到的编译问题
### 1. 文件头找不到
- cocos2d.h找不到
```
	Prefix
	#ifdef __OBJC__
		#import <Cocoa/Cocoa.h>
	#endif

	#ifdef __cplusplus
		#include "cocos2d.h"
	#endif
```
解决：
```
HelloCpp工程：Build Settings:Search Paths: Head Search Paths
新增
$(SRCROOT)/../../../cocos/
其中srcroot为 /cocos2d-x-cocos2d-x-3.17.2/templates/cpp-template-default/proj.ios_mac
```

- glfw3.h
```
	CCGLViewImpl-desktop.h
```
解决：
```
external/config.json里有说明 估计需要cocos命令行来下载
https://github.com/cocos2d/手动下载库cocos2d-x-3rd-party-libs-bin
和cocos2d-x-3rd-party-libs-src 都5年没更新了 分了v3和v4版本 估计是对应cocos2dx3.* 4.*

为了快点 从fsgame中复制了一份
```




