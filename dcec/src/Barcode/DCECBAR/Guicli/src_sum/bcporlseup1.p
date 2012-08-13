{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
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
DEF VAR bc_part1 AS CHAR FORMAT 'x(18)' LABEL "至".
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_date AS DATE LABEL '日期'.
DEF VAR bc_date1 AS DATE LABEL '至'.
DEF TEMP-TABLE b_po_chk
    FIELD b_po_g_sess LIKE g_sess
    FIELD b_po_recid AS RECID.
DEF FRAME bc
    bc_po_vend AT ROW 1.2 COL 2.5
    bc_po_vend1  AT ROW 2.4 COL 5.6
    bc_po_nbr AT ROW 3.6 COL 2.5
   
    bc_po_nbr1  AT ROW 4.8 COL 5.6
   
   bc_part AT ROW 6 COL 2.5
   /* bc_po_nbr AT ROW 6.5 COL 2.5*/
    bc_part1 AT ROW 7.2 COL 5.6
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
   bc_date AT ROW 8.4 COL 4
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 10 COL 10
    
    WITH SIZE 30 BY 12 TITLE "送货单更新"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_po_vend bc_po_vend1 bc_po_nbr bc_po_nbr1 bc_part bc_part1 bc_date  bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY + 1.

 DISP bc_date WITH FRAME bc.
VIEW c-win.

ON CURSOR-DOWN OF bc_po_vend
DO:
    
       ASSIGN bc_po_vend.
       FIND FIRST vd_mstr NO-LOCK WHERE vd_addr > bc_po_vend NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend = vd_addr.
           DISPLAY bc_po_vend WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_vend
DO:
   
       ASSIGN bc_po_vend.
       FIND LAST vd_mstr NO-LOCK WHERE vd_addr < bc_po_vend NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend = vd_addr.
           DISPLAY bc_po_vend WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_po_vend
DO:
 bc_po_vend = bc_po_vend:SCREEN-VALUE.
END.
ON enter OF bc_po_vend
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_po_vend = bc_po_vend:SCREEN-VALUE.
   /* DISABLE bc_po_vend WITH FRAME bc.
    ENABLE bc_po_vend1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_po_vend1.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.


ON CURSOR-DOWN OF bc_po_vend1
DO:
    
       ASSIGN bc_po_vend1.
       FIND FIRST vd_mstr NO-LOCK WHERE vd_addr > bc_po_vend1 NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend1 = vd_addr.
           DISPLAY bc_po_vend1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_vend1
DO:
   
       ASSIGN bc_po_vend1.
       FIND LAST vd_mstr NO-LOCK WHERE vd_addr < bc_po_vend1 NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend1 = vd_addr.
           DISPLAY bc_po_vend1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_po_vend1
DO:
 bc_po_vend1 = bc_po_vend1:SCREEN-VALUE.
END.
ON enter OF bc_po_vend1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_po_vend1 = bc_po_vend1:SCREEN-VALUE.
  /*  DISABLE bc_po_vend1 WITH FRAME bc.
    ENABLE bc_po_nbr WITH FRAME bc.*/
    APPLY 'entry':u TO bc_po_nbr.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.
ON CURSOR-DOWN OF bc_po_nbr
DO:
    
       ASSIGN bc_po_nbr.
       FIND FIRST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_order > bc_po_nbr NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_po_nbr = scx_order.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_nbr
DO:
   
       ASSIGN bc_po_nbr.
       FIND LAST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_order < bc_po_nbr NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_po_nbr = scx_order.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_po_nbr
DO:
 bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
END.
ON enter OF bc_po_nbr
DO:
    bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""po"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: */
     /*  DISABLE bc_po_nbr WITH FRAME bc.
       ENABLE bc_po_nbr1 WITH FRAME bc.*/
    APPLY  'entry':u TO bc_po_nbr1.
 
  /* END.*/
END.



ON CURSOR-DOWN OF bc_po_nbr1
DO:
    
       ASSIGN bc_po_nbr1.
       FIND FIRST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_order > bc_po_nbr1 NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_po_nbr1 = scx_order.
           DISPLAY bc_po_nbr1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_nbr1
DO:
   
       ASSIGN bc_po_nbr1.
       FIND LAST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_order < bc_po_nbr1 NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_po_nbr1 = scx_order.
           DISPLAY bc_po_nbr1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_po_nbr1
DO:
 bc_po_nbr1 = bc_po_nbr1:SCREEN-VALUE.
END.
ON enter OF bc_po_nbr1
DO:
    bc_po_nbr = bc_po_nbr1:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""po"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: */
     /*  DISABLE bc_po_nbr1 WITH FRAME bc.
       ENABLE bc_part WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part.
 
  /* END.*/
END.
/*ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.*/
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 

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
  /*  DISABLE bc_part WITH FRAME bc.
    ENABLE bc_part1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part1.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
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
    /*DISABLE bc_part1 WITH FRAME bc.*/
    
  /*  ENABLE bc_date WITH FRAME bc.*/
    APPLY 'entry':u TO bc_date.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.

ON VALUE-CHANGED OF bc_date
DO:
ASSIGN bc_date.
END.
ON enter OF bc_date
DO:
    ASSIGN bc_date.
       /* DISABLE bc_date WITH FRAME bc.
    ENABLE bc_date1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.
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
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
     
      DEF VAR i AS INT.
      IF bc_po_vend1 = '' THEN bc_po_vend1 = hi_char.
      IF bc_po_nbr1 = '' THEN bc_po_nbr1 = hi_char.
      IF bc_part1 = '' THEN bc_part1 = hi_char.
     /* IF bc_date = ? THEN bc_date = low_date.
      IF bc_date1 = ? THEN bc_date1 = hi_date.*/
    
     
     for each scx_ref no-lock
      where scx_type = 2 AND scx_shipfrom >= bc_po_vend AND scx_shipfrom <= bc_po_vend1
         AND scx_order >= bc_po_nbr AND scx_order <= bc_po_nbr1 AND scx_part >= bc_part AND scx_part <= bc_part1 ,
      each pod_det no-lock
      where pod_nbr = scx_order and pod_line = scx_line AND pod_stat = "" /* ,
      each po_mstr no-lock
      where po_nbr = pod_nbr AND po_stat = "" */:
        
     FOR EACH sch_mstr no-lock
   where sch_type = 4   AND sch_rlse_id = pod_curr_rlse_id[1]
   and sch_nbr = pod_nbr and sch_line = pod_line:
             
       
         for each schd_det no-lock
    where schd_type = sch_type AND schd_date = bc_date
    and schd_nbr = sch_nbr
    and schd_line = sch_line
    and schd_rlse_id = sch_rlse_id:
             FIND FIRST IN_mstr WHERE IN_site = scx_shipto AND IN_part = pod_part NO-LOCK NO-ERROR.
             FIND FIRST pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR.
             FIND FIRST b_po_wkfl WHERE (IF AVAILABLE in_mstr THEN b_po_staff = in__qadc01 ELSE yes) AND b_po_due_date = schd_date AND b_po_nbr = schd_nbr AND b_po_line = string(schd_line) AND b_po_part = pod_part     EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b_po_wkfl THEN DO:
         FIND FIRST b_po_rec WHERE b_po_recdate = schd_date AND b_po_ponbr = schd_nbr AND b_po_poln = STRING(schd_line) NO-LOCK NO-ERROR.
           CREATE  b_po_wkfl.
              ASSIGN
                   b_po_nbr = schd_nbr
                  b_po_line = string(schd_line)
                  b_po_part = pod_part
                  b_po_qty_req = schd_discr_qty * IF pod_um_conv <> 0 THEN pod_um_conv ELSE 1
                      b_po_qty_rec = IF AVAILABLE b_po_rec THEN b_po_recqty ELSE  0
                  b_po_due_date = schd_date
                  b_po_staff = IF AVAILABLE in_mstr THEN IN__qadc01 ELSE ''
                  b_po_prod = IF AVAILABLE pt_mstr THEN pt_prod_line ELSE '' 
                  b_po_vend = scx_shipfrom.
     
                  END.
              ELSE
                  /*IF b_po_qty_rec = 0 THEN*/
                  ASSIGN b_po_qty_req = schd_discr_qty * IF pod_um_conv <> 0 THEN pod_um_conv ELSE 1.
                         
               CREATE b_po_chk.
               ASSIGN b_po_g_sess = g_sess
                   b_po_recid = RECID(b_po_wkfl).
              

     
     
   
     
     
   
        
        
         END.
     END.
     END.
     FOR EACH b_po_wkfl WHERE b_po_due_date = bc_date AND b_po_vend >= bc_po_vend AND b_po_vend <= bc_po_vend1
         AND b_po_nbr >= bc_po_nbr AND b_po_nbr <= bc_po_nbr1 AND b_po_part >= bc_part AND b_po_part <= bc_part1 
         AND NOT CAN-FIND(FIRST b_po_chk WHERE b_po_g_sess = g_sess AND b_po_recid = recid(b_po_wkfl) NO-LOCK) EXCLUSIVE-LOCK:
         FIND FIRST pod_det WHERE pod_nbr = b_po_nbr AND string(pod_line) = b_po_line NO-LOCK NO-ERROR.
         FIND FIRST schd_det WHERE schd_type = 4 AND schd_nbr = pod_nbr AND schd_line = pod_line AND schd_rlse_id = pod_curr_rlse_id[1] AND
             schd_date = b_po_due_date.
         IF NOT AVAILABLE schd_det THEN DO:
        
             IF b_po_qty_rec = 0 THEN  DELETE b_po_wkfl.
                                 ELSE b_po_qty_req = 0.
         END.
         ELSE DO: 
         
             IF schd_discr_qty = 0 THEN 
               IF b_po_qty_rec = 0 THEN  DELETE b_po_wkfl.
                                 ELSE b_po_qty_req = 0.
            END.

     END.
      
      RELEASE b_po_wkfl.
     ENABLE bc_po_vend WITH FRAME bc.
               END.


{bctrail.i}
