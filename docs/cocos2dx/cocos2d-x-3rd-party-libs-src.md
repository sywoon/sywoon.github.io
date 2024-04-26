# 🔙[cocos2dx](/docs/cocos2dx/)

- [mingw32](https://github.com/meiry/cocos2d-x-3rd-party-libs-src-mingw32)
- [m1相关的探讨](https://discuss.cocos2d-x.org/t/apple-m1-xcode-build-fails/52202/23)
- [[bugfix] iOS compile error](https://github.com/cocos2d/cocos2d-x/pull/20634)
- [cocos2d-x-3rd-party-libs-src-mingw32]([cocos2d-x-3rd-party-libs-src-mingw32](https://github.com/meiry/cocos2d-x-3rd-party-libs-src-mingw32?tab=readme-ov-file))

## 一、编译cocos2d-x-3rd-party-libs-src v3

1. 下载后发现里面没有库的源码 根据readme 先安装brew环境

```
    brew update
    brew install git
    brew install cmake
    brew install autoconf
    brew install automake
    brew install libtool
```

2. 编译库

```
    ./build.sh -p=platform --libs=libs --arch=arch --mode=mode --list
        libs:all png,lua,jpeg,webp...
        platforms: ios, mac, android, linux and tizen
        arch:all ios Android Mac 
            - for iOS, they are "armv7, arm64, i386, x86_64"
            - for Android, they are "arm,armv7,arm64,x86"
            - for Mac, they are "x86_64"
        mode:release debug
        list:看库版本

    ./build.sh -p=mac --libs=freetype --arch=arm64 --mode=release  报错：mac不支持arm64
    ./build.sh -p=ios --libs=freetype --arch=arm64 --mode=release  得到libfreetype.a
    ./build.sh -p=ios --libs=all --arch=armv7,arm64 --mode=release
    contrib目录下 会自动下载源文件
    build目录得到所有库的编译二进制文件
```

./build.sh -p=mac --libs=png --arch=x86_64 --mode=release
有很多编译报错！！

```
    Undefined symbols for architecture arm64:
  "_png_init_filter_functions_neon", referenced from:
      _png_read_filter_row in libpng16.a[10](pngrutil.o)
ld: symbol(s) not found for architecture arm64

```

### 1. build.sh分析

#### 1.1 libs的下载

1. 通过contrib/src/main.mak查看到下载库的源头

```
    TOPSRC ?= ../../contrib
    TOPDST ?= ..
    SRC := $(TOPSRC)/src
    TARBALLS := $(TOPSRC)/tarballs

    # Common download locations
    GNU := http://ftp.gnu.org/gnu
    SF := https://downloads.sourceforge.net/project
    GITHUB := https://github.com
```

2. 通过contrib/src/png/rules.mak 查看目标lib的路径

```
    PNG_VERSION := 1.6.16
    PNG_URL := $(SF)/libpng/libpng16/older-releases/$(PNG_VERSION)/libpng-$(PNG_VERSION).tar.xz

    $(TARBALLS)/libpng-$(PNG_VERSION).tar.xz:
        $(call download,$(PNG_URL))

  得到：
    https://downloads.sourceforge.net/project/libpng/libpng16/older-releases/1.6.16/libpng-1.6.16.tar.xz
    会判断是否已经下载过了 在contrib/tarballs/目录下 所有第三方库都在这个目录里
```

### 2. third libs

#### 2.1 box

https://github.com/erincatto/Box2D

```
  $(TARBALLS)/libbox2d-git.tar.xz:
    $(call download_git,$(BOX2D_GITURL),master,f655c603ba9d83f07fc566d38d2654ba35739102)
  加载的是某个commit 不好找 直接下载了 v2.4.1 2020.10.18
```

#### 2.2 png

[src](https://sourceforge.net/projects/libpng/files/libpng16/)
使用1.6.16 最新1.6.43

#### 2.3 freetype2

[src](https://downloads.sourceforge.net/project/freetype/freetype2/2.5.5/freetype-2.5.5.tar.gz)

```
FREETYPE2_VERSION := 2.5.5
FREETYPE2_URL := $(SF)/freetype/freetype2/$(FREETYPE2_VERSION)/freetype-$(FREETYPE2_VERSION).tar.gz
```

#### 2.4 zlib

[src](http://zlib.net/fossils/zlib-1.2.8.tar.gz)
ZLIB_VERSION := 1.2.8
ZLIB_URL := http://zlib.net/fossils/zlib-$(ZLIB_VERSION).tar.gz

## 二、编译cocos2d-x-3rd-party-libs-src v2

### 1. 使用windows编译库

- 1.1 下载[msys2](https://www.msys2.org/) 下了64位的 估计那个时候是32位的
- 1.2 安装软件环境

```
  pacman -Syu    确保您的包管理器是最新
  pacman -S mingw-w64-i686-toolchain
  pacman -S git make mingw-w64-i686-cmake tar autoconf automake libtool automake
  看提示 输入all 或 Y
  
  设置环境变量：
  	临时：export MY_VARIABLE=value
  	永久：需要编辑 /etc/profile 或者 /etc/bash.bashrc 文件（或者用户级别的~/.profile 或 ~/.bash_profile）
  	案例：echo 'export MY_VARIABLE=value' >> /etc/profile
  cocos需要设置ndk路径：
  export ANDROID_NDK=/d/Ard_Env/android-ndk-r10e/
  echo 'export ANDROID_NDK=/d/Ard_Env/android-ndk-r10e/' >> /etc/profile
  测试：echo ${ANDROID_NDK}
```

- 1.3 在msys2中定位到windows的目录
  - cd /d/cocos/cocos2d-x-3rd-party-libs-src-2/build
- 1.4 使用命令行编译库

```
  ./build.sh -p=platform --libs=libs --arch=arch --mode=mode --list

  platforms: ios, mac, android, linux and tizen
  arch:
    use all to build all the supported architectures.
    for iOS, they are "armv7, arm64, i386, x86_64"
    for Android, they are "arm,armv7,arm64,x86"
    for Mac, they are "x86_64"
  mode:release debug 
    release: -O3 -DNDEBUG 
    debug: -O0 -g -DDEBUG
```

- 1.5 编译单独的库

```
  cd /D/cocos/cocos2d-x-3rd-party-libs-src-2/build
  ./build.sh -p=android --libs=png
  ./build.sh -p=ios --libs=png
  ./build.sh -p=android --libs=png --arch=armv7,arm64 --mode=debug
```

- 1.6 android arm64
- 1.6.1  NDK r10c and set the ANDROID_NDK ; source ~/.bash_profile
- 1.6.2  修改android.ini config file. Change cfg_default_build_api=21 and cfg_default_gcc_version=4.9.
- 1.6.3 Pass --arch=64 to build the libraries with arm64 support
- 注意：

```
  Note: If you build webp with arm64, you will get cpu-features.h header file not found error. This is a known issue of Android NDK r10c. You could simply create a empty header file named cpu-features.h under {ANDROID_NDK}/platforms/android-21/arch-arm64/usr/include.
```

- 1.7 自动清理  turn on the flag cfg_is_cleanup_after_build to "yes" in main.ini

### 2. 怎么升级第三方库

查看contrib/src/readme

### 3. 怎么添加新库

查看contrib/src/readme

## 三、cocos2d-x-3rd-party-libs-bin-3-deps-148

看着是bin工程 实际都是源码 通过cmake来编译
根据ai提示

### 1.1 通过cmake创建工程

```
    mkdir build
    cd build
    msys2：
    cmake .. -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/Windows_mingw-arm64.cmake
    win32：
    cmake .. -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/Windows_mingw-arm64.cmake

    编译：make
```

### 1.2 msys2编译

```
    cd /D/Cocos/cocos2d-x-3rd-party-libs-bin-3-deps-148/
    mkdir build
    cd build
    cmake .. -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/Windows_mingw-arm64.cmake
    错误：
    CMake Error: Could not create named generator MSYS Makefiles

```

### 1.3 msys2编译64位

```
    pacman -S mingw-w64-x86_64-toolchain
    cmake .. -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
    make
```

### 1.4 vs编译

```
  cmake -G "Visual Studio 15 2017" ..
  cmake -G "Visual Studio 17 2022" ..
```




## 四、cocos2dx2.2.6 libs windows-x64
没找到x64的libs 只好自己编译

### 编译环境准备

[MinGW-w64](https://www.mingw-w64.org/downloads/)
[msys2](https://www.msys2.org/)

1. 下载 msys2-x86_64-20240113.exe 并默认安装
   uname -m  查看当前版本  64位：x86_64
   pacman -Syu  更新系统的软件包列表和已安装的软件包pacman -S base-devel 安装开发工具
2. 安装gcc环境 执行p
   pacman -S mingw-w64-ucrt-x86_64-gcc
   pacman -S gcc
   gcc --version

3. 进入windows的某个盘 /d/

###　1. curl
cocos2d-x-3rd-party-libs-src-3\contrib\src\curl
rules.mak
http://curl.haxx.se/download/curl-7.52.1.tar.gz  2012年
curl-8.7.1 2024-03-27 
https://curl.se/download.html
有各种平台的bin文件 包含x64
版本来源很多 并非都有lib文件 有些只有exe

比如某个windows版本：
https://curl.se/windows/
curl 8.7.1 for Windows  包含32 64 arm64
curl-8.7.1_7-win64-mingw  只有.a文件

- 选择1：php提供的版本 
  [x86](https://windows.php.net/downloads/php-sdk/deps/vs16/x86/)
  [x64](https://windows.php.net/downloads/php-sdk/deps/vs16/x64/)
  libcurl-8.6.0-2-vs16-x64
  只有.lib  看来是个静态库
```
  报错：error LNK2019: 无法解析的外部符号 __imp__curl_easy_init，
  貌似链接了libcurl_a.lib 没什么用 可能平台还是不匹配 也不是动态库
```

- 选择2：从cocos-engine-external-3.8.2提取 最终：x86和x64不是同一个版本 后面优化下！！！
```
  这是creator的库  只有win64版本  
  32的版本继续用之前的 或者用cocos-engine-external-2.4
  注意：内部用了wsocket函数？
  ws2_32.lib;
```

- android库 还是从之前的arm64 fork1中提取 虽然版本有点不同


### 2. iconv

项目中用了源码 来自eyu_long2\TwMobile-cocos2d\cocos2dx\platform\third_party\android\prebuilt\libiconv是很早的版本2008年  版本号未知？
自己从官方下载
https://www.gnu.org/software/libiconv/
https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz  最新版本
历史列表：
https://ftp.gnu.org/pub/gnu/libiconv/

- [genwin32版本](https://gnuwin32.sourceforge.net/packages/libiconv.htm)

  - 只有2004年的 下载： Complete package, except sources	 	Setup
- 头文件可以看到

```
  旧版 ard _LIBICONV_VERSION 0x010D 源码
  旧版 win32 _LIBICONV_VERSION 0x0109 头文件+lib
  1.17 2022-05-15 _LIBICONV_VERSION 0x0111
  1.15 2017-02-02 _LIBICONV_VERSION 0x010F
  1.13.1 2009-06-30 _LIBICONV_VERSION 0x010D 原始ard源码版本
  1.12 2007-11-11 _LIBICONV_VERSION 0x010B
  1.10 2005-07-26 _LIBICONV_VERSION 0x010A
  1.9.2 2004-01-23 _LIBICONV_VERSION 0x0109 原始win32 lib版本
  1.8 2002-05-29 _LIBICONV_VERSION 0x0108
```

- iconv的cpp封装

```
  有个比较麻烦的地方 输出需要一个char*地址 而且大小也是iconv后才知道
  一般根据input的长度*3来作为outbuff的大小 再通过outsize精准定位输出长度
  由于字符串转换后 可能中间包含\0导致 直接用std::string 或 char*来输出 都会截断问题
  再次作为源头进行转换时  将出现部分字符串丢失 甚至完全转换失败
```

- 找了几个github上用c++方式的封装

```
  iconv_wrap-master
    纯粹封装成一个类 暴露了基本函数open close tranlate
    没对字符串做控制 都是原始的char*
  iconv_wrapper-master
    封装得比较复杂 转为string保存 转换失败会resize大小
  iconvpp-master 日本人写的
    convert(const std::string& input, std::string& output)
      std::vector<char> buf(buf_size_); 临时缓存 大小固定
      while (0 < src_size) {  一段一段转 不会有截断位置问题？
        dst.append(&buf[0], buf.size() - out_size); 追加到临时string
      dst.swap(output); 一次转给外部的string
  iconvpp-master2 名字相同 韩国人
    用了boost和大量的std函数 对返回结果做了处理
    std::vector<char> output( block_size );  固定大小 且外部传入的模板参数
    优点：根据参数名 了解到iconv的insize和outsize都是可修改 而且是甚于大小 不是转换后的字符串大小！！

  xqj项目： 初始字符串有点奇怪 不是GBK UTF-8 效果一样？
    static CConv s_conv("GBK//TRANSLIT", "utf-8");
    static CConv s_conv("utf-8", "GBK");

  小结：
    iconv(m_hConv, (const char**)&pInBuf, (size_t*)&nInBufLen, &pOutBuf, (size_t*)&outLeft)
    输入大小和输出大小都是可变的 且初始传入的值必须符合buf的情况
    转换后 若成功则insize变成0 outsize为剩余大小  
    因为一开始无法估计需要的大小 所以一般用insize*3作为outsize
    转换成功后 再resize(outsize-outleft) 让string精确实际大小 
    且可通过size重新作为输入 转另一种字符
    即使resize后：ansi2.length() == ansi2.size() 说明两者相同！

  解决方案：
  c++ 传入instr+insize 输出outstr&+outsize 并且按转后的实际大小resize outstr
    可以设计一个临时的string对象 作为转化缓存 用insize×3作为最小size
    再append到outstr.append(&buf[0], buf.size() - out_size);  //注意outsize是偏移值 有看到负数？
    可以用输出的对象 重新作为输入
  c 传入inchar*+insize 输出outchar**+outsize 并在内部malloc内存 由外部使用后释放
```

- 1.13.1和项目内的差异对比:去除了很多@符号

```
  对比iconv.in 猜测头文件使用命令生成的 这里是模板
  extern @DLL_VARIABLE@ int _libiconv_version; /* Likewise */
  extern /*DLL_VARIABLE*/ int _libiconv_version; /* Likewise */

  #define EILSEQ @EILSEQ@
  #define EILSEQ EILSEQ

  extern size_t iconv (iconv_t cd, @ICONV_CONST@ char* * inbuf, size_t *inbytesleft
  extern size_t iconv (iconv_t cd, const char** inbuf, size_t *inbytesleft

  #if @USE_MBSTATE_T@
  #if @BROKEN_WCHAR_H@
  #if USE_MBSTATE_T
  #if BROKEN_WCHAR_H

  #if @USE_MBSTATE_T@
  #if USE_MBSTATE_T

  #if @HAVE_WCHAR_T@
  #if HAVE_WCHAR_T

   .c文件差异非常大 
```

- 编译最新的1.17版本

```
  msys2
  android:
  ./configure --prefix=/usr/local

  win32:
  ./configure --host=i686-w64-mingw32 --prefix=/usr/local

  win64:
  ./configure --host=x86_64-w64-mingw32 --prefix=/usr/local

  make
  make install
```

- vs2022编译x86 x64库 [参考](https://blog.csdn.net/qq_38421080/article/details/122897113)
- [参考2 github x64](https://github.com/txwizard/iconv_x64_and_ARM) 基于1.15

```
  库编译成功了 但是执行不正确 另外不支持64位
  ${SolutionDir}libs\iconv; 报错 找不到iconv.h
  $(ProjectDir)..\libs\iconv; 正常  vs的bug？


  error LNK2019: 无法解析的外部符号 __imp__iconv_open，
  解决：
  #ifdef __cplusplus
    extern "C" {
    #endif
        #include "iconv.h"
    #ifdef __cplusplus
    }
    #endif

    #ifdef __cplusplus
  }
  #endif

  error LNK2019: 无法解析的外部符号 __imp_libiconv_open，函数 "public: __cdecl CConv::CConv(char const *,char const *)" (??0CConv@@QEAA@PEBD0@Z) 中引用了该符号
  解决：
  除了库工程  使用的项目也需要新增USING_STATIC_LIBICONV

  x64\iconv.lib : warning LNK4272: 库计算机类型“x86”与目标计算机类型“x64”冲突
  解决：链接库目录错误了 lib的名字是一样的

  64位机器上size_t问题 它的sizeof为8
  解决：全部改为int
```

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

- 使用ndk 编译iconv库  临时参考 后期删除
- [参考1](https://blog.hawkhai.com/backup/2021-02-27-mbs-and-wcs-for-Android.md/my.oschina.net/bd649d53.html)
- [参考](https://github.com/q384264619/android_iconv/tree/master?tab=readme-ov-file)
- [参考](https://cloud.tencent.com/developer/article/1719231)
- [参考](https://blog.csdn.net/q384264619/article/details/106400814)
- [参考](https://blog.csdn.net/q384264619/article/details/106422874)
- [参考](https://blog.csdn.net/u012138730/article/details/105145560)
- [参考](https://github.com/zw3rk/ghc-build-scripts)

### 3. libjpeg
cocos2d-x-3rd-party-libs-src-3\contrib\src\jpeg
http://www.ijg.org/files/jpegsrc.v9b.tar.gz
从cocos-engine-external-3.8.2提取


### 4. libpng
cocos2d-x-3rd-party-libs-src-3\contrib\src\png
SF := https://downloads.sourceforge.net/project
$(SF)/libpng/libpng16/older-releases/1.6.16/libpng-1.6.16.tar.xz
https://downloads.sourceforge.net/project/libpng/libpng16/older-releases/1.6.16/libpng-1.6.16.tar.xz
从cocos-engine-external-3.8.2提取

https://downloads.sourceforge.net/project/libpng/libpng16
1.6.43	2024-02-23 最新版本




### 5. libtiff
cocos2d-x-3rd-party-libs-src-3\contrib\src\tiff
http://download.osgeo.org/libtiff/old/tiff-4.0.3.tar.gz  2015-Jun-21之前
cocos-engine-external-3.8.2没这个库了 先忽视
http://download.osgeo.org/libtiff/?C=M&O=A
4.6.0 2023-Sep-13

- [参考libtiff-x64-build](https://github.com/Mayi-Keiji/libtiff-x64-build)
某个博主自己编译的x64库 [doc](https://blog.csdn.net/fengshengwei3/article/details/103733019)
只有方法 没给lib文件  按照他的方法编译出的lib 没法用

- 自己编译src库
```
  tiff-4.6.0
  cmake -S . -B build -G "Visual Studio 17 2022" -A x64
  cmake --build build --config Release  
  默认得到库名称为tiff.lib+dll
  用vs打开 修改属性：
  常规：目标名称：libtiff
  链接器：高级：到入库：D:/tiff-4.6.0/build/libtiff/Debug/tiffd.lib
  注意：build/libtiff/tiffconf.h  需要额外复制 估计是通过别的.in文件生成的
```


### 6. libwebp
cocos2d-x-3rd-party-libs-src-3\contrib\src\webp
http://downloads.webmproject.org/releases/webp/libwebp-0.5.0.tar.gz   2015-12-23
发现0.5.1的版本 有x64和x32

所有版本：http://downloads.webmproject.org/releases/webp/
libwebp-1.4.0-windows-x64.zip    2024-04-13
libwebp-1.4.0.tar.gz             2024-04-13
最新版本只有x64
从cocos-engine-external-3.8.2提取



### 7. OGLES
没找到库源码 根据头文件glew.h glxew.h wglew.h猜测都是glew的库
glew.h 是用于 Linux 和 macOS 的头文件，而 glxew.h 是用于 X Window 系统的 OpenGL 扩展，wglew.h 是用于 Windows 平台的
https://glew.sourceforge.net/
根据之前的头文件 发现是2008年的版本 对应GLEW 1.5.1 年份对上了 除了mingw32外新增了cygwin的支持
最新2.1.0 2017.7.31  看来废弃很久了 但支持x64

- x64的解决方案：直接用glew-2.1.0-win32
- android中并没使用glew(主要用于windows环境) ard中使用EGL来管理OpenGL ES扩展

```
  通过cocos/Android.md可以看到 使用的是egl2.0的版本
  LOCAL_EXPORT_LDLIBS := -lGLESv2 \
                       -llog
  对应OpenGL ES 的头文件<GLES2/gl2.h>
  最新版本已经有3.0的<GLES3/gl3.h>  LOCAL_LDLIBS := -lGLESv3

  CCObject.h
  #ifdef EMSCRIPTEN Emscripten 是一个基于 LLVM 的工具链，它可以将 C 和 C++ 代码编译成 WebAssembly（Wasm）以便在 Web 浏览器中运行
  #include <GLES2/gl2.h>
  #endif // EMSCRIPTEN

  android/CCGL.h  android平台渲染封装的地方！！！
  #include <GLES2/gl2.h>
  #include <GLES2/gl2ext.h>
```
- 手动编译glew源码 x64
```
  直接用vs2022打开glew-2.1.0\build\vc12\glew.sln
  可以看到动态库和静态库(glews.lib)两个工程 
  glew_shared release工程编译不过 但是debug可以
  glew.obj : error LNK2019: 无法解析的外部符号 _memset，函数 _glewContextInit@0 中引用了该符号
  解决：添加vcruntime.lib  为什么？？？
  用了这个版本的lib  问题依旧
  用静态库-奇怪 编译不过！！！
```
- 无论creator还是自己编译的库 运行就报错
```
  0x00007FFFED428F20 (nvoglv64.dll)处(位于 HelloCpp.exe 中)引发的异常: 0xC0000005: 读取位置 0x000000000FDA643C 时发生访问冲突。
```


### 8. pthread

根据头文件 发现版本是2.8.0 2005年
ftp://sourceware.org/pub/pthreads-win32
使用flashFXP远程连接 可以看到所有历史版本从2002-2005
也可以直接用explore打开
pthreads-w32-2-8-0-release.exe是一个解压文件
== pthreads-w32-2-8-0-release.tar.gz + dll库
发现prebuilt-dll-2-9-1-release带了64位的版本！！！

google最新结果 说windows不支持原始的pthreads
可以使用pthreads4w代替
https://sourceforge.net/projects/pthreads4w/files/
下载了2012.7.12 2.9.1
2018.8.8 2.11.0
2018.8.8 3.0.0 可能是某人一起上传的
暂时没用

### 9. zlib

cocos2d-x-3rd-party-libs-src-3\contrib\src\zlib
http://zlib.net/fossils/zlib-1.2.8.tar.gz  2013-04-28
所有版本：http://zlib.net/fossils/
zlib-1.3.1.tar.gz	2024-01-22
都是源码 需要自己编译
