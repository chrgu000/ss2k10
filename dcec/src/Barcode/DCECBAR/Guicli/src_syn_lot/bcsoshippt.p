{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)" LABEL "零件描述".
DEF VAR bc_part_desc2 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".
DEF VAR bcprefix AS CHAR.
DEF VAR bc_ship AS CHAR FORMAT "x(18)" LABEL "货运单".
DEF VAR bc_ship1 AS CHAR FORMAT "x(18)" LABEL "至".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "张数".
DEF VAR ismodi AS LOGICAL.
 DEF VAR bc AS CHAR.
 DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_cust AS CHAR FORMAT "x(8)" LABEL "客户".
DEF TEMP-TABLE b_shp_pt
    FIELD shppt_sess LIKE g_sess
    FIELD b_shp_ptid LIKE b_shp_shipper
    INDEX shppt_sess IS PRIMARY shppt_sess ASC.
DEFINE QUERY bc_qry FOR b_shp_pt .
       
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          b_shp_ptid COLUMN-LABEL "销售订单" FORMAT "x(20)"
          
        
  
WITH NO-ROW-MARKERS SEPARATORS 7 DOWN WIDTH 21  /*TITLE "待收货清单"*/.
DEF FRAME bc
    bc_cust AT ROW 1.2 COL 4
    bc_brw AT ROW 2.4 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
 
 
    WITH SIZE 30 BY 12 TITLE "销售订单备料打印"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ismodi = NO.
ENABLE bc_cust WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.
ON CURSOR-DOWN OF bc_cust
DO:
    
       ASSIGN bc_cust.
       FIND FIRST cm_mstr NO-LOCK  WHERE cm_addr > bc_cust  NO-ERROR.
       IF AVAILABLE cm_mstr THEN DO:
           ASSIGN bc_cust = cm_addr.
           DISPLAY bc_cust WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_cust
DO:
    ASSIGN bc_cust.
       FIND LAST cm_mstr NO-LOCK  WHERE cm_addr < bc_cust  NO-ERROR.
       IF AVAILABLE cm_mstr THEN DO:
           ASSIGN bc_cust = cm_addr.
           DISPLAY bc_cust WITH FRAME bc.
       END.
   
END.
ON enter OF bc_cust
DO:
    bc_cust = bc_cust:SCREEN-VALUE.
   /* DISABLE bc_ship WITH FRAME bc.*/
    FOR EACH b_shp_pt WHERE shppt_sess = g_sess:
        DELETE b_shp_pt.
    END.
    FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_cust = bc_cust AND b_shp_status = '' NO-LOCK BREAK BY b_shp_shipper :
        IF FIRST-OF(b_shp_shipper) THEN DO:
       CREATE b_shp_pt.
        ASSIGN 
            shppt_sess = g_sess
            b_shp_ptid = b_shp_shipper.
        END.
    END.
    OPEN QUERY bc_qry FOR EACH b_shp_pt WHERE shppt_sess = g_sess NO-LOCK.
        ENABLE bc_brw WITH FRAME bc.
END.
ON VALUE-CHANGED OF bc_cust
DO:
    bc_cust = bc_cust:SCREEN-VALUE.
   /* DISABLE bc_ship WITH FRAME bc.*/
    
END.
ON 'mouse-select-dblclick':U OF bc_brw
DO:
   RUN main.
END.
/*ON CURSOR-DOWN OF bc_ship
DO:
    
       ASSIGN bc_ship.
       FIND FIRST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) > bc_ship  NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_ship = SUBSTR(ABS_id,2,50).
           DISPLAY bc_ship WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_ship
DO:
    ASSIGN bc_ship.
       FIND LAST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) < bc_ship  NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_ship = SUBSTR(ABS_id,2,50).
           DISPLAY bc_ship WITH FRAME bc.
       END.
   
END.
ON enter OF bc_ship
DO:
    bc_ship = bc_ship:SCREEN-VALUE.
   /* DISABLE bc_ship WITH FRAME bc.*/
    APPLY 'entry':u TO  bc_ship1 .
END.
ON VALUE-CHANGED OF bc_ship
DO:
    bc_ship = bc_ship:SCREEN-VALUE.
   /* DISABLE bc_ship WITH FRAME bc.*/
    
END.


ON CURSOR-DOWN OF bc_ship1
DO:
    
       ASSIGN bc_ship1.
       FIND FIRST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) >= bc_ship   NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_ship1 = SUBSTR(ABS_id,2,50).
           DISPLAY bc_ship1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_ship1
DO:
    ASSIGN bc_ship1.
       FIND LAST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) < bc_ship1  NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_ship1 = SUBSTR(ABS_id,2,50).
           DISPLAY bc_ship1 WITH FRAME bc.
       END.
   
END.
ON enter OF bc_ship1
DO:
   
    bc_ship1 = bc_ship1:SCREEN-VALUE.
   /* DISABLE bc_ship1 WITH  FRAME bc.*/
     APPLY 'entry':u TO bc_button.
    
         
    END.
    ON VALUE-CHANGED OF bc_ship1
DO:
    bc_ship1 = bc_ship1:SCREEN-VALUE.
   /* DISABLE bc_ship WITH FRAME bc.*/
    
END.
    
  ON 'choose':U OF bc_button
  DO:
      RUN main.
  END.
*/

/*ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.*/
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 






ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
     DEF VAR bc_qty_mult LIKE b_co_qty_cur.
      DEF VAR i AS INT.
      /*DEF BUFFER absmstr FOR ABS_mstr.*/
    IF bc_ship1 = '' THEN bc_ship1 = hi_char.
      /*FOR EACH ABS_mstr WHERE (abs_id BEGINS 's' OR abs_id BEGINS 'c') AND abs_type = 'r' AND substr(ABS_id,2,50) >= bc_ship AND substr(ABS_id,2,50) <= bc_ship1 NO-LOCK:
         FIND FIRST b_co_mstr WHERE b_co_ref = SUBSTR(ABS_id,2,50) NO-LOCK NO-ERROR.
         IF NOT AVAILABLE  b_co_mstr THEN DO:*/
    
            create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().           
               rowstart = 1.
           chWorkSheet = chExcelApplication:Sheets:Item(1).      
           chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "备料单".
        chWorkSheet:Rows(rowstart):RowHeight = 25.
       chWorkSheet:Columns("A:h"):ColumnWidth = 15.
       chWorkSheet:Columns("e:e"):ColumnWidth = 35.
        
         chWorkSheet:Range("A1:h1"):Select().
 chExcelApplication:selection:Font:Name = "宋体".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "备料单".
       chWorkSheet:Range("b1:b1"):VALUE = "客户".
       chWorkSheet:Range("c1:c1"):VALUE = "订单号".
    
      chWorkSheet:Range("d1:d1"):VALUE = "行号".
      chWorkSheet:Range("e1:e1"):VALUE = "条码".
     chWorkSheet:Range("f1:f1"):VALUE = "零件号".
     chWorkSheet:Range("g1:g1"):VALUE = "零件描述".
    chWorkSheet:Range("h1:h1"):VALUE = "数量".
    
        FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = b_shp_pt.b_shp_ptid AND b_shp_status = '' NO-LOCK:
            FIND FIRST pt_mstr WHERE pt_part = b_shp_part NO-LOCK NO-ERROR.
            rowstart = rowstart + 1.
        chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "h" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
       chExcelApplication:selection:numberformat = '@'.
     crange = "a" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_shp_shipper.
     crange = "b" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_shp_cust.
     crange = "c" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_shp_so.
     crange = "d" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_shp_line.
     crange = "e" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_shp_code.
     crange = "f" + STRING(rowstart).  
    chWorkSheet:Range(crange):VALUE = b_shp_part .
    crange = "g" + STRING(rowstart).  
        chWorkSheet:Range(crange):VALUE =  pt_desc1 + pt_desc2.

     crange = "h" + STRING(rowstart).  
     chWorkSheet:Range(crange):numberformat = '0'.
     chWorkSheet:Range(crange):VALUE = b_shp_qty.
        END.
      chWorkSheet:Range("A1:h" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":h" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
  RELEASE OBJECT chWorksheet.
   RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   

      RELEASE b_po_wkfl.
        /* ELSE DO:
             FOR EACH b_co_mstr WHERE b_co_ref = SUBSTR(ABS_mstr.ABS_id,2,50) NO-LOCK:
{bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend"}
             END.
         END.*/
     
              /* {bcusrhist.i }*/
                   
/*MESSAGE "是否打印？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.*/
 /*IF oktocomt THEN DO:*/
/* FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.*/
    /*IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.*/
       /* END.*/
 /*OUTPUT TO VALUE(b_usr_printer).*/

 
     
     
  
   
     
    
              RELEASE b_co_mstr.
   
               RELEASE b_po_wkfl.
         /*ENABLE bc_ship WITH FRAME bc.*/
               END.


{bctrail.i}
