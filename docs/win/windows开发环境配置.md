



## git


### [git.exe](https://www.git-scm.com/)
安装Git-2.45.2-64-bit 去官方下载最新版本 且有多种gui软件
[git官方book](https://www.git-scm.com/book/zh/v2)

- terminal:扩展gitbash
    - 安装时 勾选add a git bash profile to windows terminal
    - 若错过了 后补：
        - terminal：设置：新增一个profile
        - Name: Git Bash
        - command line:C:/Program Files/Git/bin/bash.exe -i -l  
        - sharting directory: %USERPROFILE%
        - icon:C:\Program Files\Git\mingw64\share\git\git-for-windows.ico
        - 后面就可以通过新分页的创建箭头 选择git bash图标


### git环境
- 创建ssh密钥
```
    ssh-keygen -t ecdsa -b 521 -C "sywoon@163.com"
    早期使用rsa 已经淘汰 ssh-keygen -t rsa -C "sywoon@163.com"
    文件生成到： id_ecdsa.pub 和 私钥id_ecdsa
     C:\Users\S\.ssh 
```

- github后台配置
```
    ssh and GPG keys: 新增一个ssh key
    内容使用上面的id_ecdsa.pub
    测试是否通：ssh -T git@github.com

    若不行：将DNS更换为114或者阿里
    114.114.114.114
    223.5.5.5
    223.6.6.6

    第一次clone需要输入一次yes
```


### tortoiseGit
默认使用putty的ssh方式 优点？  
可通过设置修改为git的ssh方式 针对github的使用 方便很多 无需启动Pageant用来加载ppk  

- 问题：no supported authenticatio methods available
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



### sourcetree
安装后 需要创建ssh密钥 需要选择ppk文件


### ppk的制作
使用sourcetree 小乌龟 若通过git@方式都需要启动pageant工具
可以安装putty-64bit-0.74-installer.msi 直接在gitbash中敲入命令或用下面的路径
puttygen：ppk创建工具
pageant：ppk加载工具
```
    >where pageant puttygen
    C:\Program Files\TortoiseHg\Pageant.exe
    C:\Program Files\PuTTY\pageant.exe
    C:\Program Files\TortoiseGit\bin\pageant.exe
    手动add 一个ppk key即可
```
1. 上面的pagean or sourcetree  -》 工具 -》 创建和导入ssh密钥
2. 点击Load 文件类型选择*.*   选择私钥id_ecdsa(不带后缀名那个文件)  
3. 将rsa改为ecdsa 点击 save private key   注意：不是public key  否则putty导入报错
   名字定为id_ecdsa_ppk
4. 启动pageant 加载刚才的ppk文件  每次启动电脑都需启动！ 所以不如git自带的ssh方便
- 其他：
```
  a 为了避免每次开机都要启动 pgeant 加载ppk文件
    可以在某个github项目中 设置 
    修改签名密钥：C:\Users\S\.ssh\id_ecdsa_ppk.ppk
    tortoiseGit:
        clone时 勾选Load Putty Key: 选择上个步骤创建的文件
    后期可直接在项目设置中：
        工程右键 git设置 ->　git 远端 -> 添加：
        远端: origin
        url: git@192.168.88.56:client/shj_client_git.git
        putty密钥： 选择ppk文件
        标签：reachable
        勾选修剪Prune
  b 修改ssh方式 参考上面
```











