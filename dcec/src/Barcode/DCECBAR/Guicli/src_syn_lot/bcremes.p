{bcdeclre.i}
DEF TEMP-TABLE chk_mes
    FIELD chk_sess LIKE g_sess
    FIELD chk_part AS CHAR
    FIELD chk_due_date AS CHAR
    FIELD chk_qty_req AS CHAR
    FIELD chk_loc AS CHAR
    FIELD chk_ln_loc AS CHAR
    FIELD chk_site AS CHAR
    FIELD chk_vend AS CHAR
    FIELD chk_id AS CHAR
    FIELD chk_status AS LOGICAL 
    INDEX chk_index IS PRIMARY chk_sess chk_due_date chk_id chk_site chk_ln_loc chk_part chk_status ASC.
DEF VAR yn1 AS LOGICAL.
DEF VAR yn2 AS LOGICAL.
DEF VAR yn3 AS LOGICAL.
DEF VAR yn4 AS LOGICAL.
DEF VAR ipath AS CHAR.
DEF VAR opath AS CHAR.
DEF VAR msg AS CHAR.
DEF VAR mdate AS DATE.
DEF VAR mqty AS DECIMAL.
DEF VAR isfirst AS LOGICAL.
DEF VAR DATE_start AS DATE.
DEF VAR DATE_end AS DATE.
DEF TEMP-TABLE meschk
    FIELD mes_sess LIKE g_sess
    FIELD mesid AS RECID
    INDEX mes_sess IS PRIMARY mes_sess ASC.
assign
    yn1 = NO
    yn2 = NO
    yn3 = NO
    yn4 = NO.

FIND FIRST CODE_mstr WHERE CODE_fldname = 'mesipath1' AND code_value <> '' NO-LOCK NO-ERROR.

IF AVAILABLE CODE_mstr THEN ipath = CODE_value.
/*FIND FIRST CODE_mstr WHERE CODE_fldname = 'mesopath' AND CODE_value <> '' NO-LOCK NO-ERROR.
IF AVAILABLE CODE_mstr THEN opath = CODE_value.*/
FIND FIRST CODE_mstr WHERE CODE_fldname = 'meslog' AND CODE_value <> '' NO-LOCK NO-ERROR.
IF AVAILABLE code_mstr THEN opath = CODE_value.
IF ipath <> '' AND opath <> '' THEN DO:
    SESSION:DATE-FORMAT = 'ymd'.
 
    INPUT FROM VALUE(ipath).
    isfirst = YES.
    REPEAT:
       
        CREATE chk_mes.
        chk_sess = g_sess.
        chk_status = YES.
        IMPORT DELIMITER ","  chk_id chk_site chk_due_date chk_part chk_loc chk_ln_loc chk_qty_req chk_vend  .
        IF isfirst THEN do:
            DELETE chk_mes.
            isfirst = NO.
        END.
    END.
    INPUT CLOSE.
 
/*OUTPUT TO VALUE(opath).*/
   
FOR EACH chk_mes WHERE chk_sess = g_sess AND chk_part = '':
DELETE chk_mes.
END.
OUTPUT TO VALUE(opath).
FOR EACH chk_mes NO-LOCK WHERE chk_sess = g_sess:
  msg = ''.
FIND FIRST pt_mstr WHERE pt_part = chk_part NO-LOCK NO-ERROR.
IF  NOT AVAILABLE pt_mstr THEN 
    DO:
       /*PUT UNFORMAT chk_Part ' Please check part!' SPACE(2).*/
    chk_status = NO.   
   msg = '无效零件,'.
       /*success = NO.
       leave.*/
       
   END.
    
   /*RUN datechk(INPUT chk_due_date,OUTPUT yn2).*/
   mdate = DATE(chk_due_date) NO-ERROR.
   IF ERROR-STATUS:ERROR OR mdate = ? THEN DO:
       chk_status = NO.            
       msg = msg + '无效日期,'.
                 /*success = NO.
                LEAVE.*/
                   END.
   
   FIND FIRST loc_mstr WHERE loc_site = chk_site AND loc_loc = chk_ln_loc NO-LOCK NO-ERROR.
   IF NOT AVAILABLE loc_mstr THEN 
    DO:
     /*  PUT UNFORMAT chk_ln_loc ' Please check line location!' SPACE(2).
       yn3 = NO.*/
       chk_status = NO.
      msg = msg + '无效库位,'.
       /*success = NO.
       LEAVE.*/
   END.
   
   
   
   
 /* RUN qtychk(INPUT chk_qty_req,OUTPUT yn4).*/
  /*IF NOT yn4 THEN PUT UNFORMAT chk_qty_req ' Please check qunatity!' SPACE(2).
  */
   mqty = DECIMAL(chk_qty_req) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN DO:
       chk_status = NO.
      msg = msg + '无效数字'.
      /* success = NO.
       LEAVE.*/
   END.
 IF NOT chk_status THEN   PUT UNFORMAT chk_id ' ' chk_due_date ' ' chk_site ' ' chk_ln_loc ' ' chk_part ' ' chk_qty_req ' ' chk_vend ' ' msg SKIP.
END.
OUTPUT CLOSE.    
/*   FIND FIRST vd_mstr WHERE vd_addr = chk_vend NO-LOCK NO-ERROR.
       IF NOT AVAILABLE vd_mstr THEN DO:
           MESSAGE chk_vend ' 无效供应商！' VIEW-AS ALERT-BOX ERROR.
           success = NO.
           LEAVE.
       END.*/
/*IF NOT success THEN LEAVE.*/
FOR EACH chk_mes NO-LOCK WHERE chk_sess = g_sess AND chk_status:
   FIND FIRST IN_mstr WHERE IN_part = chk_part AND IN_site = chk_site   NO-LOCK NO-ERROR.             

       FIND FIRST b_mes_wkfl WHERE (IF AVAILABLE in_mstr THEN b_mes_staff = IN__qadc01 ELSE YES) AND substr(b_mes_id,1,INDEX(b_mes_id,'-') - 1) = substr(chk_id,1,INDEX(chk_id,'-') - 1) AND   b_mes_due_date = DATE(chk_due_date) AND b_mes_site = chk_site AND b_mes_ln_loc = chk_ln_loc AND  b_mes_part = chk_part AND b_mes_vend = chk_vend EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE b_mes_wkfl  THEN DO:
     
       /*  IF b_mes_id <= chk_id THEN DO:*/
            
               ASSIGN
           b_mes_id = chk_id  
           b_mes_qty_req = DECIMAL(chk_qty_req).
             
             /*  END.*/
  
         END.
           ELSE
           DO:
           
       CREATE b_mes_wkfl.
       ASSIGN
           b_mes_id = chk_id
           b_mes_part = chk_part
           b_mes_due_date = DATE(chk_due_date)
           b_mes_qty_req = DECIMAL(chk_qty_req)
           b_mes_site = chk_site
           b_mes_ln_loc = chk_ln_loc
           b_mes_staff = IF AVAILABLE IN_mstr THEN IN__qadc01 ELSE ''
           b_mes_vend = chk_vend.
 

   END.
 CREATE meschk.
ASSIGN mes_sess = g_sess
    mesid = RECID(b_mes_wkfl).
  END.
/*CREATE meschk.
ASSIGN mes_sess = g_sess
    mesid = RECID(b_mes_wkfl).*/

IF NOT success THEN LEAVE.
 FOR EACH b_mes_wkfl WHERE CAN-FIND(FIRST chk_mes WHERE chk_sess = g_sess AND chk_status AND SUBSTR(chk_id,1,INDEX(chk_id,'-') - 1) = SUBSTR(b_mes_id,1,INDEX(b_mes_id,'-') - 1) NO-LOCK)
     AND NOT CAN-FIND(FIRST meschk WHERE mes_sess = g_sess AND mesid = RECID(b_mes_wkfl) NO-LOCK):
          

  
      
                           IF b_mes_qty_iss = 0 THEN DELETE b_mes_wkfl.
                 ELSE b_mes_qty_req = 0.
           
        
      END.


  /*
 FOR EACH chk_mes NO-LOCK WHERE chk_sess = g_sess BREAK BY chk_due_date:
     IF FIRST-OF(chk_due_date) THEN DO:
     
     FIND FIRST b_mes_wkfl WHERE b_mes_due_date = DATE(chk_due_date) AND NOT CAN-FIND
         (FIRST meschk WHERE mes_sess = g_sess AND RECID(b_mes_wkfl) = mesid NO-LOCK) EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_mes_wkfl AND b_mes_qty_iss = 0 THEN
          DELETE b_mes_wkfl.
     END.
     END.*/
 SESSION:DATE-FORMAT = 'dmy'.
/*OUTPUT CLOSE.*/
MESSAGE 'MES需求数据导入完毕！' VIEW-AS ALERT-BOX.
END.
ELSE MESSAGE '请检验路径！' VIEW-AS ALERT-BOX ERROR.







    
