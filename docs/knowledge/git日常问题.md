


## 文件夹权限
fatal: unsafe repository ('D:/Github/Ala2D' is owned by someone else)
```
  方法1：每个目录都要操作
    项目目录git log 会提示完整路径
    git config --global --add safe.directory D:/Github/Ala2D
    执行一次即可
  方法2：
    文件目录-右键-属性-安全-高级-所有者-更改为 你的当前用户
``


## ssh权限
no supported authenticatio methods available  
在使用TortoiseGit与远程仓库进行同步代码时报错   
但是用bash正常  
```
  原因：TortoiseGit的默认网络SSH client是TortoiseGitPlink.exe
  解决1：麻烦 每次启动电脑都要
    puttyant 添加ppk
    或  也麻烦 单个项目设置
    设置：git：远端：putty密钥：C:\Users\S\.ssh\id_ecdsa_ppk.ppk
  解决2：inuse  
    将ssh改为bash的方式 用git下的ssh
    设置：网络：ssh客户端
    C:\Program Files\TortoiseGit\bin\TortoiseGitPlink.exe
    改为
    C:\Program Files\Git\usr\bin\ssh.exe
```



