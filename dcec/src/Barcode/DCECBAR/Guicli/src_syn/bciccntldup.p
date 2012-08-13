{bcdeclre.i  }
    {bcwin03.i}
    {bctitle.i}
{mfdeclre.i}
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".

/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF TEMP-TABLE cnt_tmp
    FIELD cnt_site AS CHAR
    FIELD cnt_loc AS CHAR
    FIELD cnt_part AS CHAR
    FIELD cnt_qty AS DECIMAL
    FIELD cnt_qty_oh AS DECIMAL
    FIELD cnt_sess LIKE g_sess.

DEF  BUFFER blddet FOR b_ld_det.
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
     bc_site AT ROW 1.5 COL 4
    bc_site1 AT ROW 3 COL 5.5
   
    bc_loc AT ROW 4.5 COL 4
     bc_loc1 AT ROW 6 COL 5.5
  
  /* bc_pkqty AT ROW 10 COL 4*/
  

    bc_button AT ROW 8 COL 10

    WITH SIZE 30 BY 10 TITLE "盘点库存更新"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_site bc_site1 bc_loc bc_loc1  bc_button WITH FRAME bc .
/*ON CURSOR-DOWN OF bc_part
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
    /*{bcrun.i ""bcmgcheck.p"" "(input ""part"",
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
           /* DISABLE bc_part WITH FRAME bc.
            ENABLE bc_part1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part1.
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
/*.i ""bcmgcheck.p"" "(input ""part"",
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
           /* DISABLE bc_part1 WITH FRAME bc.*/
           APPLY 'entry':u TO bc_button.
        /*END.*/
END.*/

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
              /* DISABLE bc_site WITH FRAME bc.
               ENABLE bc_site1 WITH FRAME bc.*/
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
            /*   DISABLE bc_site1 WITH FRAME bc.
               ENABLE bc_loc WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc.

          /* END.*/
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
            /*   DISABLE bc_loc WITH FRAME bc.
               ENABLE bc_loc1 WITH FRAME bc.*/
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
ON enter OF  bc_loc1
DO:
    ASSIGN bc_loc1.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
              /* DISABLE bc_loc1 WITH FRAME bc.
              ENABLE bc_part WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.

           /*END.*/
END.

ON 'choose':U OF bc_button
DO:
    RUN main.
END.

PROCEDURE main:
    
    DEF VAR cyc_qty LIKE b_cnt_qty_cnt.
    DEF VAR cnt_tr_typ  AS CHAR.
    DEF VAR isup AS LOGICAL INITIAL NO.
  DEF VAR mqty_cnt AS DECIMAL.
   DEF VAR oktocmt AS LOGICAL INITIAL NO.
   DEF VAR diff AS LOGICAL INITIAL NO.
   DEF VAR msite AS CHAR.
   DEF VAR mloc AS CHAR.
   DEF VAR mpart AS CHAR.
   DEF VAR mlot AS CHAR.
   DEF VAR mqty_oh AS DECIMAL.
   
   DEF VAR bqty_oh AS DECIMAL.

     {bcrun.i ""bcmgcheck.p"" "(input ""period"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input ""IC"", 
        input """",
         input """",
        output success)"}   
           
     IF NOT success THEN LEAVE.
   
  
   mqty_cnt = 0.
    IF bc_part1 = '' THEN bc_part1 = hi_char.
    IF bc_site1 = ''  THEN bc_site1 = hi_char.
    IF bc_loc1 = '' THEN bc_loc1 = hi_char.
    MESSAGE '确认要更新库存吗!' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO UPDATE oktocmt.
   /* FIND FIRST b_cnt_wkfl WHERE    b_cnt_qty_oh <> b_cnt_qty_cnt 
         AND b_cnt_loc >= bc_loc AND b_cnt_loc <= bc_loc1
        AND b_cnt_part >= bc_part AND b_cnt_part <= bc_part1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl AND b_cnt_id <> 'first' THEN 
            DO:
                MESSAGE '初盘有差异,进行重盘!' VIEW-AS ALERT-BOX.
                LEAVE.
            END.*/

   
    /*FOR EACH b_cnt_wkfl WHERE 
         b_cnt_site >= bc_site AND b_cnt_site <= bc_site1 
        AND b_cnt_loc >= bc_loc AND b_cnt_loc <= bc_loc1
        AND b_cnt_part >= bc_part AND b_cnt_part <= bc_part1 AND b_cnt_id <> 'first' AND b_cnt_status = 'i' AND b_cnt_qty_oh <> b_cnt_qty_cnt NO-LOCK BREAK BY (TRIM(b_cnt_id) + TRIM(b_cnt_site) + TRIM(b_cnt_loc) + TRIM(b_cnt_part)):
        mqty_cnt = mqty_cnt + b_cnt_qty_cnt.
    
       
        IF LAST-OF(TRIM(b_cnt_id) + TRIM(b_cnt_site) + TRIM(b_cnt_loc) + TRIM(b_cnt_part)) THEN DO:
       
        {bcrun.i ""bcmgcheck.p"" "(input ""cnt_chk"" ,
        input b_cnt_site,
        input b_cnt_loc, 
        input b_cnt_part, 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input STRING(mqty_cnt), 
        input """",
         input """",
        output success)"}
            mqty_cnt = 0.
           
           IF NOT success  THEN LEAVE.
        END.

    END.
    END.
        IF NOT success THEN LEAVE.*/
    /*FIND FIRST b_cnt_wkfl WHERE b_cnt_status = 'r' AND b_cnt_qty_rcnt = 0 NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN
        MESSAGE '存在重盘数量为0，请确定要更新吗，更新后不能还原！' VIEW-AS ALERT-BOX
        QUESTION BUTTON YES-NO
        UPDATE oktocmt .
    IF NOT oktocmt  THEN LEAVE.*/
    IF oktocmt THEN DO:
       
        FOR EACH b_cnt_wkfl /*USE-INDEX b_cnt_sort1*/ WHERE  
         b_cnt_site >= bc_site AND b_cnt_site <= bc_site1 
        AND b_cnt_loc >= bc_loc AND b_cnt_loc <= bc_loc1 AND (b_cnt_status = 'i' OR b_cnt_status = 'r'  OR  b_cnt_status = 'f') 
         , FIRST b_ld_det WHERE b_ld_site = b_cnt_site AND b_ld_loc = b_cnt_loc AND b_ld_part = b_cnt_part AND b_ld_lot = b_cnt_lot AND b_ld_qty_oh <> b_cnt_qty_oh NO-LOCK:
         diff = YES.
        ASSIGN msite = b_cnt_site
               mloc = b_cnt_loc
              mpart = b_cnt_part
              mlot = b_cnt_lot.
          

        /*  IF diff THEN do:
              FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = b_cnt_part AND b_co_lot = b_cnt_lot AND b_co_site = b_cnt_site AND b_co_loc = b_cnt_loc EXCLUSIVE-LOCK:
                  b_co_cntst = ''.
              END.
             ASSIGN b_cnt_status = ''
                    b_cnt_qty_cnt = 0
                    b_cnt_qty_rcnt = 0.
              LEAVE.
              
          END.*/

     IF diff THEN   LEAVE.
    END.
    IF NOT diff THEN DO:
         FOR EACH b_cnt_wkfl /*USE-INDEX b_cnt_sort1*/ WHERE  
         b_cnt_site >= bc_site AND b_cnt_site <= bc_site1 
        AND b_cnt_loc >= bc_loc AND b_cnt_loc <= bc_loc1 AND (b_cnt_status = 'i' OR b_cnt_status = 'r' OR b_cnt_status = 'f')  /*b_cnt_qty_rcnt <> 0 AND*/  /*IF b_cnt_status = 'i' THEN  b_cnt_qty_oh <> b_cnt_qty_cnt ELSE IF b_cnt_status = 'r' THEN b_cnt_qty_oh <> b_cnt_qty_rcnt ELSE NO*/
       NO-LOCK BREAK BY b_cnt_site BY b_cnt_loc BY b_cnt_part:
            mqty_cnt = mqty_cnt + if (b_cnt_status = 'i' OR b_cnt_status = 'f') then b_cnt_qty_cnt else b_cnt_qty_rcnt.
            mqty_oh = mqty_oh + b_cnt_qty_oh.
      IF LAST-OF(b_cnt_part) THEN DO:
         CREATE cnt_tmp.
         ASSIGN
             cnt_site = b_cnt_site
             cnt_loc = b_cnt_loc
              cnt_part = b_cnt_part
             cnt_qty = mqty_cnt
             cnt_sess = g_sess
             cnt_qty_oh = mqty_oh .


ASSIGN mqty_oh =0
     mqty_cnt = 0.
      END.

         END.
    
       FOR EACH cnt_tmp NO-LOCK WHERE cnt_sess = g_sess:
     
       FIND FIRST b_ex_cnt WHERE b_ex_site = cnt_site AND b_ex_loc = cnt_loc  EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE b_ex_cnt THEN DO:
           CREATE b_ex_cnt.
           ASSIGN
                b_ex_site = cnt_site
               b_ex_loc = cnt_loc.
            FIND FIRST b_ex_cnt WHERE b_ex_site = cnt_site AND b_ex_loc = cnt_loc  EXCLUSIVE-LOCK NO-ERROR.
       END.
        FOR EACH b_ld_det WHERE b_ld_site = cnt_site AND b_ld_loc = cnt_loc AND b_ld_part = cnt_part EXCLUSIVE-LOCK:
            bqty_oh = bqty_oh + b_ld_qty_oh.
        END.
        FIND FIRST ld_det WHERE ld_site = cnt_site AND ld_loc = cnt_loc AND ld_part = cnt_part EXCLUSIVE-LOCK NO-ERROR.

        IF bqty_oh <> cnt_qty_oh OR (IF AVAILABLE ld_det THEN (cnt_qty_oh <> ld_qty_oh OR bqty_oh <> ld_qty_oh) ELSE YES)  THEN DO:
          MESSAGE cnt_site '' cnt_loc '' cnt_part ' 该库存与盘点库存不一致，该零件不能更新！' VIEW-AS ALERT-BOX.
         /* FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = cnt_part AND b_co_lot = cnt_lot AND b_co_site = b_cnt_site AND b_co_loc = b_cnt_loc EXCLUSIVE-LOCK:
                  b_co_cntst = ''.
              END.
              b_cnt_status = ''.*/
          END.
        ELSE DO:
       
      /*  IF b_cnt_status = 'r' THEN
               assign
             cnt_tr_typ = 'cyc-rcnt'
         cyc_qty = b_cnt_qty_rcnt - b_cnt_qty_oh.
        ELSE
            ASSIGN cnt_tr_typ = 'cyc-cnt'
                   cyc_qty = b_cnt_qty_cnt - b_cnt_qty_oh.
            FIND FIRST b_co_mstr WHERE b_co_code = b_cnt_code EXCLUSIVE-LOCK NO-ERROR.

            IF cyc_qty = 0 AND b_co_status <> 'ia' THEN iscontinue = YES.
                ELSE
            IF cyc_qty > 0 AND b_co_status <> 'rct' AND b_co_status <> 'all' AND b_co_status <> 'ia' THEN  iscontinue = YES.
               ELSE
                   IF cyc_qty < 0 AND b_co_status <> 'iss' AND b_co_status <> 'ia' THEN iscontinue = YES.
         IF iscontinue THEN DO:
        

     /*   IF b_cnt_status = 'r' THEN DO:
         CREATE b_tr_hist.
        b_tr_trnbr = NEXT-VALUE(b_tr_sq01) .
        b_tr_nbr = ?.
        b_tr_line = ?.
        b_tr_part = b_cnt_part.
        b_tr_serial = b_cnt_lot.
        b_tr_lot = b_cnt_id.
        b_tr_qty_req = 0.
        b_tr_qty_loc = b_cnt_qty_cnt - b_cnt_qty_oh.
        b_tr_qty_chg = b_cnt_qty_cnt - b_cnt_qty_oh.
        b_tr_um = 'ea'.
        b_tr_date = TODAY.
        b_tr_effdate = TODAY.
        b_tr_type = 'cyc-cnt'.
        b_tr_time = TIME.
        b_tr_loc = b_cnt_loc.
        b_tr_site = b_cnt_site.
        b_tr_userid = g_user.
        b_tr_ref = ?.
        b_tr_addr = ?.
            
            
            
         END.*/
       
       
       IF cyc_qty > 0  THEN ASSIGN
                                   b_co_status = 'rct'
                                   b_co_site = b_cnt_site
                                   b_co_loc = b_cnt_loc.
         ELSE IF cyc_qty < 0 THEN
                              ASSIGN
                                   b_co_status = 'iss'
                                  /* b_co_site = ''
                                   b_co_loc = ''*/.*/
       /* IF (if b_cnt_status = 'i' then b_cnt_qty_cnt else b_cnt_qty_rcnt) - b_cnt_qty_oh  > 0 THEN*/
        OUTPUT TO VALUE(g_sess). 

           put  "@@BATCHLOAD icccaj.P" skip.
            PUT '"R"' SKIP .
            PUT UNFORMAT '"' b_cnt_part '"' SKIP.
            PUT UNFORMAT '"' b_cnt_site '" "' b_cnt_loc '"' ' "     "' SKIP.
            PUT UNFORMAT STRING(cnt_qty) ' - -'  SKIP.
            PUT "- - - -"  SKIP.
            PUT  " " SKIP.
               PUT '.' SKIP.    
               PUT      "@@END" SKIP.
        
          OUTPUT CLOSE.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
                 FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date = TODAY AND tr_type = 'cyc-rcnt' AND tr_program = 'icccaj.p' AND tr_site = b_cnt_site AND tr_loc = b_cnt_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ tr_part = b_cnt_part AND tr_serial = ''  AND tr_qty_loc = cnt_qty  AND tr_userid = g_user /*AND tr_time >= TIME - 20 AND tr_time <= TIME*/  NO-LOCK NO-ERROR.

             IF  AVAILABLE tr_hist THEN do:
             FIND FIRST b_tr_hist USE-INDEX b_tr_qadid WHERE b_tr_trnbr_qad = tr_trnbr NO-LOCK NO-ERROR.
             IF  AVAILABLE b_tr_hist THEN do:
                 success = NO.
                MESSAGE  '更新QAD失败!'  VIEW-AS ALERT-BOX.
                LEAVE.
             END.
              END.
               ELSE DO:
             success = NO.
             MESSAGE  '更新QAD失败!'  VIEW-AS ALERT-BOX.
             LEAVE.
               END.
            
            
            FOR EACH b_cnt_wkfl WHERE b_cnt_site = cnt_site AND b_cnt_loc =  cnt_loc AND b_cnt_part = cnt_part EXCLUSIVE-LOCK:
           
            
            FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE   b_co_part = b_cnt_part AND b_co_lot = b_cnt_lot AND b_co_site = b_cnt_site AND b_co_loc = b_cnt_loc AND (b_co_cntst = 'i' OR b_co_cntst = 'r') AND (b_co_status = 'ac' OR b_co_status = 'iss' OR b_co_status = 'issln')  EXCLUSIVE-LOCK:
          ASSIGN b_co_status = 'rct'
                /*b_co_site = b_cnt_site
              b_co_loc = b_cnt_loc*/
              b_co_cntst = ''.
          isup = YES.  
          END.


            /* IF (if b_cnt_status = 'i' then b_cnt_qty_cnt else b_cnt_qty_rcnt) - b_cnt_qty_oh  < 0 */
        FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE   b_co_part = b_cnt_part AND b_co_lot = b_cnt_lot AND b_co_site = b_cnt_site AND b_co_loc = b_cnt_loc AND (b_co_cntst = 'i0' OR b_co_cntst = 'r0') AND (b_co_status = 'rct' OR b_co_status = 'all' )  EXCLUSIVE-LOCK:
          ASSIGN b_co_status = 'iss'
               
              b_co_cntst = ''.
          isup = YES.
            END.
            FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = b_cnt_part AND b_co_lot = b_cnt_lot AND b_co_site = b_cnt_site AND b_co_loc = b_cnt_loc AND b_co_cntst <> '' AND b_co_status <> 'ia'   EXCLUSIVE-LOCK:
        ASSIGN 
            b_co_cntst = ''.
    END.
     
       {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=?
         &b_part=b_cnt_part
         &b_lot=b_cnt_lot
         &id=?
         &b_qty_req=0
         &b_qty_loc="(if b_cnt_status = 'i' or b_cnt_status = 'f' then b_cnt_qty_cnt else b_cnt_qty_rcnt) - b_cnt_qty_oh"
         &b_qty_chg="(if b_cnt_status = 'i' or b_cnt_status = 'f' then b_cnt_qty_cnt else b_cnt_qty_rcnt) - b_cnt_qty_oh"
         &b_qty_short=0
         &b_um='ea'
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"cyc-rcnt"'
          &mtime=TIME
           &b_loc=b_cnt_loc
           &b_site=b_cnt_site
           &b_usrid=g_user
           &b_addr=?}
       /* IF b_cnt_id = 'first' THEN DO:
            ASSIGN  b_tr_sum_id = 'firstcnt'
                    b_tr_trnbr_qad = -1.
        END.*/
    
       
    b_cnt_status = 'c'.
            END.
        END.
    END.
    
    
        END.
        ELSE MESSAGE msite '' mloc '' mpart '' mlot '存在盘点库存与当前库存不一致!' VIEW-AS ALERT-BOX.
        FOR EACH b_ex_cnt:
            DELETE b_ex_cnt.
        END.
        RELEASE b_cnt_wkfl.
    {bcrelease.i}
    END.
    

    ENABLE bc_site WITH FRAME bc.
   

    END.
{bctrail.i}
