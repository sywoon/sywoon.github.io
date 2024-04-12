import os
import subprocess
import sys
import time


opArr = [
    "1,打包(debug)",
    "2,adb推送debug包到手机的sdcard/Download目录",
    "3,打包(release)",
    "4,adb推送release包到手机的sdcard/Download目录",
    "5,一条龙debug",
    "6,一条龙release",
    "7,清理游戏数据debug",
]

script_dir = os.path.dirname(os.path.realpath(__file__))

def main():
    print("当前时间为：", time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
    op = input("请选择操作:"+str(opArr))
    if op == "1":
        buildApk(False)
    elif op == "2":
        adbPush(False)
    elif op == "3":
        buildApk(True)
    elif op == "4":
        adbPush(True)
    elif op == "5":  #编译cpp+打包apk+卸载+安装
        buildApk(False)
        adbPush(False)
        #installApk(False)  #有bug 小米node上安装后 不显示隐藏了 且需要uninstall才能安装release版本
    elif op == "6":
        buildApk(True)
        adbPush(True)
        #installApk(True)
    elif op == "7":
        cleanAppData()
    else:
        print("error input")



# 打包
def buildApk(release):
    # 在build目录下执行honor-pack pack命令
    if release:
        #os.system("build_native.bat")  #没看出和subprocess的区别
        #os.system("build_apk.bat")
        subprocess.run(["build_native.bat", "param1"]) 
        subprocess.run(["build_apk.bat"]) 
    else:
        os.system("call build_native.bat")
        os.system("call build_apk_debug.bat")

# adb push
def adbPush(release):
    if release:
        os.system("adb push \"./bin/MyTest-release.apk\" /sdcard/Download")
    else:
        os.system("adb push \"./bin/MyTest-debug.apk\" /sdcard/Download")

# 调试模式需要开启adb安装权限
def installApk(release):
    if release:
        os.system("adb install bin/MyTest-release.apk")
    else:
        os.system("adb install bin/MyTest-debug.apk")
    

# 清理荣耀小游戏数据
def cleanAppData():
    os.system("adb shell pm clear com.xqj.mytest")

main()