@echo off
REM Script to start multi-user session of MFG/PRO
 
REM tokens:
REM &DLC = Progress Directory
REM &CLIENT-DB-CONNECT = command line to connect to each db in dbset
 
SET DLC=C:\Progress10b\OpenEdge
SET PATH=%PATH%;%DLC%\bin
SET PROMSGS=%DLC%\promsgs
SET PROTERMCAP=%DLC%\protermcap
SET PROPATH=.,D:\Vmware\vm_gui_eb21sp6_no_db,D:\Vmware\vm_gui_eb21sp6_no_db\bbi,D:\Vmware\vm_gui_eb21sp6_no_db\images.pl
 
REM
REM Start MFG/PRO.
REM
 
%DLC%\bin\prowin32 -rereadnolock -c 30 -d mdy -yy 1920 -Bt 350 -D 100 -mmax 3000 -nb 200 -s 128 -noshvarfix -pf D:\Vmware\vm_gui_eb21sp6_no_db\Demonstration.pf -cpstream GB2312 -cpinternal GB2312  -ininame D:\Vmware\vm_gui_eb21sp6_no_db\Demonstration.ini -p mf.p
