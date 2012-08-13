/*{mfdeclre.i }*/
{bcdeclre.i }
    {bcwin01.i }
    
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_po_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_po_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)"    LABEL "采购单".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5
    bc_po_line AT ROW 2.4 COL 4
 /* bc_po_part AT ROW 3.6 COL 2.5*/
    bc_po_qty AT ROW 3.6 COL 2.5 
    'EA' AT ROW 3.6 COL 22 
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
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
  
   
    WITH SIZE 30 BY 14 TITLE "PO退货"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_po_nbr 
   /* bc_po_line
  
    bc_id  bc_button */ 
     WITH FRAME bc IN WINDOW c-win.
/*
bc_sub = NO.
DISP bc_sub WITH FRAME bc.*/
/*DISABLE bc_po_part_desc  bc_po_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_po_qty
  /*  bc_po_part_desc  
    bc_po_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/


ON CURSOR-DOWN OF bc_po_nbr
DO:
    
       ASSIGN bc_po_nbr.
       FIND FIRST po_mstr NO-LOCK WHERE po_nbr > bc_po_nbr NO-ERROR.
       IF AVAILABLE po_mstr THEN DO:
           ASSIGN bc_po_nbr = po_nbr.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_nbr
DO:
   
       ASSIGN bc_po_nbr.
       FIND LAST po_mstr NO-LOCK WHERE po_nbr < bc_po_nbr NO-ERROR.
       IF AVAILABLE po_mstr THEN DO:
           ASSIGN bc_po_nbr = po_nbr.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_po_nbr
DO:
    bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""po"",
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
      /* ASSIGN bc_po_nbr = ''.
       DISP bc_po_nbr WITH FRAME bc.*/
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_po_nbr WITH FRAME bc.
       ENABLE bc_id WITH FRAME bc.
 
   END.
  
    END.

/*
   ON enter OF bc_po_line
DO:
        bc_po_line = bc_po_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""pod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input bc_po_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""pod"" ,
            INPUT bc_po_nbr,
            INPUT bc_po_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_po_part = part.
    bc_po_qty = qty.
  
    DISP /*bc_po_part bc_po_qty*/ WITH FRAME bc.
     DISABLE bc_po_line WITH FRAME bc. 
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
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
           {bcrun.i ""bcmgcheck.p"" "(input ""po_ret"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input bc_po_nbr, 
        input """",
         input """", 
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
           bc_po_line = lntyp.
           DISP bc_po_line WITH FRAME bc.
              DISABLE bc_id WITH FRAME bc.
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                bc_po_qty = b_co_qty_req.
                  bc_qty = b_co_qty_cur.
                  bc_site = b_co_site.
                  bc_loc = b_co_loc.
                  DISP bc_loc bc_site bc_part bc_lot /*bc_pack*/ bc_po_qty bc_qty WITH FRAME bc.
                   {bccntlock.i "bc_site" "bc_loc"}
                  RUN main.
                  END.
                  
                 END.
         
          
    
         
    END.

    /* ON enter OF bc_site
DO:
         
         bc_site = bc_site:SCREEN-VALUE.
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
         {bcrun.i ""bcmgcheck.p"" "(input ""site"" ,
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
           
        IF NOT success THEN UNDO,RETRY.
        
        ELSE DO:
             
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
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
      RUN main.
        
          END.     
       
   
   END.
     END.*/

 


PROCEDURE main:
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
       FIND FIRST pod_det WHERE pod_nbr = bc_po_nbr AND string(pod_line) = bc_po_line NO-LOCK NO-ERROR.
     IF pod_site <> bc_site THEN DO:
    
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
        input pod_site,
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
        input pod_site, 
        input pod_loc, 
        input bc_part, 
        input """",
         input """", 
        input ""iss-prv"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.

{bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input pod_site, 
        input pod_loc, 
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
        input bc_site, 
        input bc_loc, 
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
     END.
  ELSE DO:
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
        input """",
         input """", 
        input ""iss-prv"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
  END.
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
         FIND FIRST pt_mstr WHERE pt_part = b_co_part NO-LOCK NO-ERROR.
               FIND FIRST pod_det WHERE pod_nbr = bc_po_nbr AND string(pod_line) = bc_po_line NO-LOCK NO-ERROR.
                FIND FIRST po_mstr WHERE po_nbr = pod_nbr NO-LOCK NO-ERROR.
               IF AVAILABLE pt_mstr AND AVAILABLE pod_det AND AVAILABLE po_mstr THEN DO:
                   FIND FIRST gl_ctrl NO-LOCK NO-ERROR.
            OUTPUT TO VALUE(g_sess).
                
              PUT "@@batchload porvis.p" SKIP.
         PUT UNFORMAT '"' bc_po_nbr '"' SKIP.
          PUT  "- - - - N N N Y" SKIP.
             IF po_cur <> gl_base_curr THEN  PUT '- -' SKIP.
         PUT UNFORMAT string(bc_po_line) SKIP.
           PUT UNFORMAT string(b_co_qty_cur)  ' - ' pt_um ' - - "' b_co_site '" "' b_co_loc '" "     " - - - N' SKIP.
       PUT SKIP(3)
              "." SKIP
           "@@END" SKIP.
          OUTPUT CLOSE.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date = TODAY AND tr_type = 'iss-prv' AND tr_program = 'porvis.p' AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line AND tr_serial = '' AND tr_site = (IF pod_site <> bc_site THEN pod_site ELSE bc_site) AND tr_loc = (IF pod_site <> bc_site THEN pod_loc ELSE bc_loc)  AND tr_qty_loc = (b_co_qty_cur * -1) AND tr_userid = g_user /*AND tr_time >= TIME - 20 AND tr_time <= TIME*/  NO-LOCK NO-ERROR.
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
             END.
               ELSE DO:
                   success = NO.
                MESSAGE  '该料件不存在，更新QAD失败!'  VIEW-AS ALERT-BOX.
                LEAVE.
               END.
         
         
         
         
         
         
         
         
         assign
              b_co_status = 'iss'
             .
          
          FIND FIRST b_po_wkfl WHERE b_po_nbr = bc_po_nbr AND b_po_line = bc_po_line  AND b_po_part = b_co_part AND b_po_due_date  =  b_co_due_date EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b_po_wkfl THEN
                ASSIGN
                    b_po_qty_rec = b_po_qty_rec - b_co_qty_cur.
        FIND FIRST b_po_rec WHERE b_po_recdate = b_co_due_date AND b_po_ponbr = bc_po_nbr AND b_po_poln = bc_po_line AND b_po_popart = bc_part EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAILABLE b_po_rec THEN
                        ASSIGN
                           b_po_recqty = b_po_recqty - b_co_qty_cur.
                     
         {bctrcr.i
         &ord=bc_po_nbr
         &mline=bc_po_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_qty_short="if available b_po_rec then b_co_qty_req - b_po_recqty else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-prv"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=b_co_vend}
           b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN  tr_trnbr ELSE 0.
            
            
             
             
             
             
             
           /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
             RELEASE b_po_wkfl.
             {bcrelease.i}
  ASSIGN
      bc_lot = ''
         bc_qty = 0
     bc_part = ''
     bc_id = ''
     bc_site = ''
     bc_loc = ''.
     DISP bc_id bc_site bc_loc bc_lot bc_qty bc_part WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
   APPLY 'entry':u TO bc_id.
     
END.



    {BCTRAIL.I}
