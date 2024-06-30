
# youtube上的一个案例
vscode+vim
[url](https://www.youtube.com/watch?v=uhk_YOmMwiI)
[github](https://github.com/bryant-video/neovim-tutorial?tab=readme-ov-file)  有vim相关的所有快捷键


- operator
d 剪切
c 修改
y 复制

- motion
$ 行尾
G 文档结尾
gg 文档开头
^ 行首
0 行首
w 下一个单词开头
b 反向 下一个单词开头

- leader key
解决相同key的冲突
ff 当前行找f
<leader>ff 寻找文件
"vim.leader": " ",  一般用空格代替


## vim中的模拟插件emulated plugins
- vim commentary:
    - 快速comment: gcc
    - gc+motion: gc3j 注释连续3行
    - gc+}: 注释整块

- EasyMotion：跳跃到任何单词
  - <leader><leader>s+想要定位的单词 会实时变化，再敲入单词
  - 就可以定位到任意想要的单词


- vim surround
```
  [operator]s[motion][symbol]
  ysiw)  给某个单词加括号  若用(前后会多出一个空格
  y:yank operator
  s:surround
  iw:motion,文本对象
  ): symbol

  cs)]:将小括号改为中括号
  ds]： 删除两边的中括号
  ysfr" 从当前到字符r一起加"
```


- vim sneak
```
  s/S+[char][char]  找下一个两个字母开头的字符
  [num][operator]z[char][char]
```

- 窗口相关
```
  gd 跳转到定义
  ctrl+o 后退一次
  ctrl+i 前进一次
  gh 查看文档解释
  ctrl+p 打开文件

  setting.json 设置多标签跳转
  <space>+tn/tp/tl/tf
  ctrl+n 重命名
```

- 编辑器组
```
  ctrl+\ 左右分屏
  ctrl+h/l 左右跳转
  ctrl+k+w 关闭其他
```


- 文件配置settings.json  查看作者github里的配置
```
    "vim.ignorecase": false,
    "vim.leader": " ",
    "vim.easymotion": true,
    "vim.sneak": true,
    "vim.surround": true,
    "vim.statusBarColorControl": true,
    "vim.statusBarColors.visual": "#b55d02",
    "vim.statusBarColors.visualblock": "#a02236",
    "vim.statusBarColors.visualline": "#9c195b",
    "vim.statusBarColors.replace": "#6f1f45",
    "vim.statusBarColors.insert": "#6d8400",
    "vim.statusBarColors.normal": "#997575",
    "vim.useSystemClipboard": true,th
    "vim.commandLineModeKeyBindings": [
    ],
    "vim.useCtrlKeys": true,  vim优先使用ctrl
    "vim.handleKeys": {
        "<C-a>": false,
        "<C-c>": false,
        "<C-v>": false,
        "<C-d>": false,
        "<C-f>": false,
        "<C-h>": false,
        "<C-s>": false,
        "<C-z>": false,
        "<C-p>": false,
        "<C-o>": true,
    },
    "vim.insertModeKeyBindings": [
        {
        "before": ["j", "k"],
        "after": ["<Esc>"]
        }
    ],
    "vim.visualModeKeyBindings": [
        {
        "before": ["j", "k"],
        "after": ["<Esc>"]
        }
    ],
    "vim.normalModeKeyBindings": [
        {
        "before": ["<leader>", "t", "l"],
        "commands": [":tabnext"]
        },
        {
        "before": ["<leader>", "t", "h"],
        "commands": [":tabprev"]
        }
    ],
```
- keybindings.json
```
  ctrl+shift+p open keyboard shortcuts(json)
  [
    {
        "key": "ctrl+shift+u",
        "command": "-workbench.action.output.toggleOutput",
        "when": "workbench.panel.output.active"
    },
    // {
    //     "key": "ctrl+shift+u",
    //     "command": "editor.action.transformToUppercase"
    // },
    // {
    //     "key": "ctrl+shift+i",
    //     "command": "editor.action.transformToLowercase"
    // },
    { "key": "ctrl+n", "command": "editor.action.rename" },
    { "key": "ctrl+m", "command": "workbench.action.toggleEditorWidths" },
    { "key": "ctrl+\\", "command": "workbench.action.splitEditor" },
    { "key": "ctrl+h", "command": "workbench.action.navigateLeft" },
    { "key": "ctrl+l", "command": "workbench.action.navigateRight" },
    { "key": "ctrl+w", "command": "workbench.action.closeEditorsAndGroup" }
]
```





