@echo off
del xrc\* /Q
cd src
..\xcode -d ..\xrc *
pause
