# 🔙[cocos2dx](/docs/cocos2dx/)
[参考1-ios arm64](https://www.cnblogs.com/meteoric_cry/p/4171535.html)
ios 2015年2月1日后新提交的应用必须要支持64位架构
[2.2.6下载](http://www.cocos2d-x.org/filedown/cocos2d-x-2.2.6.zip)
[讨论1](https://discuss.cocos2d-x.org/t/cocos2d-x-v3-3-external-prebuilt-lib-64bit/47167)



- 参考cocos creator
    [external](https://github.com/cocos/cocos-engine-external)




## 创建demo工程
1. 创建项目
```
cd tools/project-creator/
python create_project.py -project MyGameC2 -package com.example.mygamec2 -language cpp

新项目生成在project/下
```

2. 准备ard环境和工具
- update_project.bat  
```
    @echo off
    set "cocos_ard_path=%~dp0../../../cocos2dx/platform/android/java/"

    call android update project -p . -t android-29

    set cocos_ard_path=%cocos_ard_path:/=\%
    pushd %cocos_ard_path%
    call android update project -p . -t android-29
    popd

    call explorer %cocos_ard_path%

    pause

    #手动修改AndroidManifest.xml
    #<uses-sdk android:minSdkVersion="22"/>
    #<uses-sdk android:targetSdkVersion="29"/>
```
- 得到两个local.properties
```
    sdk.dir=D:\\Ard_Env\\android-sdk-windows
```
- build_native.bat 生成so文件
```
    @echo off
    set "path=D:\Ard_Env\android-ndk-r10e;%path%"
    set "COCOS2DX=%~dp0../../../"
    set "NDK_MODULE_PATH=%COCOS2DX%;%COCOS2DX%/cocos2dx/platform/third_party/android/prebuilt"

    set "COCOS2DX_ROOT=%~dp0/../../.."
    set "APP_ROOT="%~dp0/..""
    set "APP_ANDROID_ROOT=%~dp0"
    set "no_pause=%1"

    echo "NDK_ROOT = %NDK_ROOT%"
    echo "COCOS2DX_ROOT = %COCOS2DX_ROOT%"
    echo "APP_ROOT = %APP_ROOT%"
    echo "APP_ANDROID_ROOT = %APP_ANDROID_ROOT%"
    echo "NDK_MODULE_PATH = %NDK_MODULE_PATH%"
    echo.


    cls
    ::call ndk-build.cmd clean
    call ndk-build.cmd 

    ::ndk-build.cmd -C "%APP_ANDROID_ROOT%" NDK_MODULE_PATH=%COCOS2DX_ROOT%:%COCOS2DX_ROOT%/cocos2dx/platform/third_party/android/source

    if "%no_pause%" NEQ "no_pause" pause
```
- build_apk_debug.bat
```
    @echo off
    set "no_pause=%1"

    ::call ant clean debug
    call ant debug
    or
    call ant release

    if "%no_pause%" NEQ "no_pause" pause
```
- build_all_debug.bat
```
    call build_native.bat
    call build_apk_debug.bat
```

3. 复制Resource的内容到assets
4. 打包 得手apk
提示旧版app 
```
  AndroidManifest.xml
    <uses-sdk android:minSdkVersion="8"/>
    =>
    <uses-sdk android:minSdkVersion="22"/>
    <uses-sdk android:targetSdkVersion="29"/>
```
验证可运行

5. 使用cocos2d-x-3rd-party-libs-bin-3-deps-148\覆盖原来的android库
多了arm64-v8a

6. Application.mk 新增64位编译方式
APP_ABI := armeabi-v7a arm64-v8a


## 一、x64
基于cocos2.2.6 已经不支持64位系统 最大卡点估计在第三库  
通过win64来探索可能性

### 1. 准备x64工程
属性页：配置管理器：平台win32下拉 可创建x64 且内容复制来源于win32  
通过模仿win32的配置：头文件 lib库等 其他自己扩展的工程TwBase TwNet等都能编译过  
```
    输出：$(SolutionDir)..\..\runtime\win64\   主工程用这个作为lib库的输入 
    中间目录：$(SolutionDir)..\..\temp\$(ProjectName)64\$(Configuration)\
```


#### 1.1 libCocosDnshion工程
- SetWindowLong(m_hWnd, GWL_USERDATA, (LONG)this); 找不到GWL_USERDATA
解决：MciPlayer.cpp 头部新增定义
```
#ifdef _WIN64
    #define GWL_USERDATA        (-21)
#endif
```


#### 1.2 libcocos2d
- \temp\libs64\glew32.lib : warning LNK4272: 库计算机类型“x86”与目标计算机类型“x64”冲突
原因：属性：生成事件：连接前事件：尝试了直接用32位的库  看来不行
```
    if not exist "$(OutDir)" mkdir "$(OutDir)" (
    xcopy /Y /Q "$(ProjectDir)..\platform\third_party\win32\libraries\*.dll" "$(OutDir)"
    xcopy /Y /Q "$(ProjectDir)..\platform\third_party\win32\libraries\*.lib" "$(SolutionDir)..\..\temp\libs64\"
    )
```

- CCSprite.obj : error LNK2001: 无法解析的外部符号 __imp___glewVertexAttribPointer
估计也是32位库的问题:glew32 libzlib libpng libjpeg libtiff libwebp libiconv pthreadVCE2

- 解决：
- a 删除不用的库 tiff webp
- b 下载源码 手动编译 glew zlib png jpeg iconv pthread
- c 从creator库中复制64位的[版本](https://github.com/cocos/cocos-engine-external)















