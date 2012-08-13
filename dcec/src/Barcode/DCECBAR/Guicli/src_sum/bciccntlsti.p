{bcdeclre.i  }
    {bcwin12.i}
    {bctitle.i}
    {mfdeclre.i}

DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "批/序号".
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "至".
DEFINE BUTTON bc_button LABEL "打印" SIZE 8 BY 1.50.
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.

DEF FRAME bc
    
    bc_site AT ROW 2 COL 4
   bc_site1 AT ROW 3.5 COL 5.5
   bc_loc AT ROW 5 COL 4
   bc_loc1 AT ROW 6.5 COL 5.5

   /* bc_part AT ROW 7.5 COL 2.5
    bc_part1 AT ROW 9 COL 5.5*/
    
   
  /* bc_pkqty AT ROW 10 COL 4*/
  
  bc_button AT ROW 8 COL 10
    
    WITH SIZE 30 BY 10 TITLE "盘点单初始化打印"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

VIEW c-win.
ENABLE bc_site bc_site1 bc_loc bc_loc1  bc_button WITH FRAME bc .
/*ON CURSOR-DOWN OF bc_part
DO:
    
       ASSIGN bc_part.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part
DO:
   
       ASSIGN bc_part.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
   
END.

ON VALUE-CHANGED OF bc_part
DO:
 bc_part = bc_part:SCREEN-VALUE.
END.
ON enter OF bc_part
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""part"",
        input """",
        input """", 
        input bc_part, 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: */
           /* DISABLE bc_part WITH FRAME bc.
            ENABLE bc_part1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part1.
       /* END.*/
END.


ON CURSOR-DOWN OF bc_part1
DO:
    
       ASSIGN bc_part1.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part1
DO:
   
       ASSIGN bc_part1.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_part1
DO:
 bc_part1 = bc_part1:SCREEN-VALUE.
END.
ON enter OF bc_part1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part1 = bc_part1:SCREEN-VALUE.
/*.i ""bcmgcheck.p"" "(input ""part"",
        input """",
        input """", 
        input bc_part1, 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: */
           /* DISABLE bc_part1 WITH FRAME bc.*/
           APPLY 'entry':u TO bc_button.
        /*END.*/
END.*/

ON CURSOR-DOWN OF bc_site
DO:
    
       ASSIGN bc_site.
       FIND FIRST si_mstr NO-LOCK WHERE si_site > bc_site NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site = si_site.
           DISPLAY bc_site WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_site
DO:
   
       ASSIGN bc_site.
       FIND LAST si_mstr NO-LOCK WHERE si_site < bc_site NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site = si_site.
           DISPLAY bc_site WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_site
DO:
 bc_site = bc_site:SCREEN-VALUE.
END.
ON enter OF  bc_site
DO:
    ASSIGN bc_site.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""site"" ,
        input bc_site,
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
              /* DISABLE bc_site WITH FRAME bc.
               ENABLE bc_site1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_site1.

          /* END.*/
END.

ON CURSOR-DOWN OF bc_site1
DO:
    
       ASSIGN bc_site1.
       FIND FIRST si_mstr NO-LOCK WHERE si_site > bc_site1 NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site1 = si_site.
           DISPLAY bc_site1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_site1
DO:
   
       ASSIGN bc_site1.
       FIND LAST si_mstr NO-LOCK WHERE si_site < bc_site1 NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site1 = si_site.
           DISPLAY bc_site1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_site1
DO:
 bc_site1 = bc_site1:SCREEN-VALUE.
END.
ON enter OF  bc_site1
DO:
    ASSIGN bc_site1.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""site"" ,
        input bc_site1,
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
            /*   DISABLE bc_site1 WITH FRAME bc.
               ENABLE bc_loc WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc.

          /* END.*/
END.


ON CURSOR-DOWN OF bc_loc
DO:
    
       ASSIGN bc_loc.
       FIND FIRST loc_mstr NO-LOCK WHERE /*loc_site = bc_site AND*/ loc_loc > bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc
DO:
   
       ASSIGN bc_loc.
       FIND LAST loc_mstr NO-LOCK WHERE /*loc_site = bc_site AND*/ loc_loc < bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_loc
DO:
 bc_loc = bc_loc:SCREEN-VALUE.
END.
ON enter OF  bc_loc
DO:
    ASSIGN bc_loc.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
        input bc_site,
        input bc_loc, 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
            /*   DISABLE bc_loc WITH FRAME bc.
               ENABLE bc_loc1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_loc1.

          /* END.*/
END.

ON CURSOR-DOWN OF bc_loc1
DO:
    
       ASSIGN bc_loc1.
       FIND FIRST loc_mstr NO-LOCK WHERE /*loc_site = bc_site1 AND*/ loc_loc > bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc1
DO:
   
       ASSIGN bc_loc1.
       FIND LAST loc_mstr NO-LOCK WHERE /*loc_site = bc_site1 AND*/ loc_loc < bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_loc1
DO:
 bc_loc1 = bc_loc1:SCREEN-VALUE.
END.
ON enter OF  bc_loc1
DO:
    ASSIGN bc_loc1.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
        input bc_site1,
        input bc_loc1, 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
              /* DISABLE bc_loc1 WITH FRAME bc.
              ENABLE bc_part WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.

           /*END.*/
END.

ON 'choose':U OF bc_button
DO:
    RUN main.
END.

PROCEDURE main:
    DEF VAR id AS CHAR.
    DEF VAR oktocmt AS LOGICAL INITIAL NO.
   /* DEF FRAME b_cnt_rpt 
        b_cnt_site COLUMN-LABEL '地点' AT 8
        b_cnt_loc COLUMN-LABEL '库位'
        b_cnt_code  COLUMN-LABEL '条码' 
        b_cnt_part COLUMN-LABEL '零件号'
        pt_desc1 COLUMN-LABEL '零件描述'
        b_cnt_lot COLUMN-LABEL '批/序号'
        b_cnt_qty_oh COLUMN-LABEL '库存数量'
        WITH WIDTH 150 DOWN STREAM-IO .*/
    /* FIND FIRST b_cnt_wkfl WHERE b_cnt_id = 'first' NO-LOCK NO-ERROR.
     IF NOT AVAILABLE b_cnt_wkfl THEN DO:
         MESSAGE '库存未作过初始化!' VIEW-AS ALERT-BOX.
         LEAVE.
     END.
    FIND FIRST b_cnt_wkfl WHERE b_cnt_id = 'first' AND b_cnt_status <> 'c' NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        MESSAGE '库存初始化未关闭！' VIEW-AS ALERT-BOX.     
        LEAVE.
        END.*/
    
  
  /*  FIND FIRST b_cnt_wkfl WHERE b_cnt_status <> 'c' AND b_cnt_status <> 'x' NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        MESSAGE '存在未结盘点清单，是否取消未结清单，并继续打印？' 
    VIEW-AS ALERT-BOX QUESTION
            BUTTON YES-NO
            UPDATE oktocomt.
        IF oktocomt THEN 
            FOR EACH b_cnt_wkfl WHERE b_cnt_status <> 'c' AND b_cnt_status <> 'x' EXCLUSIVE-LOCK:
                
            b_cnt_status = 'x'.
                END.

                ELSE do:
                    
                  ENABLE bc_part WITH FRAME bc.
                    LEAVE.
                END.
       


END.*/

  /*  id = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + string(NEXT-VALUE(b_cnt_sq01),'999999999999').
    */
    IF bc_part1 = '' THEN bc_part1 = hi_char.
    IF bc_site1 = ''  THEN bc_site1 = hi_char.
    IF bc_loc1 = '' THEN bc_loc1 = hi_char.
     FIND FIRST b_cnt_wkfl WHERE b_cnt_status <> 'c' NO-LOCK NO-ERROR.
   IF AVAILABLE b_cnt_wkfl THEN DO:
        MESSAGE '要初始化盘点清单,并打印吗？' VIEW-AS ALERT-BOX
            QUESTION BUTTON YES-NO 
            UPDATE oktocmt .
       
    END.
    IF oktocmt  OR NOT AVAILABLE b_cnt_wkfl THEN 
  
    FOR EACH b_ld_det WHERE  b_ld_site >= bc_site AND b_ld_site <= bc_site1 AND 
        b_ld_loc >= bc_loc AND b_ld_loc <= bc_loc1 AND b_ld_qty_oh <> 0 NO-LOCK:
        FIND FIRST b_cnt_wkfl WHERE   b_cnt_site = b_ld_site AND b_cnt_loc = b_ld_loc AND b_cnt_part = b_ld_part AND b_cnt_lot = b_ld_lot EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE b_cnt_wkfl  THEN DO:
          
                    ASSIGN
                         b_cnt_qty_oh = b_ld_qty_oh             
                     b_cnt_qty_cnt = 0
                      b_cnt_qty_rcnt = 0
                        b_cnt_status = ''.

          END.
          ELSE DO:
        
        CREATE b_cnt_wkfl.
       /* FIND FIRST b_ld_det WHERE b_ld_ref = b_co_code AND b_ld_qty_oh <> 0 NO-LOCK NO-ERROR.
        IF AVAILABLE b_ld_det then*/
            ASSIGN
            b_cnt_status = ''
            b_cnt_part = b_ld_part
            b_cnt_lot = b_ld_lot
            b_cnt_site = b_ld_site
            b_cnt_loc = b_ld_loc
            b_cnt_qty_oh = b_ld_qty_oh
            b_cnt_userid = g_user.

          END.


    END.
    create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().
       chWorkSheet = chExcelApplication:Sheets:Item(1).   
 chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "盘点清单".
        chWorkSheet:Rows(1):RowHeight = 25.
       chWorkSheet:Columns("A:g"):ColumnWidth = 15.
       chWorkSheet:Columns("d:d"):ColumnWidth = 35.

         chWorkSheet:Range("A1:g1"):Select().
 chExcelApplication:selection:Font:Name = "宋体".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "地点".
       chWorkSheet:Range("b1:b1"):VALUE = "库位".
      
    
      chWorkSheet:Range("c1:c1"):VALUE = "零件号".
    chWorkSheet:Range("d1:d1"):VALUE = "零件描述".
     chWorkSheet:Range("e1:e1"):VALUE = "ABC分类".
     chWorkSheet:Range("f1:f1"):VALUE = "批/序号".
      chWorkSheet:Range("g1:g1"):VALUE = "库存数".
      rowstart = 1.
      FOR EACH b_cnt_wkfl  WHERE b_cnt_status <> 'c' AND b_cnt_site >= bc_site AND b_cnt_site <= bc_site1 AND b_cnt_loc >= bc_loc AND b_cnt_loc <= bc_loc1 no-LOCK:
          rowstart = rowstart + 1.
          FIND FIRST pt_mstr WHERE pt_part = b_cnt_part NO-LOCK NO-ERROR.
          
          chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "g" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
       chExcelApplication:selection:numberformat = "@".
     crange = "a" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_cnt_site.
     crange = "b" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_cnt_loc.
   
     crange = "c" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = b_cnt_part.
     crange = "d" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pt_desc1 + pt_desc2.
      crange = "e" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pt_abc.
     crange = "f" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = b_cnt_lot.
       crange = "g" + STRING(rowstart).  
       chWorkSheet:Range(crange):numberformat = '0'.
       chWorkSheet:Range(crange):VALUE = b_cnt_qty_oh.





     END.


       chWorkSheet:Range("A1:g" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":g" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 


 RELEASE OBJECT chWorksheet.
     RELEASE OBJECT chWorkbook.
     RELEASE OBJECT chExcelApplication.   

   /* OUTPUT TO notepad.txt.
    PUT SKIP(2).
    PUT SPACE(60).
    PUT '盘点清单' SKIP(1).

        FOR EACH b_cnt_wkfl WHERE b_cnt_id = id NO-LOCK:
            FIND FIRST pt_mstr WHERE pt_part = b_cnt_part NO-LOCK NO-ERROR.
            DISP b_cnt_code  
        b_cnt_part 
        pt_desc1 
        b_cnt_lot 
        b_cnt_site 
        b_cnt_loc 
        b_cnt_qty_oh WITH FRAME b_cnt_rpt.
            IF pt_desc2 <> '' THEN DO:
                DOWN 1.
                PUT SPACE(63).
                PUT UNFORMAT pt_desc2.

            END.
    END.
    OUTPUT CLOSE.
    DOS SILENT VALUE('notepad notepad.txt'). */ 
    RELEASE b_cnt_wkfl.
    ENABLE bc_site WITH FRAME bc.
    END.
 {bctrail.i}
