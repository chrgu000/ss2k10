{mfdeclre.i}
{bcdeclre.i  }
{bcwin07.i}
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
DEF VAR bc_poshp AS CHAR FORMAT "x(18)" LABEL "货运单".
DEF VAR bc_poshp1 AS CHAR FORMAT "x(18)" LABEL "至".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "张数".
DEF VAR ismodi AS LOGICAL.
 DEF VAR bc AS CHAR.
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_mult AS LOGICAL  LABEL "最小包装".
DEF FRAME bc
    bc_poshp AT ROW 1.5 COL 2.5
   bc_poshp1 AT ROW 3 COL 5.5
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
    bc_mult AT ROW 4.5 COL 1
  bc_button AT ROW 6 COL 10
 
    WITH SIZE 30 BY 8 TITLE "条码生成-货运单"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ismodi = NO.
bc_mult = YES.
ENABLE bc_poshp  bc_poshp1 bc_mult bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_mult WITH FRAME bc.
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
     APPLY 'entry':u TO bc_mult.
    
         
    END.
 ON CURSOR-DOWN OF bc_mult
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
 END.
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

      /*DEF BUFFER absmstr FOR ABS_mstr.*/
    IF bc_poshp1 = '' THEN bc_poshp1 = hi_char.
      /*FOR EACH ABS_mstr WHERE (abs_id BEGINS 's' OR abs_id BEGINS 'c') AND abs_type = 'r' AND substr(ABS_id,2,50) >= bc_poshp AND substr(ABS_id,2,50) <= bc_poshp1 NO-LOCK:
         FIND FIRST b_co_mstr WHERE b_co_ref = SUBSTR(ABS_id,2,50) NO-LOCK NO-ERROR.
         IF NOT AVAILABLE  b_co_mstr THEN DO:*/
 j = 1.
    bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).

    FOR EACH ABS_mstr WHERE    (abs_par_id BEGINS 's' OR abs_par_id BEGINS 'c') AND abs_type = 'r' AND substr(ABS_par_id,2,50) >= bc_poshp AND substr(ABS_par_id,2,50) <= bc_poshp1 NO-LOCK:
         FIND FIRST pod_det WHERE pod_nbr = ABS_order AND string(pod_line) = ABS_line NO-LOCK NO-ERROR.
          bc_rlse_qty = ABS_qty * (IF pod_um_conv <> 0 THEN pod_um_conv ELSE 1).
        IF bc_mult  THEN DO:
           bc_qty_mult = bc_rlse_qty.
       FIND FIRST ptp_det WHERE ptp_part = ABS_item AND ptp_site = ABS_site NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN
            bc_qty_mult = IF ptp_ord_mult <> 0 THEN ptp_ord_mult ELSE bc_rlse_qty.
           ELSE DO:
          FIND FIRST pt_mstr WHERE pt_part = ABS_item NO-LOCK NO-ERROR.
              IF AVAILABLE pt_mstr THEN  bc_qty_mult = IF pt_ord_mult <> 0 THEN pt_ord_mult ELSE bc_rlse_qty.

           END.
        END.
            IF bc_mult THEN     bc_qty_label = IF bc_qty_mult <> 0 AND bc_rlse_qty MOD bc_qty_mult <> 0 THEN truncate(bc_rlse_qty / bc_qty_mult,0) + 1 ELSE
                 bc_rlse_qty / (IF bc_qty_mult <> 0 THEN bc_qty_mult ELSE bc_rlse_qty). 
               ELSE
                   bc_qty_label = 1.
          
                        
             
             DO i = 1 TO bc_qty_label:
             
                   IF j MOD 1000 = 0 THEN do:
                     PAUSE 1.
                      MESSAGE '已生成1000张标签!' VIEW-AS ALERT-BOX.
                     bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
                 END.
                 b_id = bcprefix + STRING(j MOD 1000,'999').
                   
                       bc_id = b_id.
                  
                  
                   CREATE b_co_mstr.
               ASSIGN 
                   b_co_code = b_id
                   b_co_part = ABS_item
                   b_co_lot = b_id
                                   /* b_co_qty_ini = bc_qty*/
                 
                    b_co_qty_cur = 
                                   IF bc_mult THEN ( IF i < bc_qty_label THEN bc_qty_mult ELSE IF bc_rlse_qty MOD bc_qty_mult = 0 THEN bc_qty_mult ELSE bc_rlse_qty MOD bc_qty_mult
                        )
                                       ELSE
                           bc_rlse_qty
                   /*b_co_qty_std = bc_qty_std*/
                   b_co_um = 'ea'
                   b_co_status = 'ac'
                   /*b_co_format = m_fmt*/
                   b_co_userid = g_user
                   b_co_ord = ABS_order
                   b_co_line = ABS_line
                   b_co_vend = ABS_shipfrom
                  b_co_ref = substr(ABS_par_id,2,50)
                  /* b_co_qty_req = bc_rlse_qty*/
                   b_co_desc1 = IF AVAILABLE pt_mstr THEN pt_desc1 ELSE ''
                   b_co_desc2 = IF AVAILABLE pt_mstr THEN pt_desc2 ELSE ''
                   b_co_site = ABS_site
                    b_co_loc = ABS_loc.
                   {bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend"}
                       j = j + 1.
                 end.
                       
                  
        END.
      
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
         ENABLE bc_poshp WITH FRAME bc.
               END.


{bctrail.i}
