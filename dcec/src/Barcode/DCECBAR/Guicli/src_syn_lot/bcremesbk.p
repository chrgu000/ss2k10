{bcdeclre.i}
DEF TEMP-TABLE chk_mesbk
    FIELD chkbk_sess LIKE g_sess
    FIELD chkbk_part AS CHAR
    FIELD chkbk_due_date AS CHAR
    FIELD chkbk_qty_req AS CHAR
    FIELD chkbk_ln_loc AS CHAR
    FIELD chkbk_site AS CHAR
    INDEX chkbk_due_date IS PRIMARY chkbk_due_date ASC.
DEF VAR yn1 AS LOGICAL.
DEF VAR yn2 AS LOGICAL.
DEF VAR yn3 AS LOGICAL.
DEF VAR yn4 AS LOGICAL.
DEF VAR ipath AS CHAR.
DEF VAR opath AS CHAR.
DEF VAR mdate AS DATE.
DEF VAR mqty AS DECIMAL.
DEF TEMP-TABLE meschkbk
    FIELD mesbk_sess LIKE g_sess
    FIELD mesbkid AS RECID.
DEF VAR isbk AS LOGICAL INITIAL NO.
assign
    yn1 = NO
    yn2 = NO
    yn3 = NO
    yn4 = NO.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'mesipath2' AND code_value <> '' NO-LOCK NO-ERROR.

IF AVAILABLE CODE_mstr THEN ipath = CODE_value.
/*FIND FIRST CODE_mstr WHERE CODE_fldname = 'mesopath' AND CODE_value <> '' NO-LOCK NO-ERROR.
IF AVAILABLE CODE_mstr THEN opath = CODE_value.*/
IF ipath <> '' THEN DO:


    INPUT FROM VALUE(ipath).
    REPEAT:
        CREATE chk_mesbk.
        chkbk_sess = g_sess.
        IMPORT DELIMITER ";"  chkbk_due_date chkbk_part  chkbk_qty_req chkbk_site chkbk_ln_loc.

    END.
    INPUT CLOSE.

/*OUTPUT TO VALUE(opath).*/
FOR EACH chk_mesbk WHERE chkbk_sess = g_sess AND chkbk_part = '':
DELETE chk_mesbk.
END.
FOR EACH chk_mesbk WHERE chkbk_sess = g_sess NO-LOCK:
  
FIND FIRST pt_mstr WHERE pt_part = chkbk_part NO-LOCK NO-ERROR.
IF  NOT AVAILABLE pt_mstr THEN 
    DO:
       /*PUT UNFORMAT chk_Part ' Please check part!' SPACE(2).*/
       MESSAGE chkbk_part ' 无效零件号!' VIEW-AS ALERT-BOX ERROR.
       success = NO.
       LEAVE.
   END.
    
   /*RUN datechk(INPUT chk_due_date,OUTPUT yn2).*/
   mdate = DATE(chkbk_due_date) NO-ERROR.
   IF ERROR-STATUS:ERROR OR mdate = ? THEN DO:
                   MESSAGE chkbk_due_date ' 无效日期格式' VIEW-AS ALERT-BOX ERROR.
                 success = NO.
                 LEAVE.
                   END.
   
   FIND FIRST loc_mstr WHERE loc_site = chkbk_site AND loc_loc = chkbk_ln_loc NO-LOCK NO-ERROR.
   IF NOT AVAILABLE loc_mstr THEN 
    DO:
     /*  PUT UNFORMAT chk_ln_loc ' Please check line location!' SPACE(2).
       yn3 = NO.*/
       MESSAGE chkbk_site  chkbk_ln_loc ' 无效地点或库位!' VIEW-AS ALERT-BOX ERROR.
       success = NO.
       LEAVE.
   END.
   
   
   
   
 /* RUN qtychk(INPUT chk_qty_req,OUTPUT yn4).*/
  /*IF NOT yn4 THEN PUT UNFORMAT chk_qty_req ' Please check qunatity!' SPACE(2).
  */
   mqty = DECIMAL(chkbk_qty_req) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN DO:
       MESSAGE chkbk_qty_req ' 无效数字!' VIEW-AS ALERT-BOX ERROR.
       success = NO.
       LEAVE.
   END.
  
       
       
       
       FIND FIRST b_mesbk_wkfl WHERE b_mesbk_part = chkbk_part AND b_mesbk_date = mdate AND b_mesbk_site = chkbk_site AND b_mesbk_ln_loc = chkbk_ln_loc EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE b_mesbk_wkfl THEN
           ASSIGN
             b_mesbk_qty = mqty
             b_mesbk_status = ''.
           ELSE
           DO:
           
       CREATE b_mesbk_wkfl.
       ASSIGN
           b_mesbk_part = chkbk_part
           b_mesbk_date = mdate
           b_mesbk_qty = mqty
           b_mesbk_site = chkbk_site
           b_mesbk_ln_loc = chkbk_ln_loc.


   END.
CREATE meschkbk.
ASSIGN mesbk_sess = g_sess
    mesbkid = RECID(b_mesbk_wkfl).


END.
IF NOT success THEN LEAVE.
  /*
 FOR EACH chk_mesbk NO-LOCK BREAK BY chkbk_due_date:
     IF FIRST-OF(chkbk_due_date) THEN DO:
     
     FIND FIRST b_mesbk_wkfl WHERE b_mesbk_date = DATE(chkbk_due_date) AND NOT CAN-FIND
         (FIRST meschkbk WHERE mesbk_ses = g_sess AND RECID(b_mesbk_wkfl) = mesbkid NO-LOCK) EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_mesbk_wkfl  THEN
          DELETE b_mesbk_wkfl.
     END.
     END.*/
  isbk = NO.
   FOR EACH b_mesbk_wkfl USE-INDEX b_mesbk_st WHERE b_mesbk_status = '' EXCLUSIVE-LOCK:
    /* FIND FIRST b_ld_det WHERE b_ld_part = b_mesbk_part AND b_ld_site = b_mesbk_site AND b_ld_loc = b_mesbk_ln_loc NO-LOCK NO-ERROR.*/
     /*IF b_mesbk_qty <= b_ld_qty_oh  THEN DO:*/
   isbk = YES.
     /*{bctrcr.i
         &ord=""""
         &mline=?
         &b_code=?
         &b_part=b_mesbk_part
         &b_lot=""""
         &id=?
         &b_qty_req=0
         &b_qty_loc="b_mesbk_qty * -1"
         &b_qty_chg="b_mesbk_qty  * -1"
         &b_qty_short=0
         &b_um='ea'
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-wo"'
          &mtime=TIME
           &b_loc=b_mesbk_ln_loc
           &b_site=b_mesbk_site
           &b_usrid=g_user
           &b_addr=?}
           ASSIGN
              b_tr_sum_id = 'mesbk'
              b_tr_trnbr_qad = -1.*/
     b_mesbk_status = 'c'.
   /*  END.
     ELSE MESSAGE b_mesbk_site '' b_mesbk_ln_loc ' 不足以回冲料件' b_mesbk_part VIEW-AS ALERT-BOX.
   */
   END.
/*OUTPUT CLOSE.*/
IF isbk THEN MESSAGE 'MES回冲数据导入并已回冲!' VIEW-AS ALERT-BOX.
END.
ELSE MESSAGE '请检验路径!' VIEW-AS ALERT-BOX ERROR.







    
