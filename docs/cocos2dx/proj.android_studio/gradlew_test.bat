@echo off

set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
::实际不需要 为了java版本一致 就同步设置
set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"

where java
call gradlew tasks

pause

