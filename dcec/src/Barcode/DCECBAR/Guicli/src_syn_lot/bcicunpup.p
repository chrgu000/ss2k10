{mfdeclre.i}
{bcdeclre.i  }
{bcwin13.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(20)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".
DEF VAR bcprefix AS CHAR.
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)" LABEL "排程单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "张数".
DEF VAR ismodi AS LOGICAL.
DEF VAR bc_po_vend AS CHAR FORMAT "x(8)" LABEL '供应商'.
DEF VAR bc_po_vend1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_po_nbr1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_part1 AS CHAR FORMAT 'x(8)' LABEL "至".
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_date AS DATE LABEL '日期'.
DEF VAR bc_date1 AS DATE LABEL '至'.
DEF TEMP-TABLE b_unp_tmp
    FIELD b_unp_sess LIKE g_sess
    FIELD b_unp_nbr AS CHAR
    FIELD b_unp_job AS CHAR
    FIELD b_unp_part AS CHAR
    FIELD b_unp_qty AS DECIMAL
    FIELD b_unp_mark AS CHAR
    FIELD b_unp_site AS CHAR
    FIELD b_unp_date AS DATE
    INDEX b_unp_sess IS PRIMARY b_unp_sess ASC.
DEF VAR isok AS LOGICAL INITIAL NO.
DEF VAR bc_type AS CHAR FORMAT "x(6)" LABEL "需求源".
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR mdesc AS CHAR FORMAT 'x(10)'.
DEF FRAME bc
    bc_type AT ROW 3 COL 2.5
    mdesc AT ROW 3 COL 15 NO-LABEL
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 5 COL 10
    
    WITH SIZE 30 BY 8 TITLE "计划外出库需求更新"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ENABLE /*bc_type*/ bc_button WITH FRAME bc.
assign
    bc_type = 'i'
    mdesc = '计划外出库'.
DISP bc_type mdesc WITH FRAME bc.
VIEW c-win.
ON 'LEAVE':u OF bc_type
DO:
    ASSIGN bc_type.
    IF bc_type <> 'i' AND bc_type <> 'r' THEN DO:
        MESSAGE '类型只能为i，或r!' VIEW-AS ALERT-BOX ERROR.
        bc_type = 'i'.
        DISP bc_type WITH FRAME bc.
        UNDO,RETRY.
    END.
END.
ON enter OF bc_type
DO:
  ASSIGN bc_type.
    IF bc_type <> 'i' AND bc_type <> 'r' THEN DO:
        MESSAGE '类型只能为i，或r!' VIEW-AS ALERT-BOX ERROR.
        bc_type = 'i'.
        DISP bc_type WITH FRAME bc.
        UNDO,RETRY.
    END.
    ELSE APPLY 'entry':u TO bc_button.
END.
ON CURSOR-DOWN OF bc_type
DO:
    ASSIGN bc_type.
    IF bc_type = '' OR bc_type = 'i' THEN do:
       ASSIGN bc_type = 'r'
        mdesc = '计划外入库'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
     IF bc_type = '' OR bc_type = 'r' THEN do:
       ASSIGN bc_type = 'i'
        mdesc = '计划外出库'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
END.
ON CURSOR-UP OF bc_type
DO:
    ASSIGN bc_type.
    IF bc_type = '' OR bc_type = 'i' THEN do:
       ASSIGN bc_type = 'r'
        mdesc = '计划外入库'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
     IF bc_type = '' OR bc_type = 'r' THEN do:
        ASSIGN bc_type = 'i'
        mdesc = '计划外出库'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
END.






ON 'choose':U OF bc_button
DO:
   RUN main.
END.



ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
   DEF VAR mpart AS CHAR.
    DEF  VAR mvend AS CHAR.
    DEF VAR pre_ref AS CHAR.
    DEF VAR ipath AS CHAR.
    DEF VAR opath AS CHAR.
   DEF VAR match_qty AS DECIMAL.
    DEF VAR mnbr AS CHAR.
    DEF VAR mqty AS DECIMAL.
    DEF VAR mjob AS CHAR.
    DEF  VAR mark AS CHAR.
    DEF VAR msite AS CHAR.
    DEF VAR msg AS CHAR.
   DEF VAR mdate AS DATE.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'excelpath_unp' AND CODE_value <> '' NO-LOCK NO-ERROR.

IF AVAILABLE code_mstr THEN ipath = CODE_value.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'unplog' AND CODE_value <> '' NO-LOCK NO-ERROR.

IF AVAILABLE code_mstr THEN opath = CODE_value.

IF ipath <> '' AND opath <> '' THEN DO:
   
 OUTPUT TO VALUE(opath).
    create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = FALSE.
    IF SEARCH(code_value) = ? THEN DO:
         MESSAGE  '接口文件未找到！' VIEW-AS ALERT-BOX ERROR.
                  success = NO.
                   LEAVE.
     END.
       chWorkbook = chExcelApplication:Workbooks:OPEN(ipath) .
      chWorkSheet = chExcelApplication:Sheets:Item(1).  
       chExcelApplication:Sheets:Item(1):SELECT().
       rowstart = 6.
      
       DO WHILE chworksheet:range('a' + string(rowstart)):VALUE <> ?:
           /*MESSAGE chworksheet:range('a' + string(rowstart)):VALUE VIEW-AS ALERT-BOX.*/
          msg = ''.
           
          crange = "a" + STRING(rowstart).  
        
                   mpart = string(chWorkSheet:Range(crange):VALUE).
                  /* mpart = SUBSTR(mpart,1,INDEX(mpart,'.') - 1).*/
             FIND FIRST pt_mstr WHERE pt_part = mpart  NO-LOCK NO-ERROR.
               IF NOT AVAILABLE pt_mstr THEN DO:
                   msg = msg + '无效零件号，'.

                   
                   END.

                   crange = "b" + STRING(rowstart).  
               mqty = DECIMAL(chWorkSheet:Range(crange):VALUE) NO-ERROR.
               IF ERROR-STATUS:ERROR  THEN DO:
                  msg = msg + '无效数字，'.

                 
                   END.
                     crange = "c" + STRING(rowstart).  
        
                   msite = string(chWorkSheet:Range(crange):VALUE).
                  /* mpart = SUBSTR(mpart,1,INDEX(mpart,'.') - 1).*/
             FIND FIRST si_mstr WHERE si_site = msite  NO-LOCK NO-ERROR.
               IF NOT AVAILABLE si_mstr THEN DO:
                   msg = msg + '无效地点，'.

                   END.
                    crange = "d" + STRING(rowstart).  
        mjob = string(chWorkSheet:Range(crange):VALUE).
               FIND FIRST CODE_mstr WHERE CODE_fldname = 'so_job' AND CODE_value = mjob NO-LOCK NO-ERROR.
   IF NOT AVAILABLE code_mstr THEN DO:
    msg = msg + '无效预算号，'.

    
 
   END.
          crange = "e" + STRING(rowstart).  
               mnbr = string(chWorkSheet:Range(crange):VALUE) NO-ERROR.
               IF mnbr = '' THEN DO:
                   msg = '定制码不能为空，'.

                  
                   
               END.
              
       
 
         
                 
               
             
                    crange = "f" + STRING(rowstart).  
                   mark = string(chWorkSheet:Range(crange):VALUE).
                    crange = "g" + STRING(rowstart).  
               mdate = DATE(string(chWorkSheet:Range(crange):VALUE)) NO-ERROR.
               IF ERROR-STATUS:ERROR  THEN DO:
                  msg = msg + '无效日期，'.

                  
                   END.
                /*  mvend = SUBSTR(mvend,1,INDEX(mvend,'.') - 1).*/
                  IF msg <> '' THEN do:
                      
                      PUT UNFORMAT mpart ' ' mqty ' ' msite ' ' mjob ' ' mnbr ' ' mdate ' ' msg SKIP.
                      rowstart = rowstart + 1.
                      NEXT.
                      END.
                       CREATE b_unp_tmp.
          ASSIGN b_unp_sess = g_sess
                  b_unp_nbr = mnbr
              b_unp_job = mjob    
              b_unp_part = mpart
                b_unp_qty = mqty
              b_unp_mark = mark
              b_unp_site = msite
              b_unp_date = mdate.
        
          rowstart = rowstart + 1.
       END.
       OUTPUT CLOSE.
        chExcelApplication:QUIT .
   RELEASE OBJECT chWorksheet.
     RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   
      
  END.
   
     ELSE MESSAGE '请检查路径！' VIEW-AS ALERT-BOX ERROR.
   
     FOR EACH b_unp_tmp WHERE b_unp_sess = g_sess NO-LOCK:
         match_qty = 0. 
         FIND FIRST IN_mstr WHERE IN_part = b_unp_part AND IN_site = b_unp_site NO-LOCK NO-ERROR.
         FOR EACH b_co_mstr USE-INDEX b_co_sort1 WHERE (IF bc_type = 'i' THEN b_co_site = b_unp_site  AND b_co_status = 'rct' ELSE b_co_status = 'ac') AND b_co_part = b_unp_part
             AND NOT CAN-FIND(FIRST b_cnt_wkfl WHERE  substr(b_cnt_lot,1,18) = b_co_code no-lock) NO-LOCK:
         CREATE b_cnt_wkfl.
          ASSIGN
             substr(b_cnt_site,1,1) = bc_type
              substr(b_cnt_site,2,9) = IF AVAIL IN_mstr THEN IN__qadc01 ELSE ''
               SUBSTR(b_cnt_site,12,20) = b_unp_nbr
                   SUBSTR(b_cnt_site,35,10) = b_unp_job
                 SUBSTR(b_cnt_site,50,8) = b_unp_site
                  SUBSTR(b_cnt_site,60,10) = STRING(b_unp_date)
                  b_cnt_loc = b_co_loc
                  b_cnt_part = b_unp_part
                  substr(b_cnt_lot,1,18) = b_co_code
                  SUBSTR(b_cnt_lot,20) = b_co_lot
                  b_cnt_qty_oh = b_unp_qty .
                   
                     match_qty = match_qty + b_co_qty_cur.
                     IF match_qty >= b_unp_qty THEN LEAVE.
                    
                      END.
         
         
       
     END.
     FOR EACH b_cnt_wkfl :
         FIND FIRST b_co_mstr WHERE b_co_code = substr(b_cnt_lot,1,18) AND (b_co_status = 'ia' OR b_co_status = 'iss'OR b_co_status = 'issln' OR (IF SUBSTR(b_cnt_site,1,1) = 'r' THEN (b_co_status = 'rct' OR b_co_status = 'all') ELSE NO)) NO-LOCK NO-ERROR.
         IF AVAILABLE b_co_mstr THEN DELETE b_cnt_wkfl.
     END.
     FOR EACH b_unp_tmp WHERE b_unp_sess = g_sess:
        DELETE b_unp_tmp.
    END.
   MESSAGE '导入完毕！' VIEW-AS ALERT-BOX .
 END.
    

{bctrail.i}
