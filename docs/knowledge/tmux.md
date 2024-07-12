


## git bash中安装tmux
[参考1:手动从msys中复制] (https://blog.pjsen.eu/?p=440)
Go to msys2 directory, in my case it is C:\msys64\usr\bin
Copy tmux.exe and msys-event-2-1-4.dll to your Git for Windows directory, mine is C:\Program Files\Git\usr\bin
[参考2：有人干了这事 直接用](https://github.com/hongwenjun/tmux_for_windows?tab=readme-ov-file)


### 各种bash入口
- git bash右键菜单对应的exe：
```
regedit中查找"Open Git Bash here"  --没有
根据自己扩展的右键cmd 找到具体位置：
HKEY_LOCAL_MACHINE\Software\CLASSES\Directory\shell
  git_shell
    Open Git Ba&sh here
    C:\Program Files\Git\git-bash.exe
```
- 壳同上面 但手动打开 表现不一致
```
C:\Program Files\Git\usr\bin\mintty.exe  是一个mingw64  可正常跑tmux
这个exe若手动打开 有个界面可以选择类型：msys2 wingw32 mingw64
```

- 手动在powershell中配置的git bash 或安装时勾选加入powershell
C:/Program Files/Git/bin/bash.exe -i -l  

**除了右键中打开的bash 其他几个都不能运行tmux**
```
提示bash: tmux: command not found
```


- msys先安装
```
  更新msys2
  pacman -Syu
  安装：
  pacman -S tmux
  验证：
  tmux -V  必须要显示版本号才算成功
```


- 第一次复制后 有文件 但不能运行；按照chatgpt提示
```
  查看安装包：
  pacman -Qs tmux
  查看依赖项：
  ldd /usr/bin/tmux
  更新依赖项：
  pacman -S ncurses
  pacman -S libevent

  在msys中正常了 复制到git bash：
  tmux.exe
  msys-ncurses*.dll 2个
  msys-event_*.dll 5个
```


## tmux的配置
.tmux.conf
```
#unbind C-b
# 设置自定义前缀
#set -g prefix C-a

# 采用vim的操作方式
#setw -g mode-keys vi
# 窗口序号从1开始计数
set -g base-index 1

# tmux 启用鼠标操作
setw -g mouse
set-option -g history-limit 20000
set-option -g mouse on
bind -n WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -n WheelDownPane select-pane -t= \; send-keys -M
```


## tmux 常规操作
c-b c 创建新窗口
c-b p/n 上/下一个窗口
c-b % 左右分面板
c-b o 切换面板
c-b x 关闭面板



## 问题记录

### git bash中tmux的回退键无效
echo $TERM
```
  vi ~/.bash_profile
  #解决问题
  #export TERM=cygwin   --不能这么用 会影响nvim  升级windows for git后问题修复 这里直接注释了

  #加载其他配置
  test -f ~/.profile && . ~/.profile
  test -f ~/.bashrc && . ~/.bashrc

  .tmux.conf  实际没用 但也能设置
  # 尝试修复git bash不支持tmux 
  #set-option -g default-terminal "cygwin" 
```


### open terminal failed: not a terminal
在powershell中集成的git bash运行tmux报错
C:/Program Files/Git/bin/bash.exe -i -l  
好像是tmux需要一个终端壳 但是pwoershell中的bash给不了
但是独立的git-bash-实际环境是mingw64 可运行tmux
---
暂时无解


### vim和nvim冲突  
bash/zsh中打开vim9后 再打开nvim会导致显示错乱 
解决：
1. 修改.bash_profile  注释：export TERM=cygwin  测试确定是这个引起的 当初为了解决tmux回退键失效bug
或修改为 export TERM=xterm-256color
2. 删除~下的缓存文件 .cache .vim-fuf-data _viminfo .bash_history .viminfo .z .zsh_history
估计是某个引起的
3. 若不行 再删除%temp%目录




