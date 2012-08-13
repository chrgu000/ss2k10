{bcdeclre.i  }
    {bcwin00.i 12.5}
    {bctitle.i}
{mfdeclre.i}
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".

/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "至".

DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR bc_date AS DATE LABEL '日期'.
DEF VAR bc_date1 AS DATE LABEL '至'.
DEFINE BUTTON bc_button LABEL "打印" SIZE 8 BY 1.20.
DEF FRAME bc
   bc_date AT ROW 1.2 COL 4
    bc_date1 AT ROW 2.4 COL 5.5  
    bc_site AT ROW 3.6 COL 4
    bc_site1 AT ROW 4.8 COL 5.5
   
    bc_loc AT ROW 6 COL 4
     bc_loc1 AT ROW 7.2 COL 5.5
   
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_part AT ROW 8.4 COL 2.5
    bc_part1 AT ROW 9.6 COL 5.5
    
   bc_button AT ROW 10.8 COL 10

   
    WITH SIZE 30 BY 13 TITLE "未盘清单" SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_date bc_date1 bc_site bc_site1 bc_loc bc_loc1 bc_part bc_part1  bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 bc_date = TODAY.
 bc_date1 = TODAY.
 DISP bc_date bc_date1 WITH FRAME bc.
VIEW c-win.
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
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""part"",
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
           /* DISABLE bc_part WITH FRAME bc.*/
            ENABLE bc_part1 WITH FRAME bc.
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

ON enter OF bc_part1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part1 = bc_part1:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""part"",
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
            /*DISABLE bc_part1 WITH FRAME bc.*/
           APPLY 'entry':u TO bc_button.
        /*END.*/
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
            /*   DISABLE bc_site WITH FRAME bc.
               ENABLE bc_site1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_site1.

          /* END.*/
END.
ON VALUE-CHANGED OF  bc_site
DO:
    ASSIGN bc_site.
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
               APPLY 'entry':u TO bc_loc.

          /* END.*/
END.

ON VALUE-CHANGED OF  bc_site1
DO:
    ASSIGN bc_site1.
END.
ON CURSOR-DOWN OF bc_loc
DO:
    
       ASSIGN bc_loc.
       FIND FIRST loc_mstr NO-LOCK WHERE loc_site = bc_site AND loc_loc > bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc
DO:
   
       ASSIGN bc_loc.
       FIND LAST loc_mstr NO-LOCK WHERE loc_site = bc_site AND loc_loc < bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
   
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
              APPLY 'entry':u TO bc_loc1.

           /*END.*/
END.
ON VALUE-CHANGED OF  bc_loc
DO:
    ASSIGN bc_loc.
END.
ON CURSOR-DOWN OF bc_loc1
DO:
    
       ASSIGN bc_loc1.
       FIND FIRST loc_mstr NO-LOCK WHERE loc_site = bc_site1 AND loc_loc > bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc1
DO:
   
       ASSIGN bc_loc1.
       FIND LAST loc_mstr NO-LOCK WHERE loc_site = bc_site1 AND loc_loc < bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
   
END.
ON enter OF  bc_loc1
DO:
    ASSIGN bc_loc1.
    /* {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
              APPLY 'entry':u TO bc_part.

          /* END.*/
END.
ON VALUE-CHANGED OF  bc_loc1
DO:
    ASSIGN bc_loc1.
END.
ON enter OF bc_date
DO:
   ASSIGN bc_date NO-ERROR.
   APPLY 'entry':u TO bc_date1.
END.
ON VALUE-CHANGED OF bc_date
DO:
  ASSIGN bc_date NO-ERROR.
END.

ON enter OF bc_date1
DO:
   ASSIGN bc_date1 NO-ERROR.
   APPLY 'entry':u TO bc_site.
END.
ON VALUE-CHANGED OF bc_date1
DO:
  ASSIGN bc_date1 NO-ERROR.
END.
ON 'choose':U OF bc_button
DO:
    RUN main.
END.
PROCEDURE main:
   /* DEF VAR ori_qty_oh_tot LIKE b_cnt_qty_oh.
    DEF VAR cnt_qty_tot LIKE b_cnt_qty_cnt.
    DEF VAR diff_qty LIKE cnt_qty_tot.
    DEF FRAME b_cnt_rpt 
       b_cnt_site COLUMN-LABEL '地点' AT 8
        b_cnt_loc COLUMN-LABEL '库位'
        b_cnt_part COLUMN-LABEL '零件号' 
        pt_desc1 COLUMN-LABEL '零件描述'
        b_cnt_lot COLUMN-LABEL '批/序号'
        ori_qty_oh_tot COLUMN-LABEL '原库存数量'
        cnt_qty_tot COLUMN-LABEL '初盘数量'
        diff_qty COLUMN-LABEL '初盘差异'
        WITH WIDTH 150 DOWN STREAM-IO .*/
    DEF VAR isst AS LOGICAL INITIAL YES.
    IF bc_part1 = '' THEN bc_part1 = hi_char.
    IF bc_site1 = ''  THEN bc_site1 = hi_char.
    IF bc_loc1 = '' THEN bc_loc1 = hi_char.
    IF bc_date = ? THEN bc_date = low_date.
    IF bc_date1 = ? THEN bc_date1 = hi_date.
   /* OUTPUT TO notepad.txt.
    PUT SKIP(2).
    PUT SPACE(60).
    PUT '盘点差异报表(I)' SKIP(1).*/

     create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().
       chWorkSheet = chExcelApplication:Sheets:Item(1).   
 chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "未盘清单(I)".
        chWorkSheet:Rows(1):RowHeight = 25.
       chWorkSheet:Columns("A:f"):ColumnWidth = 15.
       chWorkSheet:Columns("d:d"):ColumnWidth = 35.

         chWorkSheet:Range("A1:f1"):Select().
 chExcelApplication:selection:Font:Name = "宋体".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "地点".
       chWorkSheet:Range("b1:b1"):VALUE = "库位".
     /* chWorkSheet:Range("c1:c1"):VALUE = "条码".*/
    
      chWorkSheet:Range("c1:c1"):VALUE = "零件号".
    chWorkSheet:Range("d1:d1"):VALUE = "零件描述".
    chWorkSheet:Range("e1:e1"):VALUE = "批/序号".
      chWorkSheet:Range("f1:f1"):VALUE = "数量".
       
      rowstart = 1.
    FOR EACH ld_det WHERE ld_site >= bc_site AND ld_site <= bc_site1 AND ld_loc >= bc_loc AND ld_loc <= bc_loc1 AND ld_part >= bc_part AND ld_part <= bc_part1 NO-LOCK:
    
        FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= bc_date  AND tr_date <= bc_date1 AND  tr_type BEGINS 'cyc' AND tr_program = 'icccaj.p' AND tr_site = ld_site AND tr_loc = ld_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ tr_part = ld_part AND tr_serial = ld_lot   NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tr_hist THEN DO:
         FIND FIRST pt_mstr WHERE pt_part = ld_part NO-LOCK NO-ERROR.
            rowstart = rowstart + 1.
            chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "f" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
      chExcelApplication:selection:numberformat = '@'.
     crange = "a" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = ld_site.
     crange = "b" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = ld_loc.
     /*crange = "c" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = b_co_code.*/
     crange = "c" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = ld_part.
     crange = "d" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE '' .
      crange = "e" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = ld_lot.
     crange = "f" + STRING(rowstart). 
chWorkSheet:Range(crange):numberformat = '0'.
     chWorkSheet:Range(crange):VALUE = ld_qty_oh.
         END.
        
        END.
   
 
          
           /* FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = b_cnt_part AND b_co_lot = b_cnt_lot AND b_co_site = b_cnt_site AND b_co_loc = b_cnt_loc AND (b_co_status = 'rct' OR b_co_status = 'all') NO-LOCK :
              IF b_co_cntst = '' OR substr(b_co_cntst,1,1) = 'r' THEN do:
                  isst = NO.
                IF b_co_cntst = '' THEN DO:  b_cnt_status  = ''.
               LEAVE.
                END.
              END.
                END.
              
      IF isst  THEN b_cnt_status = 'i'.*/
              
          
      
                 /* DISP 
              b_cnt_site 
        b_cnt_loc 
        b_cnt_part 
        pt_desc1 
        b_cnt_lot 
        ori_qty_oh_tot 
        cnt_qty_tot 
        (cnt_qty_tot - ori_qty_oh_tot) @ diff_qty
               WITH FRAME b_cnt_rpt.

           IF pt_desc2 <> '' THEN DO:
                DOWN 1.
                PUT SPACE(44).
                PUT UNFORMAT pt_desc2.

            END.*/
        
            
      

  

/*OUTPUT CLOSE.
 DOS SILENT VALUE('notepad notepad.txt').  
    RELEASE b_cnt_wkfl.
    ENABLE bc_site WITH FRAME bc.*/

     chWorkSheet:Range("A1:f" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":f" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 


 RELEASE OBJECT chWorksheet.
     RELEASE OBJECT chWorkbook.
     RELEASE OBJECT chExcelApplication.   


    END.
{bctrail.i}
