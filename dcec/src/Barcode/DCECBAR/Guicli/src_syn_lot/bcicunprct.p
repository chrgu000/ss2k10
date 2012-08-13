{bcdeclre.i }
    {bcwin02.i}
     {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "入地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "入库位".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_so_job AS CHAR FORMAT "x(8)" LABEL "预算号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR bc_cr AS CHAR FORMAT "x(18)" LABEL "定制码".
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 2.7 COL 2.5
   
    
   bc_lot AT ROW 3.9 COL 1.6
    /*bc_ref AT ROW 5.1 COL 2.5*/
    bc_qty AT ROW 5.1 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 6.3 COL 2.5

    bc_loc AT ROW 7.5 COL 2.5
  bc_so_job AT ROW 8.7 COL 2.5
bc_cr AT ROW 9.9 COL 2.5
   /*bc_cr AT ROW 10.8 COL 4*/
 
    WITH SIZE 30 BY 12 TITLE "计划外入库"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


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
   ASSIGN bc_site = ''
     bc_loc = ''.
   DISP bc_site bc_loc WITH FRAME bc.
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
         input  ""in"" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN DO: 
        bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
        END.
      ELSE DO:
     

          
          
              DISABLE bc_id WITH FRAME bc.
              
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_ref*/ bc_qty WITH FRAME bc.
                  END.
                  
                  ENABLE bc_site WITH FRAME bc.
      END.
          

         
    END.
 ON enter OF bc_site
DO:
           bc_site = bc_site:SCREEN-VALUE.
          /* APPLY 'entry':u TO bc_site.*/
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
        {bccntlock.i "bc_site" "bc_loc"}
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
           
           IF NOT success  THEN do:
              ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               UNDO,RETRY.
           END.
           ELSE DO:
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
     ENABLE bc_so_job WITH FRAME bc.
        
          END.     
       
  
   END.

   /* ON enter OF bc_loc
DO:
        bc_loc = bc_loc:SCREEN-VALUE.
        
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
        output success)"}
        IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc WITH FRAME bc.
       ENABLE bc_so_job WITH FRAME bc.
        
        
        
        END.
   
   
   END.*/
   ON CURSOR-DOWN OF bc_so_job
DO:
    ASSIGN bc_so_job.
    FIND FIRST CODE_mstr WHERE CODE_fldname = 'so_job' AND CODE_value > bc_so_job NO-LOCK NO-ERROR.
   IF AVAILABLE CODE_mstr THEN DO:
     bc_so_job = CODE_value.
     DISP bc_so_job WITH FRAME bc.
   END.
   END.
   ON CURSOR-UP OF bc_so_job
DO:
    ASSIGN bc_so_job.
    FIND LAST CODE_mstr WHERE CODE_fldname = 'so_job' AND CODE_value < bc_so_job NO-LOCK NO-ERROR.
   IF AVAILABLE CODE_mstr THEN DO:
     bc_so_job = CODE_value.
     DISP bc_so_job WITH FRAME bc.
   END.
   END.
ON enter OF bc_so_job
DO:
   bc_so_job = bc_so_job:SCREEN-VALUE.
   FIND FIRST CODE_mstr WHERE CODE_fldname = 'so_job' AND CODE_value = bc_so_job NO-LOCK NO-ERROR.
   IF NOT AVAILABLE code_mstr THEN DO:
    MESSAGE '无效预算号！' VIEW-AS ALERT-BOX ERROR.
    ASSIGN
        bc_so_job = ''.
    DISP bc_so_job WITH FRAME bc.
    UNDO,RETRY.
   END.
   ELSE DO:
 
   DISABLE bc_so_job WITH FRAME bc.
  ENABLE bc_cr WITH FRAME bc.
   END.
END.
ON enter OF bc_cr
DO:
   bc_cr = bc_cr:SCREEN-VALUE.
   IF bc_cr = '' THEN DO:
       MESSAGE '定制码不能为空！' VIEW-AS ALERT-BOX ERROR.
       UNDO,RETRY.
   END.
   /* FIND FIRST CODE_mstr WHERE CODE_fldname = 'ordernbr' AND CODE_value = bc_cr NO-LOCK NO-ERROR.
   IF NOT AVAILABLE code_mstr THEN DO:
    MESSAGE '无效定制码！' VIEW-AS ALERT-BOX ERROR.
    ASSIGN
        bc_cr = ''.
    DISP bc_cr WITH FRAME bc.
    UNDO,RETRY.
   END.
   ELSE DO:*/
 ELSE DO:

   DISABLE bc_cr WITH FRAME bc.
  RUN main.
 END.
  /* END.*/
END.
/*ON enter OF bc_cr
DO:
   bc_cr = bc_cr:SCREEN-VALUE.
   {bcrun.i ""bcmgcheck.p"" "(input ""acct"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input  bc_cr , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
        ELSE DO:
       
   DISABLE bc_cr WITH FRAME bc.
   ENABLE bc_button WITH FRAME bc.
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
          shre_date = DATE('01/' + string(MONTH(TODAY) MOD 12 + 1,'99') + '/' + IF MONTH(TODAY) = 12 THEN string(YEAR(TODAY) + 1,'9999') ELSE STRING(YEAR(TODAY),'9999')).
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
{bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site, 
        input bc_loc, 
        input bc_part, 
        input bc_lot,
         input """", 
        input ""rct-unp"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.

FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
OUTPUT TO VALUE(g_sess). 
put  "@@BATCHLOAD icunrc.P" skip.
            PUT UNFORMAT '"' b_co_part '"' SKIP .
            PUT UNFORMAT STRING(b_co_qty_cur) " - - " '"' + bc_site + '" "' + bc_loc + '"' ' "' b_co_lot '"'  SKIP.
            PUT UNFORMAT '"' bc_cr '"' " -" ' "' bc_so_job '"' " - - " string(eff_date) SKIP.
            PUT      " " skip
                     "." SKIP
                     "@@END" SKIP.
        
          OUTPUT CLOSE.
          mtime = TIME.
          mdate = TODAY.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
              OS-DELETE VALUE('out.txt').
                 FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'rct-unp' AND tr_program = 'icunrc.p' AND tr_site = bc_site AND tr_loc = bc_loc AND  tr_nbr = bc_cr AND tr_so_job = bc_so_job AND tr_part = b_co_part AND tr_serial = b_co_lot  AND tr_qty_loc = b_co_qty_cur  AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.

            IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
               END.




ASSIGN b_co_status = 'rct'
       b_co_site = bc_site
        b_co_loc = bc_loc.
 
            FIND FIRST IN_mstr WHERE IN_part = b_co_part AND IN_site = b_co_site NO-LOCK NO-ERROR.

   /* FIND FIRST b_cnt_wkfl WHERE substr(b_cnt_site,1,1) = 'r' AND (IF AVAILABLE IN_mstr THEN substr(b_cnt_site,2,9) = in__qadc01 ELSE YES ) AND SUBSTR(b_cnt_site,10,20) = bc_cr AND  SUBSTR(b_cnt_site,35,10) = bc_so_job
        AND SUBSTR(b_cnt_site,50,8) = b_co_site AND b_cnt_loc = b_co_loc
        AND b_cnt_part = b_co_part EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN
          ASSIGN
              b_cnt_qty_cnt = b_cnt_qty_cnt + b_co_qty_cur.
     FIND FIRST b_cnt_wkfl WHERE substr(b_cnt_lot,1,18) = b_co_code EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b_cnt_wkfl THEN DELETE b_cnt_wkfl.*/

  /*   {bctrcr.i
         &ord=bc_so_job
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=bc_cr
         &b_qty_req=0
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-unp"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=?}
          b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.*/
   /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION.*/
    {bcrelease.i}
        ASSIGN
     /* bc_lot = ''
         bc_qty = 0
     bc_part = ''*/
     bc_id = ''
     /*
         bc_so_job = ''
         bc_cr = ''*/.
     DISP bc_id bc_site bc_loc bc_lot bc_qty bc_part bc_so_job bc_cr WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
         ENABLE bc_id WITH FRAME bc.
     APPLY 'entry':u TO bc_id.
END.

{bctrail.i}
