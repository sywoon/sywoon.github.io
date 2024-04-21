# 🔙[cocos2dx](/docs/cocos2dx/)

- [参考1-ios arm64](https://www.cnblogs.com/meteoric_cry/p/4171535.html)
  ios 2015年2月1日后新提交的应用必须要支持64位架构
- [2.2.6下载](http://www.cocos2d-x.org/filedown/cocos2d-x-2.2.6.zip)
- [讨论1](https://discuss.cocos2d-x.org/t/cocos2d-x-v3-3-external-prebuilt-lib-64bit/47167)
- [讨论2](https://discuss.cocos2d-x.org/t/cocos2dx-v2-2-6-migration-to-android-studio/45495/13)
- [讨论3](https://discuss.cocos2d-x.org/t/critical-support-for-64bit-on-cocos2d-x-on-android/45516/46)
- [cocos2d-x-v2 arm64 fork1](https://github.com/SelAD/cocos2d-x-v2)
- [cocos2d-x-v2 arm64 fork2](https://github.com/novatien/cocos2d-x-v2)
- [cocos2dx v2 古典经典版本 支持arm64](https://github.com/stubma/cocos2dx-classical)
- as案例工程

  - [cocos2d-x226-android-studio](https://github.com/SelAD/cocos2d-x226-android-studio/tree/master)
  - Cocos2d-x2.2.6AS工程
  - [2.2.6使用as的gradle](https://discuss.cocos2d-x.org/t/cocos2d-x-2-2-6-to-gradle/37524/5)
  - [2.2.6-android-studio案例](https://github.com/SelAD/cocos2d-x226-android-studio/tree/master)
- [制作as android.mk工具](https://gist.github.com/daniaDlbani/6ebd0014583f870982c73ca15db579b3)
- [制作eclpise android.mk工具](https://gist.github.com/daniaDlbani/2ccb89a3959c955351ae5a87928974d6)
- [wiengine 类cocos 学习用 有各种第三方库](https://github.com/stubma/WiEngine/tree/master)
- 参考cocos creator
  [external](https://github.com/cocos/cocos-engine-external)

## 一、创建demo工程

### 1. 创建项目  新项目生成在project/下

```
cd tools/project-creator/
python create_project.py -project MyGameC2 -package com.example.mygamec2 -language cpp
```

### 2. 1 vs编译win32版本

使用vs2022升级工程到最新

- 报错1：

```
    1>libpng.lib(pngerror.obj) : error LNK2019: 无法解析的外部符号 ___iob_func，函数 _png_default_error 中引用了该符号
    1>libpng.lib(pngrutil.obj) : error LNK2001: 无法解析的外部符号 ___iob_func
    1>libjpeg.lib(jerror.obj) : error LNK2001: 无法解析的外部符号 ___iob_func
    原因：
    原来在 VS2015 中 __iob_func 改成了 __acrt_iob_func 
    解决：在cocos2d.cpp中新增 注意不能在.h 因为定义重复错误
    #ifdef WIN32
    #if _MSC_VER>=1900  
    #include "stdio.h"   
    _ACRTIMP_ALT FILE* __cdecl __acrt_iob_func(unsigned);
    #ifdef __cplusplus   
    extern "C" {
    #endif   
        FILE* __cdecl __iob_func(unsigned i) {
            return __acrt_iob_func(i);
        }
    #ifdef __cplusplus   
    }
    #endif  

    #pragma comment(lib, "legacy_stdio_definitions.lib")
    #endif /* _MSC_VER>=1900 */ 
    #endif  //WIN32
```

-报错2：

```
    chipmunk.c(48,31): error C3688: 文本后缀“XSTR”无效；未找到文文本运算符或文本运算符模板“operator """"XSTR”
    解决：
    #define STR(s) #s
    #define XSTR(s) STR(s)
    //const char *cpVersionString = XSTR(CP_VERSION_MAJOR)"."XSTR(CP_VERSION_MINOR)"."XSTR(CP_VERSION_RELEASE);
    const char* cpVersionString = STR(CP_VERSION_MAJOR) "." STR(CP_VERSION_MINOR) "." STR(CP_VERSION_RELEASE);
```

- 报错3：

```
    stdio.h(1912,1): warning C4005: “snprintf”: 宏重定义
    解决：
    CCStdC.h
    #if _MSC_VER < 1700 
    #ifndef snprintf
    #define snprintf _snprintf
    #endif
    #endif
```

- 报错4：

```
    pthread.h(307,17): error C2011: “timespec”:“struct”类型重定义
    解决：
    新增HAVE_STRUCT_TIMESPEC
```

- 报错5:

```
    >libpng.lib(pngrutil.obj) : error LNK2019: 无法解析的外部符号 __snprintf，函数 _png_handle_IHDR 中引用了该符号
    解决：vs2015之后就没了
     #pragma comment(lib, "legacy_stdio_definitions.lib")
```

- 报错6:

```
    main.obj : error LNK2005: ___iob_func 已经在 AppDelegate.obj 中定义
    解决：
    将保持1的修复移动到cocos2d.cpp中 防止定义多次 哪怕加了自定义控制宏 也不行
```

至此win32版本 已经能正常运行

- warn 1：warning C4005: “__useHeader”: 宏重定义
  以前处理过 搜索不到了 待处理

### 2. 2 准备ard环境和工具

所有文件查看cocos2dx/proj.android/*.bat

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

1. 复制Resource的内容到assets
2. 打包 得手apk
   提示旧版app

```
  AndroidManifest.xml
    <uses-sdk android:minSdkVersion="8"/>
    =>
    <uses-sdk android:minSdkVersion="22"/>
    <uses-sdk android:targetSdkVersion="29"/>
```

验证可运行

- 错误1：

```
    build.xml:283: Execute failed: java.io.IOException: Cannot run program "D:\Ard_Env\android-sdk-windows\build-tools\34.0.0\dx.bat": CreateProcess error=2, 系统找不到指定的文件。
    解决：
    删除34.0.0 保留29.0.3 而且通过SDK Manager打开的管理器 也是29.0.3
    更高的版本通过as升级的？
```

## 二、在2.2.6中创建android studio

创建干净的hello项目 再使用cocos2d-x-v2-master-fork1覆盖

- 编译命令：

```
    set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
    set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"
    gradlew assembleDebug / assembleRelease
```

- 问题1：

```
    cvc-complex-type.2.4.a: 发现了以元素 'base-extension' 开头的无效内容。应以 '{codename, layoutlib}' 之一开头。
    解决：升级gradle
    #distributionUrl=https\://services.gradle.org/distributions/gradle-7.2-all.zip
    distributionUrl=https://mirrors.cloud.tencent.com/gradle/gradle-7.2-all.zip
    classpath 'com.android.tools.build:gradle:4.2.2'
```

- 问题2：

```
    add-application.mk:178: *** Android NDK: APP_STL gnustl_static is no longer supported. Please switch to either c++_static or c++_shared. See https://developer.android.com/ndk/guides/cpp-support.html for more information.    .  Stop.
    --
    新版本的 Android NDK 中，对于 GNU STL 静态库的支持已经被移除了
    解决：Application.mk
    APP_STL := gnustl_static 修改为 APP_STL := c++_static
```

- 问题3：

```
    Installed Build Tools revision 33.0.1 is corrupted. Remove and install again using the SDK Manager.
    ---
    tools:sdk manager:
    解决:
    a 重命名33.0.0的两个文件 d8.bat 和 d8.jar（将两个文件名中的8换成x）
      sdk/build-tools/33.0.0/lib/d8.jar -> dx.jar  上层d8.bat->dx.bat
    b 降低版本到30.0.3
```

- 问题4：

```
    build-binary.mk:651: Android NDK: Module cocos2dcpp_shared depends on undefined modules: cocos_libxml2_static  
    --
    修改cocos2dx/Android.mk 
    注释LOCAL_WHOLE_STATIC_LIBRARIES += cocos_libxml2_static  实际也没这个库
```

- 问题5：

```
    Manifest merger failed : Apps targeting Android 12 and higher are required to specify an explicit value for `android:exported` when the corresponding component has an intent filter defined. See https://developer.android.com/guide/topics/manifest/activity-element#exported for details.
    ---
    从Android 12开始，系统要求应用程序明确指定android:exported的值，以增强应用程序的安全性
    解决：
    <activity android:name=".hello"
                  android:label="@string/app_name"
                  android:exported="true"  新增
```

- 问题6：

```
    temp = (int) FloatMath.ceil(pPaint.measureText(line, 0,
    --
    改为：Math.ceil
```

- 问题7:

```
    Execution failed for task ':hello:processDebugMainManifest'.
    > Unable to make field private final java.lang.String java.io.File.path accessible: module java.base does not "opens java.io" to unnamed module @6276f7fd
    ---
    搜索到 external/emscripten/tests/java_io.file.c中有"java.io.File",
    这个模块是将c/c++通过llvm编译为js 就是一个LLVM-to-javascript的编译器
    --
    解决:删除整个文件夹  估计是太老了 新的java16不支持
    --
    问题依旧
```

## 三、arm64尝试1

1. 使用cocos2d-x-3rd-party-libs-bin-3-deps-148\覆盖原来的android库
   多了arm64-v8a
2. Application.mk 新增64位编译方式
   APP_ABI := armeabi-v7a arm64-v8a
   因为各种报错 没推演下去

## 四、cocos2d-x-v2 arm64 fork1

尝试先用这个工程编译通as arm64

- 问题1：

```
    cvc-complex-type.2.4.a: 发现了以元素 'base-extension' 开头的无效内容。应以 '{codename, layoutlib}' 之一开头。
    --
    之前使用升级gradle的方式  后期也带来了很多问题 不确定是否是升级引起的
    本次采用修改配置的方式：
    file：setting：build execution : build tools: gradle: 
    修改gradle jdk: 1.8 改为 jbr-17
    --
    点击工具栏右上角叫 鲸鱼图案按钮-sync project with gradle
```

- 问题2：

```
    Unsupported Java. 
    Your build is currently configured to use Java 17.0.6 and Gradle 4.10.1.
    ---
    file : project structure: gradle plugin version: 2.3.3改为7.4.2
    gradle version：改为7.2 会自动修改
    但是gradle-wrapper.properties中的地址没改 按这个下载的？
    distributionUrl=https://mirrors.cloud.tencent.com/gradle/gradle-7.4.2-all.zip
    上面的修改 会体现到gradle.gradle model 中的
    classpath "com.android.tools.build:gradle:$agp_version2"
```

- 问题3：

```
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile project(':libcocos2dx')
    ==
    改为api或iimplementation 从gradle4开始 
```

- 问题4：

```
    *** Android NDK: APP_STL gnustl_static is no longer supported. Please switch to either c++_static or c++_shared. See https://developer.android.com/ndk/guides/cpp-support.html for more information.
    ---
    定义在application.mk APP_STL := gnustl_static
    改为：APP_STL := c++_static或APP_STL := c++_shared。
```

- 问题5：

```
    compileSdkVersion 26 =》 31 = android12
    buildToolsVersion "28.0.3" =》 30.0.3  超过后有个d8.jar dx.jar遗失问题 看上面
    -- build.gradle module可能有多个 比如hello libcocos2dx
    compileSdkVersion 31
    buildToolsVersion "30.0.3"

    defaultConfig {
        minSdkVersion 19
        targetSdkVersion 31
        versionCode 1
        versionName "1.0"
    }
```

- 问题6：

```
     <activity android:name=".hello"
    android:exported="true">   manifest.xml中配置
```

- 问题7：

```
    > Task :hello:buildNdkBuildDebug[arm64-v8a][cocos2dcpp] FAILED
    C/C++: make: *** No rule to make target 'cocos2dcpp'.  Stop.
    ---
    build.gradle hello
    externalNativeBuild {
            if (PROP_BUILD_TYPE == 'ndk-build') {
                ndkBuild {
                    targets 'cocos2dcpp'  => cocos2dcpp_shared
```

- 问题8：

```
    Namespace not specified. Specify a namespace in the module's build file
    ---
    Android Gradle Plugin 7.0开始，所有模块的build文件中都需要指定一个namespace
    这个namespace通常和你的包名一致，用来唯一标识你的模块
    解决：build.gradle hello 新增
    android {
        namespace 'org.cocos.hello'
    注意：这里用于指定模块的唯一id 所以cocos2dx的gradle内也需要添加 不然一直报未定义错误
    android {
        namespace "org.cocos2dx.lib"
```

- 问题9：

```
    The specified Android SDK Build Tools version (30.0.3) is ignored, as it is below the minimum supported version (33.0.1) for Android Gradle Plugin 8.1.4.
    Android SDK Build Tools 33.0.1 will be used.
    To suppress this warning, remove "buildToolsVersion '30.0.3'" from your build.gradle file, as each version of the Android Gradle Plugin now has a default version of the build tools.
    ---
    buildToolsVersion 不再需要被明确指定。插件现在会自动选择一个与其兼容的构建工具版本去使用
    改为：
    //compileSdkVersion 31
    compileSdk 31
    //buildToolsVersion "33.0.3"
```

- 问题10：

```
	java版本不对 错误不记得了 可能是上面的  
	java.io.File.path accessible: module java.base does not "opens java.io" to unnamed module @6276f7fd
    --
    注意命令行工具需要切java的环境路径 参考：build_apk_debug.bat
    set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
    解决：
    工程本身：tools:sdk manager:build execution:buildtools:gradle: 修改gradle jdk为jbr-17
    命令行 修改javahome地址
    set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
   set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"
   call gradlew assembleDebug
   call gradlew assembleRelase
```

- 问题11：

```
    package="org.cocos2dx.lib" found in source AndroidManifest.xml: D:\Work\cocos\cocos2d-x-v2-master-fork1\cocos2dx\platform\android\libcocos2dx\AndroidManifest.xml.
    --
    删除cocos2dx目录下manifest文件中的package="org.cocos2dx.lib">
    已经在gradle中指定了包名
```

- 问题12：

```
    Connection timed out: no further information. If you are behind an HTTP proxy, please configure the proxy settings either in IDE or Gradle.
    --
    下载超时
    解决：build.gradle中 下面的仓库也加入新地址
    allprojects {
        repositories {  内容同buildscript.repositories
```

- 问题13：

```
    > Task :hello:buildNdkBuildDebug[arm64-v8a][cocos2dcpp_shared] FAILED
    > Unexpected native build target cocos2dcpp_shared. Valid values are: cocos2dcpp, extension, cpufeatures, box2d, cocos2d, chipmunk, cocosdenshion
    ---
    call gradlew assembleDebug --stacktrace --info
    可查看具体执行的命令参数
    解决：修改jni/Android.mk  修改名字LOCAL_MODULE := cocos2dcpp_shared  为cocos2dcpp
    至于是动态库 还是静态库 是根据下面的include $(BUILD_SHARED_LIBRARY)
    或 include $(BUILD_STATIC_LIBRARY) 来决定的

    另外修改bdkBuild
    arguments 'NDK_TOOLCHAIN_VERSION=4.9' 为 clang  前面的是gcc在高版本ndk已经删除
```

- 问题14：

```
    ld: error: relocation R_AARCH64_PREL64 cannot be used against symbol 'OPENSSL_armcap_P'; recompile with -fPIC
>>> defined in D:/Work/cocos/cocos2d-x-v2-master-fork1/cocos2dx/platform/third_party/android/prebuilt/libcurl/libs/arm64-v8a/libcrypto.a(armcap.o)
    ---
    意味着你链接的库没有以-fPIC（位置无关代码）方式构建
    解决：
    方式1：使用./configure CFLAGS="-fPIC" CXXFLAGS="-fPIC" ... 重新编译库
    方式2：in use
    使用cocos-engine-external-github中的库libcrypto.a覆盖现有 包含3种cpu
```

- 问题15：

```
    ld: error: undefined hidden symbol: __stack_chk_fail_local
    --
    它是堆栈保护函数，用于防止栈溢出攻击，特别是在栈中分配大数组时
    解决：Application.mk中添加
    APP_CPPFLAGS += -fstack-protector
    注意：点击同步  否则不会生效
```

app\build\intermediates\apk\debug\hello-debug.apk  为什么里面只有arm64的so？
支持64位 用as连接手机 成功制作debug包！！！最大好处 可以调试c++代码！！！

- 问题16：通过bat编译产生的

```
    ld: error: undefined hidden symbol: __stack_chk_fail_local
    ---
    和上面的一样 as通过修改mk搞定了 但是通过gradlew assembleDebug还是报错
    解决1：新增参数NDK_LOG=1 和 cFlags "-fstack-protector"  -无效
    ndkBuild {
                    targets 'cocos2dcpp'
                    arguments 'NDK_TOOLCHAIN_VERSION=clang NDK_LOG=1'
                    cFlags "-fstack-protector"
    解决2： -无效
    本来打算从cocos-engine-external-github复制一份 但已经没这个so了
    需要使用 -fstack-protector 标志来重新编译库
    或 采用libcurl/android.mk中新增
    LOCAL_CPPFLAGS += -fstack-protector
    LOCAL_CFLAGS += -fstack-protector

    解决3：对比as本身的编译 发现错误发生的log针对liburl的x86库
    修改gradle.properties PROP_APP_ABI=armeabi-v7a:arm64-v8a
    删除x86库
```

- 为什么bat比as编译debug要慢很多？ 
  - 一个增量 一个完整编译
  - 一个多种so 一个只有arm64
  - 因为Android Studio默认只为当前连接的设备或者选中的模拟器的架构编译SO库。
  - 当你运行或者调试你的应用时，这样做可以使编译时间更短

### 1. arm64 hello基础上 复制cpptest工程

- 问题1：

```
    app\assets\Images\test_1021x1024_a8.pvr
    Duplicate resources
    --
    有看到另一个test_1021x1024_a8.pvr.gz 重复了？
    删除它 
    为什么会和test_1021x1024_a8.pvr冲突？
```

- 问题2：资源问题

```
    手动复制Resoucre到app/assets
    注释build.gradle hello  免得每次都复制 
    //preBuild.dependsOn copyAssets
```

- 问题3：新的democpp问题

```
    app/jni/Android.mk
    删除
        ../../../Classes/AppDelegate.cpp \
        ../../../Classes/HelloWorldScene.cpp
    因为文件太多了 通过一个新的mk文件制作成一个静态库引入
    位置在MyGameC2/Android.mk 来源于cpptest
    新增LOCAL_WHOLE_STATIC_LIBRARIES := cocos_testcpp_common
    $(call import-module,projects/MyGameC2/)  这里包含了上面的新mk文件路径 编译前as会自动搜索 
    若找不到会报错
```

- 问题4：

```
    .gitignore新增
    .vs
    .cxx
    projects/MyGameC2/Resources
```

支持cpptest arm64位的版本成功运行！！！


## 五、x64原生工程

基于cocos2.2.6 已经不支持64位系统 最大卡点估计在第三库
通过win64来探索可能性

### 1. 准备x64工程

属性页：配置管理器：平台win32下拉 可创建x64 且内容复制来源于win32
通过模仿win32的配置：头文件 lib库等 其他自己扩展的工程TwBase TwNet等都能编译过

```
    输出：$(SolutionDir)..\..\runtime\win64\   主工程用这个作为lib库的输入 
    中间目录：$(SolutionDir)..\..\temp\$(ProjectName)64\$(Configuration)\
```

### 1.0 准备win64第三方库
从win32先复制一份 然后逐个替换为64位的版本  
包含：curl iconv libjpeg libpng libtiff libwebp OGLES pthread zlib libraries  

#### 1.1 libCocosDenshion工程

- SetWindowLong(m_hWnd, GWL_USERDATA, (LONG)this); 找不到GWL_USERDATA
  解决：MciPlayer.cpp 头部新增定义
  类似情况：Win102InputBox.cpp

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
    解决：x64下 来源改为win64  重新制作第三方库库 采用x64的版本
```

- CCSprite.obj : error LNK2001: 无法解析的外部符号 __imp___glewVertexAttribPointer
  估计也是32位库的问题:glew32 libzlib libpng libjpeg libtiff libwebp libiconv pthreadVCE2
- 可能解决：最终方案[参考](/docs/cocos2dx/cocos2d-x-3rd-party-libs-src.md?)
  - a 删除不用的库 tiff webp
  - b 下载源码 手动编译 glew zlib png jpeg iconv pthread
  - c 从cocos2d-x-3rd-party-libs-src找源码
  - d 从creator库中复制64位的[版本](https://github.com/cocos/cocos-engine-external)
  - e 从github其他人提供的工程中寻找

- 问题1：
```
  error LNK2001: 无法解析的外部符号 "public: virtual void __cdecl cocos2d::CCDataVisitor::visit(class cocos2d::CCBool const *)" (?visit@CCDataVisitor@cocos2d@@UEAAXPEBVCCBool@2@@Z)
  解决：vs中打开CCDataVisitor.cpp文件 右键编译 正常通过后 再次编译cocos工程就没这个报错了 缓存问题？
```

- 问题2：
```
    void CC_DLL CCLog(const char * pszFormat, ...) CC_FORMAT_PRINTF(1, 2);
    解决：
    #elif defined(__has_attribute)
    #if __has_attribute(format)
    #define CC_FORMAT_PRINTF(formatPos, argPos) __attribute__((__format__(printf, formatPos, argPos)))
    #else  新增这一段
    #define CC_FORMAT_PRINTF(formatPos, argPos)
    #endif
```


### 1.3 libExtensions
```
  生成事件中 额外的库：
  if not exist "$(OutDir)" mkdir "$(OutDir)"
    xcopy /Y /Q "$(ProjectDir)..\..\external\libwebsockets\win64\lib\*.*" "$(OutDir)"
    xcopy /Y /Q "$(ProjectDir)..\..\external\sqlite3\libraries\win64\*.*" "$(OutDir)"

  解决： 
  新建libwebsockets\win64
  从D:\Cocos\cocos-engine-external-3.8.2\win64\libs\复制websockets.lib .dll

  重新整理sqlite3的目录 原来公用了include 现在改为独立 类似上面
  D:\Cocos\cocos-engine-external-3.8.2\win64\include\sqlite3\
  同时修改vs工程include地址
```

### 其他问题
- 问题1：编译x64通过后 运行报错
```
  缺少：libcrypto-1_1-x64.dll libssl-1_1-x64.dll 
    从C:\ProgramData\cocos\editors\Creator\3.8.0\resources\tools\openSSLWin64复制一份
  缺少：libuv.dll
    从C:\ProgramData\cocos\editors\Creator\3.8.0\resources\resources\3d\engine\bin\.editor复制
```

- 问题2： 精灵对象为null
```
    CCSprite* pSprite = CCSprite::create("HelloWorld.png");
    补路径：
    #ifdef _WIN64
        searchPaths.push_back("../../Resources");  //hello\proj.win32\x64\Debug 比hello\proj.win32\Debug.win32多一层
    #endif

    还是报错 跟踪发现png解析问题
    核对了库 和一样
    定位代码：
    #define PNG_LIBPNG_VER_STRING "1.4.5beta04"
    png_create_read_struct(PNG_LIBPNG_VER_STRING, 0, 0, 0);
    发现 这个版本字符串必须要和库一致 in png.c 
    查看creator源码 找到这个字符串 发现定义在png.h中 而非.c
    由于x86和x64版本不同  
    #define PNG_LIBPNG_VER_STRING "1.6.37"
    #define PNG_LIBPNG_VER_STRING "1.4.5beta04"
    原因：引入库地址错了
    修改：找到所有的工程include 全部改为64的地址
    注意：除外
    $(ProjectDir)..\..\..\cocos2dx\platform\win32 这里存放的是cpp源码
```

- 问题3： 缺少uv.h
```
    libwebsockets.h
    #ifdef LWS_WITH_LIBUV
    #include <uv.h>
    #ifdef LWS_HAVE_UV_VERSION_H
    #include <uv-version.h>
    #endif
    #endif /* LWS_WITH_LIBUV */

    发现是新引入的websocket库带来的
    从D:\Cocos\cocos-engine-external-3.8.2\win64\libs\复制uv库 和libuv.lib libuv.dll
    加入到third_party\win64\libraries 并添加include
    又缺openssl 同样方式复制
```

- 问题4：CHECK_GL_ERROR_DEBUG();
```
    {
        GLenum __error = glGetError();  实际为这个函数调用报错
		if (__error) {
			CCLog("OpenGL error 0x%04X in %s %s %d\n", __error, __FILE__, __FUNCTION__, __LINE__);
		}
    }
```



