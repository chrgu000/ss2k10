{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 10}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批号".
DEF VAR bc_lot1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".

DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEFINE BUTTON bc_button1 LABEL "清除" SIZE 8 BY 1.50.
DEFINE BUTTON bc_button2 LABEL "打印" SIZE 8 BY 1.50.
DEFINE BUTTON bc_button3 LABEL "条码生成" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR LABEL "地点".
DEF VAR bc_site1 AS CHAR LABEL "至".
DEF VAR bc_loc AS CHAR LABEL "库位".
DEF VAR bc_loc1 AS CHAR LABEL "至".
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR bc_id1  AS CHAR FORMAT "x(18)" LABEL '至'.
DEF FRAME bc
   bc_id AT ROW 1.5 COL 4
    bc_id1 AT ROW 3 COL 5.5
    bc_lot AT ROW 4.5 COL 4
    bc_lot1 AT ROW 6 COL 5.5
    
  
    
   bc_button1 AT ROW 7.5 COL 10
    /*bc_button2 AT ROW 11 COL 16*/
    
    WITH SIZE 30 BY 10 TITLE "条码清除"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id bc_id1 bc_lot bc_lot1 bc_button1 /*bc_button2*/ WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.


ON CURSOR-DOWN OF bc_id
DO:
    
       ASSIGN bc_id.
       FIND FIRST b_co_mstr  NO-LOCK WHERE   b_co_code > bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.
ON CURSOR-UP OF bc_id
DO:
    
       ASSIGN bc_id.
       FIND LAST b_co_mstr  NO-LOCK WHERE   b_co_code < bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.


ON enter OF bc_id
DO:
     ASSIGN bc_id.
    APPLY 'entry':u TO bc_id1.
END.

    ON VALUE-CHANGED OF bc_id
    DO:
        ASSIGN bc_id.
    END.
    ON CURSOR-DOWN OF bc_id1
DO:
    
       ASSIGN bc_id1.
       FIND FIRST b_co_mstr  NO-LOCK WHERE   b_co_code > bc_id1 NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id1 = b_co_code.
           DISPLAY bc_id1 WITH FRAME bc.
       END.
    
END.
ON CURSOR-UP OF bc_id1
DO:
    
       ASSIGN bc_id1.
       FIND LAST b_co_mstr  NO-LOCK WHERE   b_co_code < bc_id1 NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id1 = b_co_code.
           DISPLAY bc_id1 WITH FRAME bc.
       END.
    
END.


ON enter OF bc_id1
DO:
     ASSIGN bc_id1.
    APPLY 'entry':u TO bc_lot.
END.

    ON VALUE-CHANGED OF bc_id1
    DO:
        ASSIGN bc_id1.
    END.


 ON CURSOR-DOWN OF bc_lot
DO:
    
       ASSIGN bc_lot.
       FIND FIRST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE  b_co_lot > bc_lot NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot = b_co_lot.
           DISPLAY bc_lot WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_lot
DO:
   
       ASSIGN bc_lot.
       FIND LAST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE   b_co_lot < bc_lot NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot = b_co_lot.
           DISPLAY bc_lot WITH FRAME bc.
       END.
END.
ON enter OF bc_lot
DO:
     ASSIGN bc_lot.
    APPLY 'entry':u TO bc_lot1.
END.

    ON VALUE-CHANGED OF bc_lot
    DO:
        ASSIGN bc_lot.
    END.
    ON CURSOR-DOWN OF bc_lot1
DO:
    
       ASSIGN bc_lot1.
       FIND FIRST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE   b_co_lot > bc_lot1 NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot1 = b_co_lot.
           DISPLAY bc_lot1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_lot1
DO:
   
       ASSIGN bc_lot1.
       FIND LAST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE   b_co_lot < bc_lot1 NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot1 = b_co_lot.
           DISPLAY bc_lot1 WITH FRAME bc.
       END.
END.
ON enter OF bc_lot1
DO:
     ASSIGN bc_lot1.
    RUN main.
END.

    ON VALUE-CHANGED OF bc_lot1
    DO:
        ASSIGN bc_lot1.
    END.



/*ON 'choose':U OF bc_button2
DO:
    RUN prt.
END.*/

/*
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
ON enter OF bc_site
DO:
    bc_site = bc_site:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""site"",
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
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/
   /*  DISABLE bc_site WITH FRAME bc.*/
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
ON enter OF bc_site1
DO:
    bc_site1 = bc_site1:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""site"",
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
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/
 /*    DISABLE bc_site1 WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc.
        /*END.*/
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
ON enter OF bc_loc
DO:
    bc_loc = bc_loc:SCREEN-VALUE.
   /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"",
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
       INPUT """",
       INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: */
           
               
           /* DISABLE bc_loc WITH FRAME bc.*/
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
ON enter OF bc_loc1
DO:
    bc_loc1 = bc_loc1:SCREEN-VALUE.
    APPLY 'entry':u TO bc_button1.
   /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"",
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
       INPUT """",
       INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/ 
           
               
          /*  DISABLE bc_loc1 WITH FRAME bc.*/
   /* APPLY 'entry':u TO bc_button.*/
     
        /*        
        END.*/
END.*/
ON 'choose':U OF bc_button1
DO:
    RUN main.
END.

ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
PROCEDURE prt:
     IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   DEF FRAME a
       b_ld_site COLUMN-LABEL "地点" AT 8
       b_ld_loc COLUMN-LABEL "库位"
       b_ld_part  COLUMN-LABEL "零件号"
       pt_desc1 COLUMN-LABEL "零件描述"
       b_ld_lot COLUMN-LABEL "批/序号"
       b_ld_qty_oh COLUMN-LABEL "初始库存数"
       WITH WIDTH 150 DOWN STREAM-IO.
   FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.

   OUTPUT TO VALUE(b_usr_printer1).
    PUT SKIP(2).
    PUT SPACE(60).
    PUT '库存初始化清单' SKIP(1).
FOR EACH b_ld_det WHERE b_ld_site >= bc_site AND b_ld_site <= bc_site1 AND b_ld_loc >= bc_loc AND b_ld_loc <= bc_loc1 AND b_ld_part >= bc_part AND b_ld_part <= bc_part1 NO-LOCK:
     FIND FIRST pt_mstr WHERE pt_part = b_ld_part NO-LOCK NO-ERROR.
    
    DISP b_ld_site b_ld_loc b_ld_part pt_desc1 b_ld_lot b_ld_qty_oh WITH FRAME a.
        
            IF pt_desc2 <> '' THEN DO:
                DOWN 1.
                PUT SPACE(34).
                PUT UNFORMAT pt_desc2.

            END.
    END.
    OUTPUT CLOSE.
    
    END.
PROCEDURE main:
    DEF VAR blocid AS CHAR FORMAT "x(17)".
    DEF VAR oktocmt AS LOGICAL.
    IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   IF bc_lot1 = '' THEN bc_lot1 = hi_char.
   IF bc_id1 = '' THEN bc_id1 = hi_char.
  /* create "Excel.Application" chExcelApplication.
      chExcelApplication:Visible = TRUE.

      chWorkbook = chExcelApplication:Workbooks:Add().
     chWorkSheet = chExcelApplication:Sheets:Item(1).      
           chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "条码查询-批号" .
        chWorkSheet:Rows(1):RowHeight = 25.
       chWorkSheet:Columns("A:g"):ColumnWidth = 15.
       chWorkSheet:Columns("c:c"):ColumnWidth = 35.
        
         chWorkSheet:Range("A1:g1"):Select().
 chExcelApplication:selection:Font:Name = "宋体".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "条码".
       chWorkSheet:Range("b1:b1"):VALUE = "零件号".
    
      chWorkSheet:Range("c1:c1"):VALUE = "零件描述".
     chWorkSheet:Range("d1:d1"):VALUE = "批/序号".
      chWorkSheet:Range("e1:e1"):VALUE = "地点".
       chWorkSheet:Range("f1:f1"):VALUE = "库位".
    chWorkSheet:Range("g1:g1"):VALUE = "数量".
    rowstart = 1.
 FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part >= bc_part AND b_co_part <= bc_part1  AND b_co_lot >= bc_lot AND b_co_lot <= bc_lot1 AND b_co_site >= bc_site AND b_co_site <= bc_site1 AND b_co_loc >= bc_loc AND b_co_loc <= bc_loc1 NO-LOCK:
     FIND FIRST pt_mstr WHERE pt_part = b_co_part NO-LOCK NO-ERROR.
     rowstart = rowstart + 1.
chWorkSheet:Rows(rowstart):RowHeight = 15. 
                   crange = "a" + STRING(rowstart) + ":"  + "g" + STRING(rowstart).
                     chWorkSheet:Range(crange):Select().
      chexcelApplication:Selection:Font:Size = 10.  

     chExcelApplication:selection:HorizontalAlignment = 2.
     chExcelApplication:selection:VerticalAlignment = 2.
     chExcelApplication:selection:Font:Name = "ARIAL". 
     chExcelApplication:selection:numberformat = '@'.
   crange = "a" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_co_code.
   crange = "b" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_co_part.
   
   crange = "c" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2  ELSE '' .
   crange = "d" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_co_lot.
   crange = "e" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_co_site.
   crange = "f" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_co_loc.
   crange = "g" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
  chWorkSheet:Range(crange):VALUE = b_co_qty_cur .
  
    
    
     
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
       RELEASE OBJECT chExcelApplication. */
MESSAGE '确认清除吗？' VIEW-AS ALERT-BOX
    QUESTION  BUTTON YES-NO
    UPDATE oktocmt.
IF oktocmt  THEN DO:

IF bc_id = '' AND bc_id1 = hi_char THEN
FOR EACH b_co_mstr  USE-INDEX b_co_lot WHERE /*b_co_part >= bc_part AND b_co_part <= bc_part1  AND*/ b_co_lot >= bc_lot AND b_co_lot <= bc_lot1 /*AND b_co_site >= bc_site AND b_co_site <= bc_site1 AND b_co_loc >= bc_loc AND b_co_loc <= bc_loc1*/ AND (b_co_status = 'iss' OR b_co_status = 'issln' OR b_co_status = 'ia' OR b_co_status = 'ac') EXCLUSIVE-LOCK:
     DELETE b_co_mstr.
END.
 ELSE 
     FOR EACH b_co_mstr  WHERE b_co_code >= bc_id AND b_co_code <= bc_id1 AND /*b_co_part >= bc_part AND b_co_part <= bc_part1  AND*/ b_co_lot >= bc_lot AND b_co_lot <= bc_lot1 /*AND b_co_site >= bc_site AND b_co_site <= bc_site1 AND b_co_loc >= bc_loc AND b_co_loc <= bc_loc1*/ AND (b_co_status = 'iss' OR b_co_status = 'issln' OR b_co_status = 'ia' OR b_co_status = 'ac') EXCLUSIVE-LOCK:
     DELETE b_co_mstr.
END.
     
   MESSAGE '清除成功！' VIEW-AS ALERT-BOX.  
END.
    /*    
     ENABLE bc_site WITH FRAME bc.    */
               END.


{bctrail.i}
