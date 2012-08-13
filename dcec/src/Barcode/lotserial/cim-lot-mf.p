{mfdeclre.i}
DEFINE VAR mdate AS CHAR.


mdate = SUBSTRING(STRING(TODAY),1,2) + SUBSTRIN(STRING(TODAY),4,2) + SUBSTRING(STRING(TODAY),7,2) + '-'.
/*DISPLAY mdate.*/

OUTPUT TO c:\lot.inp.
PUT '"' + 'mfg' + '"'.
PUT SPACE(1).
PUT '"' + '"'.
PUT SKIP.
PUT '"' + 'clcn001.p' + '"'.
PUT SKIP.
PUT '"' + 'lfd' + '"'.
PUT SPACE(1).
PUT '-'.
PUT SKIP.
PUT '"' + mdate + '"'.
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
PUT '"' + 'Y' + '"'.
OUTPUT CLOSE.
INPUT FROM c:\lot.inp.
/*batchrun = YES.
pause 0 before-hide.
DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:*/

/*{gprun.i ""gpwinrun.p"" "('clcn001.w' 'cim').*/
RUN mf.r.
/*END.*/
INPUT CLOSE.
