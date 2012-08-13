{mfdeclre.i}
{bcdeclre.i  }
{bcwin14.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".

DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEFINE BUTTON bc_button LABEL "打印" SIZE 8 BY 1.20.
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
DEF VAR bc_date AS DATE LABEL "日期".
DEF VAR bc_date1 AS DATE LABEL "至".
DEF VAR mcnt AS INT.
DEF FRAME bc
   
    bc_date AT ROW 1.2 COL 4
    bc_date1 AT ROW 2.4 COL 5.5
    bc_site AT ROW 3.6 COL 4
   bc_site1 AT ROW 4.8 COL 5.5 
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_loc AT ROW 6 COL 4
    bc_loc1 AT ROW 7.2 COL 5.5
  
    bc_part AT ROW 8.4 COL 2.5
    bc_part1 AT ROW 9.6 COL 5.5
   bc_button AT ROW 10.9 COL 10
    /*bc_button2 AT ROW 11 COL 16*/
    
    WITH SIZE 30 BY 12.5 TITLE "自制件领料单打印"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_date bc_date1 bc_site  bc_site1 bc_loc bc_loc1 bc_part bc_part1 bc_button /*bc_button2*/ WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY.
 bc_date1 = TODAY.
 DISP bc_date bc_date1 WITH FRAME bc.
VIEW c-win.
ON VALUE-CHANGED OF bc_date
DO:
   ASSIGN bc_date NO-ERROR.
END.
ON enter OF bc_date
DO:
   ASSIGN bc_date NO-ERROR.
   APPLY 'entry':u TO bc_date1.
END.

ON VALUE-CHANGED OF bc_date1
DO:
   ASSIGN bc_date1 NO-ERROR.
END.
ON enter OF bc_date1
DO:
   ASSIGN bc_date1 NO-ERROR.
   APPLY 'entry':u TO bc_site.
END.
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
    APPLY 'entry':u TO bc_part.
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
END.
ON CURSOR-DOWN OF bc_part
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
ON enter OF bc_part
DO:
     ASSIGN bc_part.
    APPLY 'entry':u TO bc_part1.
END.

    ON VALUE-CHANGED OF bc_part
    DO:
        ASSIGN bc_part.
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
ON enter OF bc_part1
DO:
     ASSIGN bc_part1.
    APPLY 'entry':u TO bc_button.
END.

    ON VALUE-CHANGED OF bc_part
    DO:
        ASSIGN bc_part.
    END.
ON 'choose':U OF bc_button
DO:
    RUN main.
END.

/*ON 'choose':U OF bc_button2
DO:
    RUN prt.
END.*/





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
FOR EACH b_ld_det WHERE b_ld_site >= bc_site AND b_ld_site <= bc_site1 AND b_ld_loc >= bc_loc AND b_ld_loc <= bc_loc1 NO-LOCK:
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
    IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   IF bc_date = ? THEN bc_date = low_date.
   IF bc_date1 = ? THEN bc_date = hi_date.
   create "Excel.Application" chExcelApplication.
      chExcelApplication:Visible = TRUE.

      chWorkbook = chExcelApplication:Workbooks:Add().
    
  mcnt = 1.
 FOR EACH b_rep_wkfl  WHERE b_rep_due_date >= bc_date AND b_rep_due_date <= bc_date1 AND b_rep_site >= bc_site AND b_rep_site <= bc_site1 AND b_rep_ln_loc >= bc_loc AND b_rep_ln_loc <= bc_loc1 AND b_rep_part >= bc_part AND b_rep_part <= bc_part1 NO-LOCK BREAK BY b_rep_staff:
 IF FIRST-OF(b_rep_staff) THEN DO:
           rowstart = 1.
            chWorkSheet = chExcelApplication:Sheets:Item(mcnt).      
           chExcelApplication:Sheets:Item(mcnt):SELECT().
       chExcelApplication:Sheets:Item(mcnt):NAME = "自制件生产发料单-" + b_rep_staff.
        chWorkSheet:Rows(rowstart):RowHeight = 25.
       chWorkSheet:Columns("A:i"):ColumnWidth = 15.
       chWorkSheet:Columns("f:f"):ColumnWidth = 35.
        
         chWorkSheet:Range("A1:i1"):Select().
 chExcelApplication:selection:Font:Name = "宋体".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
  chWorkSheet:Range("a1:a1"):VALUE = "日期".      
 chWorkSheet:Range("b1:b1"):VALUE = "地点".
       chWorkSheet:Range("c1:c1"):VALUE = "生产线".
       chWorkSheet:Range("d1:d1"):VALUE = "线边库位".
    
      chWorkSheet:Range("e1:e1"):VALUE = "零件号".
     chWorkSheet:Range("f1:f1"):VALUE = "零件描述".
    chWorkSheet:Range("g1:g1"):VALUE = "需求数".
    chWorkSheet:Range("h1:h1"):VALUE = "实发数".
    chWorkSheet:Range("i1:i1"):VALUE = "欠交数".
      mcnt = mcnt + 1.
           END.

     FIND FIRST pt_mstr WHERE pt_part = b_rep_part NO-LOCK NO-ERROR.
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
     chWorkSheet:Range(crange):numberformat = 'dd/mm/yy'.
   chWorkSheet:Range(crange):VALUE = b_rep_due_date.
     crange = "b" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_rep_site.
   crange = "c" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = substr(b_rep_line,1,9).
   crange = "d" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_rep_ln_loc.
   crange = "e" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_rep_part.
   crange = "f" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE ''.
   crange = "g" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = b_rep_qty_req .
   crange = "h" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE =  b_rep_qty_iss.
   crange = "i" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = b_rep_qty_req - b_rep_qty_iss.
   
    IF LAST-OF(b_rep_staff) THEN DO:
chWorkSheet:Range("A1:i" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":i" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
 RELEASE OBJECT chWorksheet.
    END.
    
     
 END.
     
      
  
   RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   
     
     
     
     
  
    /*    
     ENABLE bc_site WITH FRAME bc.    */
               END.


{bctrail.i}
