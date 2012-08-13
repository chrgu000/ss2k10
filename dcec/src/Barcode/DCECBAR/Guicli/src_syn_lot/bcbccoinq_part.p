{mfdeclre.i}
{bcdeclre.i  }
{bcwin01.i}
     {bctitle.i}
    
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_lot_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_lot_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_merge_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9".

DEF VAR bc_merge_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "合并数量".
DEF VAR oktocomt AS LOGICAL.
DEF VAR mcnt AS INT.
DEF VAR bc_merge_destid LIKE bc_id.

DEF TEMP-TABLE part_tmp
   FIELD part_code LIKE b_co_code
    FIELD part_part LIKE b_co_part
    FIELD part_lot LIKE b_co_lot
    FIELD part_qty LIKE b_co_qty_cur
    FIELD part_site LIKE b_co_site
    FIELD part_loc LIKE b_co_loc
    FIELD part_status LIKE b_co_status
    FIELD part_time AS CHAR FORMAT 'x(12)'
    FIELD part_date AS DATE
    FIELD part_sess LIKE g_sess
    INDEX part_index IS PRIMARY part_sess part_date DESC  part_time DESC   part_site part_loc part_lot part_status ASC.

DEFINE QUERY bc_qry FOR part_tmp.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
        
        part_code  LABEL "条码" FORMAT "x(18)"

 
 part_lot LABEL "批/序号"

        part_qty LABEL "数量" FORMAT "->>,>>>,>>9.9" 
        part_part LABEL "零件号"
      part_site LABEL "地点"
        part_loc LABEL "库位"   
       part_status LABEL '状态'
        part_date LABEL "日期"
        part_time LABEL '时间'
  
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  SCROLLABLE TITLE "查询清单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
    bc_lot AT ROW 1.5 COL 3
   
    bc_brw AT ROW 3 COL 1
  /* bc_pkqty AT ROW 10 COL 4*/
   
  
   
    
    WITH SIZE 30 BY 14 TITLE "条码查询-批号"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_lot  bc_brw WITH FRAME bc IN WINDOW c-win.

/*DISABLE bc_lot_desc  bc_lot_desc1 WITH FRAME bc .*/

VIEW c-win.
ON CURSOR-DOWN OF bc_lot
DO:
    
       ASSIGN bc_lot.
       FIND FIRST pt_mstr  NO-LOCK WHERE /*b_co_part = bc_lot AND*/  pt_part > bc_lot NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_lot = pt_part.
           DISPLAY bc_lot WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_lot
DO:
   
      ASSIGN bc_lot.
       FIND LAST pt_mstr  NO-LOCK WHERE /*b_co_part = bc_lot AND*/  pt_part < bc_lot NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_lot = pt_part.
           DISPLAY bc_lot WITH FRAME bc.
       END.
    
END.
ON enter OF bc_lot
DO:
     ASSIGN bc_lot.
     FIND FIRST pt_mstr  NO-LOCK WHERE pt_part = bc_lot  NO-ERROR.
     IF NOT AVAILABLE pt_mstr THEN DO:
         MESSAGE '无效零件号！' VIEW-AS ALERT-BOX ERROR.
         UNDO,RETRY.
         END.
         ELSE DO:
       RUN main.   
       END.
   
END.

    
     
/*
ON 'choose':u OF bc_button
DO:
    DISABLE bc_button WITH FRAME bc.
    RUN main.
END.*/
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.




PROCEDURE main:
    FOR EACH part_tmp WHERE part_sess = g_sess:
        DELETE part_tmp.
    END.
     
   /* FOR EACH ld_det WHERE ld_part = bc_lot AND ld_lot <> '' NO-LOCK ,*/ FOR EACH b_co_mstr USE-INDEX b_co_sort4 WHERE /*b_co_site = ld_site AND b_co_loc = ld_loc*/
        /*AND*/ b_co_part = bc_lot  /*AND b_co_status = 'rct'*/  NO-LOCK:
        CREATE part_tmp.
        ASSIGN part_sess = g_sess
              part_code = b_co_code
            part_part = b_co_part
            part_lot = b_co_lot
            part_qty = b_co_qty_cur
            part_site = b_co_site
            part_loc = b_co_loc
            part_status = b_co_status
            part_time = STRING(integer(substr(b_co_code,7,6)),"hh:mm:ss")
            part_date = DATE(SUBSTR(b_co_code,1,6)).
    END.
    OPEN QUERY bc_qry FOR EACH part_tmp WHERE part_sess = g_sess NO-LOCK.
    
     
 END.
{bctrail.i}
