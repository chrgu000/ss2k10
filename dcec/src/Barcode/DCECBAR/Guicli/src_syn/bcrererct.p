{mfdeclre.i}
{bcdeclre.i  }
{bcwin12.i}
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
DEFINE TEMP-TABLE t_tr_hist
    field t_tr_part like tr_part
    field t_tr_date like tr_date
    field t_tr_site like tr_site
    field t_tr_loc like tr_loc
    FIELD t_tr_lot LIKE tr_lot
    field t_tr_serial like tr_serial
    field t_tr_qty_loc like tr_qty_loc
    field t_tr_type like tr_type
    field t_tr_nbr like tr_nbr
    field t_tr_line like tr_line
    field t_tr_um like tr_um
    field t_tr_userid like tr_userid
    field t_tr_time like tr_time
    field t_tr_addr like tr_addr
    field t_tr_trnbr like tr_trnbr
    FIELD t_tr_site1 LIKE tr_site
    FIELD t_tr_loc1 LIKE tr_loc
    FIELD t_tr_sess AS CHAR.
DEF FRAME bc
    
   bc_date AT ROW 1.5 COL 4
    bc_date1 AT ROW 3 COL 5.5
   bc_part AT ROW 4.5 COL 2.5
   /* bc_po_nbr AT ROW 6.5 COL 2.5*/
    bc_part1 AT ROW 6 COL 5.5
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
   
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 7.5 COL 10
    
    WITH SIZE 30 BY 10 TITLE "自制件入库条码生成"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_date bc_date1 bc_part bc_part1   bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY .
bc_date1 = TODAY.
 DISP bc_date bc_date1 WITH FRAME bc.
VIEW c-win.

ON VALUE-CHANGED OF bc_date
DO:
    
    ASSIGN bc_date NO-ERROR.
   /* IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE '无效日期!' VIEW-AS ALERT-BOX.
        UNDO,RETRY.
    END.*/

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
    
    APPLY 'entry':u TO bc_part.
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
     DEF VAR bc_qty_mult AS DECIMAL.
     DEF VAR mqty AS DECIMAL.
      DEF VAR i AS INT.
      DEF VAR bcprefix AS CHAR.
      DEF VAR bc_qty_label AS INT.
      DEF VAR bc_qty AS DECIMAL.
      DEF VAR mtrqadid AS INT.
     IF bc_date = ? THEN bc_date = low_date.
     IF bc_date1 = ? THEN bc_date1 = hi_date.
      IF bc_part1 = '' THEN bc_part1 = hi_char.
      DEF VAR j AS INT.
     /* IF bc_date = ? THEN bc_date = low_date.
      IF bc_date1 = ? THEN bc_date1 = hi_date.*/
       FOR EACH tr_hist USE-INDEX tr_date_trn WHERE  tr_date >= bc_date AND tr_date <= bc_date1 AND tr_type = 'rct-wo'  AND tr_part >= bc_part AND tr_part <= bc_part1
           NO-LOCK:
           FIND LAST b_tr_hist USE-INDEX b_tr_date_trn WHERE b_tr_date = tr_date AND b_tr_type = 'rct-wo' AND b_tr_part = tr_part AND b_tr_site = tr_site AND b_tr_loc = tr_loc NO-LOCK NO-ERROR.
          
           IF NOT AVAILABLE b_tr_hist OR (IF AVAILABLE b_tr_hist THEN tr_trnbr > b_tr_trnbr_qad ELSE NO)  THEN DO:
        /*   MESSAGE tr_trnbr VIEW-AS ALERT-BOX.
            MESSAGE b_tr_trnbr VIEW-AS ALERT-BOX.*/
           CREATE t_tr_hist.
         ASSIGN
             t_tr_part = tr_part
    t_tr_date = tr_date
             t_tr_time = tr_time
     t_tr_site = tr_site
     t_tr_loc = tr_loc
     t_tr_lot = tr_lot
     t_tr_serial = tr_serial
     t_tr_qty_loc = tr_qty_loc
     t_tr_type = tr_type
     t_tr_nbr = tr_nbr
     t_tr_line = tr_line
     t_tr_um = tr_um
     t_tr_userid = tr_userid
       t_tr_trnbr = tr_trnbr
    t_tr_sess = g_sess.
         
           END.
       END.
      
      
      mtrqadid = 0.
      j = 1.
      mqty = 0.
      bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
      FOR EACH t_tr_hist WHERE t_tr_sess = g_sess NO-LOCK BREAK /*BY t_tr_nbr BY t_tr_lot*/ BY t_tr_date BY t_tr_site BY t_tr_loc  BY t_tr_part:
          
          mqty = mqty + t_tr_qty_loc.

         IF mtrqadid < t_tr_trnbr THEN mtrqadid = t_tr_trnbr.
           IF LAST-OF(t_tr_part) AND mqty > 0 THEN DO:
           
       FIND FIRST ptp_det WHERE ptp_part = t_tr_part AND ptp_site = t_tr_site NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN
            bc_qty_mult = IF ptp_ord_mult <> 0  AND mqty > ptp_ord_mult THEN ptp_ord_mult ELSE mqty.
           ELSE DO:
          FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
              IF AVAILABLE pt_mstr THEN  bc_qty_mult = IF pt_ord_mult <> 0 AND mqty > pt_ord_mult THEN pt_ord_mult ELSE mqty.
            END.
              bc_qty_label = IF bc_qty_mult <> 0 AND mqty MOD bc_qty_mult <> 0 THEN truncate(mqty / bc_qty_mult,0) + 1 ELSE
                mqty / (IF bc_qty_mult <> 0 THEN bc_qty_mult ELSE mqty). 
          
             
            
           
             
                        
             
             DO i = 1  TO   bc_qty_label:
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
                   b_co_part = t_tr_part
                   b_co_lot = b_id
                                   /* b_co_qty_ini = bc_qty*/
                 
                    b_co_qty_cur = 
                                    IF i < bc_qty_label THEN bc_qty_mult ELSE IF mqty MOD bc_qty_mult = 0 THEN bc_qty_mult ELSE mqty MOD bc_qty_mult
                       
                   /*b_co_qty_std = bc_qty_std*/
                   b_co_um = 'ea'
                   b_co_status = 'rct'
                   /*b_co_format = m_fmt*/
                   b_co_userid = g_user
                    b_co_ord = t_tr_nbr
                   b_co_line = t_tr_lot
                  /* b_co_qty_req = bc_rlse_qty*/
                   b_co_desc1 = IF AVAILABLE pt_mstr THEN pt_desc1 ELSE ''
                   b_co_desc2 = IF AVAILABLE pt_mstr THEN pt_desc2 ELSE ''
                   b_co_site = t_tr_site
                    b_co_loc = t_tr_loc.
                   {bctrcr.i
         &ord=b_co_part
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=0
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=t_tr_date
          &mdate2=t_tr_date
          &mdate_eff=t_tr_date
           &b_typ='"rct-wo"'
          &mtime=t_tr_time
           &b_loc=b_co_loc
           &b_site=b_co_site
           &b_usrid=g_user
           &b_addr=?}
 
           b_tr_trnbr_qad =  mtrqadid.
                   {bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend"}
             j = j + 1.
               END.
         mqty = 0.
         mtrqadid = 0.
           END.


       END.
     FOR EACH t_tr_hist WHERE t_tr_sess = g_sess EXCLUSIVE-LOCK:
           DELETE t_tr_hist.
       END.
       MESSAGE '入库条码生成完毕!' VIEW-AS ALERT-BOX.
END.
{bctrail.i}
