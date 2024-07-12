

# 从零开始配置 Neovim(Nvim)
[web](https://www.cnblogs.com/RioTian/p/17993485)
作者以mac为例

## 安装
```
brew install neovim
```

## 创建配置
```
  mkdir ~/.config/nvim
  mkdir ~/.config/nvim/lua
  touch ~/.config/nvim/init.lua
```

## 选项配置 lua/options.lua
采用系统粘贴板 支持鼠标操控 tab和空格的换算 智能搜索
```
-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.mouse = 'a' -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered
```


## 按键配置 lua/keymaps.lua
```
<C-h/j/k/l> 快速在多个窗口之间移动光标
ctrl+方向键 调整窗口大小
选择模式下 可以用tab或者shift-tab改变缩进
-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------
-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-----------------
-- insert mode --
-----------------
vim.keymap.set('i', 'jk', '<ESC>', opts)

```


## 用Packer管理插件
这个不再维护了 所以没打算用 直接用lazy.vim来管理

## lazy.vim
从别的地方学习而来  根据官网文档配置
[doc](https://lazy.folke.io/installation)

- lua/lazy_nvim.lua
```
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },  --改为"tokyonight-storm"
  -- automatically check for plugin updates
  checker = { enabled = true },
})
```
将vim.g部分移入options.lua中
init.lua中添加 require "lazy_nvim"
mkdir lua/plugins 会扫描这个文件夹内的文件

- lua/plugins/theme.lua
注意:只会安装后启用一次 若需要永久启用需要设置 通过config函数
为了支持切换不同主体 通过名字来切换
```
local theme_names = {
    monokai = { "tanvirtin/monokai.nvim", "monokai"},
    tokyonight = { "folke/tokyonight.nvim", "tokyonight"},
    tokyonight_moon = { "folke/tokyonight.nvim", "tokyonight-moon"},
}
local theme_name = "tokyonight_moon"

return {
    -- the colorscheme should be available when starting Neovim
    {
        theme_names[theme_name][1],
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {},
        config = function()
            -- load the colorscheme here
            -- vim.cmd("colorscheme tokyonight")
            vim.cmd("colorscheme " .. theme_names[theme_name][2])
        end,
    },
}
```


## 第三方插件

### vim-cmp 补全菜单
- cmp_nvim.lua
删除lspconfig部分 新增tab支持 新增experimental
新增<C-k/j>来选择菜单项 新增formatting
由于官方没有lazy插件的安装方法 参考了内容和其他博主的安装方式
```lua
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- 'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',

        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },
    config = function ()
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require'cmp'
        local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        experimental = {
            ghost_text = true,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- they way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'vsnip' }, -- For vsnip users.
          { name = 'luasnip' }, -- For luasnip users.
          { name = 'buffer' },
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }),
        formatting = {
          -- Set order from left to right
          -- kind: single letter indicating the type of completion
          -- abbr: abbreviation of "word"; when not empty it is used in the menu instead of "word"
          -- menu: extra text for the popup menu, displayed after "word" or "abbr"
          fields = { 'abbr', 'menu' },

          -- customize the appearance of the completion menu
          format = function(entry, vim_item)
              vim_item.menu = ({
                  nvim_lsp = '[Lsp]',
                  luasnip = '[Luasnip]',
                  buffer = '[File]',
                  path = '[Path]',
              })[entry.source.name]
              return vim_item
          end,
        },
      })

      -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
      -- Set configuration for specific filetype.
      --[[ cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
        }, {
          { name = 'buffer' },
        })
     })
     require("cmp_git").setup() ]]-- 

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        }),
        -- matching = { disallow_symbol_nonprefix_matching = false }
      })

      -- Set up lspconfig.
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
      --   capabilities = capabilities
      -- }
    end,
}
```



## lsp
- mason
3者有先后顺序
lsp.lua 根据依赖来配置
新增lspconfig配置 每种语言都需要设置一次 这里只用了lua做案例
之前的博主NeovimZero2Hero-main使用for遍历所有语言来设置
```
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function ()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })

        require('mason-lspconfig').setup({
            -- A list of servers to automatically install if they're not already installed
            ensure_installed = {'lua_ls'},
            -- ensure_installed = { 'pylsp', 'gopls', 'lua_ls', 'rust_analyzer' },
        })


        local lspconfig = require('lspconfig')

        -- Customized on_attach function
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap = true, silent = true }
        --vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "<space>f", function()
                vim.lsp.buf.format({ async = true })
            end, bufopts)
        end

        -- Configure each language
        -- How to add LSP for a specific language?
        -- 1. use `:Mason` to install corresponding LSP
        -- 2. add configuration below
        lspconfig["lua_ls"].setup({
            on_attach = on_attach,
        })
    end,
}
```
重启后自动安装 
:Mason可查看进度 
打开lua后 可用gd跳转定义 gr查看引用 <space>f格式化文档
语法错的地方 也会自动识别和提示
[所有语言的配置](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)



































