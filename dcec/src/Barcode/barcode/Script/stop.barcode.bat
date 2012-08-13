REM file: stop.wtp
REM Script to stop database servers.
 
REM tokens:
REM &DLC = Progress Directory
REM &LOOP-DB-START = start of database loop
REM &LOOP-DB-END = end of database loop
REM &STOP-SERVER = command line to shutdown current DB in database loop
 
SET DLC=d:\mfg\DLC91d
SET PATH=%PATH%;%DLC%
SET PROMSGS=%DLC%\promsgs
SET PROTERMCAP=%DLC%\protermcap
 
REM loop-db-start
  %DLC%\bin\_mprshut d:\mfg\eb2_sp8\mfgsvr\db\mfgdemo -by
  %DLC%\bin\_mprshut d:\mfg\eb2_sp8\mfgsvr\db\hlpdemo -by
  %DLC%\bin\_mprshut d:\mfg\eb2_sp8\mfgsvr\db\admdemo -by
  %DLC%\bin\_mprshut d:\yfkbc\db\barcode -by
REM loop-db-end
 
pause
