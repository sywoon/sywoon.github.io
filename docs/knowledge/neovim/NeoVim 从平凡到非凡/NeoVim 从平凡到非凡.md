
# NeoVim 从平凡到非凡
[视频0](https://www.youtube.com/watch?v=Qp71mD7Eex0&list=PLlYlfdIF0BKcSMqYr2dxsQNTCLJFQ_hMI)
[github](https://github.com/FledgeXu/NeovimZero2Hero)


- 常用的发行部：已经配置好模板
LazyVim NvChad LunaVim AstroNvim

- 技巧集：
  - 文件链接 jf跳转



## 第1集：Neovim 基础配置

- mac环境
```
  item2
  brew install neovim git 
  brew search nerd-font  
  brew install font-hack-nerd-font
```

- config
```
    ~/.config/nvim
    %userprofile%/AppData/Local
```
- init.lua
vim.loader.enable()
```
local option = vim.opt
local buffer = vim.b
local global = vim.g

-- Globol Settings --
option.showmode = false
option.backspace = { "indent", "eol", "start" }
option.tabstop = 4
option.shiftwidth = 4
option.expandtab = true
option.shiftround = true
option.autoindent = true
option.smartindent = true
option.number = true
option.relativenumber = true
option.wildmenu = true
option.hlsearch = false
option.ignorecase = true
option.smartcase = true
option.completeopt = { "menu", "menuone" }
option.cursorline = true
option.termguicolors = true
option.signcolumn = "yes"
option.autoread = true
option.title = true
option.swapfile = false
option.backup = false
option.updatetime = 50
option.mouse = "a"
option.undofile = true
option.undodir = vim.fn.expand('$HOME/.local/share/nvim/undo')
option.exrc = true
option.wrap = false
option.splitright = true

-- Buffer Settings --
buffer.fileenconding = "utf-8"

-- Global Settings --
global.mapleader = " "

-- Key mappings --
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>")

vim.keymap.set("n", "<A-Tab>", "<cmd>bNext<CR>") 
vim.keymap.set("n", "<leader>bc", "<cmd>bd<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "v", "n" }, "<leader>y", "\"+y")
```



## 第2集：插件管理器和第一个插件
- lazy.nvim
```
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
vim.opt.rtp:prepend(lazypath)
local opts = {
    install = {
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "tokyonight-storm" },
    },
}
require("lazy").setup("plugins", opts)
```
- plugins/them.lua
```
return {
     {
         "folke/tokyonight.nvim",
         config = function()
             vim.cmd[[colorscheme tokyonight-storm]]
         end
     },
}
```


## 第3集：美化Vim

- lualine  高级状态条
- nvim-web-devicons  可通过dependencies  状态栏上多一些icon
- utilyre/barbecue.nvim 显示文件路径在上方
- SmitestP/nvim-navic
- akinsho/bufferline.nvim 多个buffer页签显示 可鼠标操作
- lukas-reineke/indent-blankline.nvim  没行前 根据块 显示竖线
- lewis6991/gitsigns.nvim  每行前显示git的状态 
- goolord/alpha-nvim  打开一个操作界面 比如ff打开窗口 需要安装额外的插件来支持
- RRethy/vim-illuminate  块显和命中单词一样的文字

- 其他插件参考：
  - lazy.nvim
  - kickstart.nvm  各种插件的配置推荐



## 第4集：Telescope 模糊搜索

- telescope.lua
搜索功能： 文件 内容 
```
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { 
            'nvim-telescope/telescope-fzf-native.nvim', 
            --build = 'make',
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
        }
    },
windows需要安装cmake clang   上面的命令没能自动执行 
后来手动用powershell执行了命令 分两段执行 得到build/release/libfzf.dll
```

- 环境需求：
brew install ripgrep fzf-有何用 和插件什么区别？
 

- 作者的配置额外错误
需要额外复制dll
```fzf
Failed to run `config` for telescope.nvim                                                                                                                                                                               ...a/lazy/telescope.nvim/lua/telescope/_extensions/init.lua:10: 'fzf' extension doesn't exist or isn't installed: ...nvim-data/lazy/telescope-fzf-native.nvim/lua/fzf_lib.lua:11: cannot load module 'C:/Users/admin/AppData/Local/nvim-data/lazy/telescope-fzf-native.nvim/lua/../build/libfzf.dll': 找不到指定的模块。^M 
```

```blankline
You are trying to call the setup function of indent-blankline version 2, but you have 
version 3 installed.  Take a look at the GitHub wiki for instructions on how to migrate, or revert back to version 2.  
解决：
说是lazyvim找的版本有问题
1 Change the indent-blankline.nvim line in lazy-lock.json to "indent-blankline.nvim": { "branch": "master", "commit": "29be0919b91fb59eca9e90690d76014233392bef" },
2 Run :Lazy, press U to update
若不行 可能U后 文件又被还原回去了
方案2：inuse
{
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    commit = "29be0919b91fb59eca9e90690d76014233392bef",
}
```

### 配置后的快捷键
ff 文件搜索
fg 内容搜索
fb 搜索buffer
fh 搜索help



##  第5集：Tree-Sitter
语法支持 不同颜色显示关键字
- nvim-treesitter
ensure_installed = "all",
最好根据自己需要的语言 选择安装 不用搞200多个

- 环境报错
```
[nvim-treesitter] [1/277] Compiling...                                                                      nvim-treesitter[rasi]: Error during download, please verify your internet connection                        Cloning into 'tree-sitter-rasi'...                                                                          fatal: unable to access 'https://github.com/Fymyte/tree-sitter-rasi/': Empty reply from server  
```

- vim text objects  知识点 对理解vim很有用
  

### nvim-treesitter-textobjects
vif dif 对整个函数块操作 需要配置快捷键



## 第6集：实用插件

- rhysd/accelerated-jk
按j k时间越久 速度越快

- folke/persistence.nvim
重新打开 恢复之前的buffer布局

- windwp/nvim-autopairs
补全括号 引号

- ethanholz/nvim-lastplace
打开文件 光标回到之前的位置

- olke/flash.nvim
文件内 快速跳转任意位置 按某个字符后 会动态计算符合的字符

- kamykn/spelunker.vim
驼峰命名检查

- ellisonleao/glow.nvim
markdown语法

- nvim-neo-tree/neo-tree.nvim
? 显示快捷键

- folke/which-key.nvim
按空格后 显示面板 所有的后续快捷键

- echasnovski/mini.ai
a i扩展

- echasnovski/mini.comment
gcc注释  自动识别不同语言

- s1n7ax/nvim-window-picker
眺不同窗口  感觉不如<c-hjkl>实用


## 第7集：LSP 配置
不同语言有不同的lsp 查看定义 格式化等
- .nvim.lua

- pytho lsp
```
  python3 -m venv .env
  pip install pyright
  pyright-langserver

  项目中配置.vnim.lua
  进入vi后  用配置的快捷键启动lsp
  htop* 查看启用的lsp
```

https://www.youtube.com/watch?v=tXyg2DFkqIQ&list=PLlYlfdIF0BKcSMqYr2dxsQNTCLJFQ_hMI&index=8
12分钟











