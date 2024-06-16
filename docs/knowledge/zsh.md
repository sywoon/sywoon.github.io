



### Zsh
[参考](https://juejin.cn/post/7229507721795993661)
[参考2](https://www.haoyep.com/posts/zsh-config-oh-my-zsh/)

- 下载 Zsh https://packages.msys2.org  
  [zsh-5.9-2-x86_64.pkg.tar](https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64)
  
  - 注意：pkg.tar需要使用[7z22.01-zstd](https://github.com/mcmilk/7-Zip-zstd/releases)
  - 右键菜单 7z提取文件：得到pkg  再提取一次即可！
- 覆盖入 Git 安装路径(是里面的内容复制进去 不是zsh文件夹)，重启 git bash 输入 zsh 命令查看是否安装  ; 输入0 得到~/.zshrc

- 或者 手动创建$Home目录下 .bashrc键入(-l方式启动需要)已下内容：
  - ```shell
    if [ -t 1 ]; then
    	exec zsh
    fi
    ```
    这样输入bash时 自动跳转启动zsh

  - **echo $HOME 查看家目录**


### oy my zsh
用于管理Zsh配置 它捆绑了数千个有用的功能、助手、插件、主题
- 手动安装 oh-my-zsh（已随文件附带，并且附带插件），将 .oh-my-zsh和.zshrc放置Home目录
- gitbash自动安装：sh -c "$(curl -fsSL https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"


#### omzsh插件
- zsh-autosuggestions
在你历史指令中找到与你当前输入指令匹配的记录
```
    cd ~/.oh-my-zsh/custom/plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

- z自带插件 配置即可 类似mac的autojump跳转插件 用于跳打开过的目录

- zsh-syntax-highlighting 命令高亮
```
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- zshrc 文件中 plugins 变量改为：
    vim ~/.zshrc
    source ~/.zshrc
  - ```shell
    # 启用补全功能
    autoload -Uz compinit && compinit
    # 设置大小写不敏感的补全匹配规则
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    # 禁用 Homebrew 安装后的自动清理
    #export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
    # 设置 grep 输出颜色高亮
    alias grep="grep --color=auto"

    alias lg='lazygit';

    if type nvim > /dev/null 2>&1; then
        alias vi='nvim'
    fi

    plugins=(
    	git
    	zsh-autosuggestions
    	zsh-syntax-highlighting
    	z
    )

    # 用setCip命令 将内容写入粘贴板 mac系统
    setClip() { osascript -e 'set the clipboard to "'"${*}"'" as text'; }
    ```

- 插件bug：启动zsh会显示~ ←[?1h←[?1h 而且输入任何字符都会一直出现
- 解决：使用tag版本zsh-autosuggestions-0.6.4.zip [github](https://github.com/zsh-users/zsh-autosuggestions/tree/master)  替换：C:\Users\admin\.oh-my-zsh\custom\plugins\zsh-autosuggestions   --没用
- 修改主题：通过设置为random 找到部分正常主题：steeef  kolo jnrowe 
- 添加新主题：没有乱码！！！
```
	git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	ZSH_THEME="powerlevel10k/powerlevel10k"
	第一次启动会有很多配置选择 更加自己喜欢的即可
	后续修改：.p10k.zsh
    重新设置：p10k configure
```














