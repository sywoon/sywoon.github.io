# 🔙[cocos2dx](/docs/cocos2dx/)
龙珠项目编译相关


## ios工程编译问题
1. signing & capabilities 报错
bundle和provision都选对了development还是错误
解决: build settings:code signning identity 选择正确的p12证书


2. Multiple commands 
Showing Recent Issues
Multiple commands produce '/Users/s-mac/Library/Developer/Xcode/DerivedData/DragonBall-anrptvvtsjmpjsdaxweiozsjzqxv/Build/Products/Debug-iphoneos/DragonBall-appstore.app/Info.plist'
解决：
```
  a. 主工程属性:Build Phases:Copy Bundle Resources 和 Compile Sources
  查看有没重复添加的 删除多余的 ； 可通过拖拉方式 按文件名排序 更好查看
  b. build settings:查看info.plist路径 和 copy bundle resources中的 和 
  工程目录树中的info是否一致
  发现：build settings中的是${TARGET_NAME}/Info.plist = DragonBall-appstroe/Info.plist 而另外两个这是proj.ios_mac/ios/Info.plist
  全部统一用appstroe目录下的info.plist config.plist
  c. 路径修改为
  ${TARGET_NAME}/Info.plist =>　DragonBall-appstore/Info.plist
   取消目录树中info勾选 DragonBall-appstore 
   另外copy bundle resource中删除plist
```

MATLC244VB































