@echo off
REM Script to start multi-user session of MFG/PRO
 
REM tokens:
REM &DLC = Progress Directory
REM &CLIENT-DB-CONNECT = command line to connect to each db in dbset
 
SET DLC=d:\mfg\dlc91d
SET PATH=%PATH%;%DLC%
SET PROMSGS=%DLC%\promsgs
SET PROTERMCAP=%DLC%\protermcap
SET PROPATH=.,D:\yfk\Guicli,d:\mfg\eb2sp5\guicli,d:\mfg\eb2sp5guicli\bbi,D:\yfk\LOGO
 
REM
REM Start MFG/PRO.
REM
 
%DLC%\bin\prowin32 -c 30 -d mdy -yy 1920 -Bt 350 -D 100 -mmax 3000 -nb 200 -s 63 -noshvarfix -p bcmf.p -pf D:\yfkbc\script\barcode.pf -ininame progress.svg  
