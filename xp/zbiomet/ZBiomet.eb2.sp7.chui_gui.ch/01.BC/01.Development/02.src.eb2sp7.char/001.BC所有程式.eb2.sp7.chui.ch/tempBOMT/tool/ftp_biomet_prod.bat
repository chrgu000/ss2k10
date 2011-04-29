@echo off

cd c:\tempBOMT
del /Q .\xrc\*.*

cd src_manual
..\tool\xcode -d ..\xrc\ *.p
..\tool\xcode -d ..\xrc\ *.i
cd ..

cd src_auto
..\tool\xcode -d ..\xrc\ *.p
..\tool\xcode -d ..\xrc\ *.i
cd ..

cd xrc
ftp -s:c:\tempbomt\tool\ftp03.txt
rem ftp01.txt --> 192.168.58.91(vmware)
rem ftp02.txt --> 10.52.20.13(biomet_test)
rem ftp03.txt --> 10.52.20.13(biomet_prod)
cd ..

pause 