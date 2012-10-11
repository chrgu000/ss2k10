/*{mfdtitle.i "d+ "}  */
/*{mfdeclre.i "new"}*/
/* {mfdtitle.i "e+"} */

{mfdtitle.i "20120816"}

DEFINE VAR loadfile AS CHARA INITIAL "d:\packingnotes1.xls" FORMAT "X(40)". /*导入文件*/
DEFINE VAR loadsheet AS CHARA INITIAL "sheet1" FORMAT "X(40)". /*导入工作薄*/
DEFINE VAR logfile AS CHARA. /*导入后生成的日志*/
DEFINE VAR i AS INTEGER INIT 3. /*计数*/

DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
DEFINE NEW SHARED VARIABLE chExcelWorksheet AS COM-HANDLE.


DEFINE VARIABLE cim_file AS CHAR FORMAT "x(40)" INIT "d:\DRPsimLoadfile.cim".
DEFINE STREAM cim.


DEFINE WORKFILE xxwk
    FIELD sn AS INT
    FIELD nbr LIKE dsd_nbr
    FIELD shipsite LIKE dss_shipsite
    FIELD site LIKE dsd_site
    FIELD part LIKE dsd_part
    FIELD qty LIKE dsd_qty_con.





FORM
    loadfile     LABEL "选择导入文件" COLON 20
    loadsheet    LABEL "选择导入工作薄" COLON 20
    WITH FRAME  a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D.


REPEAT:
    

    IF loadfile = "" THEN  loadfile =  "d:\packingnotes1.xls".
    IF loadsheet = "" THEN loadsheet = "sheet1".

    UPDATE loadfile loadsheet WITH FRAME a.
    IF SEARCH(loadfile) = ? THEN DO: 
    MESSAGE "文件不存在" VIEW-AS ALERT-BOX ERROR.
    UNDO,RETRY.
    END.

    IF loadfile = "" THEN  loadfile =  "d:\packingnotes1.xls".
    IF loadsheet = "" THEN loadsheet = "sheet1".

    MESSAGE "开始读取Excel数据" VIEW-AS ALERT-BOX. 

    /*{mfselprt.i "printer" 255}*/
    CREATE "Excel.Application" chExcelApplication.
    chExcelWorkbook = chExcelApplication:Workbooks:ADD(loadfile).
    chExcelWorksheet = chExcelApplication:Worksheets(loadsheet).
    
    i = 5.
    FOR EACH xxwk.
        DELETE xxwk.
    END.
    REPEAT:
        i = i + 1.
        IF TRIM(chExcelWorksheet:cells(i,1):TEXT) <> "" THEN DO:
            IF TRIM(chExcelWorksheet:cells(i,12):TEXT) <> "" THEN DO:
                CREATE xxwk.
                ASSIGN xxwk.sn = INT(TRIM(chExcelWorksheet:cells(i,1):TEXT)) 
                       xxwk.nbr = TRIM(chExcelWorksheet:cells(i,8):TEXT)
                       xxwk.shipsite = TRIM(chExcelWorksheet:cells(i,5):TEXT)
                       xxwk.site = TRIM(chExcelWorksheet:cells(i,7):TEXT)
                       xxwk.part = TRIM(chExcelWorksheet:cells(i,3):TEXT)
                       xxwk.qty = INT(TRIM(chExcelWorksheet:cells(i,12):TEXT)).

            END.
        END.
        IF TRIM(chExcelWorksheet:cells(i,1):TEXT) = "" THEN LEAVE.
    END.

   chExcelApplication:VISIBLE = FALSE.
   chExcelWorkbook:CLOSE(FALSE).
   chExcelApplication:QUIT.
   RELEASE OBJECT chExcelApplication.
   RELEASE OBJECT chExcelWorkbook.
   RELEASE OBJECT chExcelWorksheet.

    MESSAGE "读取Excel完毕" VIEW-AS ALERT-BOX. 
    
    OUTPUT TO xxloaddrp.txt.
    FOR EACH xxwk.
        DISP xxwk WITH WIDTH 180 STREAM-IO.
    END.

    OUTPUT CLOSE .

    OUTPUT STREAM cim TO VALUE(cim_file).
    OUTPUT TO d:\unloaddrp.txt.
    FOR EACH xxwk.
       FIND FIRST dsd_det WHERE dsd_domain = global_domain and dsd_nbr = xxwk.nbr 
            AND dsd_part = xxwk.part AND dsd_site = xxwk.site AND dsd_qty_con - (xxwk.qty + dsd_qty_ship) >= 0 NO-LOCK NO-ERROR.
       IF AVAIL dsd_det THEN DO:
        /*PUT STREAM cim UNFORMATTED  "@@BATCHLOAD dsdois.p" SKIP.*/
        PUT STREAM cim "~"" xxwk.nbr "~" " "~"" xxwk.shipsite "~" "  SKIP. 
        PUT STREAM cim "~"" xxwk.site  "~" " " - " " - " " - "SKIP.
        PUT STREAM cim  "~"" xxwk.part "~" " SKIP.
        PUT STREAM cim  "~"" xxwk.qty "~" " SKIP.
        PUT STREAM cim UNFORMATTED "." SKIP.
        PUT STREAM cim  SKIP.
        PUT STREAM cim UNFORMATTED "." SKIP.
        /*PUT STREAM cim UNFORMATTED "@@END" SKIP.*/
       END.
       ELSE DO: 
           DISP xxwk WITH WIDTH 180 STREAM-IO.
       END.
    END.
   OUTPUT STREAM cim CLOSE.

   INPUT FROM VALUE(cim_file).
   OUTPUT TO VALUE(cim_file + ".out").
   /*PAUSE 0 BEFORE-HIDE.*/
   batchrun = YES.
   {gprun.i ""dsdois.p""}
   batchrun = NO.
   OUTPUT CLOSE.
   INPUT CLOSE .

   MESSAGE "导入移仓完毕" VIEW-AS ALERT-BOX. 
  


      /*{mfreset.i}
      {mfgrptrm.i}*/
END.
