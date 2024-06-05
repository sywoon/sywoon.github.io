
::bug 需要bat置顶 才能将目标窗口置顶； 但是第一次执行就被第一个窗口给顶了 导致后续的窗口没能置顶
::  可以单次调用 或 换别的方式 通过截自己 而非屏幕区域

:: 0:微信 1:抖音 2:QQ 3:淘宝
powershell %~dp0screenshot02.ps1 0
timeout /T 3 /NOBREAK

powershell %~dp0screenshot02.ps1 1
timeout /T 3 /NOBREAK

powershell %~dp0screenshot02.ps1 2
timeout /T 3 /NOBREAK

powershell %~dp0screenshot02.ps1 3
timeout /T 3 /NOBREAK



