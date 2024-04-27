# 🔙[cocos2dx](/docs/cocos2dx/)

有了之前的积累 打算用hello工程 做一个x64的版本


## 项目准备
1. 创建demo工程 会生成在projects/
```
    python2.7
    cd tools/project-creator/
    python create_project.py -project hello -package com.example.hello -language cpp
```

2. 用vs编译win32版本 成功后 再创建x64版本
```
  debug win32下拉菜单：点击配置管理器：活动解决方案选择新建：
  目标x64 来源win32
  ---
  这样的工程配置 和通过新建干净的windows工程项目有和区别？(已经自带了x64平台)
```

3. 准备x64的第三方库 以及相关工程配置
```
  a 新建cocos2dx\platform\third_party\win64
  	libraries 包含所有lib和dll  后面复制需要用到
  b 修改libcocos2d的include路径 将原32位库的路径都改为64位 后期都需要补齐
    比如：
    $(ProjectDir)..\platform\third_party\win32\pthread
    =》
    $(ProjectDir)..\platform\third_party\win64\pthread
    注意：
    $(ProjectDir)..\platform\win32 这个路径不变 因为存放的是cpp文件
  c 生成事件：链接前事件 改为win64
    if not exist "$(OutDir)" mkdir "$(OutDir)"
    xcopy /Y /Q "$(ProjectDir)..\platform\third_party\win64\libraries\*.*" "$(OutDir)"

```

4. 补齐所有64位库
- glew
```
  解决：使用glew-2.1.0-win32 自带了x64库
  几个重要目录：
    cocos2dx\platform\third_party\win64\glew\ 头文件 加入include路径
    cocos2dx\platform\third_party\win64\libraries\  .lib .dll文件 会自动复制到out目录
    projects\hello\proj.win32\x64\Debug\  out目录
```

- iconv
- [github上找到的x64版本的iconv](https://github.com/txwizard/iconv_x64_and_ARM)
  基于1.15
```
  能编译出x64的dll和lib
  但是测试案例都比较抽象
  将lib和dll单独提取 重新创建测试工程 可以使用！！！

  修改win32版本的库名称：
    由于链接器：常规：输出文件：$(OutDir)$(TargetName)$(TargetExt)
    所以修改 目标文件名：$(ProjectName)$(PlatformArchitecture) 改为：$(ProjectName)
```

- pthread
```
  根据头文件 发现版本是2.8.0 2005年
    ftp://sourceware.org/pub/pthreads-win32
    下载发现prebuilt-dll-2-9-1-release带了64位的版本  使用之！！！
```

- png + zlib
```
  早期libpng-1.6.16
  https://downloads.sourceforge.net/project/libpng/libpng16
  libpng-1.6.43 自带vs工程
  依赖 zlib 1.0.4 or later  
  最后选择了最新的zlib-1.3.1.tar.gz 解压到和libpng并行的目录
  实际根据vs工程内的zlib工程带的源码 双击打开也能看到路径
  zlib库 一次编译通过！！
  
  修改libpng生成的文件名：
  常规：目标文件名：$(ProjectName)16 改为 $(ProjectName)
  
  libpng编译报错：
  arm_init.c(16,10): error C2220: 以下警告被视为错误
   warning C4464: 相对包含路径包括 ".."
  #include "../pngpriv.h"
  解决：
  配置：c/c++:常规：将警告视为错误：$(TreatWarningAsError) 改为否
  这个值哪里配置的？
  
  zlib库：
    删除宏Z_SOLO  gzread gzopen gzclose会受到影响 cocos的ZipUtils.cpp有用到
    并且工程中加入gzclose.c gzlib.c gzread.c gzwrite.c
  
  创建x64位配置 从win32复制而来
  最后得到x86 x64的库 libpng.lib .dll
```

- jpeg
- [参考](https://blog.csdn.net/Strive_For_Future/article/details/134085227)
```
  http://www.ijg.org/files/
  jpegsr9f.zip or jpegsrc.v9f.tar.gz 内容一样
  
  编译：
  a 复制C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include\Win32.Mak 到解压后的根目录
  b 使用vs2022 控制台开发工具 developer command 不是：交叉编译控制台 x86_x64 cross tools
  c nmake /f makefile.vc setup-v10
  报错：
  NMAKE : fatal error U1073: 不知道如何生成“setup-v10”
  找到makefile.vc文件 查看到内部为setup-v16
  nmake /f makefile.vc setup-v16
  d 打开jpeg.sln 注意不是 apps.sln这是使用案例 需要用到libjpeg
  只有release版本 如要debug版本可参考上面链接制作
```

- tiff
```
  http://download.osgeo.org/libtiff/
  a tiff-4.6.0.zip 最新版本
  cmake -S . -B build -G "Visual Studio 17 2022" -A x64 
  cmake --build build --config Release  
  b 打开sln工程 修改tiff工程目标名称为libtiff
  链接器：高级：到入库： libtiff/Debug/libtiff.lib
  c 制作win32平台从x64复制
  为了防止和x64的目录冲突
  修改输出目录：$(SolutionDir)$(Configuration)\$(Platform)\
  中间目录：$(SolutionDir)$(Configuration)\$(Platform)\$(ProjectName)\
  得到lib和dll
  
  无论是否带x64 生成的sln文件都只有x64 复制为win32后编译不过
  所以32位的lib暂时搁置
```

- webp
```
  http://downloads.webmproject.org/releases/webp/
  libwebp-1.4.0-windows-x64.zip    2024-04-13
  只有64位版本  32位的lib暂时搁置
```

- curl
```
  http://curl.haxx.se/download/
  curl-8.7.1.zip
  a cmake -S . -B build -G "Visual Studio 17 2022"
  b 复制src到build/src
  编译得到curl.exe
  c 修改libcurl_shared 目标名称：libcurl-d 改为libcurl
  链接器:高级:导入库 build/lib/Debug/libcurl-d_imp.lib 改为：libcurl_imp.lib
  只有x64 尝试复制出win32 编译不过
```

- opengl32
```
  C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64 x86
  复制OpenGL32.Lib
```


3. 编译libcocos2d

- 问题1：glew相关库
```
  CCApplication.obj : error LNK2001: 无法解析的外部符号 __imp_Sleep
  CCApplication.obj : error LNK2001: 无法解析的外部符号 	  	__imp_GetModuleHandleW
  所有系统函数都链接不到
  
  根据新建的win32项目 x64正常编译 切支持Sleep 对比两个工程配置：
  include路径：删除
  $(MSBuildProgramFiles32)\Microsoft SDKs\Windows\v7.1A\include
  c/c++ 所有选项：
    调试信息格式：程序数据库 (/Zi) 改为 用于“编辑并继续”的程序数据库 (/ZI)
```
- 没解决问题 也不好对比
- 重新采用新建工程libcocos2d2 手动添加文件的方式  
- 至少新建的工程x64可以编译过 能执行Sleep函数
```
  a 创建静态库工程 完成x64 win32平台编译
  b 手动添加所有目录结构和文件到vs工程里
  c 对比之前的工程 修改配置属性
  
  可疑处记录：
  1 vc++目录：库目录：
   win32:
    $(MSBuildProgramFiles32)\Microsoft SDKs\Windows\v7.1A\lib;$(LibraryPath)  旧
    $(VC_LibraryPath_x86);$(WindowsSDK_LibraryPath_x86) 新
    对应：
    C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.37.32822\lib\x86
    C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\ucrt\x86
  x64:
    $(MSBuildProgramFiles32)\Microsoft SDKs\Windows\v7.1A\lib
    $(VC_LibraryPath_x64);$(WindowsSDK_LibraryPath_x64)
    对应：
    C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.37.32822\lib\x64
    C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\ucrt\x64
    
   其他几个配置也类似：可执行文件目录 引用目录等 都在vc++目录页内
   解决：
   把libcocos2d的 库目录都改为新地址 win32 x64都改了
   
  2. c/c++:常规：库包含目录
   删除 $(MSBuildProgramFiles32)\Microsoft SDKs\Windows\v7.1A\include
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

- 问题3：
```
  error LNK2001: 无法解析的外部符号 gzread gzopen gzclose
  zlib其他库函数可以 感觉是否缺了一个编译开关？
  
  打开zlib工程的zlib.h文件 可以看到gzopen函数都是灰色的
  受到#ifndef Z_SOLO 控制
  Z_SOLO：
  生成一个不依赖任何第三方库的版本
  zlib库的一些功能会被禁用，例如gz*函数和一些依赖内存分配的函数（如compress()、uncompress()等）。这是因为这些功能可能需要使用到第三方库
  通常用于嵌入式环境
  解决：
  删除宏Z_SOLO  并且工程中加入gzclose.c gzlib.c gzread.c gzwrite.c
```

- 问题4：
```
  pthread函数链接不上：
  pthreadVCE2.lib 改为 pthreadVC2.lib
```
至此libcocos2d库 完整的x64编译通过！！！


4. 编译其他工程库

- 问题1：
```
  error C2065: “GWL_USERDATA”: 未声明的标识符
  解决：MciPlayer.cpp 头部新增定义
    #ifdef _WIN64
        #define GWL_USERDATA        (-21)
    #endif
    类似情况：Win102InputBox.cpp
```

- 问题：
```
   LocalStorage.obj : error LNK2019: 无法解析的外部符号 sqlite3_close
   sqlite3.lib : warning LNK4272: 库计算机类型“x86”与目标计算机类型“x64”冲突
   Websocket.obj : error LNK2019: 无法解析的外部符号 lws_create_context
   websockets.lib : warning LNK4272: 库计算机类型“x86”与目标计算机类型“x64”冲突
   
   解决： 
      新建libwebsockets\win64
      从D:\Cocos\cocos-engine-external-3.8.2\win64\libs\复制websockets.lib .dll

      重新整理sqlite3的目录 原来公用了include 现在改为独立 类似上面
      D:\Cocos\cocos-engine-external-3.8.2\win64\include\sqlite3\
      同时修改vs工程include地址

      生成事件中 额外的库：
      if not exist "$(OutDir)" mkdir "$(OutDir)"
        xcopy /Y /Q "$(ProjectDir)..\..\external\libwebsockets\win64\lib\*.*" "$(OutDir)"
        xcopy /Y /Q "$(ProjectDir)..\..\external\sqlite3\win64\lib\*.*" "$(OutDir)"
```

- 问题：其他工程编译目标平台问题
```
  库目录 全部改为：
  $(VC_LibraryPath_x64);$(WindowsSDK_LibraryPath_x64)
```

- 问题：
```
```





