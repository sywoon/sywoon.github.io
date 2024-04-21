# 🔙[CocosCreator](/README?id=🔸cocoscreator引擎)
游戏引擎学习和分析

[src 3.*](https://github.com/cocos/cocos-engine)
  - 重写底层
[src 2.*](https://github.com/cocos/engine-native)
  - 基于cocos2dx3.9
[第三方库](https://github.com/cocos/cocos-engine-external)
[插件](https://github.com/cocos/cocos-creator-extensions)
[官方案例](https://github.com/baiyuwubing/cocos-creator-examples)
[第三方案例文档](https://github.com/cocos/awesome-cocos)



## [cocos-engine-external](docs/cocoscreator/cocos-engine-external.md)


## 日积月累


### 修改模拟器默认大小
  https://docs.cocos.com/creator/3.0/manual/zh/editor/preview/
  cocos 2.*
    CocosCreator\resources\cocos2d-x\simulator\win32\config.json
  cocos 3.*
  先找到引擎版本文件夹
    C:\ProgramData\cocos\editors\Creator\3.8.0
    C:\ProgramData\cocos\editors\Creator\3.8.0\resources\resources\3d\engine\native\simulator\Release
  没找到类似的配置 exe启动就写死这么大?

```
  electron中 设置初始大小
  new BrowserWindow({
    width: 800,
    height: 600,
```



