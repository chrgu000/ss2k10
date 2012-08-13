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
DEF TEMP-TABLE  t_part
    FIELD t_part_id LIKE pt_part
    FIELD t_part_desc LIKE pt_desc1
    FIELD t_part_draw LIKE pt_draw
    FIELD t_part_sess LIKE mfguser
    INDEX t_part_sess IS PRIMARY t_part_sess ASC.
DEF FRAME a
    
    SKIP(0.5)
    path COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.

    REPEAT:
    FOR EACH t_part WHERE t_part_sess = mfguser EXCLUSIVE-LOCK:
       DELETE t_part.
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
          CREATE t_part.
          t_part_sess = mfguser.
          crange = 'a' + STRING(rowstart).
          t_part_id = string(chWorkSheet:Range(crange):VALUE).
          crange = 'b' + STRING(rowstart).
          t_part_desc = string(chWorkSheet:Range(crange):VALUE).
          crange = 'c' + STRING(rowstart).
          t_part_draw = string(chWorkSheet:Range(crange):VALUE).
         
          rowstart = rowstart + 1.
       END.
     /*  chWorkbook = chExcelApplication:Workbooks:CLOSE(path) .*/
   RELEASE OBJECT chWorksheet.
     RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   
       IF NOT succ THEN UNDO,RETRY.
       {partconv.i "t_part" "t_part_id" """" "t_part_sess"}
        FIND FIRST CODE_mstr WHERE CODE_fldname = 'part_error_log' AND CODE_value <> '' NO-LOCK NO-ERROR.
        IF AVAILABLE CODE_mstr THEN DO:
       mdate = TODAY. 
           OUTPUT TO VALUE(CODE_value).
        FOR EACH t_part WHERE t_part_sess = mfguser EXCLUSIVE-LOCK:
            OUTPUT TO VALUE(mfguser) APPEND.

            /*cim*/
             OUTPUT CLOSE.
        END.
        RUN bcmgbdpro.p(INPUT mfguser, INPUT 'out.txt').
          OS-DELETE VALUE(mfguser).
          OS-DELETE VALUE('out.txt').
          FOR EACH t_part WHERE t_part_sess = mfguser EXCLUSIVE-LOCK:
              FIND FIRST pt_mstr WHERE pt_part = t_part_id AND pt_desc1 = SUBSTR(t_part_desc,1,24) AND pt_desc2 = SUBSTR(t_part_desc,25) AND pt_draw = t_part_draw NO-LOCK NO-ERROR.
              IF NOT AVAILABLE pt_mstr THEN
                  PUT UNFORMAT string(mdate) ' 零件 ' t_part_id ' ' t_part_desc ' CIM失败！' SKIP.
                  DELETE t_part.
          END.
        OUTPUT CLOSE.
        END.
        ELSE DO:
            MESSAGE '无效log路径！' VIEW-AS ALERT-BOX ERROR.
        END.
           
           
           
           
           END.
