# 🔙[mac](/README?id=🔸Mac日常)


## mac编程环境

### mac环境系统设置
[参考1](https://imageslr.com/2020/03/19/mac-initialization.html)
- 1. 关闭安装验证
```
  跳过打开 DMG 文件时的验证过程：
	defaults write com.apple.frameworks.diskimages skip-verify -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  取消禁止安装第三方 App
	sudo spctl --master-disable
	defaults write com.apple.LaunchServices LSQuarantine -bool false
```
- 2. 禁用文字自动更正: 也可以在“系统设置-键盘-文本”中设置
```
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
```
- 3. 关闭触控板在浏览器中的前进后退
	系统设置 - 触控板 - 更多手势 - 在页面之间轻扫，取消勾选。






### brew
1. 安装	选择3北京外国语大学的点
   ```
	/bin/zsh -c "$(curl -fsSL https://gitee.com/huwei1024/HomebrewCN/raw/master/Homebrew.sh)"   #安装  选择清华点

	bin/zsh -c "$(curl -fsSL https://gitee.com/huwei1024/HomebrewCN/raw/master/HomebrewUninstall.sh)"  #卸载
   ```
2. 中途会弹出安装xcode commmand tools  实际直接先安装xcode也更好-需要启动一次，同意协议
3. 修改环境路径
	```
	open -e .zshrc  没找到这个文件 和.bash_profile的关系？
	mac新版本默认用的zsh终端 对应的配置就是.zshrc  早期的mac用的bash
	# HomeBrew
	export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
	export PATH="/usr/local/bin:$PATH"
	export PATH="/usr/local/sbin:$PATH"
	# HomeBrew END
	这是早期的路径 新的m1下的路径为：
	export PATH="/opt/homebrew/bin:$PATH"  
	export PATH="/opt/homebrew/sbin:$PATH"
	```


### 2. oh my zsh
- 安装
```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
- 修改主题
```
	open ~/.zshrc

	# 找到 ZSH_THEME
	# robbyrussell 是默认的主题
	ZSH_THEME="robbyrussell"

	# ZSH_THEME="样式名称" 

	内部自带的主题：cd ~/.oh-my-zsh/themes && ls
	卸载：uninstall_oh_my_zsh
	安装后默认代替系统的zsh 若不行 手动执行：
	sudo chsh -s $(which zsh) $(whoami)
```
- 安装插件
```
  安装 zsh-autosuggestion 与 autojump：提示输入的命令-使用往右箭头 + 用j+单词挑转到之前的位置
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

	# autojump
	git clone https://github.com/wting/autojump.git
	cd autojump
	./install.py

	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
	输入命令后，如果命令正确，则高亮为绿色，反之高亮为红色。
```
- 插件配置
```
	vim ~/.zshrc
	找到pugins位置 替换：
	# Add wisely, as too many plugins slow down shell startup.
	plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting)

	[[ -s /home/zsh/.autojump/etc/profile.d/autojump.sh ]] && source /home/zsh/.autojump/etc/profile.d/autojump.sh
	autoload -U compinit && compinit -u

	source $ZSH/oh-my-zsh.sh
```
- 生效和验证
```
	source ~/.zshrc
	输入命令时 会自动提示补全
	打开过的目录 用j+前缀 不用敲全 也可以挑转到目录
```
- 同步
```
    .zshrc头部加上：
	source ~/.bash_profile
	source /etc/profile
```


### 3. git
- 全局名称
```
git config --global user.email "sywoon@163.com"
git config --global user.name "sywoon"
```
- git别名
```
~/.gitconfig
[alias]
	last = log -1
	lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow) %d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
	co = checkout
	ci = commit
	st = status
	br = branch
	cp = cherry-pick
```


## 一、mac软件下载
- [osx](osx.cx) 终身vip会员 parallel这里下载 
  - shenglingdao   90….
  - 解压密码  osx.cx
- [macwk](https://macwk.cn/) 下载无需注册 有各种破解版软件 synergy这里下载的
- [maczz](https://maczz.net) 类似macwk beyondcompare从这里下载的
- 软件先锋 需要钱购买
	- [macv-mac版本软件](https://www.macv.com/) 
	- [macxf-pc版软件](https://macxf.com/ )
- [macwk](https://macwk.cn/app/377.html) 
- [maczj](https://maczj.com)

- synergy  鼠标键盘共享
	- [win](https://soft.macxf.com/soft/2615.html)
	- [mac](https://www.macv.com/mac/2150.html)
	- [macwk win+mac 有注册码](https://macwk.cn/app/377.html)
		- 使用了1.14.5.13版本 win和mac都有
		- 按照文档说明 这是企业版 无需输入注册码


- mac远程控制windows电脑
	- [Microsoft Remote Desktop for mac](https://install.appcenter.ms/orgs/rdmacios-k2vy/apps/microsoft-remote-desktop-for-mac/distribution_groups/all-users-of-microsoft-remote-desktop-for-mac)

- [win10 iso](https://www.microsoft.com/zh-cn/software-download/windows10ISO)
没看到arm版本的

- [win10 arm](https://sysin.org/blog/windows-10-arm/)

- [xcode 13.2](https://sysin.org/blog/apple-xcode-13/)





----------------------------
## 二、mac中好用的软件 
大部分来之osx.cx


### 1. 系统软件
  
#### 1.1 文件夹管理器
- QSpace_Pro_4.3.2_osx.cx   最优
  - 类似windir 但是分页是整个页面 不是单独的区域 适合稳定的开发目录
  - 有剪切-可cmd+x +v 第一次会显示浅色 类似windows 
  - 可添加文件夹书签
  - 右键新建txt文件
  - cmd+del删除文件
  - 区分删除和移动到垃圾桶
  - 显示：显示所有标签页栏 可扩展标签页 cmd+shift+\ 显示所有页
  - 自定义设置：
    - 属性：使用习惯：勾选 双击空白 前往上一层
    - 显示: 自定义工具栏：将拷贝路径、显示隐藏文件 拖入顶部的工具栏区域
    - 属性：快捷启动：新增vscode
  - 缺点：
    - 新标签页 是是整个方式 而非每个独立的小窗口  不像win的q-dir 按单独窗口添加多标签

- Commander_One_PRO_3.8_osx.cx 文件管理  
	- 功能更强大 适合拖来拖去
	- 没有右键剪切

- Path Finder For Mac 	功能强大的文件管理工具 类mac原生的finder --不好用
  - 非常奇怪的剪切功能  cmd+x 会让文件先消失 万一操作别的去了 文件不就没了
  - 右键没有删除功能
  



#### 1.2 虚拟机
- CrossOver_24.0.1_osx.cx mac上运行windows软件
	-  只能安装现有列出的软件  几乎都是游戏类的  没几种 其他软件怎么安装？

#### 1.3 截图软件
- Snagit_2023.2.0_osx.cx  屏幕截图和录制  功能比较复杂  通过顶部菜单比较好用
  - 启动后在顶部菜单栏 用起来比较方便 且支持超长截图  
  - 设置快捷键ctrl+cmd+1 截图
- Shottr_1.7.2_osx.cx 截图软件 小巧  快捷键不会用 也设置不了ctlr+cmd+1 提示冲突


#### 1.4 硬件增强或扩展
- Smooze_Pro_2.0.72_osx.cx  鼠标增强 表现方式  
  - 鼠标滚轮好像变快了 原来雷电鼠滚轮bug好像好了
  - 确实解决了鼠标滚轮bug 可以调低 滚轮加速 滚轮单步距离
- Synergy Pro-macwk.cn  键盘和鼠标共享


#### 1.5 其他
- OmniPlayer PRO 2.0.16 MAS [HCiSO]  视频播放
  
- Bandzip > BetterZip  压缩软件

- Sensei For Mac 1.5.9 系统清理软件 更简洁
- CleanMyMac_X_4.15.1_osx.cx 系统清理软件




### 2. 开发软件
- MWeb md写作软件 -非必需  可以用 vscode



#### 2.1 git软件
	- Sublime_Merge_2_2087_osx.cx  已经损坏 无法安装
	- Tower_PRO_9_2-osx.cx  运行注册机 点击写入 重启app
	- GitKraken 9.8.1
	




 ## 三、mac技巧
 ### 1. 锁定屏幕
 －ctrl+cmd+q 或　左上mac图标：锁定屏幕

 ### 2. 和windows共享文件夹
 - mac系统设置
	- 通用：共享：打开 文件共享
 	- 点击文件共享开关后面的“i”按钮
 	- 点击左下的选项：勾选windows文件共享下面的账户 
 	- 若没内容可能需要win上远程登录一下 \\192.168.64.170 但是会提示用户名和密码错误

 ### 3. mac mini关闭睡眠
 - 系统设置 : 锁定屏幕：
	 - 不活跃时关闭显示器　选择永不
	 - 不活跃时启动屏幕保护程序　永不

 
### 4. windows远程控制mac
1. 向日葵 
优点：清晰 速度快  系统之间可以共享粘贴板
缺点：经常断开  错误码：57351
经过测试：发现用mac远程windows反而挺好用的 再单独搞个桌面 ctrl+<-来切换
也会卡死  频率没那么高就是了  原因：在控制的win内 鼠标移动到另一个屏幕的win-估计和synergy冲突了
临时方案：最后发现没必要 synergy本身已经支持共享 注意快捷键的不同
	- mac连接win
	- synergy同时操作双屏的win(切换器-物理解决鼠标和键盘+synergy-软件解决)

2. vnc viewer
- 共享:远程登录：打开 
	可通过ssh s-mac@192.168.64.170登录这台电脑
- 共享：远程管理：打开
	打开vnc 并设置密码


### 5.禁用mac的.DS_Store
```
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
	killall Finder
	恢复：
	defaults delete com.apple.desktopservices DSDontWriteNetworkStores
	删除当前目录：
	find . -name '.DS_Store' -type f -delete
	删除所有：
	sudo find / -name ".DS_Store" -depth -exec rm {} \;
```




## 四、xcode技巧

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


5. 每次编译运行都会弹出一个密钥确认框
- 钥匙串访问 ： 左边选择“系统” ：右边选择证书： 可以看到之前为了开发xcode项目安装的p12
    双击 勾选永久允许







 