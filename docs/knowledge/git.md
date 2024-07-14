## 远程和本地图片
三种方式通过docsify在github.io中测试都通过  
![](https://raw.githubusercontent.com/sywoon/MyLua/master/lua.gif)
![](../lua.png)
![](../lua.gif)  
这里是相对路径，若在根目录下，可直接使用doc/lua.png


## 配置
```
git config --global user.name sywoon
git config --global user.email sywoon@163.com
git config --global color.ui auto

git config --global core.editor nvim
git config --global core.ignorecase false

:: false: pull push do nothing  in only windows
:: input: push change crlf to lf   pull do nothing  in linux
:: true: pull push both change   in window and linux
git config --global core.autocrlf false

git config --global sendpack.sideband false
git config --global push.default simple

git config --global diff.tool bc4
git config --global difftool.bc4.cmd "\"c:/program files/beyond compare/bcomp.exe\" \"$LOCAL\" \"$REMOTE\""

git config --global merge.tool bc4
git config --global mergetool.bc4.cmd "\"c:/program files/beyond compare/bcomp.exe\" \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\""
git config --global mergetool.bc4.trustExitCode true

git config --global branch.master.rebase true
git config --global branch.release.rebase true

git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.st "status"
git config --global alias.dt "difftool"
git config --global alias.logs "log --stat"
git config --global alias.logo "log --oneline"
git config --global alias.cp "cherry-pick"
```

## 本地新增分支 推送给远端：
```
git br -av 查看本地分支
git co master
git pull  更到最新
git co -b release 从本地master切分支到release
git push -u origin release
```

## 从远程获取新分支
```
git fetch   获取所有远程分支
git br -av 
git co -b release origin/release
```


## 添加远程github库
```
git remote add origin git@github.com:sywoon/eff_test.git
git push -u origin master
```

## 将XX分支的某个提交复制到XX分支
```
master的复制到relase
git checkout master 切换到master分支
git pull 更新远端master代码
git checkout release 切换到release分支
git pull 更新远端release代码
git logo -3 master 查看master分支最新三条log记录
git cherry-pick Hash   Hash是logo里找到要复制的提交的hash(记录前面的那串字母).cherry-pick可简写成cp
git push 推送提交

可多条记录一起提交
git cherry-pick <HashA> <HashB> 
```




