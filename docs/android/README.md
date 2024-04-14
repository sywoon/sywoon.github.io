# 🔙[ard](/README?id=🔸Ard日常)


## android日常
[android studio](https://developer.android.google.cn/studio?hl=zh-cn)
[gradle下载](https://mirrors.cloud.tencent.com/gradle/)



## as日常
1. 多开项目
   - file:open / open recent
   - 打开某个工程后 会提示 用当前的窗口 还是 开新窗口
2. 控制台错误提示乱码
   [参考](https://blog.csdn.net/jankingmeaning/article/details/104772104)
   - as中双击shift 打开的窗口中输入vmoption
   - 选择Edit Custom VM Options...
   - 第一次会创建一个新的文件studio64.exe.vmoptions
   - 新增  -Dfile.encoding=UTF-8  重启as即可


## [as编程](/docs/android/androidstudio.md)

- [pradle-wrapper.properties](distributionUrl=https://mirrors.cloud.tencent.com/gradle/gradle-7.4.2-all.zip)

- build.gradle project
```
   repositories {
        maven { url 'https://mirrors.cloud.tencent.com/maven/' }
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        maven { url "https://nexus.bsdn.org/content/groups/public/" }
        maven { url "https://jitpack.io" }
        jcenter()
        maven { url 'https://dl.google.com/dl/android/maven2/' }
        google()
    }

   dependencies {
     classpath 'com.android.tools.build:gradle:4.2.2'
```

- build.gradle module
```
   namespace 'org.cocos.hello'
```

- build cmd
```
  调试：
   gradlew clean
   gradlew build --stacktrace
  出包:
   set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
   set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"
   call gradlew assembleDebug
   call gradlew assembleRelase
```


 

