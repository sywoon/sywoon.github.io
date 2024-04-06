@echo off

set "cocos_ard_path=%~dp0../../../cocos2dx/platform/android/java/"

call android update project -p . -t android-29

set cocos_ard_path=%cocos_ard_path:/=\%
pushd %cocos_ard_path%
call android update project -p . -t android-29
popd

call explorer %cocos_ard_path%

pause

#ÊÖ¶¯ÐÞ¸ÄAndroidManifest.xml
#<uses-sdk android:minSdkVersion="22"/>
#<uses-sdk android:targetSdkVersion="29"/>