
# neovim入门指南
[web](https://youngxhui.top/)
[web1](https://www.cnblogs.com/youngxhui/p/17730419.html)



## neovim入门指南(一)
相比vim 内置lsp 支持异步io  插件系统更完善 社区活跃


### 基础配置
:h lua-guide

- 路径
```
  ~/.config/nvim/
  %USERPROFILE%/AppData/Local/nvim/
```
- init.lua
```
  require "options"
  require "lazy_nvim"
```


- 内容配置
lua/options.lua
```lua
-- 编码方式 utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"
-- jkhl 移动时光标周围保留8行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
-- 显示行号
vim.wo.number = true
-- 使用相对行号
vim.wo.relativenumber = true
-- 高亮所在行
vim.wo.cursorline = true
-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"
-- 右侧参考线
vim.wo.colorcolumn = "160"
-- 缩进字符
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
-- >> << 时移动长度
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
-- 空格替代
vim.o.expandtab = true
vim.bo.expandtab = true
-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
-- 搜索大小写不敏感，除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true
-- 搜索不要高亮
vim.o.hlsearch = false
 
vim.o.incsearch = true
-- 命令模式行高
vim.o.cmdheight = 1
-- 自动加载外部修改
vim.o.autoread = true
vim.bo.autoread = true
-- 禁止折行
vim.wo.wrap = false
-- 光标在行首尾时<Left><Right>可以跳到下一行
vim.o.whichwrap = "<,>,[,]"
-- 允许隐藏被修改过的buffer
vim.o.hidden = true
-- 鼠标支持
vim.o.mouse = "a"
-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- smaller updatetime
vim.o.updatetime = 300
 
vim.o.timeoutlen = 500
 
vim.o.splitbelow = true
vim.o.splitright = true
-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 样式
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 不可见字符的显示，这里只把空格显示为一个点
vim.o.list = false
vim.o.listchars = "space:·,tab:>-"
 
vim.o.wildmenu = true
 
vim.o.shortmess = vim.o.shortmess .. "c"
-- 补全显示10行
vim.o.pumheight = 10
vim.o.clipboard = "unnamedplus"
```


### 插件
[插件查询](https://github.com/rockerBOO/awesome-neovim)

### lazy.nvim
lua/lazy_nvim.lua
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
 
require("lazy").setup(
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
)
vim.cmd.colorscheme("catppuccin")
```

### 快捷键
Ctrl Alt Shift 
:h key-notations 
mode	模式的简写，常见的有 n(normal), i(insert), v(view) 等
[ripgrep](https://github.com/BurntSushi/ripgrep/tree/master)

- leader
[doc](https://luciaca.cn/posts/vimscript-learning-on-leaders/)
```
vim.g.mapleader = " "
vim.g.maplocalleader = " "
local opt = { noremap = true, silent = true }
 
-- visual模式下缩进代码
vim.keymap.set("v", "<", "<gv", opt)
vim.keymap.set("v", ">", ">gv", opt)
```



## neovim入门指南(二)：常用插件


### nvim-tree
早期的做法 setup中安装插件 额外搞一份配置来单独配置每个插件
最新的做法setup("plugins") 只需在plugins文件夹中创建插件配置即可
:NvimTreeToggle
```
require("lazy").setup ({
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "kyazdani42/nvim-tree.lua", event = "VimEnter", dependencies = "nvim-tree/nvim-web-devicons" },
})
```

- lua/plugins-config/nvim-tree.lua
```
local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
	vim.notify("没有找到 nvim-tree")
	return
end

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', '<leader>e',  api.tree.toggle,                  opts('Toggle'))
end


nvim_tree.setup({
  sort_by = "case_sensitive",
  on_attach = my_on_attach,
	-- 是否显示 git 状态
	git = {
		enable = true,
	},
	-- 过滤文件
	filters = {
		dotfiles = true, -- 过滤 dotfile
		custom = { "node_modules" }, -- 其他过滤目录
	},
  view = {
	-- 文件浏览器展示位置，左侧：left, 右侧：right
	side = "left",
	-- 行号是否显示
	number = false,
	relativenumber = false,
	signcolumn = "yes", -- 显示图标
	width = 30,
  },
  renderer = {
    group_empty = true,
  },
})
```
测试发现<leader>e没起效


### bufferline
管理buffer像ide的多个tab一样

- buffer的原始操作
```
  :e filename  打开文件
  :bn 下一个文件
  :bp 上一个文件
  :ls 文件列表 显示出编号
  :b [N] 跳转到某个文件
  :b bufname 跳转到打开的buffer 用tab可补全
  :bd 关闭当前  测试发现会关闭整个bufferline
  :bd [N] 关闭某一个
```

- lazy-nvim.lua
```
{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'}
```

- plugins/bufferline.lua
```
local status, bufferline = pcall(require, "bufferline")
if not status then
    vim.notify("没有找到 bufferline")
  return
end

bufferline.setup({
    options = {
		close_command = "bdelete! %d",       -- 点击关闭按钮关闭
		right_mouse_command = "bdelete! %d", -- 右键点击关闭
		indicator = {
			icon = '▎', -- 分割线
			style = 'underline',
		},
		buffer_close_icon = '󰅖',
		modified_icon = '●',
		close_icon = '',
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer" ,
				text_align = "left",
				separator = true,
			}
		},
    }   
})
```
:h bufferline-configuration
鼠标关闭有bug 会将所有tab都关闭


- keybinding.lua
```
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", ":BufferLineCycleNext<CR>", opt)
map("n", "<leader>e", ":NvimTreeToggle<CR>", opt)
```



### lualine
个性化状态栏
用官方的setup配置

- lazy_nvim.lua
```
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
```


### telescope




