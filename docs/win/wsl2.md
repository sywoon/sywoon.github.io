

# wsl2
[参考1](https://segmentfault.com/a/1190000022865557)
[参考2](https://learn.microsoft.com/zh-cn/windows/wsl/install)


## 安装
1. 设置开启
```
powershell:
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# 启用 wsl
  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# 启用虚拟机
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# 设置 wsl 默认版本
  wsl --set-default-version 2
```
重启  顺便bios里 开启cpu vt 虚拟化技术

2. 启动或关闭windows功能
```
设置 =》应用和功能：右边的 程序和功能 =》 启用或关闭windows功能
（其实就是卸载程序窗口）
勾选 适用于linux的windows子系统
```

3. windows商店 搜索ubuntu
```
选择ubuntu 20.04.5 LTS
下载安装 第一次运行wsl 会初始化
设置用户 密码
syw 123
```

## 文件夹路径映射：
```
\\wsl$ 可以看到子系统映射的目录
但是命令行中用的地址 或文件夹的地址 没有$符号：
\\wsl.localhost\Ubuntu-24.04\home\syw\.config\nvim
```
- windows中添加文件夹入口
```
我的电脑 : 
添加一个网络位置
or
菜单：计算机：添加一个网络位置  映射到z盘
可以看到区的大小
```

### 跨文件系统的文件存储和性能
[官方文档](https://learn.microsoft.com/zh-cn/windows/wsl/filesystems#file-storage-and-performance-across-file-systems)
为了避免性能问题 不同环境推荐不同的用法：
```
  最快的性能速度 前提是在 Linux 命令行(Ubuntu)中使用
  如果使用 Windows 命令行（PowerShell、命令提示符）工作，请将文件存储在 Windows 文件系统

  使用 Linux 文件系统根目录：\\wsl$\Ubuntu\home\<user name>\Project
  而不使用 Windows 文件系统根目录：/mnt/c/Users/<user name>/Project$ 或 C:\Users\<user name>\Project
```



## 重置ubuntu启动默认账号为root而非安装时创建的账号syw(非必要)
```
C:\Users\S\AppData\Local\Microsoft\WindowsApps\ubuntu2004.exe config --default-user root
只要执行一次即可 后续控制台中运行wsl 默认就是root   
等环境安装完毕后 可改回syw账号
```

## 卸载升级重新安装wsl2版本：
- 卸载旧版本：
```
wslconfig /l
wslconfig /u Ubuntu-20.04
wsl --set-default-version 2   升级默认
但是商店里看到的还是处于安装状态
windows菜单 找到ubuntu20.04lts 右键 卸载
需要重启电脑 install状态 变成 owned
```

- 重新安装
```
wsl --list --online
wsl --install -d ubuntu-20.04
安装后 启动报错：
Error: 0x800701bc WSL 2 ?????????????????? https://aka.ms/wsl2kernel
```
[参考1](https://blog.csdn.net/qq_18625805/article/details/109732122)
[参考2](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
下载wsl_update_x64.msi  适用于 x64 计算机的最新 WSL2 Linux 内核更新包
安装后 商店界面  再次点击启动
成功！
wsl -l -v 



## 启动
```
可以从windows菜单启动 or 商店 or 命令行wsl  
实际位置：  
C:\Program Files\WindowsApps\CanonicalGroupLimited.Ubuntu20.04LTS_2004.5.11.0_x64__79rhkp1fndgsc\ubuntu2004.exe  

wsl中访问windows路径：  
cd /mnt  
```


## vscode wsl插件：微软官方的
```
f1 输入wsl ： 开启新wsl窗口   第一次会下载ubuntu环境   
新的vsc窗口  左下角多了一个 wsl:ubuntu-20.04标记   点击打开f1菜单
vscode左边 多出一个远程控制管理器  默认包含了已经安装的 ubuntu20.04
右键 connect to wsl   会打开一个新的vsc窗口
菜单：终端：新建终端
默认以自己的账号登录  非root
```


## lazygit
```
sudo add-apt-repository ppa:lazygit-team/release
sudo apt-get update
sudo apt-get install lazygit
```


## 安装nodejs
[参考](https://learn.microsoft.com/zh-tw/windows/dev-environment/javascript/nodejs-on-wsl)
```
sudo apt update && sudo apt upgrade
sudo apt-get install curl
curl -V

安装nvm 管理nodejs版本
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm ls 查看已安装版本
nvm install --lts安装稳定版
or
nvim install node 安装最新版
node --version
```
- nvm安装失败
```
1 wsl中安装进度无反应：windows中开启open vpn代理
2. 报错
export NVM_DIR="$HOME/.nvm"
会自动到.zshrc末尾添加
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
重启terminal  需要关闭整个 纯粹退出wsl还不够 
```
nvm --version
安装目录：/home/syw/.nvm/versions/node/v20.15.1/bin/node



## 问题汇总

1. win10商店打不开
```
问题1：code 0x80131500
方法1：
控制面板 ： 网络和internet ：internet选项 ：高级
勾选  使用TLS1.1 1.2
刷新商店
方法2：
系统设置
应用和功能 找商店app
Microsoft Store 点击重置
```

2. WslRegisterDistribution failed with error: 0x8007019e
```
原因：未安装Windows子系统支持。
解决办法：
管理员打开power shell：
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
输入Y重启系统
```


3.  WSL忘记密码: 修改密码 (PowerShell, 管理员权限)
```
# 设置默认登录用户为root, 重新登录系统修改用户密码
ubuntu1804.exe config --default-user root
passwd username

# 修改完毕, 在修改系统默认登录用户
ubuntu1804.exe config --default-user username
```








