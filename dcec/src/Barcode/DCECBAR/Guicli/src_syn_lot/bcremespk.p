{bcdeclre.i }
    {bcwin00.i 13}
    {bctitle.i}

DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".
DEF VAR bc_modi_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".

DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_site1 AS CHAR FORMAT "x(18)" LABEL "地点".
 
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "材料库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "线边库位".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF TEMP-TABLE blddet LIKE b_ld_det.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR bc_vend AS CHAR.
DEF VAR ISEXEC AS LOGICAL.
DEF VAR msite AS CHAR.
 
DEF VAR bc_tag AS CHAR FORMAT "x(18)" LABEL "移仓单".
DEF TEMP-TABLE bcomstr_mespk LIKE b_co_mstr
    FIELD bcomstr_mespk_sess LIKE g_sess
    INDEX bcomstr_mespk_sess IS PRIMARY bcomstr_mespk_sess ASC.
DEF TEMP-TABLE bcoprt_mespk LIKE b_co_mstr
    FIELD bcoprt_mespk_sess LIKE g_sess
    INDEX bcoprt_mespk_sess IS PRIMARY bcoprt_mespk_sess ASC.
DEF FRAME bc
  bc_tag AT ROW 1.2 COL 2.5   
    bc_id AT ROW 2.4 COL 4
    bc_part AT ROW 3.6 COL 2.5
   
    
   bc_lot AT ROW 4.8 COL 1.6
   /* bc_ref AT ROW 6 COL 2.5*/
    bc_modi_qty AT ROW 6 COL 4
   /*bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 7.2 COL 4

    bc_loc AT ROW 8.4 COL 1
    bc_site1 AT ROW 9.6 COL 4
    bc_loc1 AT ROW 10.8 COL 1
  
   
    WITH SIZE 30 BY 13 TITLE "MES生产领料"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ENABLE bc_tag WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_part 
   
    
   bc_lot 
    bc_modi_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.
ON CURSOR-DOWN OF bc_tag
DO:
    
       ASSIGN bc_tag.
       FIND FIRST b_mes_wkfl NO-LOCK WHERE b_mes_id > bc_tag NO-ERROR.
       IF AVAILABLE b_mes_wkfl THEN DO:
           ASSIGN bc_tag = b_mes_id.
           DISPLAY bc_tag WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_tag
DO:
    
       ASSIGN bc_tag.
       FIND LAST b_mes_wkfl NO-LOCK WHERE b_mes_id < bc_tag NO-ERROR.
       IF AVAILABLE b_mes_wkfl THEN DO:
           ASSIGN bc_tag = b_mes_id.
           DISPLAY bc_tag WITH FRAME bc.
       END.
    
END.
ON enter OF bc_tag
           DO:
           ASSIGN bc_tag.
           
           FIND FIRST b_mes_wkfl WHERE b_mes_id = bc_tag NO-LOCK NO-ERROR.
           IF NOT AVAILABLE b_mes_wkfl THEN DO:
                  MESSAGE '无效移仓单！' VIEW-AS ALERT-BOX ERROR. 
                   bc_tag = ''.
                  DISP bc_tag WITH FRAME bc.
                UNDO,RETRY.

           END.
            ELSE DO:
             DISABLE bc_tag WITH FRAME bc.
             ENABLE bc_id WITH FRAME bc.
              
            END.
END.
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
         input  ""out"" , 
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
        FIND FIRST pt_mstr WHERE pt_part = b_co_part NO-LOCK NO-ERROR.
    IF pt_lot_ser <> '' THEN DO:
       MESSAGE '该料件强制了批/序号控制，不能发料！' VIEW-AS ALERT-BOX ERROR.
       UNDO,RETRY.
       END.
       ELSE DO:
      
          FIND FIRST b_mes_wkfl WHERE b_mes_id = bc_tag AND b_mes_part = b_co_part /*AND b_mes_vend = b_co_vend*/ NO-LOCK NO-ERROR.
          IF NOT AVAILABLE b_mes_wkfl THEN DO:
              MESSAGE '该料件没有需求！' VIEW-AS ALERT-BOX ERROR.
              UNDO,RETRY.
          END.
          ELSE DO:
          
         
             
             
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  bc_modi_qty = b_co_qty_cur.
                  bc_site = b_co_site.
                  bc_loc = b_co_loc.
                  bc_vend = b_co_vend.
                  DISP bc_part bc_lot bc_site bc_loc /*bc_ref*/ bc_modi_qty WITH FRAME bc.
                 FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
                 
                
                 FIND FIRST ld_det WHERE   ld_site = b_co_site AND ld_loc = b_co_loc AND ld_part = b_co_part AND ld_lot < b_co_lot AND ld_qty_oh > 0 NO-LOCK NO-ERROR.
                  
                  IF AVAILABLE b_ct_ctrl AND b_ct_up_mtd = 'yes' THEN DO:   
                   IF AVAILABLE ld_det THEN do:
                       MESSAGE '该料件存在更小的批次！' VIEW-AS ALERT-BOX ERROR.
                   UNDO,RETRY.
                   END.
                   END.
                 ELSE DO: 
                     IF AVAILABLE ld_det THEN MESSAGE '该料件存在更小的批次！' VIEW-AS ALERT-BOX WARNING.
                 END.
                 DISABLE bc_id WITH FRAME bc.
                  {bccntlock.i "bc_site" "bc_loc"}
                  ENABLE bc_modi_qty WITH FRAME bc.
                  END.
                 
                      
                     
          END.
       END.
                  
      END.
          

         
    END.
ON enter OF bc_modi_qty
DO:
    bc_modi_qty = decimal(bc_modi_qty:SCREEN-VALUE).
    IF bc_modi_qty > bc_qty OR bc_modi_qty <= 0 THEN DO:
        MESSAGE '领料数量超过原数量，或等于零，或为负！' VIEW-AS ALERT-BOX ERROR.
        UNDO,RETRY.
    END.
    ELSE do:
        DISABLE bc_modi_qty WITH FRAME bc.
         ENABLE bc_site1 WITH FRAME bc.
    END.
END.
 ON enter OF bc_site1
DO:
         bc_site1 = bc_site1:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site1.
         msite = bc_site1.
        bc_site1 = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc1 = SUBSTR(msite,INDEX(msite,'.') + 1).
         
          {bccntlock.i "bc_site1" "bc_loc1"}
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
         FIND FIRST b_mes_wkfl WHERE b_mes_id = bc_tag AND b_mes_part = bc_part AND b_mes_site = bc_site1 AND b_mes_ln_loc = bc_loc1 AND /*b_mes_vend = bc_vend AND*/ b_mes_qty_req > b_mes_qty_iss NO-LOCK NO-ERROR.
         IF NOT AVAILABLE b_mes_wkfl THEN DO:
             MESSAGE '该线边无该料件的领料需求！' VIEW-AS ALERT-BOX ERROR.
             UNDO,RETRY.
             END.
         ELSE DO:
         
       DISABLE bc_site1 WITH FRAME bc.
      DISP bc_site1 bc_loc1 WITH FRAME bc.
     
    IF bc_site = bc_site1 AND bc_loc = bc_loc1 THEN DO:
         MESSAGE '零转库！' VIEW-AS ALERT-BOX ERROR.
         ASSIGN bc_site1 = ''
                     bc_loc1 = ''.
               DISP bc_site1 bc_loc1 WITH FRAME bc.
               ENABLE bc_site1 WITH FRAME bc.
               APPLY 'entry':u TO bc_site1.
         UNDO,RETRY.
     END.
     ELSE DO:
 
  RUN main.
        
     END.
     END.     
       
           END.

   
   
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
   DEF VAR isok AS LOGICAL INITIAL NO.
   DEF VAR bc_offset AS INT.
    DEF  VAR bcprefix AS CHAR.
      DEF VAR bcorist LIKE b_co_status.
     DEF VAR mtime AS INT.
      DEF VAR mdate AS DATE.
      DEF VAR mdesc AS CHAR FORMAT "x(50)".
       DEF VAR prt AS CHAR FORMAT 'x(22)' LABEL '打印机'.
      DEF VAR isfirst AS CHAR.
          DEF VAR isleave AS LOGICAL.
          DEF VAR shre_date AS DATE.
    DEF VAR eff_date AS DATE.
 FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
     IF AVAILABLE b_ct_ctrl THEN DO:
         bc_offset = INTEGER(b_ct_nrm) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN bc_offset = 0.
     END.
     ELSE bc_offset = 0.
          shre_date = DATE('01/' + string(MONTH(TODAY) MOD 12 + 1,'99') + '/' + IF MONTH(TODAY) = 12 THEN string(YEAR(TODAY) + 1,'9999') ELSE STRING(YEAR(TODAY),'9999')).
          eff_date = MIN(TODAY + bc_offset, shre_date).
          isfirst = 'first'.
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
        input bc_lot,
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
        input """",
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
    
FIND FIRST b_mes_wkfl WHERE b_mes_due_date = TODAY AND b_mes_id = bc_tag AND b_mes_part = bc_part AND b_mes_site = bc_site1 AND b_mes_ln_loc = bc_loc1 AND /*b_mes_vend = bc_vend AND*/ b_mes_qty_req > b_mes_qty_iss EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
 
          ASSIGN
            b_mes_qty_iss = b_mes_qty_iss + bc_modi_qty.
          isok = YES.
    END.
      ELSE DO:
      
          FIND FIRST b_mes_wkfl WHERE b_mes_id = bc_tag AND b_mes_part = bc_part AND b_mes_site = bc_site1 AND b_mes_ln_loc = bc_loc1  AND /*b_mes_vend = bc_vend AND*/ b_mes_qty_req > b_mes_qty_iss EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE b_mes_wkfl THEN DO:
             ASSIGN
                 b_mes_qty_iss = b_mes_qty_iss + bc_modi_qty.
             isok = YES.
         END.
      END.
     
     IF isok THEN DO:
      FIND FIRST b_co_mstr WHERE b_co_mstr.b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
       IF bc_modi_qty <> bc_qty THEN DO:
           bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
       bcorist = b_co_status.                  
        b_co_status = 'ia'.
              CREATE bcomstr_mespk.
              BUFFER-COPY 
                  b_co_mstr 
                  TO
                  bcomstr_mespk
                  ASSIGN bcomstr_mespk_sess = g_sess .
             CREATE b_co_mstr.
                   BUFFER-COPY
                       bcomstr_mespk 
                       EXCEPT bcomstr_mespk.b_co_code bcomstr_mespk.b_co_qty_cur  bcomstr_mespk.b_co_status bcomstr_mespk.b_co_btype bcomstr_mespk.b_co_userid bcomstr_mespk_sess
                       TO
                        b_co_mstr
                       
                   ASSIGN
                   b_co_mstr.b_co_code = bcprefix + '001'
                   b_co_mstr.b_co_qty_cur = bc_modi_qty
                       b_co_mstr.b_co_status = bcorist
                       b_co_mstr.b_co_btype = 's'
                       b_co_mstr.b_co_userid = g_user.
                   bc_id = b_co_mstr.b_co_code.
                  CREATE bcoprt_mespk.
                  BUFFER-COPY
                      b_co_mstr TO bcoprt_mespk
                      ASSIGN
                       bcoprt_mespk_sess = g_sess.
                  CREATE b_co_mstr.
                   BUFFER-COPY
                       bcomstr_mespk 
                       EXCEPT bcomstr_mespk.b_co_code bcomstr_mespk.b_co_qty_cur  bcomstr_mespk.b_co_status bcomstr_mespk.b_co_btype bcomstr_mespk.b_co_userid bcomstr_mespk_sess
                       TO
                        b_co_mstr
                       
                   ASSIGN
                   b_co_mstr.b_co_code = bcprefix + '002'
                   b_co_mstr.b_co_qty_cur = bc_qty - bc_modi_qty
                       b_co_mstr.b_co_status = bcorist
                       b_co_mstr.b_co_btype = 's'
                       b_co_mstr.b_co_userid = barusr.
                  CREATE bcoprt_mespk.
                  BUFFER-COPY
                      b_co_mstr TO bcoprt_mespk
                      ASSIGN
                       bcoprt_mespk_sess = g_sess.
                  RELEASE bcomstr_mespk.
                  FIND FIRST b_co_mstr WHERE b_co_mstr.b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
                  FOR EACH bcoprt_mespk WHERE bcoprt_mespk_sess = g_sess NO-LOCK:
                      mdesc = bcoprt_mespk.b_co_desc2 + bcoprt_mespk.b_co_desc1.
 {bclabel.i ""zpl"" ""part"" "bcoprt_mespk.b_co_code" "bcoprt_mespk.b_co_part" 
     "bcoprt_mespk.b_co_lot" "bcoprt_mespk.b_co_ref" "bcoprt_mespk.b_co_qty_cur" "bcoprt_mespk.b_co_vend" "mdesc" }
     
     DELETE bcoprt_mespk.
                  END.

       END.
   
    OUTPUT TO value(g_sess).
                
              put  "@@BATCHLOAD iclotr04.p" skip.
            PUT UNFORMAT '"' b_co_mstr.b_co_part '"' SKIP.
            PUT UNFORMAT STRING(b_co_mstr.b_co_qty_cur) ' ' STRING(eff_date) ' "' bc_tag '"'  skip.
            PUT 'Y T Y - ' SKIP.
            PUT UNFORMAT '"' + b_co_mstr.b_co_site + '" "' + b_co_mstr.b_co_loc + '"' + ' "' b_co_mstr.b_co_lot '"'  SKIP.
            PUT UNFORMAT '"' bc_site1 '" "' bc_loc1 '"' +  ' ""' SKIP.
          PUT     SKIP(2)
                     "." SKIP
                     "@@END" SKIP.
          OUTPUT CLOSE.
          mtime = TIME.
          mdate = TODAY.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
              OS-DELETE VALUE('out.txt').
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'iss-tr' AND tr_program = 'iclotr04.p' AND tr_site = b_co_mstr.b_co_site AND tr_loc = b_co_mstr.b_co_loc AND tr_nbr = bc_tag AND /*AND string(tr_line) = bc_po_line*/ tr_part = b_co_mstr.b_co_part AND tr_serial = b_co_mstr.b_co_lot  AND tr_qty_loc = (b_co_mstr.b_co_qty_cur * -1) AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.
         
             IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
               END.
    
    
    
    
    
    ASSIGN
       b_co_mstr.b_co_status = 'issln'
       b_co_mstr.b_co_site = bc_site1
    b_co_mstr.b_co_loc = bc_loc1.
    /*{bctrcr.i
         &ord=""""
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_mes_qty_req
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_qty_short="b_mes_qty_req - b_mes_qty_iss"
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
    b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN  tr_trnbr ELSE 0.
          {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=""""
         &id=?
         &b_qty_req=b_mes_qty_req
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short="b_mes_qty_req - b_mes_qty_iss"
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
      END.
   /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
    RELEASE b_mes_wkfl.
    {bcrelease.i}
     
    
ASSIGN
      /*bc_lot = ''
         bc_qty = 0
     bc_part = ''*/
     bc_id = ''
    /* bc_site = ''
     bc_loc = ''
         bc_site1 = ''
     bc_loc1 = ''*/.
    
     DISP bc_id bc_site bc_loc bc_site1 bc_loc1 bc_lot bc_modi_qty bc_part WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
    APPLY 'entry':u TO bc_id.
    END.



    {bctrail.i}
