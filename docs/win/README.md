# 🔙[win](/README?id=🔸Win日常)

## win软件
- 雷蛇(Razer) 炼狱蝰蛇标准版有线鼠标
[驱动](https://cn.razerzone.com) 支持：电脑：鼠标：雷蛇蝰蛇标准版 有黑白两种颜色  
开始了解：为鼠标按键分配宏：雷云3: 只有说明介绍 哪里下载软件？ 且没有mac版本



1. q-dir
- 双击空白 返回上一页 ； 选项：列表视图：双击空白处
- 关闭自带的zip 有些大的文件 速度比winrar慢很多
  - 选项：更多选项：关联：添加：选择winrar.exe
  - 修改对应的ext文件：*.rar;*.zip=C:\Program Files\WinRAR\WinRAR.exe
  - 注意：一定要点保存  直接点确定是没用的


2. Listary 类似everything

3. shexview 查看shell扩展 右键菜单
https://www.nirsoft.net/ 还有很多软件：进程查看 网络等


4. understand
[破解](https://blog.csdn.net/weixin_48220838/article/details/131297065)
[官方下载](https://licensing.scitools.com/download)
[exe修改器](https://mh-nexus.de/en/downloads.php?product=HxD20)
  a. 用官方exe安装
  b. 复制bin/understand.exe到外部
  c. 用HxD打开exe
    ctrl-f 搜索 areYouThere 用IamNotHere!代替  直接Ctrl-v即可，前面的搜索会选中这块内容
    回到顶部，以字节序列模式搜索"45 33 FF 41 0F B6 C6 48 3B DF 44 0F 4E F8"，替换为
    "41 BF 01 00 00 00 90 90 90 90 90 90 90 90"
    Ctrl+S保存退出 将exe覆盖回去




## win技巧

1. 任务管理器中判断exe是32位还是64位
```
  方法一: 任务管理器法
  任务管理器>>>进程(processes)>>
  进程后带有*32的是32位程序

  方法二: 简化颜色模式法   可行！！
  右键exe>>>属性>>>兼容性
  若Settings框中的降低色彩和分辨率的选项可勾选>>>32位程序
  若Settings框中的降低色彩和分辨率的选项不可勾选>>>64位程序
```


2. win+c 打开cortana  禁用之
```
  powershell 管理员打开	
  Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage
```



3. powershell 运行部分命令权限问题
```
	此系统上禁止运行脚本  about_Execution_Policies。
	get-ExecutionPolicy  (查询当前策略设置)
	set-ExecutionPolicy RemoteSigned (修改策略以执行prowershell脚本)
```


4. winget

- 软件安装使用的winget，如果没有建议安装，因为部分命令行工具安装依赖这个包管理器。
- [winget](https://github.com/microsoft/winget-cli/releases)
```
	- 安装后命令行中还是不能用 手动添加路径：
	C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.24.1551.0_x64__8wekyb3d8bbwe
  删除路径中的：
  %USERPROFILE%\AppData\Local\Microsoft\WindowsApps

	注意：不是appstore的路径 这里的exe大小为0 而且还有python python3
	C:\Users\admin\AppData\Local\Microsoft\WindowsApps 奇怪的是这里的exe为0k 但是能用
```

5. 删除文件夹
```
powershell:
  rd /s /q .
bash:
  rm -rf *
```







## win11相关设置
1. win11右键菜单
```
  切换到旧版右键菜单：
  reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

  恢复回Win11右键菜单：
  reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f

  重启Windows资源管理器生效：
  taskkill /f /im explorer.exe & start explorer.exe
```










