
# youtube上的一个案例
lsp的强大
[url](https://www.youtube.com/watch?v=nwiOapEE2Rc)
[github](https://github.com/bryant-video/neovim-tutorial?tab=readme-ov-file)  有vim相关的所有快捷键



## declaration definition
gd 预览定义 
gD 跳转到定义
gr 寻找所有的定义
K 看文档解释  不是gh？
ctrl o/i 前进后退

<space>xd 查看编译错误
[d 下一个错误
]d 上一个错误

<space>ca 导入头文件
<space>rn 重命名 包含定义文件


## mason
类似于packagemgr 用于安装不同的lsp
```
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  :Mason
  移动到目录  i 开始安装
  / 可搜索字符
```
-lspconfig lspsaga
```
  配置定义相关快捷键
  map.set("n", "gr", "<cmd>Laspsaga lsp_finder<cr>", opt)
  map.set("n", "gd", "<cmd>Laspsaga peek_definition<cr>", opt)

  map.set("n", "<leader>tt", "<cmd>Laspsaga term_toggle", opt)
  打开终端 用exit退出
```

- null-ls.lua
- trouble.lua
- nvim-cmp.lua
- treesitter.lua

