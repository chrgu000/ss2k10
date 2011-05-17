rem @echo off

rem this parameter must change to svnpath(xcode.bat path).
set svn=C:\tmp\common

set xrc=c:\qadguicli
set xcode=C:\qadguicli\proedit
set src=C:\qadguicli\garbage\src
set cim=C:\qadguicli\garbage\cim
del %src%\*.* /s/q/f/a
del %xrc%\xrc\*.* /s/q/f/a
rem rd %xrc%\xrc
mkdir %xrc%\garbage\src
mkdir /d %xrc%\xrc

rem copy src to srcdir
mkdir %src%
copy /y %svn%\xxbdpro\xxbdpro.p %src%\
copy /y %svn%\xxcomp\xx*.i %src%\
copy /y %svn%\xxcomp\xxc.p %src%\
copy /y %svn%\xxcomp\xxcomp.p %src%\
copy /y %svn%\xxcomp\xxcompil.p %src%\
copy /y %svn%\xxmsgiq.p %src%\
copy /y %svn%\xxlbliq\*.p %src%\
copy /y %svn%\xxgettab\*.* %src%\
copy /y %svn%\xxmeiq\*.p %src%\

rem Xcode.
cd /d %src%
%xcode%\xcode -d %xrc%\xrc xx*.p
%xcode%\xcode -d %xrc%\xrc xx*.i
%xcode%\xcode -d %xrc%\xrc xx*.v

copy %cim%\*.cim %xrc%\xrc\c.cim

rem convert.
mkdir %xrc%\gui
if %1=="A" goto exitme
echo srcSearchPath=%src%> %xrc%\convert.tmp
echo targetDir=%xrc%\gui>> %xrc%\convert.tmp
echo workDir=%xrc%>> %xrc%\convert.tmp
%xcode%\convert.exe -r -ini=%xrc%\convert.tmp %src%\xx*.p>%xrc%\convert.log
%xcode%\convert.exe -r -ini=%xrc%\convert.tmp %src%\xx*.i>>%xrc%\convert.log
rem del %xrc%\convert.tmp /s/q/f/a

:exitme
