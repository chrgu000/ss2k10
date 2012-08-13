{mfdtitle.i}
    DEF VAR path AS CHAR FORMAT "x(40)" LABEL "输入".
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR succ AS LOGICAL.
DEF VAR mdate AS DATE.
DEF VAR START_date AS DATE.
DEF VAR END_date AS DATE.
DEF VAR isend AS LOGICAL.
DEF VAR ismodi AS LOGICAL.
DEF VAR er_qty AS CHAR.
DEF TEMP-TABLE  t_bom
    FIELD t_bom_par LIKE ps_par
    FIELD t_bom_comp LIKE ps_comp
    FIELD t_bom_qty LIKE ps_qty_per
    FIELD t_bom_sess LIKE mfguser
    INDEX t_bom_sess IS PRIMARY t_bom_sess ASC.
DEF FRAME a
    
    SKIP(0.5)
    path COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.

    REPEAT:
    FOR EACH t_bom WHERE t_bom_sess = mfguser EXCLUSIVE-LOCK:
       DELETE t_bom.
    END.
    UPDATE  path WITH FRAME a.
    IF path = '' THEN DO: 
        MESSAGE "路径为空！" VIEW-AS ALERT-BOX ERROR.
        UNDO,RETRY.
    END.
    succ = YES.
      create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = FALSE.
    
       chWorkbook = chExcelApplication:Workbooks:OPEN(path) .
      chWorkSheet = chExcelApplication:Sheets:Item(1).  
       chExcelApplication:Sheets:Item(1):SELECT().
       rowstart = 2.
       DO WHILE chworksheet:range('a' + string(rowstart)):VALUE <> ?:
          CREATE t_bom.
          t_bom_sess = mfguser.
          crange = 'a' + STRING(rowstart).
          t_bom_par = string(chWorkSheet:Range(crange):VALUE).
          crange = 'b' + STRING(rowstart).
          t_bom_comp = string(chWorkSheet:Range(crange):VALUE).
          crange = 'c' + STRING(rowstart).
          t_bom_qty = decimal(chWorkSheet:Range(crange):VALUE) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
              er_qty = chWorkSheet:Range(crange):VALUE.
              MESSAGE  er_qty ' 无效数字！' VIEW-AS ALERT-BOX ERROR.
              succ = NO.
              LEAVE.
          END.
          rowstart = rowstart + 1.
       END.
      /* chWorkbook = chExcelApplication:Workbooks:CLOSE(path) .*/
   RELEASE OBJECT chWorksheet.
     RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   
       IF NOT succ THEN UNDO,RETRY.
       {partconv.i "t_bom" "t_bom_par" "t_bom_comp" "t_bom_sess"}
        FIND FIRST CODE_mstr WHERE CODE_fldname = 'bom_error_log' AND CODE_value <> '' NO-LOCK NO-ERROR.
        IF AVAILABLE CODE_mstr THEN DO:
       mdate = TODAY. 
           OUTPUT TO VALUE(CODE_value).
        FOR EACH t_bom WHERE t_bom_sess = mfguser EXCLUSIVE-LOCK:
            succ = YES.
            ismodi = NO.
            isend = NO.
            FIND FIRST pt_mstr WHERE pt_part = t_bom_par NO-LOCK NO-ERROR.
            IF NOT AVAILABLE pt_mstr THEN DO:
              PUT UNFORMAT string(mdate) ' 父件 ' t_bom_par ' 不存在！' SKIP.
              succ = NO.
              END.
              ELSE t_bom_par = IF pt_bom <> '' THEN pt_bom ELSE pt_part.
            IF succ THEN DO:
           
                  FIND FIRST pt_mstr WHERE pt_part = t_bom_comp NO-LOCK NO-ERROR.
            IF NOT AVAILABLE pt_mstr THEN DO:
              PUT UNFORMAT STRING(mdate) ' 子件 ' t_bom_comp ' 不存在！' SKIP.
              succ = NO.
              END. 
              END.
              IF succ THEN DO:
                 FIND LAST ps_mstr USE-INDEX ps_parcomp WHERE ps_par = t_bom_par AND ps_comp = t_bom_comp NO-LOCK NO-ERROR.
                 IF AVAILABLE ps_mstr THEN DO:
                    IF ps_start < mdate THEN do:
                        START_date = ps_start.
                        ismodi = YES.
                    END.
                    ELSE 
                        IF ps_start > mdate THEN DO:
                      END_date = ps_start - 1.
                        isend = YES.
                            END.
                    
                 END.
                 
                 OUTPUT TO VALUE(mfguser) APPEND.
                 IF ismodi THEN DO:
                    /* PUT "@@batchload bmpsmt.p" SKIP.*/
                  PUT UNFORMAT t_bom_par SKIP.
                  PUT UNFORMAT t_bom_comp  '-' string(START_date) SKIP.
                  PUT UNFORMAT STRING(t_bom_qty) '- -' STRING(mdate - 1) SKIP.
                  PUT '.' SKIP.
                  /*PUT '@@end' SKIP.*/
                  
                     END.
               /*  PUT "@@batchload bmpsmt.p" SKIP.*/
                  PUT UNFORMAT t_bom_par SKIP.
                  PUT UNFORMAT t_bom_comp  '-' string(mdate) SKIP.
                IF NOT isend  THEN PUT UNFORMAT STRING(t_bom_qty) SKIP.
                  ELSE PUT UNFORMAT STRING(t_bom_qty) '- -' STRING(END_date) SKIP.
                  PUT '.' SKIP.
                 /* PUT '@@end' SKIP.*/
                 
                 OUTPUT CLOSE.
                 
       
               
              END.
        END.
       /* RUN bcmgbdpro.p(INPUT mfguser, INPUT 'out.txt').*/
        batchrun = YES.
        INPUT FROM VALUE(mfguser).
        OUTPUT TO VALUE ('out.txt').
        {gprun.i ""bmpsmt.p""}
            OUTPUT CLOSE.
           INPUT CLOSE.
          OS-DELETE VALUE(mfguser).
          OS-DELETE VALUE('out.txt').
          FOR EACH t_bom WHERE t_bom_sess = mfguser EXCLUSIVE-LOCK:
              FIND LAST ps_mstr WHERE ps_par = t_bom_par AND ps_comp = t_bom_comp AND ps_start = mdate AND ps_qty_per = t_bom_qty NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ps_mstr THEN 
                  PUT UNFORMAT STRING(mdate) ' 父件 ' t_bom_par ' 子件 ' t_bom_comp ' CIM失败！' SKIP.
             DELETE t_bom.
          END.
        OUTPUT CLOSE.
        END.
        ELSE DO:
            MESSAGE '无效log路径！' VIEW-AS ALERT-BOX ERROR.
        END.
           
           
           
           
           END.
