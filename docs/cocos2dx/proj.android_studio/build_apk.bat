@echo off

set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "path=C:\Program Files\Android\Android Studio\jbr\bin;%path%"

cls
::ͨ��app/build.gradle ����keystore
pushd %~dp0
call gradlew assembleRelease
popd


::pause