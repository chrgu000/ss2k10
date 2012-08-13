{mfdeclre.i }
{bcdeclre.i }
   
    {bcwin01.i }
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_wo_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_wo_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_wo_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_wo_nbr AS CHAR FORMAT "x(8)"    LABEL "加工单".
DEF VAR bc_wo_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_wo_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_wo_nbr AT ROW 1.2 COL 2.5
    bc_wo_line AT ROW 2.4 COL 4
 /* bc_wo_part AT ROW 3.6 COL 2.5*/
    bc_wo_qty AT ROW 3.6 COL 4  
    'EA' AT ROW 3.6 COL 22 
    /*bc_wo_part_desc  AT ROW 6 COL 1
    bc_wo_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
    bc_id AT ROW 4.8 COL 4
    bc_part AT ROW 6 COL 2.5
   
  
   bc_lot AT ROW 7.2 COL 1.6
   /* bc_ref AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 8.4 COL 4 'EA' AT ROW 8.4 COL 22 
   
    bc_site AT ROW 9.6 COL 4

    bc_loc AT ROW 10.8 COL 4
  
   
    WITH SIZE 30 BY 14 TITLE "加工单发料"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_wo_nbr 
   /* bc_wo_line
  
    bc_id  bc_button */ 
     WITH FRAME bc IN WINDOW c-win.
/*
bc_sub = NO.
DISP bc_sub WITH FRAME bc.*/
/*DISABLE bc_wo_part_desc  bc_wo_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_wo_qty
  /*  bc_wo_part_desc  
    bc_wo_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/


ON CURSOR-DOWN OF bc_wo_nbr
DO:
    
       ASSIGN bc_wo_nbr.
       FIND FIRST wo_mstr NO-LOCK WHERE wo_nbr > bc_wo_nbr NO-ERROR.
       IF AVAILABLE wo_mstr THEN DO:
           ASSIGN bc_wo_nbr = wo_nbr.
           DISPLAY bc_wo_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_wo_nbr
DO:
   
       ASSIGN bc_wo_nbr.
       FIND LAST wo_mstr NO-LOCK WHERE wo_nbr < bc_wo_nbr NO-ERROR.
       IF AVAILABLE wo_mstr THEN DO:
           ASSIGN bc_wo_nbr = wo_nbr.
           DISPLAY bc_wo_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_wo_nbr
DO:
    bc_wo_nbr = bc_wo_nbr:SCREEN-VALUE.
   FIND FIRST wo_mstr WHERE wo_nbr = bc_wo_nbr AND wo_status = 'r' NO-LOCK NO-ERROR.
    IF  NOT AVAILABLE wo_mstr THEN do:
       MESSAGE '无效工单，或非下达状态！' VIEW-AS ALERT-BOX ERROR.
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_wo_nbr WITH FRAME bc.
       ENABLE bc_id WITH FRAME bc.
 
   END.
  
    END.

/*
   ON enter OF bc_wo_line
DO:
        bc_wo_line = bc_wo_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""sod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo_nbr, 
        input bc_wo_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""sod"" ,
            INPUT bc_wo_nbr,
            INPUT bc_wo_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_wo_part = part.
    bc_wo_qty = qty.
  
    DISP /*bc_wo_part bc_wo_qty*/ WITH FRAME bc.
     DISABLE bc_wo_line WITH FRAME bc. 
    IF lntyp = 's' THEN do:
        bc_sub = YES.
       /* ENABLE bc_wo WITH FRAME bc.*/
    END.
    ELSE do:
        bc_sub = NO.
        bc_wo = ''.
        bc_woid = ''.
        ENABLE bc_id WITH FRAME bc.
        
        END.
    
   
    
    END.
    END.*/

   /* ON enter OF bc_sub
DO:
      
        IF bc_sub:SCREEN-VALUE = 'YES' THEN 
    ENABLE bc_wo  WITH FRAME bc.
        ELSE  ENABLE bc_id WITH FRAME bc.
        DISABLE bc_sub WITH FRAME bc.
        END.*/
    
    
 /*ON enter OF bc_wo
DO:
     bc_wo = bc_wo:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""wo"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}.
    IF NOT success THEN do:
      UNDO,RETRY.
      
    END.
    ELSE DO:
    DISABLE bc_wo WITH FRAME bc.
    ENABLE bc_woid WITH FRAME bc.
        
        END.
    END.

    ON enter OF bc_woid
DO:
        bc_woid = bc_woid:SCREEN-VALUE.
          {bcrun.i ""bcmgcheck.p"" "(input ""woid"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo, 
        input bc_woid,
         input """", 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE 
          do:
              DISABLE bc_woid WITH FRAME bc.
          ENABLE bc_id WITH FRAME bc.
      END.
    END.*/
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
        bc_id = bc_id:SCREEN-VALUE.
        
       APPLY 'entry':u TO bc_id.
           FIND FIRST b_co_mstr WHERE b_co_code = bc_id AND b_co_status = 'rct' EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAILABLE b_co_mstr THEN DO:
               MESSAGE '无效条码，或已发生该业务！' VIEW-AS ALERT-BOX ERROR.
               bc_id = ''.
               DISP bc_id WITH FRAME bc.
               UNDO,RETRY.
               END.
          ELSE DO:
          
             /*  FIND FIRST wod_det WHERE wod_nbr = bc_wo_nbr  AND wod_part = b_co_part EXCLUSIVE-LOCK NO-ERROR.
                  IF NOT AVAILABLE wod_det THEN DO:
                      MESSAGE '零件不匹配！' VIEW-AS ALERT-BOX ERROR.
                        bc_id = ''.
               DISP bc_id WITH FRAME bc.
               UNDO,RETRY.
                  END.
               */
         
    /*  ELSE DO: */
           bc_wo_line = lntyp.
           DISP bc_wo_line WITH FRAME bc.
              DISABLE bc_id WITH FRAME bc.
           
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                bc_wo_qty = qty.
                  bc_qty = b_co_qty_cur.
                  bc_site = b_co_site.
                  bc_loc = b_co_loc.
                  DISP bc_part bc_lot bc_site bc_loc /*bc_pack*/ bc_wo_qty bc_qty WITH FRAME bc.
                   {bccntlock.i "bc_site" "bc_loc"}
                  RUN main.
                  END.
              
   /*   END.*/
          
          END.
         
    END.

     

 


PROCEDURE main:
    DEF VAR umconv AS DECIMAL. 
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
        input ""iss-wo"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
         FIND FIRST wo_mstr WHERE wo_nbr = bc_wo_nbr NO-LOCK NO-ERROR.
        
                                                                                        
            
                 OUTPUT TO value(g_sess).
                
              PUT "@@batchload wowois.p" SKIP.
          PUT UNFORMAT '"' bc_wo_nbr '" - - ' string(eff_date) ' - -' SKIP.
         PUT UNFORMAT b_co_part ' -' SKIP.
         PUT UNFORMAT STRING(b_co_qty_cur) ' - - "' b_co_site '" "' b_co_loc '"' ' "' b_co_lot '"' SKIP.
         PUT '.' SKIP.
         PUT  SKIP(2).
       
     PUT '.' SKIP.
     PUT '@@END' SKIP.
          OUTPUT CLOSE.
          mtime = TIME.
          mdate = TODAY.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
              OS-DELETE VALUE('out.txt').
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'iss-wo' AND tr_program = 'wowois.p' AND tr_nbr = bc_wo_nbr AND /*string(tr_line) = bc_wo_line AND*/ tr_site = b_co_site AND tr_loc = b_co_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ /*tr_part = b_co_part AND*/ tr_serial = b_co_lot  AND tr_qty_loc = (b_co_qty_cur * -1) AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.
         
           IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
               END.
            
                assign
              b_co_status = 'iss'
             b_co_ord = bc_wo_nbr
           
           b_co_qty_req = bc_wo_qty
              
             b_co_due_date = wo_due_date .
          
          
         
        /* {bctrcr.i
         &ord=bc_wo_nbr
         &mline=bc_wo_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_qty_short="if available b_ex_sod then b_co_qty_req - b_ex_issqty else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-so"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=?}
           b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.
            */
             
             
             
             
             
             
           /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
             RELEASE wo_mstr.
             {bcrelease.i}
    ASSIGN
    /*  bc_lot = ''
         bc_qty = 0
     bc_part = ''*/
     bc_id = ''
    /* bc_site = ''
     bc_loc = ''*/.
     DISP bc_id bc_site bc_loc bc_lot bc_qty bc_part WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
    APPLY 'entry':u TO bc_id.
  
     
END.



    {BCTRAIL.I}
