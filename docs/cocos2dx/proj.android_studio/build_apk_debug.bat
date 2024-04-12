@echo off

set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"

cls
pushd %~dp0
::call gradlew assembleDebug --stacktrace --debug --scan
call gradlew assembleDebug --stacktrace --info
popd


::pause