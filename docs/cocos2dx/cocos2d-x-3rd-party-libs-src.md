
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

1. curl
cocos2d-x-3rd-party-libs-src-3\contrib\src\curl\
rules.mak
http://curl.haxx.se/download/curl-7.52.1.tar.gz


2. iconv
项目中用了源码 来自eyu_long2\TwMobile-cocos2d\cocos2dx\platform\third_party\android\prebuilt\libiconv\
是很早的版本2008年  版本号未知？
自己从官方下载
https://www.gnu.org/software/libiconv/
https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz


3. libjpeg
cocos2d-x-3rd-party-libs-src-3\contrib\src\jpeg\
http://www.ijg.org/files/jpegsrc.v9b.tar.gz

4. libpng
cocos2d-x-3rd-party-libs-src-3\contrib\src\png\
SF := https://downloads.sourceforge.net/project
$(SF)/libpng/libpng16/older-releases/1.6.16/libpng-1.6.16.tar.xz
https://downloads.sourceforge.net/project/libpng/libpng16/older-releases/1.6.16/libpng-1.6.16.tar.xz

5. libtiff
cocos2d-x-3rd-party-libs-src-3\contrib\src\tiff\
http://download.osgeo.org/libtiff/old/tiff-4.0.3.tar.gz


6. libwebp
cocos2d-x-3rd-party-libs-src-3\contrib\src\webp\
http://downloads.webmproject.org/releases/webp/libwebp-0.5.0.tar.gz   2015-12-23
发现0.5.1的版本 有x64和x32

所有版本：http://downloads.webmproject.org/releases/webp/
libwebp-1.4.0-windows-x64.zip    2024-04-13
libwebp-1.4.0.tar.gz             2024-04-13
最新版本只有x64


7. OGLES
没找到库源码 根据头文件glew.h glxew.h wglew.h猜测都是glew的库
glew.h 是用于 Linux 和 macOS 的头文件，而 glxew.h 是用于 X Window 系统的 OpenGL 扩展，wglew.h 是用于 Windows 平台的
https://glew.sourceforge.net/
根据之前的头文件 发现是2008年的版本 对应GLEW 1.5.1 年份对上了 除了mingw32外新增了cygwin的支持
最新2.1.0 2017.7.31  看来废弃很久了 但支持x64



8. pthread
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


9. zlib
cocos2d-x-3rd-party-libs-src-3\contrib\src\zlib\
http://zlib.net/fossils/zlib-1.2.8.tar.gz  2013-04-28
所有版本：http://zlib.net/fossils/
zlib-1.3.1.tar.gz	2024-01-22
都是源码 需要自己编译














