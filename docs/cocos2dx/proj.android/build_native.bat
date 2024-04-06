@echo off

set "path=D:\Ard_Env\android-ndk-r10e;%path%"
set "COCOS2DX=%~dp0../../../"
set "NDK_MODULE_PATH=%COCOS2DX%;%COCOS2DX%/cocos2dx/platform/third_party/android/prebuilt"

set "COCOS2DX_ROOT=%~dp0/../../.."
set "APP_ROOT="%~dp0/..""
set "APP_ANDROID_ROOT=%~dp0"
set "no_pause=%1"

echo "NDK_ROOT = %NDK_ROOT%"
echo "COCOS2DX_ROOT = %COCOS2DX_ROOT%"
echo "APP_ROOT = %APP_ROOT%"
echo "APP_ANDROID_ROOT = %APP_ANDROID_ROOT%"
echo "NDK_MODULE_PATH = %NDK_MODULE_PATH%"
echo.


cls
::call ndk-build.cmd clean
call ndk-build.cmd 

::ndk-build.cmd -C "%APP_ANDROID_ROOT%" NDK_MODULE_PATH=%COCOS2DX_ROOT%:%COCOS2DX_ROOT%/cocos2dx/platform/third_party/android/source

if "%no_pause%" NEQ "no_pause" pause

