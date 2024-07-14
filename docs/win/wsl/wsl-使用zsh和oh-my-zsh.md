

# wsl中使用zsh和oh-my-zsh


## 安装
- 升级软件源
```
sudo apt-get update
sudo apt-get upgrade
```
- 安装zsh 
**设置为默认shell**
```
sudo apt-get install zsh
sudo usermod -s /bin/zsh $(whoami)  # or sudo usermod -s $(which zsh) $(whoami)
```
- oh-my-zsh自动化安装脚本下载及安装
```
# 方法一
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# 方法二: 手动复制/粘贴此脚本到本地, 执行安装
https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/install.sh
bash ./install.sh

# 方法三:
sh -c "$(curl -fsSL https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)" 
这是国内的镜像点 可无需代理安装
```
安装成功后会自动备份 所以若在安装前 启动过一次zsh 会让手动选择配置zshrc 这里也会被替换掉
Found /home/syw/.zshrc. Backing up to /home/syw/.zshrc.pre-oh-my-zsh


## 安装插件
```
# 智能提示
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 语法高亮插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git z插件默认就有 无需下载
```
- 修改配置.zshrc
```
alias grep="grep --color=auto"
if type nvim > /dev/null 2>&1; then
	alias vi='nvim'
	alias vim='nvim'
fi

# 启动错误命令自动更正
ENABLE_CORRECTION="true"

# 开启大小写敏感
CASE_SENSITIVE="true"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
)

# 和系统粘贴板互通 
setClip() { osascript -e 'set the clipboard to "'"${*}"'" as text'; }

# 最后一栏,增加如下两行, 不显示用户@主机信息
# redefine prompt_context for hiding user@hostname
prompt_context () { }
```

- 配置生效
source ~/.zshrc


## powerlevel10k 主题
```
  wsl:
	git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
  powershell:
    git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

	ZSH_THEME="powerlevel10k/powerlevel10k"
	第一次启动会有很多配置选择 更加自己喜欢的即可
    会备份和修改一次.zshrc
	后续修改：.p10k.zsh
```