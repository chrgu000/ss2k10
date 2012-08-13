{mfdeclre.i}
{bcdeclre.i }
{bcwin07.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)" LABEL "零件描述".
DEF VAR bc_part_desc2 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "拆分数量".
DEF VAR bcprefix AS CHAR.
DEF VAR bc_poshp AS CHAR FORMAT "x(18)" LABEL "货运单".
DEF VAR bc_poshp1 AS CHAR FORMAT "x(18)" LABEL "至".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9" LABEL "张数".
DEF VAR ismodi AS LOGICAL.
 DEF VAR bc AS CHAR.
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "需求量".
DEF VAR bc_mult AS LOGICAL  LABEL "最小包装".
DEF FRAME bc
    bc_poshp AT ROW 2 COL 2.5
   bc_poshp1 AT ROW 3.5 COL 5.5
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
   /* bc_mult AT ROW 4.5 COL 1*/
  bc_button AT ROW 5.5 COL 10
 
    WITH SIZE 30 BY 8 TITLE "条码重打-货运单"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ismodi = NO.

ENABLE bc_poshp  bc_poshp1  bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.


ON CURSOR-DOWN OF bc_poshp
DO:
    
       ASSIGN bc_poshp.
       FIND FIRST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) > bc_poshp  NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_poshp = SUBSTR(ABS_id,2,50).
           DISPLAY bc_poshp WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_poshp
DO:
    ASSIGN bc_poshp.
       FIND LAST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) < bc_poshp  NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_poshp = SUBSTR(ABS_id,2,50).
           DISPLAY bc_poshp WITH FRAME bc.
       END.
   
END.

ON VALUE-CHANGED OF bc_poshp
DO:
    bc_poshp = bc_poshp:SCREEN-VALUE.
   /* DISABLE bc_poshp WITH FRAME bc.*/
    
END.

ON enter OF bc_poshp
DO:
    bc_poshp = bc_poshp:SCREEN-VALUE.
   /* DISABLE bc_poshp WITH FRAME bc.*/
    APPLY 'entry':u TO bc_poshp1 .
END.
ON CURSOR-DOWN OF bc_poshp1
DO:
    
       ASSIGN bc_poshp1.
       FIND FIRST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) >= bc_poshp   NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_poshp1 = SUBSTR(ABS_id,2,50).
           DISPLAY bc_poshp1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_poshp1
DO:
    ASSIGN bc_poshp1.
       FIND LAST ABS_mstr NO-LOCK WHERE (ABS_id BEGINS 's' OR ABS_id BEGINS 'c') AND ABS_type = 'r' AND substr(ABS_id,2,50) < bc_poshp1  NO-ERROR.
       IF AVAILABLE ABS_mstr THEN DO:
           ASSIGN bc_poshp1 = SUBSTR(ABS_id,2,50).
           DISPLAY bc_poshp1 WITH FRAME bc.
       END.
   
END.

   ON VALUE-CHANGED OF bc_poshp1
DO:
    bc_poshp1 = bc_poshp1:SCREEN-VALUE.
   /* DISABLE bc_poshp WITH FRAME bc.*/
    
END.
ON enter OF bc_poshp1
DO:
   
    bc_poshp1 = bc_poshp1:SCREEN-VALUE.
   /* DISABLE bc_poshp1 WITH  FRAME bc.*/
    /* APPLY 'entry':u TO bc_mult.*/
    RUN main.
    
         
    END.
 /*ON CURSOR-DOWN OF bc_mult
DO:
 ASSIGN bc_mult.
 IF bc_mult  THEN bc_mult = NO.
       ELSE bc_mult = YES.
       DISP bc_mult WITH FRAME bc.

 END.

 ON CURSOR-UP OF bc_mult
DO:
 ASSIGN bc_mult.
 IF bc_mult  THEN bc_mult = NO.
       ELSE bc_mult = YES.
       DISP bc_mult WITH FRAME bc.

 END.

 ON VALUE-CHANGED OF bc_mult
 DO:
     ASSIGN bc_mult.
 END.
 ON enter OF bc_mult
 DO:
     ASSIGN  bc_mult.
     APPLY 'entry':u TO bc_button.
 END.*/
  ON 'choose':U OF bc_button
  DO:
      RUN main.
  END.


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
      DEF VAR j AS INT.
   DEF VAR mqty AS DECIMAL.
   DEF VAR mdesc AS CHAR FORMAT "x(50)".
    DEF VAR prt AS CHAR FORMAT 'x(22)' LABEL '打印机'.
      DEF VAR isfirst AS CHAR.
          DEF VAR isleave AS LOGICAL.
          isfirst = 'first'.
      /*DEF BUFFER absmstr FOR ABS_mstr.*/
    IF bc_poshp1 = '' THEN bc_poshp1 = hi_char.
      FOR EACH b_co_mstr USE-INDEX b_co_sort5 WHERE b_co_ref >= bc_poshp AND b_co_ref <= bc_poshp1  AND b_co_status <> 'ia' NO-LOCK:
          mdesc = b_co_desc2 + b_co_desc1. 
          {bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend" "mdesc" "isfirst"}
             
      END.

 
     
     
  
   
     
    
              RELEASE b_co_mstr.
   
               RELEASE b_po_wkfl.
         ENABLE bc_poshp WITH FRAME bc.
         APPLY 'entry':u TO bc_poshp.
               END.


{bctrail.i}
