@echo off

set "no_pause=%1"

::call ant clean debug
call ant debug

if "%no_pause%" NEQ "no_pause" pause


