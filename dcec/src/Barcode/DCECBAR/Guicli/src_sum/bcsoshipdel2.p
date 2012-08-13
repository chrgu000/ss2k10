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
DEF TEMP-TABLE b_shp_tmp
    FIELD shptmp_sess LIKE g_sess
    FIELD b_shp_tmpid LIKE b_shp_shipper.
DEFINE QUERY bc_qry FOR b_shp_tmp.
       
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          b_shp_tmpid COLUMN-LABEL "发运单" FORMAT "x(20)"
          
        
  
WITH NO-ROW-MARKERS SEPARATORS 7 DOWN WIDTH 21  /*TITLE "待收货清单"*/.
DEF FRAME bc
    bc_cust AT ROW 1.2 COL 4
    bc_brw AT ROW 2.4 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
 
 
    WITH SIZE 30 BY 12 TITLE "发运单打印"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ismodi = NO.
ENABLE bc_so_nbr WITH FRAME bc IN WINDOW c-win.
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
    FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_cust = bc_cust AND b_shp_status = '' NO-LOCK BREAK BY b_shp_shipper :
        IF FIRST-OF(b_shp_shipper) THEN DO:
       CREATE b_shp_tmp.
        ASSIGN 
            shptmp_sess = g_sess
            b_shp_tmpid = b_shp_shipper.
        END.
    END.
    OPEN QUERY bc_qry FOR EACH b_shp_tmp WHERE shptmp_sess = g_sess NO-LOCK.
        FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_cust = bc_cust AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
        ENABLE bc_brw WITH FRAME bc.
END.
ON VALUE-CHANGED OF bc_cust
DO:
    bc_cust = bc_cust:SCREEN-VALUE.
   /* DISABLE bc_ship WITH FRAME bc.*/
    
END.
ON 'mouse-select-dblclick':U OF bc_brw
DO:
    DEF VAR oktocmt AS LOGICAL INITIAL NO.
    MESSAGE '确定删除吗？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO UPDATE oktocmt.
    IF oktocmt  THEN
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
    
        FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = b_shp_tmp.b_shp_tmpid AND b_shp_status = '' EXCLUSIVE-LOCK:
           FIND FIRST b_co_mstr WHERE b_co_code = b_shp_code EXCLUSIVE-LOCK NO-ERROR.
           ASSIGN
              
        b_co_cust = ''
        b_co_qty_req = 0
       b_co_due_date = ?
       b_co_ord = ''
       b_co_line = ''
       b_co_status = 'rct'.
           DELETE b_shp_wkfl.
          
        END.
        DELETE b_shp_tmp.
        OPEN QUERY bc_qry FOR EACH b_shp_tmp WHERE shptmp_sess = g_sess NO-LOCK.
      
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
   
               RELEASE b_shp_wkfl.
         /*ENABLE bc_ship WITH FRAME bc.*/
               END.


{bctrail.i}
