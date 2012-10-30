SET PROWRK=\\qadtemp\appeb2\batch\outbox
SET PROBAT=\\qadtemp\appeb2\batch
SET PROGRAM=\\qadtemp\appeb2\batch\prg\PPIF
SET DLC=\\qadtemp\appeb2\dlc91d
SET PROBUILD=\\qadtemp\appeb2\dlc91d\probuild
SET PROMSGS=\\qadtemp\appeb2\dlc91d\promsgs
SET PROPATH=.,\\qadtemp\appeb2\batch\prg,\\qadtemp\appeb2\mfgchui,\\qadtemp\appeb2\mfgchui\bbi,\\qadtemp\appeb2\mfggui,\\qadtemp\appeb2\mfgchui\images.pl,\\qadtemp\appeb2\mfgchui\triggers,\\qadtemp\appeb2\mfgchui\xrc

%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\inqyeb2.pf -b -p %PROGRAM%\yyppifload.p > %PROWRK%\ppif-load.out
%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\inqyeb2.pf -b -p %PROGRAM%\yyppifim01.p > %PROWRK%\ppif-im01.out
%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\inqyeb2.pf -b -p %PROGRAM%\yyppifim02.p > %PROWRK%\ppif-im02.out
%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\inqyeb2.pf -b -p %PROGRAM%\yyppifbm01.p > %PROWRK%\ppif-bm01.out
%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\inqyeb2.pf -b -p %PROGRAM%\yyppifbm02.p > %PROWRK%\ppif-bm02.out


