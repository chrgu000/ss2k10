SET PROWRK=f:\appeb2\batch\
SET PROBAT=\\qadtemp\appeb2\batch

SET DLC=\\qadtemp\appeb2\dlc91d
SET PROBUILD=\\qadtemp\appeb2\dlc91d\probuild
SET PROMSGS=\\qadtemp\appeb2\dlc91d\promsgs
SET PROPATH=.,\\qadtemp\appeb2\batch\prg,\\qadtemp\appeb2\mfgchuimod,\\qadtemp\appeb2\mfgchui,\\qadtemp\appeb2\mfgchui\bbi,\\qadtemp\appeb2\mfgchui\images.pl,\\qadtemp\appeb2\mfgchui\triggers,\\qadtemp\appeb2\mfgchui\xrc,\\qadtemp\appeb2\mfggui,\\qadtemp\appeb2\mfggui\triggers,\\qadtemp\appeb2\mfggui\qxo


cd %PROWRK%\outbox

%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\prodeb2.pf -b -p F:\appeb2\batch\QADtoCRM\salesdetail.p > %PROWRK%\outbox\QADtoCRMSale.out
%DLC%\bin\prowin32.exe -ininame %PROBAT%\progress_prod.bch -pf %PROBAT%\para\prodeb2.pf -b -p F:\appeb2\batch\QADtoCRM\QADToCRM.p  > %PROWRK%\outbox\QADtoCRM01.out
cd %PROWRK%