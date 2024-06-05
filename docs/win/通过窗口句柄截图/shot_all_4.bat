@echo off

::bug 需要bat置顶 才能将目标窗口置顶； 但是第一次执行就被第一个窗口给顶了 导致后续的窗口没能置顶
::  可以单次调用 或 换别的方式 通过截自己 而非屏幕区域

pushd %~dp0
:: 0:微信 1:抖音 2:QQ 3:淘宝
powershell %~dp0screenshot4.ps1 wx "‘微信开发者工具 Stable v1.06.2206090’"
timeout /T 3 /NOBREAK

powershell %~dp0screenshot4.ps1 dy "抖音开发者工具前置管理页"
timeout /T 3 /NOBREAK

powershell %~dp0screenshot4.ps1 qq "QQ小程序开发者工具"
timeout /T 3 /NOBREAK

powershell %~dp0screenshot4.ps1 tb "淘宝开发者工具" "mini_taobao"
timeout /T 3 /NOBREAK

popd