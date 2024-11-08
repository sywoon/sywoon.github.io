# youtube上的一个案例
nvim一分钟配置
[url](https://www.youtube.com/watch?v=Wh2Uh3g5fOM)

可以直接用作者的版本中的lazyvim 复制到local下 改名为nvim
其原有的nvim为自定义同Packer安装的插件版本
(也是telescope-fzf-native编译不过 默认用了/usr/bin/bash估计需要修改配置)


## LazyVim

### 环境要求
NerdFont lazygit 
ripgrep: live grep 
fd: find files


### 入门配置
[starter](https://github.com/LazyVim/starter/tree/main)
[doc](https://www.lazyvim.org/installation)
[treesitter插件需要的c编译器](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support) 支持clang gcc cl； 选择安装llvm.exe-包含clang即可


### 安装
```
  linux mac:
    git clone https://github.com/LazyVim/starter ~/.config/nvim
  win powershell:
    git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim
```
- 第一次运行报错
```
   ● telescope-fzf-native.nvim 0.2ms ✔ build
        -- Building for: NMake Makefiles
        CMake Deprecation Warning at CMakeLists.txt:1 (cmake_minimum_required):
          Compatibility with CMake < 3.5 will be removed from a future version of
          CMake.
          Update the VERSION argument <min> value or use a ...<max> suffix to tell
          CMake that the project does not need compatibility with older versions.

        CMake Error at CMakeLists.txt:2 (project):
          Running
           'nmake' '-?'
          failed with:
```


## options + keymaps + lsp
- options
```
    默认配置
    https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
    重新设置
    local opt = vim.opt
    opt.relativenumber = false
```
- keymaps
```
  local map = vim.keymap
  map.set("i", "ii", "<Esc>") 
```
- lsp
```
  :Mason
  搜索python的lsp
  /pyright 输入回车就开始安装
```
- 自定义插件:example.lua
```
    新增plugins/tabnine.lua
    return {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    config = function()
        require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<C-n>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 300,
        suggestion_color = { gui = "#808080", cterm = 244 },
        execlude_iletypes = { "TelescopePrompt" },
        })
    end,
    }
    如果安装卡住了 手动运行
    ~/.local/share/nvim/lazy/tabnine-nvim
```




















