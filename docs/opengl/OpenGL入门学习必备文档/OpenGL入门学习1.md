# 🔙[OpenGL](/docs/opengl/)



## 绘图方式 
- 古老的绘图
编程作图 - TC 的#include <graphics.h>
640*480 分辨率、16 色

- 新时代绘图-[opengl](www.opengl.org)
1. 与c紧密结合
2. 强大的可移植性：与平台无关
3. 高性能

- 游戏应用：doom3 quake4



## windows下的opengl

- 编译环境
vs c++builder dev-c++

- glut工具包-The OpenGL Utility Toolkit
非必须 但对学习带来方便
[glutdll3.7](http://www.opengl.org/resources/libraries/glut/glutdlls37beta.zip)
The original GLUT has been unsupported for 20 years

- freeglut
官方推荐用[freeglut](https://freeglut.sourceforge.net/)
freeglut 3.6.0 (sourceforge mirror) [Released: 12 June 2024]
[github](https://github.com/freeglut/freeglut)


- 创建opengl工程
```
    vs => c++ : win32 console
    c/c++:常规：附加包含目录：E:\study_2024\opengl_introduction\3rd\gult\include
    链接器：附加库目录：E:\study_2024\opengl_introduction\3rd\gult\libs
    链接器：输入：glut.lib;glut32.lib
    复制glut.dll glut32.dll到exe所在的debug目录
```
main.cpp
```cpp
#include "glut.h"

//#pragma lib "glut.lib"
//#pragma lib "glut32.lib"

void myDisplay(void)
{
	glClear(GL_COLOR_BUFFER_BIT);
	glRectf(-0.5f, -0.5f, 0.5f, 0.5f);
	glFlush();  //保证前面的OpenGL命令立即执行 作用跟 fflush(stdout)类似
}

int main(int argc, char* argv[])
{
	glutInit(&argc, argv);

	//GLUT_RGB 表示使用 RGB 颜色; 有 GLUT_INDEX 表示使用索引颜色
	//GLUT_SINGLE 表示使用单缓冲; GLUT_DOUBLE 使用双缓冲
	glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
	glutInitWindowPosition(100, 100);
	glutInitWindowSize(400, 400);
	glutCreateWindow("第一个 OpenGL 程序");   //并不立即显示到屏幕上;  调用glutMainLoop才能看到窗口
	glutDisplayFunc(&myDisplay);
	glutMainLoop();   //窗口关闭后函数才会返回
	return 0;
}
```


### 代码分析
- #include "glut.h"
```
内部会包含
#include <GL/gl.h>
#include <GL/glu.h>
在win10sdk下面 10.0.22621.0
C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um\gl
C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um
C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x86 
没找到opengl.dll 从F:\Github\opengl\zero_step_opengl1.1\GLEngine\src\external\opengl1.1\dll下载一份
```


























