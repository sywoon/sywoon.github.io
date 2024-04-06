@echo off

set "no_pause=%1"

if Exist AndroidManifest.xml (
    rename AndroidManifest.xml AndroidManifest_temp.xml
    rename AndroidManifest_Release.xml AndroidManifest.xml
)

::call ant clean debug
::自动签名 ant.properties
::有bug 运行崩溃 ard签名方式改了？ v1 v2
call ant release

::or 手动签名
::call ant debug
::jarsigner -verbose -keystore xqj.keystore bin/MyTest-debug.apk
::zipalign -v 4 bin/product_signed.apk bin/product_final.apk


rename AndroidManifest.xml AndroidManifest_Release.xml
rename AndroidManifest_temp.xml AndroidManifest.xml

if "%no_pause%" NEQ "no_pause" pause


