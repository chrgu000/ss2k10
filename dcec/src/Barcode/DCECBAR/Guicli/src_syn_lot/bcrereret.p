{bcdeclre.i }
    {bcwin02.i}
    {bctitle.i}

DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".

DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_site1 AS CHAR FORMAT "x(18)" LABEL "地点".
 
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "线边库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "材料库位".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF TEMP-TABLE blddet LIKE b_ld_det.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".

DEF VAR ISEXEC AS LOGICAL.
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_id AT ROW 1.2 COL 4
    bc_part AT ROW 2.4 COL 2.5
   
    
   bc_lot AT ROW 3.6 COL 1.6
   /* bc_ref AT ROW 6 COL 2.5*/
    bc_qty AT ROW 4.8 COL 4
   /*bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 6 COL 4

    bc_loc AT ROW 7.2 COL 1
    bc_site1 AT ROW 8.4 COL 4
    bc_loc1 AT ROW 9.6 COL 1
   
   
    WITH SIZE 30 BY 12 TITLE "生产退料"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ENABLE bc_id WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_part 
   
    
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.
ON CURSOR-DOWN OF bc_id
DO:
    
       ASSIGN bc_id.
       FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code > bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_id
DO:
   
        ASSIGN bc_id.
       FIND LAST b_co_mstr NO-LOCK WHERE b_co_code < bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
   
END.
  ON enter OF bc_id
DO:
       CURRENT-WINDOW:NAME = ''.
      ASSIGN bc_site1 = ''
        bc_loc1 = ''.   
       DISP bc_site1 bc_loc1 WITH FRAME bc.
      bc_id = bc_id:SCREEN-VALUE.
        APPLY 'entry':u TO bc_id.
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
         {bcrun.i ""bcmgcheck.p"" "(input ""bd"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input  ""rep"" , 
        input """",
         input """",
        output success)"}
     IF NOT success THEN 
        DO:
        ASSIGN bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
          END.
      ELSE DO:
     
        /*  FIND FIRST b_rep_wkfl WHERE b_rep_part = b_co_part  NO-LOCK NO-ERROR.
          IF NOT AVAILABLE b_rep_wkfl THEN DO:
              MESSAGE '该料件没有需求!' VIEW-AS ALERT-BOX.
              UNDO,RETRY.
          END.
          ELSE DO:*/
          
          
              DISABLE bc_id WITH FRAME bc.
             
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  bc_site = b_co_site.
                  bc_loc = b_co_loc.
                  DISP bc_part bc_lot bc_site bc_loc /*bc_ref*/ bc_qty WITH FRAME bc.
                   {bccntlock.i "bc_site" "bc_loc"}
                  IF bc_site = '' OR bc_loc = ''  THEN DO:
                      CURRENT-WINDOW:NAME = 'ac'.
                      ENABLE bc_site WITH FRAME bc. 
                      END.
                 ELSE
                      ENABLE bc_site1 WITH FRAME bc.
                 
                  END.
                 
                      
                     
          /*END.*/
                     
                  
      END.
          

         
    END.
ON enter OF bc_site
DO:
         bc_site = bc_site:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site.
         msite = bc_site.
        bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
          {bccntlock.i "bc_site1" "bc_loc1"}
          {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
           
           IF NOT success  THEN do: ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               
               UNDO,RETRY.
           END.
           ELSE DO:
        /* FIND FIRST b_rep_wkfl WHERE b_rep_part = bc_part AND b_rep_site = bc_site1 AND b_rep_ln_loc = bc_loc1 AND b_rep_qty_req > b_rep_qty_iss NO-LOCK NO-ERROR.
         IF NOT AVAILABLE b_rep_wkfl THEN DO:
             MESSAGE '该线边无该料件的领料需求!' VIEW-AS ALERT-BOX.
         END.
         ELSE DO:*/
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
    ENABLE bc_site1 WITH FRAME bc.
       
         /*  END.*/

           END.
   
   END.
 ON enter OF bc_site1
DO:
         bc_site1 = bc_site1:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site1.
         msite = bc_site1.
        bc_site1 = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc1 = SUBSTR(msite,INDEX(msite,'.') + 1).
         
         
          {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
           
           IF NOT success  THEN do:
               ASSIGN bc_site1 = ''
                     bc_loc1 = ''.
               DISP bc_site1 bc_loc1 WITH FRAME bc.
               
               UNDO,RETRY.
           END.
           ELSE DO:
        /* FIND FIRST b_rep_wkfl WHERE b_rep_part = bc_part AND b_rep_site = bc_site1 AND b_rep_ln_loc = bc_loc1 AND b_rep_qty_req > b_rep_qty_iss NO-LOCK NO-ERROR.
         IF NOT AVAILABLE b_rep_wkfl THEN DO:
             MESSAGE '该线边无该料件的领料需求!' VIEW-AS ALERT-BOX.
         END.
         ELSE DO:*/
         
       DISABLE bc_site1 WITH FRAME bc.
      DISP bc_site1 bc_loc1 WITH FRAME bc.
     
    IF bc_site = bc_site1 AND bc_loc = bc_loc1 THEN DO:
         MESSAGE '零转库！' VIEW-AS ALERT-BOX ERROR.
        /* ENABLE bc_id WITH FRAME bc.*/
         ASSIGN bc_site1 = ''
                     bc_loc1 = ''.
               DISP bc_site1 bc_loc1 WITH FRAME bc.
               ENABLE bc_site1 WITH FRAME bc.
               APPLY 'entry':u TO bc_site1 .
         UNDO,RETRY.
     END.
     ELSE RUN main.
     END.     
       
         /*  END.*/

   
   
   END.

   /* ON enter OF bc_loc1
DO:
        bc_loc1 = bc_loc1:SCREEN-VALUE.
        IF bc_loc1 = bc_loc THEN DO:
            MESSAGE '零转移，不允许！' VIEW-AS ALERT-BOX ERROR.
            UNDO,RETRY.
        END.
            ELSE
            DO:
        
        {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
        output success)"}
        IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc1 WITH FRAME bc.
       ENABLE bc_button WITH FRAME bc.
        
        
        
        END.
   
   END.
   END.*/
    
        ON WINDOW-CLOSE OF c-win /* <insert window title> */
   DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO c-win.
  RETURN NO-APPLY.

        END.


PROCEDURE main:
   DEF VAR mtime AS INT.
    
       DEF VAR mdate AS DATE.
      DEF VAR bc_offset AS INT.
    DEF VAR shre_date AS DATE.
    DEF VAR eff_date AS DATE.
 FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
     IF AVAILABLE b_ct_ctrl THEN DO:
         bc_offset = INTEGER(b_ct_nrm) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN bc_offset = 0.
     END.
     ELSE bc_offset = 0.
          shre_date = DATE('01/' + string(MONTH(TODAY) MOD 12 + 1,'99') + '/' +  IF MONTH(TODAY) = 12 THEN string(YEAR(TODAY) + 1,'9999') ELSE STRING(YEAR(TODAY),'9999')).
          eff_date = MIN(TODAY + bc_offset, shre_date).
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
        input STRING(eff_date),
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
     {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
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
     IF NOT success THEN LEAVE.
     {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
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
     IF NOT success THEN LEAVE.
     
IF NOT success THEN LEAVE.
    {bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site, 
        input bc_loc, 
        input bc_part, 
        input """",
         input """", 
        input ""iss-tr"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
       output success)"}      
IF NOT success THEN LEAVE.
    
     {bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site1, 
        input bc_loc1, 
        input bc_part, 
        input bc_lot,
         input """", 
        input ""rct-tr"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
          INPUT """",
       output success)"}      
IF NOT success THEN LEAVE.
    FIND FIRST b_rep_wkfl WHERE b_rep_due_date = TODAY AND b_rep_part = bc_part AND b_rep_site = bc_site AND b_rep_ln_loc = bc_loc EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_rep_wkfl THEN DO:
 
          ASSIGN
            b_rep_qty_iss = b_rep_qty_iss - bc_qty.
         
    END.
      ELSE DO:
      
          FIND FIRST b_rep_wkfl WHERE b_rep_part = bc_part AND b_rep_site = bc_site AND b_rep_ln_loc = bc_loc  EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE b_rep_wkfl THEN DO:
             ASSIGN
                 b_rep_qty_iss = b_rep_qty_iss - bc_qty.
             
         END.
      END.

    FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
    OUTPUT TO value(g_sess).
                
              put  "@@BATCHLOAD iclotr04.P" skip.
            PUT UNFORMAT '"' b_co_part '"' SKIP.
            PUT UNFORMAT STRING(b_co_qty_cur) ' ' STRING(eff_date)  skip.
             PUT 'Y T Y - ' SKIP.
            PUT UNFORMAT '"' + bc_site + '" "' + bc_loc + '"'   SKIP.
            PUT UNFORMAT '"' bc_site1 '" "' bc_loc1 '"' +  ' "' b_co_lot '"' SKIP.
          PUT      SKIP(2)
                     "." SKIP
                     "@@END" SKIP.
          OUTPUT CLOSE.
          mtime = TIME.
          mdate = TODAY.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
              OS-DELETE VALUE('out.txt').
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'iss-tr' AND tr_program = 'iclotr04.p' AND tr_site = bc_site AND tr_loc = bc_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ tr_part = b_co_part AND /*tr_serial = b_co_lot  AND*/ tr_qty_loc = (b_co_qty_cur * -1) AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.
         
            IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
               END.
    ASSIGN
       b_co_status = 'rct'
        b_co_site = bc_site1
    b_co_loc = bc_loc1.
   /* {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=""""
         &id=?
         &b_qty_req=b_rep_qty_req
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_qty_short="if available b_rep_wkfl then b_rep_qty_req - b_rep_qty_iss else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-tr"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=?}
           /*mid1 = mcount.*/
        ASSIGN b_tr_site1 = bc_site1
                b_tr_loc1 = bc_loc1.
    b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.
          {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_rep_qty_req
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short="if available b_rep_wkfl then b_rep_qty_req - b_rep_qty_iss else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-tr"'
          &mtime=TIME
           &b_loc=bc_loc1
           &b_site=bc_site1
           &b_usrid=g_user
           &b_addr=?}
          /* mid2 = mcount.*/
      ASSIGN b_tr_site1 = bc_site
                b_tr_loc1 = bc_loc.*/
   /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
    RELEASE b_rep_wkfl.
    {bcrelease.i}
     
    ASSIGN
      bc_lot = ''
         bc_qty = 0
     bc_part = ''
     bc_id = ''
     bc_site = ''
     bc_loc = ''
         bc_site1 = ''
     bc_loc1 = ''.
     DISP bc_id bc_site bc_loc bc_site1 bc_loc1 bc_lot bc_qty bc_part WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
    APPLY 'entry':u TO bc_id.
    END.



    {bctrail.i}
