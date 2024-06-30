
# youtube上的一个案例
从0开始vim
[url](https://www.youtube.com/watch?v=_7v9pIWKzuM)
[github](https://github.com/bryant-video/neovim-tutorial?tab=readme-ov-file)



## 环境
vscode+vim插件


## 模式
normal insert visual

## normal模式
- 光标移动：
hjkl
num+hjkl
w b 整个单词移动
num+w/b
$ ^ 0 行首尾
G gg 文档首尾
{} 上下空行
num+gg/G 具体行
:+num 同上
/ chars 寻找档次
 n N 移动目标

## insert模式
i
shift+i 行首
shift+a 行尾
jk映射为esc 作者用了ii
o O 上下行
c + motion
  c$ cw c^ c0 ciw


## cut paste
dd dw yw yy + p 删除后粘贴
u ctrl+r  
:%s/from/to/g

## visual模式
- v-Character
v 进入
v+w + y + p 复制选中
v+w + d 删除选中

- v-line
shift+v 进入
jj.. 选中多行 + >/< 缩进
+ ctr/ 注释多行

- v-block
ctrl+v 进入


## 保存文件
:w
:q
:q! 不保存退出
:wqa 关闭所有



