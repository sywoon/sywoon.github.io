# 🔙[win](/README?id=🔸Win日常)


## win系统
https://next.itellyou.cn/  下载原版iso  用迅雷-不限速  百度云不支持了  用qq登录即可
https://www.sordum.org/  下载暂停更新 暂停defender等系统软件  免费


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

5. setuna3.x 截图软件
win11清晰度问题：选项：杂项设置：勾选 鼠标是否可穿透截图透明部分




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

6. ps图片背景透明
用ps顶部的选择--主体--ctr+j，最新图层就是透明的

7. 一键获得文件夹的所有者
管理员运行cmd
```
  如果重装了系统 git文件夹拉取时 会提示权限问题 需要配置文件夹权限
  git config --global --add safe.director 'f:/xxxxx'
  takeown /f path /r 可一键获得
  在某个盘符下执行
```
添加everyone用户权限
cacls 文件或目录名 /p everyone:f /e
包含子目录
cacls 目录名 /p everyone:f /t



## win11相关设置
1. win11右键菜单
```
  切换到旧版右键菜单：
  reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

  恢复回Win11右键菜单：
  reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
  or
  reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /va /f

  重启Windows资源管理器生效：
  taskkill /f /im explorer.exe & start explorer.exe
```

2. 右键菜单txt没了
win ： 所有应用： 找到notepad ： 右键应用设置
点击重置中的修复按钮  ： 重启explorer

2. win11 安装需要启用TPM 2.0
https://support.microsoft.com/zh-cn/windows/%E5%9C%A8%E7%94%B5%E8%84%91%E4%B8%8A%E5%90%AF%E7%94%A8-tpm-2-0-1fd5a332-360d-4f46-a1e7-ae6b0c90645c#bkmk_enable_tpm
UEFI BIOS 中标有 “高级”、“ 安全性”或“ 受信任的计算”的子菜单中。 启用 TPM 的选项可能标记为“安全设备”、“安全设备支持”、“TPM 状态”、“AMD fTPM 交换机”、“AMD PSP fTPM”、“Intel PTT” 或“Intel 平台信任技术”。


- 华硕主板
　　1、首先重启电脑，在开机时连续敲击键盘“del”进入bios设置。
　　2、点击“Advanced Mode”或者按“F7”找到“Advanced”选项。
　　3、在其中选择“AMD fTPM configuration”
　　4、找到下方的把“Selects TPM device”将它设置为“Enable Firmware TPM”
　　5、在弹出窗口选择“OK”，再按下键盘“F10”进行保存即可。


3. VMware虚拟机安装windows 11(win11) 跳过TPM2.0检查等
https://winsec.cn/archives/VMwarewindows11win11TPM20
```
  shift+f10 调出cmd
  regedit 打开注册表编辑器
  在 HKEY_LOCAL_MACHINE\SYSTEM\Setup 下添加一项 名称为“labconfig”
  在labconfig项下依次添加三个DWORD，值均为1 如图所示。
  4.1. bypasstpmcheck
  4.2. bypassramcheck
  4.3. bypasssecurebootcheck
```



### scoop
类似mac的brew
- 安装
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
- 使用
```
# 添加extras存储桶
scoop bucket add extras

# 安装lazygit
scoop install lazygit
```



