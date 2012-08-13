{mfdeclre.i }
{bcdeclre.i }
   
    {bcwin00.i 12}
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_dss_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_dss_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_dss_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_dss_nbr AS CHAR FORMAT "x(8)"    LABEL "订单号".
DEF VAR bc_dss_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_dss_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR msite AS CHAR.
DEF VAR bc_drp_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF FRAME bc
    bc_dss_nbr AT ROW 1.2 COL 2.5
   bc_drp_site AT ROW 2.4 COL 4
 /* bc_dss_part AT ROW 3.6 COL 2.5*/
   
    /*bc_dss_part_desc  AT ROW 6 COL 1
    bc_dss_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
    bc_id AT ROW 3.6 COL 4
    bc_part AT ROW 4.8 COL 2.5
   
  
   bc_lot AT ROW 6 COL 1.6
   /* bc_ref AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 7.2 COL 4 
   
    bc_site AT ROW 8.4 COL 4

    bc_loc AT ROW 9.6 COL 4
     
   
    WITH SIZE 30 BY 12 TITLE "新包装入备件库"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_dss_nbr 
   /* bc_dss_line
  
    bc_id  bc_button */ 
     WITH FRAME bc IN WINDOW c-win.
/*
bc_sub = NO.
DISP bc_sub WITH FRAME bc.*/
/*DISABLE bc_dss_part_desc  bc_dss_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_dss_qty
  /*  bc_dss_part_desc  
    bc_dss_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/


ON CURSOR-DOWN OF bc_dss_nbr
DO:
    
       ASSIGN bc_dss_nbr.
       FIND FIRST dss_mstr NO-LOCK WHERE dss_nbr > bc_dss_nbr NO-ERROR.
       IF AVAILABLE dss_mstr THEN DO:
           ASSIGN bc_dss_nbr = dss_nbr.
           DISPLAY bc_dss_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_dss_nbr
DO:
   
       ASSIGN bc_dss_nbr.
       FIND LAST dss_mstr NO-LOCK WHERE dss_nbr < bc_dss_nbr NO-ERROR.
       IF AVAILABLE dss_mstr THEN DO:
           ASSIGN bc_dss_nbr = dss_nbr.
           DISPLAY bc_dss_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_dss_nbr
DO:
    bc_dss_nbr = bc_dss_nbr:SCREEN-VALUE.
   FIND FIRST Dss_mstr WHERE dss_nbr = bc_dss_nbr AND dss_status = '' NO-LOCK NO-ERROR.
    IF  NOT AVAILABLE dss_mstr THEN do:
        MESSAGE '无效订单，或已关闭，或已取消！' VIEW-AS ALERT-BOX ERROR.
        bc_dss_nbr = ''.
       DISP bc_dss_nbr WITH FRAME bc.
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_dss_nbr WITH FRAME bc.
       ENABLE bc_id WITH FRAME bc.
 
   END.
  
    END.


/*
   ON enter OF bc_dss_line
DO:
        bc_dss_line = bc_dss_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""sod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_dss_nbr, 
        input bc_dss_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""sod"" ,
            INPUT bc_dss_nbr,
            INPUT bc_dss_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_dss_part = part.
    bc_dss_qty = qty.
  
    DISP /*bc_dss_part bc_dss_qty*/ WITH FRAME bc.
     DISABLE bc_dss_line WITH FRAME bc. 
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
           FIND FIRST b_co_mstr WHERE b_co_code = bc_id AND b_co_status = 'rct' AND SUBSTR(b_co_desc1,80,1) = 'd' EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAILABLE b_co_mstr THEN 
           DO:
              MESSAGE '无效条码，或已发生该业务！' VIEW-AS ALERT-BOX ERROR.
               bc_id = ''.
               DISP bc_id WITH FRAME bc.
               UNDO,RETRY.
               END.
             
               else
               DO:
           FIND FIRST dsd_det WHERE dsd_nbr = bc_dss_nbr AND dsd_part = b_co_part   NO-LOCK NO-ERROR.
              
             
           IF NOT AVAILABLE dsd_det THEN
              DO:
                  MESSAGE '该订单无该零件，或已关闭，或已取消！' VIEW-AS ALERT-BOX ERROR.
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
                bc_dss_qty = qty.
                  bc_qty = b_co_qty_cur.
                  bc_drp_site = substr(b_co_desc1,82,8).
                 
                  DISP bc_part bc_lot bc_site bc_loc /*bc_pack*/  bc_qty WITH FRAME bc.
                   {bccntlock.i "bc_site" "bc_loc"}
                  ENABLE bc_site WITH FRAME bc.
                  END.
             
      END.
               END.
    
         
    END.

     
 ON enter OF bc_site
DO:  
         ASSIGN bc_site. 
     IF INDEX(bc_site,'.') <> 0 THEN DO:      
    
          /* APPLY 'entry':u TO bc_site.*/
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
      END.
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
           
           IF NOT success  THEN 
               
               do:
               ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               
               UNDO,RETRY.
           END.

          
           ELSE DO:
               FIND FIRST dsd_det WHERE dsd_nbr = bc_dss_nbr AND dsd_part = bc_part AND  dsd_site = bc_site NO-LOCK NO-ERROR.

         IF NOT AVAILABLE dsd_det THEN DO:
      ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
                MESSAGE '地点不一致，不能收货！' VIEW-AS ALERT-BOX ERROR.
               UNDO,RETRY.
         END.
     ELSE DO:
     FIND FIRST ld_det WHERE ld_site = bc_site AND ld_loc = dsd_trans_id AND ld_part = bc_part AND ld_lot = bc_lot AND bc_qty <= ld_qty_oh  NO-LOCK NO-ERROR.
             IF NOT AVAILABLE ld_det THEN DO:
                 MESSAGE '收货数量超过发货数量！' VIEW-AS ALERT-BOX ERROR.
                 bc_id = ''.
                 DISP bc_id WITH FRAME bc.
                 UNDO,RETRY.
                 END.
           ELSE DO:
         DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
      RUN main.
           END.
         END.
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
        input STRING(eff_DATE),
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
        input bc_drp_site,
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
        input ""rct-do"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
         FIND FIRST dss_mstr WHERE dss_nbr = bc_dss_nbr NO-LOCK NO-ERROR.
        
            
                                                                                        
            
                 OUTPUT TO value(g_sess).
                
              PUT "@@batchload dsdorc.p" SKIP.
          PUT UNFORMAT '"' bc_site '" "' bc_dss_nbr '" "' bc_drp_site '" ' string(eff_date) ' no' SKIP.
         PUT UNFORMAT '"' b_co_part '"' SKIP.
         PUT UNFORMAT STRING(b_co_qty_cur) ' "' bc_site '" "' bc_loc '"' ' "' b_co_lot '"' SKIP.
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
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'rct-do' AND tr_program = 'dsdorc.p' AND tr_nbr = bc_dss_nbr  AND tr_site = bc_site AND tr_loc = bc_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ /*tr_part = b_co_part AND*/ tr_serial = b_co_lot  AND tr_qty_loc = (b_co_qty_cur) AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.
         
           IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
               END.
            
               ASSIGN
                   SUBSTR(b_co_desc1,80,1) = 'r'
                   b_co_site = bc_site
                   b_co_loc = bc_loc.
                  
          
        /* {bctrcr.i
         &ord=bc_dss_nbr
         &mline=bc_dss_line
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
