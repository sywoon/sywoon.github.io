
# youtube上的一个案例
从0开始nvim
[url](https://www.youtube.com/watch?v=c5icE_ZxMzQ)
[github](https://github.com/bryant-video/neovim-tutorial?tab=readme-ov-file)
[telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim)


## 外部环境
Nerdfonts Riggrep

## 直接使用作者的配置
1. github上下载nvim复制到
mac: ~/.config 
win: %userprofile%\AppData\Local == C:\Users\S\AppData\Local

2. nvim plugins-setup.lua
  输入 :PackerSync 会安装所有插件

3. 快捷键列表 在作者的github里


## 功能点

### 常用命令
```
    f[char]  当前行往前找
    F[char]  当前行往回找

    [C-u]  往上半页
    [C-d]  往下半页
    [C-b]  往上一页
    [C-f]  往下一页
```


### 配置环境
```
  cd ~/.config  or  %userprofile%\AppData\Local
  mkdir nvim  第一次没这个文件夹
  目录树：
    init.lua
    lua
      bryant
        core
          keymaps.lua
          options.lua
        plugins
          nvim-tree.lua
          telescope.lua
        plugins-setup.lua
```

#### 配置keymaps和options
- nvim keymaps.lua
```lua
vim.g.mapleader = " "

local map = vim.keymap
map.set("i", "ii", "<Esc>")
map.set("n", "<leader>sv", "<C-w>v")
map.set("n", "<leader>sx", ":close<cr>")
```
- init.lua
```
require ("my.core.options")
require ("my.core.keymaps")
```
- options.lua
```
local opt = vim.opt

opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.splitright = true
opt.clipboard:append("unnamedplus")  --y和粘贴板互通

:h option-list
```

#### Packer
- 安装
```
  powershell
  git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
```
- plugins-setup.lua
```
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
end)

:PackerSync  同步安装环境 安装插件
```
- 新增插件
```
use {
    "windwp/nvim-autopairs",
    config = function () require("nvim-autopairs").setup {} end
}
use {
    'nvim-tree/nvim-tree.lua',
    requires = {
        'nvim-tree/nvim-web-devicons', --optional, for file icons
    },
    tag = "nightly"
}
use "folke/tokyonight.nvim"
实测中 tree安装失败 手动复制了一份到packer的目录下C:\Users\S\AppData\Local\nvim-data\site\pack\packer\start
```

#### 配置NvimTree
```
  nvim-tree.lua
  从官网复制
  local status, ntree = pcall(require, "nvim-tree")
    if not status then
        return
    end
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true

    ntree.setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    })

  keymaps.lua 简化打开方式
  map.set("n", "<leader>e", ":NvimTreeToggle<cr>")
```
- 常规操作
```
    :NvimTreeOpen
    选中文件或文件夹 o打开
    选中文件夹 a新增 r重命名 d删除文件 f过滤文件
```

#### tokyonight 颜色主题
```
  colorscheme.lua
    local status, tn = pcall(require, "tokyonight")
    if not status then
        return
    end

    tn.setup({
        style = "storm",
        dim_inactive = true
    })
    vim.cmd("colorscheme tokyonight-storm")
```

- telescope 模糊查找插件
依赖repgrep-外部安装 plenary
```
    use "nvim-lua/plenary.nvim"
    use({"nvim-telescope/telescope-fzf-native.nivm", run="make"})
    use({"nvim-telescope/telescope.nivm", branch="0.1.x"})
  plugins/telescope.lua
    local status, scope = pcall(require, "telescope")
    if not status then
        return
    end

    local status, actions = pcall(require, "telescope.actions")
    if not status then
        return
    end

    scope.setup({})
    scope.load_extension("fzf")
```
插件安装失败 手动复制telescope.nvim telescope-fzf-native.nvim
```
  根据官网提示 不会提供bin文件 需要本地自己编译 需要环境安装cmake和clang
  修改如下：
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  --use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
```

- 快捷键
```
map.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
map.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
map.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map.set("n", "<leader>lds", "<cmd>Telescope lsp_documembols<cr>")

ff打开文件列表 esc后可用jk上下选中不同的文件 <C-u><C-d>可移动查看的内容
  i回到编辑模式后 <C-c>退出ff
fs 全局查找某个字符串 整个字符串匹配
fc 全局查找某个字符串 字符单独匹配 可分开

map.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
map.set("n", "<leader>gfc", "<cmd>Telescope git_bcommit<cr>")
map.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
map.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")
git文件夹的一些快捷操作
```

#### hop插件
- 安装
```
  use({
      "phaazon/hop.nvim",
      branch = "v2",
      config = function ()
          require("hop").setup({keys="etovxqpdygfblzhckisuran"})
      end
  })

  map.set("n", "<leader>hw", ":HopWord<cr>")
  map.set("n", "<leader>hwW", ":HopWordMW<cr>")
  map.set("n", "<leader>hc", ":HopChar2<cr>")
  map.set("n", "<leader>hcc", ":HopChar2MW<cr>")
  map.set("n", "<leader>hl", ":HopLine<cr>")
  map.set("n", "<leader>hls", ":HopLineStart<cr>")
```

### maximizer  窗口调整
```
  use("szw/vim-maximizer)
  map.set("n", "<leader>sm", ":MaximizerToggle<cr>")
```


### tmux-navigator
用<C-h><C-l>来移动窗口焦点； 实际自己配置快捷键也行；
普通移动<C-w>+hjkl or <C-w>


### Comment
```
  use("numToStr/Comment.nvim")
  gcc注释当前行
  gc3c 注释3行
```

### vim-surround
为某段文字加双引号
```
ys+navigation+"
cs+"+)
```

### 各种报错

1. 启动时fzf插件报错
```
E5113: Error while calling lua chunk: ...\start\telescope.nvim/lua/telescope/_extensions/init.lua:10: 'fzf' extension doesn't exist or isn't installed: ...k\packer\start\telescope-fzf-native.nvim/lua/fzf_lib.lua:11: cannot load module 'C:\Users\S\AppData\Local\nvim-data\site\pack\packer\start\telescope-fzf-native.nvim/lua/../build/libfzf.dll': 找不到指定的模块。                                                                                              
查看代码错误：
  fzf_lib.lua
  local library_path = (function()
  local dirname = string.sub(debug.getinfo(1).source, 2, #"/fzf_lib.lua" * -1)
  if package.config:sub(1, 1) == "\\" then
    return dirname .. "../build/libfzf.dll"
  else
    return dirname .. "../build/libfzf.so"
  end
end)()
local native = ffi.load(library_path)
  所以是这个插件没正确编译出dll
```
解决：telescope-fzf-native 需要手动编译
```
  官方说法 编译需求：
  CMake, and the Microsoft C++ Build Tools on Windows
  CMake, make, and GCC or Clang on Linux and MacOS

  powershell：安装了vs2022
  cd C:\Users\S\AppData\Local\nvim-data\site\pack\packer\start\telescope-fzf-native.nvim
  cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build
```












