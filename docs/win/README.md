# 🔙[win](/README?id=🔸Win日常)

## win软件
- 雷蛇(Razer) 炼狱蝰蛇标准版有线鼠标
[驱动](https://cn.razerzone.com) 支持：电脑：鼠标：雷蛇蝰蛇标准版 有黑白两种颜色  
开始了解：为鼠标按键分配宏：雷云3: 只有说明介绍 哪里下载软件？ 且没有mac版本



### q-dir
- 双击空白 返回上一页 ； 选项：列表视图：双击空白处
- 关闭自带的zip 有些大的文件 速度比winrar慢很多
  - 选项：更多选项：关联：添加：选择winrar.exe
  - 修改对应的ext文件：*.rar;*.zip=C:\Program Files\WinRAR\WinRAR.exe
  - 注意：一定要点保存  直接点确定是没用的



## win技巧

1 任务管理器中判断exe是32位还是64位
```
  方法一: 任务管理器法
  任务管理器>>>进程(processes)>>
  进程后带有*32的是32位程序

  方法二: 简化颜色模式法   可行！！
  右键exe>>>属性>>>兼容性
  若Settings框中的降低色彩和分辨率的选项可勾选>>>32位程序
  若Settings框中的降低色彩和分辨率的选项不可勾选>>>64位程序
```



2 win+c 打开cortana  禁用之
```
  powershell 管理员打开	
  Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage
```



3 powershell 运行部分命令权限问题
```
	此系统上禁止运行脚本  about_Execution_Policies。
	get-ExecutionPolicy  (查询当前策略设置)
	set-ExecutionPolicy RemoteSigned (修改策略以执行prowershell脚本)
```


