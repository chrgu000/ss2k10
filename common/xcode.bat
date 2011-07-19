rem @echo off

rem this parameter must change to svnpath(xcode.bat path).
set svn="C:\Docume~1\zy\LocalS~1\Temp\comp"

set xrc=c:\qadguicli
set xcode=C:\qadguicli\proedit
set src=C:\qadguicli\garbage\src
set cim=C:\qadguicli\garbage\cim
del %src%\*.* /s/q/f/a
del %cim%\*.* /s/q/f/a
del %xrc%\xrc\*.* /s/q/f/a
rem rd %xrc%\xrc
mkdir %src%
mkdir %xrc%\xrc
mkdir %cim%

rem copy src to srcdir
mkdir %src%
copy /y %svn%\xxbdpro\xx*.? %src%\
copy /y %svn%\xxbwmt\xx*.? %src%\
copy /y %svn%\xxcmmt\xx*.? %src%\
copy /y %svn%\xxcomp\xx*.? %src%\
copy /y %svn%\xxdlfhmt\xx*.? %src%\
copy /y %svn%\xxflhusr\xx*.? %src%\
copy /y %svn%\xxgettab\xx*.? %src%\
copy /y %svn%\xxlbldmt\xx*.? %src%\
copy /y %svn%\xxlbliq\xx*.? %src%\
copy /y %svn%\xxmecm\xx*.? %src%\
copy /y %svn%\xxmeiq\xx*.? %src%\
copy /y %svn%\xxmgflh1\xx*.? %src%\
copy /y %svn%\xxmgflh1\l.cim %cim%\xxmgflh1.cim
copy /y %svn%\xxnrgnmt\xx*.? %src%\
copy /y %svn%\xxvifile\xx*.? %src%\
copy /y %svn%\xxvifile\p.cim %cim%\xxvifile.cim

copy /y %svn%\xxmsgiq.p %src%\
copy /y %svn%\xxmsgmt.p %src%\

rem Xcode.
cd /d %src%
%xcode%\xcode -d %xrc%\xrc xx*.p
%xcode%\xcode -d %xrc%\xrc xx*.i
%xcode%\xcode -d %xrc%\xrc xx*.v

copy %cim%\*.cim %xrc%\xrc\p.cim

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
