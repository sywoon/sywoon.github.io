

# 环境搭建
## c的编译
gcc(gnv compiler collection) gnu开发的免费编译器
支持：c c++ object-c fortran java ada go
包含常用库：libstdc++ libgcj
最初是为gnu操作系统写的


## mac环境
通过xcode的command line tools 内部自带了gcc
or
手动安装gcc环境 下载gcc-bin包 解压后配置环境
```
  gunzip gcc-4.8-bin.tar.gz
  sudo tar -xvf gc-4.8-bin.tarr
  touch ~/.bash_profile
    export PATH='/User/s/Gcc/usr/local/bin:$PATH"
  source ~/.bash_profile
  echo $PATH
  通过gcc -v来验证
```
or
brew install gcc


## vs中调试c/c++
[参考1](https://cloud.tencent.com/developer/article/2282951)
[参考2](https://blog.csdn.net/weixin_45277161/article/details/122300658)
- 需要的插件：
    - c/c++  c/c++ extension pack
    - CodeLLDB 调试c/c++用

1. 新建一个cpp文件 用vs打开
2. 菜单：terminal：configure default build task:c/c++ clang++
   会在cpp所在文件夹创建一个.vscode文件夹和tasks.json文件
   在args中新增"-std=c++17",
3. cmd+shift+p 调出c/c++编辑配置json 会生成一个c_cpp_properties.json文件
    修改内容：
    "compilerPath": "/usr/bin/clang++",
    "cppStandard": "c++17", 
4. 菜单：terminal：run build task 得到可执行文件
5. 菜单：run:add configuration...:c++(gdb/lldb)-clang++
   生成一个launch.json文件  
   将"type": "cppdbg",修改为"type": "lldb",
6. 回到cpp文件 添加断点 菜单：run：start debugging



## vs中调试c/c++ 或其他脚本
1. mac里安装brew
```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. vs插件安装 c/c++
3. 插件安装 code runner




