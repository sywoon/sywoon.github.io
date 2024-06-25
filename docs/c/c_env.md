

# windows下vscode配置c/c++调试环境
[参考](https://cloud.tencent.com/developer/article/2282951)
[llvm](https://llvm.org/)  本次使用18.1.6

## 需要的插件
c/c++; c++ intellisense; CodeLLDB;

## 新建一个cpp文件 后续操作需要
```
#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main()
{
    vector<string> msg {"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};

    for (const string& word : msg)
    {
        cout << word << " ";
    }
    cout << endl;
}
```

## 配置工程调试
- tasks.json
```
  菜单：终端：配置默认生成任务：c/c++ clang++
  得到tasks.json 参数中"${file}",下面新增："-std=c++17",
```

- c_cpp_properties.json
```
  ctrl+shift+p : c/c++编辑配置(json)
  修改"compilerPath": "cl.exe",为
  "compilerPath": "C:\\Program Files\\LLVM\\bin\\clang++.exe",
  可以从上面的tasks.json中得到这个地址 也和本地安装llvm.exe所在目录一致
```

## 编译exe
菜单：终端：运行生成任务  ctrl+shift+b
得到exe ilk pdb  


## 调试配置 launch.json
菜单：运行：添加配置：c++(gdb/lldb) 在mac中还会有一个clang++的选择 win中没有  
手动新增一份调试配置到configurations数组内部
```
"configurations": [
        {
            "name": "clang++ - 生成和调试活动文件",
            "type": "lldb",
            "request": "launch",
            "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
            "args": [],
            "cwd": "${fileDirname}",
            "preLaunchTask": "C/C++: clang++ 生成活动文件",    注意这里的名字要和tasks中相同
        }
    ]
```
- 遗留问题：可以调试 但是c++下看不了变量值





