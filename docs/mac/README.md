# mac

## mac软件
- [osx](osx.cx) 终身vip会员 parallel这里下载 
- [macwk](https://macwk.cn/) 下载无需注册 有各种破解版软件 synergy这里下载的
- [maczz](https://maczz.net) 类似macwk beyondcompare从这里下载的
- 软件先锋 需要钱购买
	- [macv-mac版本软件](https://www.macv.com/) 
	- [macxf-pc版软件](https://macxf.com/ )
- [macwk](https://macwk.cn/app/377.html) 

- synergy  鼠标键盘共享
	- [win](https://soft.macxf.com/soft/2615.html)
	- [mac](https://www.macv.com/mac/2150.html)
	- [macwk win+mac 有注册码](https://macwk.cn/app/377.html)
		- 使用了1.14.5.13版本 win和mac都有
		- 按照文档说明 这是企业版 无需输入注册码


- mac远程控制windows电脑
	- [Microsoft Remote Desktop for mac](https://install.appcenter.ms/orgs/rdmacios-k2vy/apps/microsoft-remote-desktop-for-mac/distribution_groups/all-users-of-microsoft-remote-desktop-for-mac)



 ## mac技巧
 ### 锁定屏幕
 －ctrl+cmd+q 或　左上mac图标：锁定屏幕

 ### 和windows共享文件夹
 - mac系统设置
	- 通用：共享：打开 文件共享
 	- 点击文件共享开关后面的“i”按钮
 	- 点击左下的选项：勾选windows文件共享下面的账户 
 	- 若没内容可能需要win上远程登录一下 \\192.168.64.170 但是会提示用户名和密码错误

 ### mac mini关闭睡眠
 - 系统设置 : 锁定屏幕：
	 - 不活跃时关闭显示器　选择永不
	 - 不活跃时启动屏幕保护程序　永不

 
### windows远程控制mac
1 向日葵 
优点：清晰 速度快  系统之间可以共享粘贴板
缺点：经常断开  错误码：57351
经过测试：发现用mac远程windows反而挺好用的 再单独搞个桌面 ctrl+<-来切换
也会卡死  频率没那么高就是了  原因：在控制的win内 鼠标移动到另一个屏幕的win-估计和synergy冲突了
临时方案：最后发现没必要 synergy本身已经支持共享 注意快捷键的不同
	- mac连接win
	- synergy同时操作双屏的win(切换器-物理解决鼠标和键盘+synergy-软件解决)


2 vnc viewer
- 共享:远程登录：打开 
	可通过ssh s-mac@192.168.64.170登录这台电脑
- 共享：远程管理：打开
	打开vnc 并设置密码



## xcode技巧

1. 打开某个文件
cmd + shift + o

2. 前进和后退
ctrl+cmd+方向键

3. 剪切文件
cmd+c 先复制  
右键目标文件夹空白处 按住option 会出现移动到这

4. 查看系统信息 
- 比如预置udid-用于xcode在mac中运行ios程序 类似模拟器
- 点击左上苹果图标 ： 按住option 关于本机 会变成 系统信息











 