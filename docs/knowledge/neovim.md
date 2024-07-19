


# neovim
[neovim](https://neovim.io/)
[nerdfonts](https://www.nerdfonts.com/font-downloads)
[nerd字库图标](https://www.nerdfonts.com/cheat-sheet)
[所有颜色插件](https://github.com/topics/neovim-colorscheme)

[样板1:SimpleNvim](https://github.com/askfiy/SimpleNvim)
[参考1](https://zhuanlan.zhihu.com/p/464902429)
[参考2](https://blog.csdn.net/qq_55125921/article/details/127177442)


注意：不能和vim9混用 打开过vim后 再回到nvim 显示乱码 操作诡异
删除~/nvimlog .bash_history .txt  按时间排序可以看到 -没用 重新打开pwoershell即可


## [从零开始配置Neovim(Nvim)](/docs/knowledge/neovim/从零开始配置Neovim(Nvim).md)
## [NeoVim从平凡到非凡](/docs/knowledge/neovim/NeoVim从平凡到非凡.md)
## [Neovim配置实战:从0到1打造自己的IDE](/docs/knowledge/neovim/Neovim配置实战-从0到1打造自己的IDE.md)
## [neovim入门指南](/docs/knowledge/neovim/neovim入门指南.md)


## 安装
官方下载nvim-win64.msi C:\Program Files\Neovim\
会将nvim自动加入环境路径
git config --global core.editor "nvim"


## git bash
安装git for window 
[64-bit Git for Windows Setup](https://git-scm.com/download/win)

## git bash添加到powershell路径中
实际terminal中可以配置git bash入口
```
echo $PROFILE
C:\Users\admin\Documents\WindowsPowerShell
手动创建文件：
Microsoft.PowerShell_profile.ps1
    # 添加 Git Bash 路径到系统路径
    $gitBashPath = "C:\Program Files\Git\bin"
    if (-Not ($env:Path -split ';' | ForEach-Object {$_ -eq $gitBashPath})) {
        $env:Path += ";$gitBashPath"
    }

    # 定义一个命令以便直接运行 Git Bash
    function Start-GitBash {
        & "$gitBashPath\bash.exe" -i -l
    }

    # 可选：创建一个别名
    Set-Alias bash Start-GitBash
```

### terminal中新增git bash
  - 需要一个 cygwin 的环境，为了方便起见，这里使用 git bash
  - 安装时需要给 windows terminal 添加 git bash 启动配置，git 安装时会有自动添加的勾选，如果错过了需要新建配置，关键配置如下：
      - 命令行: C:/Program Files/Git/bin/bash.exe -i -l  
        - 启动一个新的 Bash shell 实例，并同时处于交互模式和登录模式
        - -i 执行命令并立即获得反馈  windows中 是否添加 貌似没区别 默认就是交互模式
        - -l 登录模式 Bash 会读取并执行特定的初始化文件 
        - 例如 /etc/profile、~/.bash_profile、~/.bash_login 和 ~/.profile。
      - 启动目录: %USERPROFILE%  == C:\Users\admin

  - 配置方法
    - terminal：设置：新增一个profile
    - Name: Git Bash
    - command line:C:/Program Files/Git/bin/bash.exe -i -l  
    - sharting directory: %USERPROFILE%
    - icon:C:\Program Files\Git\mingw64\share\git\git-for-windows.ico
    - 后面就可以通过新分页的创建箭头 选择git bash图标



### git bash中支持tree
1. 从Tree for Windows中下载exe [download binaries](https://gnuwin32.sourceforge.net/packages/tree.htm)
2. 解压得到bin/tree.exe 复制到 C:\Program Files\Git\usr\bin

- tmux是否也可以从这里下载？
gnuwin32中没有tmux 可以安装Cygwin或Msys2


### git bash支持zsh 和 oh-my-zsh
[参考](https://juejin.cn/post/7229507721795993661)
[参考2](https://www.haoyep.com/posts/zsh-config-oh-my-zsh/)

- 下载 Zsh（已随文件附带），https://packages.msys2.org  
  [zsh-5.9-2-x86_64.pkg.tar](https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64)
  
  - 注意：pkg.tar需要使用[7z22.01-zstd](https://github.com/mcmilk/7-Zip-zstd/releases)
  - 右键菜单 7z提取文件：得到pkg  再提取一次即可！
  - 得到usr/bin/zsh.exe
- 覆盖入 Git 安装路径(是里面的内容复制进去 不是zsh文件夹)，重启git bash输入zsh命令查看是否安装; 输入0 得到~/.zshrc  最初的默认版本

- 或者 手动创建$Home目录下 .bashrc键入(-l方式启动需要)已下内容：
  ```shell
  if [ -t 1 ]; then
    exec zsh
  fi
  ```
  这样输入bash时 自动跳转启动zsh

**echo $HOME 查看家目录**
- 手动安装 oh-my-zsh（已随文件附带，并且附带插件），将.oh-my-zsh和.zshrc放置Home目录
- 自动安装：sh -c "$(curl -fsSL https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"   这是国内的镜像点 可无需代理安装
- 国外原始地址：
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

- zshrc 文件中 plugins 变量改为：
  ```shell
    plugins=(
    	git
    	zsh-autosuggestions
    	zsh-syntax-highlighting
    	z
    )
  ```

- powerlevel10k
- 插件bug：启动zsh会显示~ ←[?1h←[?1h 而且输入任何字符都会一直出现; 
- 最新的gitbash没这个bug所以无需这么处理了
- 解决：使用tag版本zsh-autosuggestions-0.6.4.zip [github](https://github.com/zsh-users/zsh-autosuggestions/tree/master)  替换：C:\Users\admin\.oh-my-zsh\custom\plugins\zsh-autosuggestions   --没用
- 修改主题：通过设置为random 找到部分正常主题：steeef  kolo jnrowe 
- 添加新主题：没有乱码！！！
```
	git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	ZSH_THEME="powerlevel10k/powerlevel10k"
	第一次启动会有很多配置选择 更加自己喜欢的即可
	后续修改：.p10k.zsh
```


## winget

- 软件安装使用的winget，如果没有建议安装，因为部分命令行工具安装依赖这个包管理器。
- [winget](https://github.com/microsoft/winget-cli/releases)
```
	- 安装后命令行中还是不能用 手动添加路径：

	C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.24.1551.0_x64__8wekyb3d8bbwe
	注意：不是appstore的路径 这里的exe大小为0 而且还有python python3
	C:\Users\admin\AppData\Local\Microsoft\WindowsApps 奇怪的是这里的exe为0k 但是能用
```





## windows从0开始
[Neovim 配置实战：从0到1打造自己的IDE](https://blog.csdn.net/qq_55125921/article/details/127177442) 比较完整 插件废弃了
[neovim入门指南(一)：基础配置](https://www.cnblogs.com/youngxhui/p/17730419.html) 类似上面 用了lazy插件

### 安装terminal
win11默认就有 可以从商店安装；设置修改主题为one half dark；若后期快捷键和vim冲突 也可从这里修改


### 安装wsl2子系统
win11中 默认有terminal 和 wsl
1. wsl -l -o  可查看所有可安装的系统
2. wsl --install -d ubuntu-24.04  挑选某个系统安装  (重启系统)
```
  遇到的问题：
   商店里搜索ubuntu可以看到这个版本的标记是installed 但是命令行wsl启动不了
   需要从商店进一次 创建账号
   点击install 会打开控制台继续安装 输入用户名和密码syw ' '
  解决：发现之前是在gitbash中启动的wsl 而非powershell
```
3. wsl -l -v 查看安装后的系统
4. 无论从power gitbash zsh都可以用wsl打开ubuntu；再通过exit退出(实际还在运行 running状态)
```
    切换到win目录
    cd /mnt/c/Users/S
    切换到ubuntu目录
    cd ~  == /home/s
```


### Nerd Font
[download](https://www.nerdfonts.com/font-downloads)
很多种类 可以看数字、字幕符号部分 找自己喜欢的字体； 安装后在terminal中设置  
可以点preview查看所有字体的预览版本  
选择：CousineNerdFont中的CousineNerdFont-Regular.ttf 常规版本  
Mono: Monospace（等宽字体） 表现上更宽   
Proportional Spacing（比例）比例间隔版本 每个字符占用的水平空间不尽相同  

[图标查询](https://www.nerdfonts.com/cheat-sheet) 
比如输入空格 再点击show all icons 可看到所有图标 点右上角的copy icon就可以复制到命令行中



### ubuntu安装neovim
```
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
    若报错需要 安装依赖包
    sudo apt-get install software-properties-common
    验证：
    nvim --version

    安装后路径：
    window: C:\Program Files\Neovim\share\nvim\runtime
    Linux:  /usr/share/nvim/runtime
    wsl:  \\wsl.localhost\Ubuntu-24.04\usr\share\nvim\runtime
```
- 我的电脑新增一个网络链接：
  - 右键：新增一个网络位置：\\wsl.localhost\Ubuntu-24.04

- 修改nvim别名
```
  nvim ~/.bashrc
  alias vim='nvim'
  alias vi='nvim'
```


### windows安装Neovim发行版
- 使用winget搜索安装包:
  - ```powershell
    winget search neovim
    ```
  
- 安装发行版:
  - ```powershell
    winget install Neovim.Neovim
    实际下载来源：https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-win64.msi
    手动下载安装 会自动加入环境路径：C:\Program Files\Neovim\bin\nvim.exe
    ```

- 检查安装是否成功：
  - ```shell
    nvim -v
    ```


## LuaJIT
- 同样使用winget安装，本机使用的是 2.1版本； 注意window11中安装无效
```
	winget search luajit
	winget install LuaJIT
	 https://github.com/DevelopersCommunity/cmake-luajit/releases/download/v2.1.19757/LuaJIT-2.1.19757-win64.msi
	 C:\Users\admin\AppData\Local\Programs\LuaJIT\
	 手动安装 也会自动加入环境路径
	 luajit -v
	LuaJIT 2.1.1707061634 -- Copyright (C) 2005-2023 Mike Pall. https://luajit.org/
	还是基于lua5.1
```


## tmux
```
	https://github.com/trzsz/trzsz-go/releases/download/v1.1.7/trzsz_1.1.7_windows_x86_64.zip
```


## C编译器
### cmake和make  
windows中安装cmake即可
- telescope-fzf-native 需要手动编译
- nvim-treesitter 需要编译动态库使用

### clang
后续安装fzf需要
- 见 windows 常见问题，主要原因是 nvim-treesitter 使用 gcc 编译的 .so 动态库无法在 windows 上正确运行


### ripgrep
- 模糊搜索依赖，同样建议使用 winget 安装(github官网版本太多，很烦)
```
	winget install BurntSushi.ripgrep.MSVC
	https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-pc-windows-msvc.zip
	解压到某个路径 加入环境中
```


### NerdFont
- 只是为了UI显示好看需要，nvim中左边的tree图标 需要这个字体才正常显示
```
	https://www.nerdfonts.com/font-downloads
	有很多字体 选择SauceCodePro
	SauceCodeProNerdFontPropo-Regular.ttf
	手动安装后 terminal设置中 修改gitbash中的字体 重启vi
	后面换了个字体：上面的比较宽
	CousineNerdFont-Regular.ttf
```

## 安装配置
https://github.com/mendelyv/nvim

**配置（nvim）和插件（nvim-data）已随文件附带，两个文件夹均放置于 AppData/Local**
zshrc 配置nvim别名（可选）
``` shell
if type nvim > /dev/null 2>1&; then
    vi=‘nvim'
fi
```





## neovim最基本的设置
- 配置目录
```
    windows: %USERPROFILE%\AppData\Local\nvim\
    wsl: ~/.config/nvim/  == /home/s/.config/nvim/
```

- 整体结构
```
  nvim
    init.lua  主入口 加载其他模块 
    lua
      autocmds.lua
      basic.lua  基础配置 对默认配置的重置
      colorscheme.lua  主题皮肤 这里切换皮肤
      keybindings.lua  快捷键
      lsp  编程语言和语法提示
        cmp.lua 语法自动补全配置
        config  各种语言服务器单独的配置文件
          bash.lua emmet.lua html.lua json.lua
          lua.lua markdown.lua pyright.lua rust.lua ts.lua
        formatter.lua 格式化代码
        null-ls.lua
        setup.lua  内置lsp的配置
        ui.lua  内置lsp功能增量和ui美化
      plugin-config  第三方插件的配置 
        bufferline.lua comment.lua dashboard.lua gitsigns.lua
        indent-blankline.lua lualine.lua nvim-autopairs.lua
        nvim-tree.lua nvim-treesitter.lua project.lua
        surround.lua telescope.lua toggleterm.lua
        vimspector.lua which-key.lua
      plugins.lua  插件管理
      utils  常见问题修改 输入法切换 windows的特殊配置等
        fix-yank.lua
        global.lua
        im-select.lua
```

- ~/.config/nvim/lua/basic.lua
```lua
    -- vim.g.{name} 全局变量（global variables）
    -- vim.o.{name} 全局选项（global options）
    -- vim.b.{name} 缓冲区变量
    -- vim.w.{name} 窗口变量
    -- vim.bo.{option} buffer-local选项
    -- vim.wo.{option} window-local选项
    --
    -- utf8
    vim.g.encoding = "UTF-8"  -- 设置全局编码为 UTF-8
    vim.o.fileencoding = "utf-8"  -- 设置文件编码为 UTF-8

    -- jkhl 移动时光标周围保留8行
    vim.o.scrolloff = 8   -- 设置光标上下移动时保留8行
    vim.o.sidescrolloff = 8    -- 设置光标左右移动时保留8列

    -- 使用相对行号
    vim.wo.number = true  -- 启用行号
    vim.wo.relativenumber = true  -- 启用相对行号

    -- 高亮所在行
    vim.wo.cursorline = true

    -- 显示左侧图标指示列
    vim.wo.signcolumn = "yes"  -- 始终显示符号列

    -- 右侧参考线 超过表示代码太长 考虑换行
    vim.wo.colorcolumn = "80"  -- 在第80列显示垂直参考线

    -- 缩进4个空格等于一个tab
    vim.o.tabstop = 4  -- 设置 tab 字符的宽度为4
    vim.bo.tabstop = 4
    vim.o.softtabstop = 4  -- 设置软 tab 的宽度为4
    vim.o.shiftround = true  -- 缩进时将光标移动到最近的 tabstop

    -- >> << 移动长度
    vim.o.shiftwidth = 4  -- 设置自动缩进的宽度为4
    vim.bo.shiftwidth = 4

    -- 空格代替tab
    vim.o.expandtab = true
    vim.bo.expandtab = true

    -- 新行对齐当前行
    vim.o.autoindent = true  -- 自动对齐新行
    vim.bo.autoindent = true
    vim.o.smartindent = true   -- 智能对齐新行

    -- 搜索大小写不敏感 除非包含大写
    vim.o.ignorecase = true  -- 搜索时忽略大小写
    vim.o.smartcase = true  -- 搜索时如果包含大写字母则区分大小写

    -- 搜索不要高亮
    vim.o.hlsearch = false

    -- 边输入边搜索
    vim.o.incsearch = true

    -- 命令行高2 提供足够的现实空间
    vim.o.cmdheight = 2  -- 命令行高度为2行

    -- 当文件被外部程序修改时 自动加载
    vim.o.autoread = true
    vim.bo.autoread = true

    -- 禁止拆行
    vim.wo.wrap = false

    -- 光标在首位时<left><right>可以调到下一行
    vim.o.whichwrap = '<,>,[,]'

    -- 允许隐藏被修改过的buffer
    vim.o.hidden = true  -- 允许在不保存的情况下切换 buffer

    -- 鼠标支持
    vim.o.mouse = "a"  -- 启用鼠标支持

    -- 禁止创建备份文件
    vim.o.backup = false   -- 禁用备份文件
    vim.o.writebackup = false  -- 禁用写入备份文件
    vim.o.swapfile = false  -- 禁用交换文件

    -- smaller updatetime
    vim.o.updatetime = 300

    -- 设置timeoutlen 为等待键盘快捷键连击时间500毫秒 可根据需要设置
    vim.o.timeoutlen = 500

    -- split window 从下边和右边出现
    vim.o.splitbelow = true  -- 新窗口从下边出现
    vim.o.splitright = true  -- 新窗口从右边出现

    -- 自动补全不自动选中
    vim.g.completeopt = "menu,menuone,noselect,noinsert"

    -- 样式
    vim.o.background = "dark"
    vim.o.termguicolors = true  -- 启用终端的真彩色支持
    vim.opt.termguicolors = true

    -- 不可见字符的显示 这里只把空格显示为一个点
    vim.o.list = true  -- 启用不可见字符显示
    vim.o.listchars = "space:·"   -- 把空格显示为点

    -- 补齐增强
    vim.o.wildmenu = true  -- 启用命令行补全菜单

    -- Don't pass message to |ins-completin menu|
    vim.o.shortmess = vim.o.shortmess .. 'c'  -- 设置简短消息选项，避免显示过多信息

    -- 补全最多显示10行
    vim.o.pumheight = 10  -- 设置补全菜单最多显示10行

    -- 永远显示tabline
    vim.o.showtabline = 2  -- 始终显示标签栏

    -- 使用增强状态栏插件  
    -- 底部会以文本方式显示当前模式如： -- INSERT -- ， -- VISUAL --后不在需要vim的模式提示
    -- 关闭后 用插件代替
    vim.o.showmode = false

    -- 使用系统粘贴板
    vim.o.clipboard = "unnamedplus"
```

### neovim快捷键
- vim.api.nvim_set_keymap() 全局快捷键  
- vim.api.nvim_buf_set_keymap() Buffer 快捷键  
- vim.api.nvim_set_keymap('模式', '按键', '映射为', 'options')  
    * n Normal 模式
    * i Insert 模式
    * v Visual 模式
    * t Terminal 模式
    * c Command 模式
    * options 大部分会设置为 { noremap = true, silent = true }

- lua/keybindings.lua
```lua
    -- <leader> key
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "


    -- map('模式', '按键', '映射为', 'options')
    -- n Normal 模式
    -- i Insert 模式
    -- v Visual 模式
    -- t Terminal 模式
    -- c Command 模式
    local map = vim.api.nvim_set_keymap
    local opt = {noremap = true, silent = true}


    -- 窗口管理快捷键
    -- map("", "", "", opt)
    map("n", "s", "", opt)  -- 取消s的默认功能
    map("n", "sv", ":vsp<CR>", opt)  -- 分新列
    map("n", "sh", ":sp<CR>", opt)  -- 分新行
    map("n", "sc", "<C-w>c", opt)  --关闭当前
    map("n", "so", "<C-w>o", opt)  --关闭其他
    map("n", "<A-h>", "<C-w>h", opt)  --alt+hjkl切换不同窗口
    map("n", "<A-j>", "<C-w>j", opt)
    map("n", "<A-k>", "<C-w>k", opt)
    map("n", "<A-l>", "<C-w>l", opt)


    -- 左右比例控制
    map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
    map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
    map("n", "s,", ":vertical resize -20<CR>", opt)
    map("n", "s.", ":vertical resize +20<CR>", opt)
    -- 上下比例
    map("n", "sj", ":resize +10<CR>", opt)
    map("n", "sk", ":resize -10<CR>", opt)
    map("n", "<C-Down>", ":resize +2<CR>", opt)
    map("n", "<C-Up>", ":resize -2<CR>", opt)
    -- 等比例
    map("n", "s=", "<C-w>=", opt)


    -- Terminal相关
    map("n", "<leader>t", ":sp | terminal<CR>", opt)
    map("n", "<leader>vt", ":vsp | terminal<CR>", opt)
    map("t", "<Esc>", "<C-\\><C-n>", opt)
    map("t", "A-h", [[ <C-\><C-N><C-w>h ]], opt)
    map("t", "A-j", [[ <C-\><C-N><C-w>j ]], opt)
    map("t", "A-k", [[ <C-\><C-N><C-w>k ]], opt)
    map("t", "A-l", [[ <C-\><C-N><C-w>l ]], opt)


    -- visual模式下缩进代码
    map("v", "<", "<gv", opt)
    map("v", ">", ">gv", opt)
    -- 上下移动选中文本
    map("v", "J", ":move '>+1<CR>gv-gv", opt)
    map("v", "K", ":move '>-2<CR>gv-gv", opt)


    -- 上下滚动浏览
    map("n", "<C-j>", "4j", opt)
    map("n", "<C-k>", "4k", opt)
    -- ctrl+u / ctrl+d 只移动9行 默认半屏
    map("n", "<C-u>", "9k", opt)
    map("n", "<C-d>", "9j", opt)


    -- 在v模式 粘贴不要复制
    map("v", "p", '"_dP', opt)
    -- 退出
    map("n", "q", ":q<CR>", opt)
    map("n", "qq", ":q!<CR>", opt)
    map("n", "Q", ":qa!<CR>", opt)

    -- insert模式 调到行首尾
    map("i", "<C-h>", "<ESC>I", opt)
    map("i", "<C-l>", "<ESC>A", opt)
    
    map("i", "jk", "<ESC>", opt)
```

- 技巧1：gd跳转到定义 相当于vs中的f12
    - gdgv 用新分页的方式打开定义 再用gc关闭




## 配置模板


### 根据官网安装LazyVim(非插件)
[lazyvim doc](https://www.lazyvim.org)
- 安装
```
  git clone https://github.com/LazyVim/starter ~/.config/nvim
```
- 配置：默认已经有一堆的插件了 只需要启动一次nvim就会自动安装
- 默认插件安装的路径
```
  \home\s\.config\nvim\ 原始配置目录
  \home\s\.local\share\nvim\  插件安装目录
      lazy mason  
   == Windows: C:\\Users\\{username}\\AppData\\Local\\nvim-data
  \home\s\.cache\nvim\luac\  插件的lua编译文件？
```

- 启动报错1：
```
Error detected while processing BufReadPost Autocommands for "*":
Error executing lua callback: /usr/share/nvim/runtime/filetype.lua:35: Error executing lua: /usr/share/nvim/runtime/file
type.lua:36: BufReadPost Autocommands for "*"..FileType Autocommands for "*"..function <SNR>1_LoadFTPlugin[20]..script /
usr/share/nvim/runtime/ftplugin/lua.lua: Vim(runtime):E5113: Error while calling lua chunk: /usr/share/nvim/runtime/lua/
vim/treesitter/language.lua:107: no parser for 'lua' language, see :help treesitter-parsers
stack traceback:
        [C]: in function 'error'
        /usr/share/nvim/runtime/lua/vim/treesitter/language.lua:107: in function 'add'
        /usr/share/nvim/runtime/lua/vim/treesitter/languagetree.lua:111: in function 'new'
        /usr/share/nvim/runtime/lua/vim/treesitter.lua:41: in function '_create_parser'
        /usr/share/nvim/runtime/lua/vim/treesitter.lua:108: in function 'get_parser'
        /usr/share/nvim/runtime/lua/vim/treesitter.lua:416: in function 'start'
        /usr/share/nvim/runtime/ftplugin/lua.lua:2: in main chunk
        [C]: in function 'nvim_cmd'
        /usr/share/nvim/runtime/filetype.lua:36: in function </usr/share/nvim/runtime/filetype.lua:35>
        [C]: in function 'nvim_buf_call'
        /usr/share/nvim/runtime/filetype.lua:35: in function </usr/share/nvim/runtime/filetype.lua:10>
stack traceback:
        [C]: in function 'nvim_cmd'
        /usr/share/nvim/runtime/filetype.lua:36: in function </usr/share/nvim/runtime/filetype.lua:35>
        [C]: in function 'nvim_buf_call'
        /usr/share/nvim/runtime/filetype.lua:35: in function </usr/share/nvim/runtime/filetype.lua:10>
stack traceback:
        [C]: in function 'nvim_buf_call'
        /usr/share/nvim/runtime/filetype.lua:35: in function </usr/share/nvim/runtime/filetype.lua:10>
```
- 分析：
```
  回车后 可以看到额外的信息：
  No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable

  关键路径 \\wsl.localhost\Ubuntu-24.04\usr\share\nvim\runtime\lua\vim\treesitter\language.lua
    error("no parser for '" .. lang .. "' language, see :help treesitter-parsers")
  对应上面的：language.lua:107: no parser for 'lua' language, see :help treesitter-parsers
```
- 原因：ubuntu环境缺少c编译器
```
  sudo apt update
  sudo apt install clang
  clang --version
  sudo apt install build-essential  安装其他依赖
```




## 插件
[vim-plug](https://github.com/junegunn/vim-plug)
[查询流行的插件](https://github.com/rockerBOO/awesome-neovim)
早期主要有 vim-plug 和 packer.nvim(已废弃) 两个
最新[lazy.nvim插件管理](https://github.com/folke/lazy.nvim) pckr.nvim 
[LazyVim懒人配置 不是同一个东西](https://github.com/LazyVim/LazyVim)

- 插件所在目录
```
  :echo $VIMRUNTIME
  C:\Program Files\Neovim\share\nvim\runtime\
```



### lazy.nvim
init.lua中添加
```lua
-- 1. 准备lazy.nvim模块（存在性检测）
-- stdpath("data")
-- macOS/Linux: ~/.local/share/nvim
-- Windows: ~/AppData/Local/nvim-data
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- 2. 将 lazypath 设置为运行时路径
-- rtp（runtime path）
-- nvim进行路径搜索的时候，除已有的路径，还会从prepend的路径中查找
-- 否则，下面 require("lazy") 是找不到的
vim.opt.rtp:prepend(lazypath)
require("lazy").setup()
```
- 分析
```
  vim.fn.stdpath("data")   -- /home/syw/.local/share/nvim/
  该路径通常用于存储 Neovim 的用户数据，如插件、会话和其他持久性数据

  Linux: ~/.local/share/nvim
  macOS: ~/.local/share/nvim
  Windows: C:\\Users\\{username}\\AppData\\Local\\nvim-data
```

- 安装
下次进入nvim会判断和下载插件 通过:Lazy查看是否成功
按q退出
- 遇到的安装报错
```
    error delected while processing BufReadPost Autocommands for "*":
    error executing lua callback:/usr/share/nvim/runtime/filetype.lua:35:
    解决：安装clang
```


#### lazy插件
```lua
require("lazy").setup(
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
)
vim.cmd.colorscheme("catppuccin")   --永久生效
第一次安装时有报错 重启后又正常了

:colorscheme Tab键  查看其他插件
```

- 插件的另一种安装方式
```
  init.lua
  require("basic")
  require("keybindings")
  require("lazynvim-init")  需要在全局配置之后
```
-- lazynvim-init.lua
```
  以目录的方式加载插件
  require("lazy").setup("plugins")
  只要创建lua/plugins
  每个插件都以独立的文件存在 方便扩展
  第一次会报错 插件安装完后 下次就正常了！
```
- plugin-lualine.lua
```lua
-- 文件状态展示
return {  
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup()
        end
    }
}
```
- plugin-nvim-tree
```lua
return {
    {
        "nvim-tree/nvim-tree.lua",  --插件在github上的short url
        version = "*",  --表明使用最新版本  以后仓库有更新，则拉去最新插件代码
        dependencies = {"nvim-tree/nvim-web-devicons"},  --依赖另一个插件
        config = function()  --插件启动加载以后，则会执行该config的代码
            require("nvim-tree").setup {}
            --local status, nvim_tree = pcall(require, "nvim-tree")
            --if not status then
            --    vim.notify("没有找到 nvim-tree")
            --    return
            --end
        end
    }
}
map("n", "<leader>e", ":NvimTreeToggle<cr>", opt)
:NvimTreeOpen
```

- plugin-theme-catppuccin 主题
```lua
return {  
    {
        'catppuccin/nvim',
        config = function()
            require('catppuccin').setup()
        end
    }
}
需要在另个文件中启用 比如lua/theme.lua
vim.cmd.colorscheme("catppuccin")
另一种启用方式
local colorscheme = "tokyonight"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " 没有找到！")
  return
end
```


## 多个相同字符一起编辑
mg979/vim-visual-multi
类似vsc中的Ctrl-d
```
  Ctrl-n 选中单词 n/N 选下一个 q调过 Q？  ia编辑
  Ctrl-Down/Up 纵向选中
  Tab切换 cursor模式和extend模式 类似normal和visual ？
  :help visual-multi
```


## 注释插件
默认gcc够大部分情况 选中需要注释的行即可
- tpope/vim-commentary
gcap 注释一段 包含函数名
gciB 注释函数内部
gcaB 注释整个函数







## copilot支持
[copilot](https://github.com/github/copilot.vim)
```
自动安装：
pulgins/copolit.lua
  return {
    "github/copilot.vim"
  }

手动安装：
window powershell:
  git clone https://github.com/github/copilot.vim.git 
  $HOME/AppData/Local/nvim/pack/github/start/copilot.vim
```

- nodejs升级
```
  :Copilot setup  要求nodejs18以上
  nvm ls
  提示node版本太旧了 本地为14.21.3 为了跑laya的环境
  nvm install --lts  升级到20.15.1
  nvm use 20.15.1
  重新验证上面的命令
  第一会给一个code 回车后打开github网页 输入code即可
    github.com/login/device
  test.lua中验证 
  可以正常使用！！！
```

- 问题1： tab键和nvim-cmp冲突
  解决：修改pluginKeys.nvimCmp 注释tab部分

- 问题2：由于copilot的工程在nvim/pack/github/start目录下 子git工程
```
  git submodule add https://github.com/github/copilot.vim.git nvim2/pack/github/start/copilot.vim
  git rm --cached nvim2/pack/github/start/copilot.vim
  .gitignore中忽略这个目录：
     nvim2/pack/github/start/
```


## 不同项目 nvimtree过滤规则不同

- project.lua
```
project.setup({
  -- 自动加载项目配置 让不同的项目可以有不同的配置
  local function load_project_config()
      local project_config_path = vim.fn.getcwd() .. '/.nvim/config.lua'
      if vim.fn.filereadable(project_config_path) == 1 then
          dofile(project_config_path)
      end
  end

  -- 在进入项目时加载配置
  vim.api.nvim_create_autocmd("VimEnter", {
      callback = load_project_config
  })

  -- 在切换目录时加载配置
  vim.api.nvim_create_autocmd("DirChanged", {
      callback = load_project_config
  })
```

- 项目文件夹中新建  .nvim/config.lua
```lua
require'nvim-tree'.setup {
  filters = {
    dotfiles = false,
    custom = { 'node_modules', '.git', 'assets', '.ts.meta', '.js.meta' }
  }
}
```
cd projectpath
nvim .





















