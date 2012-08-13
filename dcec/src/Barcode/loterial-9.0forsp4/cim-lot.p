
DEFINE VAR mdate AS CHAR FORMAT "x(6)".


mdate = SUBSTRING(STRING(TODAY),1,2) + SUBSTRIN(STRING(TODAY),4,2) + SUBSTRING(STRING(TODAY),7,2) + '-'.
/*DISPLAY mdate.*/
/*
OUTPUT TO c:\lot.bpi.
PUT '"'.
 PUT 'lfd' .
    PUT '"'.
PUT SPACE(1).
PUT '-'.
PUT SKIP.
PUT '"'.
   PUT mdate.
   PUT '"'.
PUT SPACE(1).
PUT '-'.
PUT SPACE(1).
PUT '1'.
PUT SPACE(1).
PUT '-'.
PUT SPACE(1).
PUT '-'.
PUT SKIP.
PUT '.'.
    PUT SKIP.
PUT '.'.
PUT SKIP.
PUT '"'.
 PUT 'Y'.
 PUT '"'.
OUTPUT CLOSE.
INPUT FROM c:\lot.bpi.
batchrun = YES.
pause 0 before-hide.
DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:

{gprun.i ""gpwinrun.p"" "('clcn001.w' 'cim')"}.

END.
INPUT CLOSE.*/
FIND FIRST alm_mstr WHERE alm_lot_grp = 'lfd' EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE alm_mstr THEN do:
    alm_lead = mdate.
  IF string(TIME,"hh:mm") >= '00:00' AND string(TIME,"hh:mm") <= '01:00' THEN  alm_seq = 1.
END.
