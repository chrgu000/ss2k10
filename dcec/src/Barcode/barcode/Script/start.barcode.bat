REM Script to start database server.
 
REM tokens:
REM &DLC = Progress Directory
REM &LOOP-DB-START = start of database loop
REM &LOOP-DB-END = end of database loop
REM &START-SERVER = command line to start current DB in database loop
 
SET DLC=d:\mfg\DLC91d
SET PATH=%PATH%;%DLC%
SET PROMSGS=%DLC%\promsgs
SET PROTERMCAP=%DLC%\protermcap
 
REM loop-db-start
  %DLC%\bin\_mprosrv d:\mfg\eb2_sp8\mfgsvr\db\mfgdemo -L 8000 -c 350 -B 1000 -S mfgdemo -N TCP
  %DLC%\bin\_mprosrv d:\mfg\eb2_sp8\mfgsvr\db\hlpdemo -L 8000 -c 350 -B 1000 -S hlpdemo -N TCP
  %DLC%\bin\_mprosrv d:\mfg\eb2_sp8\mfgsvr\db\admdemo -L 8000 -c 350 -B 1000 -S admdemo -N TCP
  %DLC%\bin\_mprosrv d:\yfkbc\db\barcode -L 8000 -c 350 -B 1000 -S barcode -N TCP
REM loop-db-end
pause
