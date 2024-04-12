# 原生打包工具
#  by NoRain
# Date: 2020/05/20

import os
import subprocess

hasPydub = False

try:
    from pydub import AudioSegment
    hasPydub = True
except ImportError:
    hasPydub = False


#路径约定
# 1.所有路径都以/分割
# 2.当遇到os.system来运行win32的批命令时 再临时转为\\

#文件长度警告 在行末尾添加 # noqa: E501


# D:\HK_Games\BoxGame\box_mini\box_android_my\tools
tools_dir = os.path.dirname(os.path.realpath(__file__))
project_ard_dir = os.path.join(tools_dir, "../")
project_root_dir = os.path.join(project_ard_dir, "../../")
target_bin_dir = os.path.join(project_ard_dir, "bin/")

tools_dir = tools_dir.replace("\\", "/")
project_ard_dir = project_ard_dir.replace("\\", "/")
project_root_dir = project_root_dir.replace("\\", "/")
target_bin_dir = target_bin_dir.replace("\\", "/")

#print("tools_dir", tools_dir)
#print("project_ard_dir", project_ard_dir)
#print("project_root_dir", project_root_dir)
#print("target_bin_dir", target_bin_dir)


#声音配置路径
soundPath = "bin/res/sound"
soundFilter = ["bin/res/sound/bg"]
mp3Path = os.path.join(project_ard_dir, soundPath).replace("\\", "/")


def start():
    print("当前时间"+os.popen("date /t").read())
    print("请输入打包类型：1.复制master 2.复制release 3.仅仅拷贝bundle.js(master) 4.删除update文件夹 5.刷新DCC 6.打包apk 7.打包+推送 8.复制APK到bin目录 9.安装APK 10.推送APK 11.mp3转ogg")
    type = input()
    if type == "1":
        bat_file = os.path.join(tools_dir, "sync_client_bin.bat")
        print("正在执行"+bat_file, project_root_dir, "kbx_master", target_bin_dir)
        subprocess.run([bat_file, project_root_dir, "kbx_master", target_bin_dir]) 
        
    elif type == "2":
        bat_file = os.path.join(tools_dir, "sync_client_bin.bat")
        print("正在执行"+bat_file, project_root_dir, "kbx_release", target_bin_dir)
        subprocess.run([bat_file, project_root_dir, "kbx_release", target_bin_dir])
        
    elif type == "3":
        file_from = os.path.join(project_root_dir, "kbx_master/client/bin/js/bundle.js")
        file_to = os.path.join(target_bin_dir, "js/bundle.js")
        file_from = file_from.replace("/", "\\")
        file_to = file_to.replace("/", "\\")
        print("copy /Y " + file_from + " " + file_to)
        os.system("copy /Y " + file_from + " " + file_to)
        
    elif type == "4":
        # 删除bin目录下的update文件夹
        updatePath = os.path.join(target_bin_dir, "update")
        updatePath = updatePath.replace("/", "\\")
        if os.path.exists(updatePath):
            print("rd /s /q "+updatePath)
            os.system("rd /s /q "+updatePath)
            print("删除update文件夹成功")
        else:
            print("update文件夹不存在")
            
    elif type == "5":
        os.system("cd " + target_bin_dir + " && layadcc .")
    
    elif type == "6":
        buildApk(True)
    
    elif type == "7":
        buildApk(True)
        adbPush(True)
        
    elif type == "8":
        isdebug = False
        file_from = ""
        if isdebug:
            file_from = os.path.join(project_ard_dir, "platforms\\android_studio\\app\\build\\outputs\\apk\\debug\\app-debug.apk")
        else:
            file_from = os.path.join(project_ard_dir, "platforms\\android_studio\\app\\build\\outputs\\apk\\release\\app-release.apk")
            
        file_to = project_ard_dir
        file_from = file_from.replace("/", "\\")
        file_to = file_to.replace("/", "\\")
        if os.path.exists(file_from):
            print("copy /Y " + file_from + " " + file_to)
            os.system("copy /Y " + file_from + " " + file_to)
        else:
            print("apk文件不存在", file_from)
            
    elif type == "9":
        file_from = os.path.join(project_ard_dir, "platforms\\android_studio\\app\\build\\outputs\\apk\\release\\app-release.apk")
        os.system("adb install " + file_from)
        
    elif type == "10":
        adbPush(True)
        
    elif type == "11":
        # 判断是否存在 AddioSegment 库
        if hasPydub is False:
            print("正在安装pydub库,记得还要解压ffmpeg到你喜欢的目录,然后把对应的bin目录地址添加到环境变量path中")
            os.system("pip install pydub")
        # 遍历sound文件夹 把所有的MP3转换成ogg 并且转为单声道, 采样率为22050, 位深度为16
        # layanative 的音效必须是 ogg格式,背景音乐必须是mp3格式
        convert_mp3_to_ogg_path(mp3Path, soundFilter, False)
        print("转换完成")
        
    else:
        print("输入错误")



def buildApk(release):
    bat_file = ""
    if release:
        bat_file = os.path.join(project_ard_dir, "platforms\\android_studio\\build_apk.bat")
    else:
        bat_file = os.path.join(project_ard_dir, "platforms\\android_studio\\build_apk_debug.bat")
    print("make pkg", bat_file)
    subprocess.run([bat_file]) 

# adb push
def adbPush(release):
    file_from = ""
    if release:
        file_from = os.path.join(project_ard_dir, "platforms\\android_studio\\app\\build\\outputs\\apk\\release\\app-release.apk")
    else:
        file_from = os.path.join(project_ard_dir, "platforms\\android_studio\\app\\build\\outputs\\apk\\debug\\app-debug.apk")
    cmd = "adb push " + file_from + " /sdcard/Download"
    os.system(cmd)


def convert_mp3_to_ogg(soundFile):
    if not soundFile.endswith(".mp3"):
        return
    oggFile = soundFile.replace(".mp3", ".ogg")
    if os.path.exists(oggFile):
        return
    
    sound = AudioSegment.from_mp3(soundFile)
    sound = sound.set_channels(1)
    sound = sound.set_frame_rate(22050)
    sound = sound.set_sample_width(2)
    sound.export(oggFile, format="ogg")  
    print("to ogg", soundFile)


def convert_mp3_to_ogg_path(soundPath, soundFilter, removeOld):
    soundPath = soundPath.replace("\\", "/")
    print("soundPath", soundPath)
    for root, dirs, files in os.walk(soundPath):
        root = root.replace("\\", "/")  #win32下 新加的路径以windows方式bin/res/sound\bg
        relative = root.replace(project_ard_dir, "")

        # 如果是过滤文件夹中的文件,则跳过
        if relative in soundFilter:
            #print("find in filter", relative)
            continue
                
        for file in files:
            if file.endswith(".mp3"):
                fullPath = os.path.join(root, file)
                convert_mp3_to_ogg(fullPath)
                if removeOld:  # 删除原文件
                    os.remove(fullPath)
                    print("remove file", fullPath)



# root:当前扫描的文件夹全路径 D:\HK_Games\BoxGame\box_mini\box_android_my\bin\res\sound\bg
# dirs:只是文件夹名 没路径['bg', 'role', 'ui']  files也一样['101.mp3', '102.mp3',
# walk会一轮一轮调用下去 包含子文件夹 相当于遍历整颗ui树
def walt_path_test(mp3Path):
    for root, dirs, files in os.walk(mp3Path):
        root = root.replace("\\", "/")  #win32下 新加的路径以windows方式bin/res/sound\bg 末尾没\
        print(root, dirs)
        print(files)
        relative = root.replace(project_ard_dir, "")
        print(relative)
        print("-----")
        
        if relative in soundFilter:
            print("find filter", root)
    
    
    
start()
