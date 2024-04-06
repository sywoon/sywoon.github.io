# 🔙[program](/README?id=🔸program)
vscode日常收集


## 插件路径   可以修改各种内部名称
%userprofile%.vscode-insiders\extensions
%userprofile%.vscode\extensions  == C:\Users\admin\.vscode\extensions


## 已安装插件
- better comments  
- eslint  代码格式
- gitlens
- luahelper 
- markdown all in one
- office viewer  查看fnt doc
- prettier 代码格式化
- shader languages support
- wsl  windows子系统
- hex editor  十六进制编辑
- leek-fund 漂亮盒子



## 彻底卸载
win+R 输入%userprofile%
删除当前路径下的.Vscode文件夹
Win+R 输入 %appdata%
删除当前路径下的code和vscode(可能没有)文件夹即可
另外安装本用户模式 别所有用户 否则删除没权限



## 插件安装不了：网络连接不上
彻底卸载 重新安装最新版本
  发现用远程的配置同步到本地后 插件就链接不上了 不清楚哪里配置问题
  重新走一边卸载安装 在登录帐号后 用本地覆盖线上 
正好重新安装后 选了某个主题 导致setting.json和远程冲突
但是选择对比后  原来使用本地覆盖线上的窗口没了！ 本次不动了 下次选择不同的主题 让冲突 再选择
注意：主题会和代码显示相关  若有些类有下划线 换个主题试一试  推荐：one dark modern
通过查看对比 发现链接不上的原因：  
```
网络部分 估计之前用了其他vpn代理的 
    {
    "workbench.colorTheme": "One Dark Modern",
    "editor.inlineSuggest.enabled": true,
    "files.exclude": {
        "**/.cache": true,
        "**/.creator": true,
        "**/*.meta": true,
        "**/library": true,
        "**/node_modules": true,
        "**/temp": true
    },
    "[typescript]": {
        "editor.defaultFormatter": "vscode.typescript-language-features"
    },
    "[markdown]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "typescript.updateImportsOnFileMove.enabled": "always",
    "git.openRepositoryInParentFolders": "never",
    "[json]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },  
    "http.proxy": "http://localhost:15236",
    "[javascript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[html]": {
        "editor.defaultFormatter": "vscode.html-language-features"
    },
    "[css]": {
        "editor.defaultFormatter": "vscode.css-language-features"
    },
    "prettier.tabWidth": 4,
    "prettier.endOfLine": "auto",
    "prettier.printWidth": 120,
    "prettier.bracketSameLine": true,
    "prettier.htmlWhitespaceSensitivity": "ignore",
    "prettier.proseWrap": "never",
    "javascript.updateImportsOnFileMove.enabled": "always",
    "workbench.editorAssociations": {
        "*.xml": "default"
    }
}
```


## 账号登陆不了
github无法访问？vscode 无法使用github登录同步? 改 hosts 吧 - 池中物王二狗 - 博客园 (cnblogs.com)
https://www.ipaddress.com/   查找两个网站的ip地址
修改hosts：C:\Windows\System32\drivers\etc
```
	140.82.114.4 github.com
    185.199.108.153 vscode-auth.github.com 
    185.199.109.153 vscode-auth.github.com 
    185.199.110.153 vscode-auth.github.com 
    185.199.111.153 vscode-auth.github.com 
    cmd：刷新
    ipconfig /flushdns
```



## 控制台输入命名 执行报错
Set-ExecutionPolicy : Windows PowerShell 已成功更新你的执行策略，但在更具体的作业域中定义的策略覆盖了该设置。由于发生覆
盖，你的外壳程序将保留其当前的有效执行策略 Bypass。请键入“Get-ExecutionPolicy -List”以查看你的执行策略设置。有关详细
信息，请参阅“Get-Help Set-ExecutionPolicy”。

Get-ExecutionPolicy -List
Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process          Bypass
  CurrentUser    RemoteSigned
 LocalMachine       Undefined

修改权限
Set-ExecutionPolicy RemoteSigned -Scope Process
Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process    RemoteSigned
  CurrentUser    RemoteSigned
 LocalMachine       Undefined














