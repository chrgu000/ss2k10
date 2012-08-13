{mfdeclre.i }
{bcdeclre.i }
   
    {bcwin00.i 14}
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
DEFINE BUTTON bc_button LABEL "收货" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR msite AS CHAR.
DEF VAR mqty AS DECIMAL.
DEF VAR bc_rec AS CHAR FORMAT "x(8)" .
DEF TEMP-TABLE po1_tmp
    FIELD po1_nbr LIKE pod_nbr
    FIELD po1_line LIKE pod_line
    FIELD po1_part LIKE pod_part
    FIELD po1_site LIKE pod_site
    FIELD po1_loc LIKE pod_loc
    FIELD po1_qty LIKE pod_qty_ord
    FIELD po1_lot LIKE b_co_lot
   
    FIELD po1_sess LIKE g_sess
    INDEX po1_sess IS PRIMARY po1_sess ASC.
DEF TEMP-TABLE bid1_tmp
    FIELD bid1_id LIKE b_co_code
    FIELD bid1_lot LIKE b_co_lot
    FIELD bid1_par_id LIKE b_co_code
    FIELD bid1_line LIKE pod_line
    FIELD bid1_sess LIKE g_sess
    INDEX bid1_sess IS PRIMARY bid1_sess bid1_line bid1_par_id bid1_id ASC.
 DEF VAR bc_offset AS INT.
    DEF VAR shre_date AS DATE.
    DEF VAR eff_date AS DATE.
DEF VAR bc_rec_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "累计量".
DEF VAR mtype AS CHAR.
DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5   
    bc_rec AT ROW 1.2 COL 18 NO-LABEL
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
   po1_qty AT ROW 10.8 COL 18 NO-LABEL
    bc_button AT ROW 12.2 COL 11
   
    WITH SIZE 30 BY 14 TITLE "PO收货"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

 FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
     IF AVAILABLE b_ct_ctrl THEN DO:
         bc_offset = INTEGER(b_ct_nrm) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN bc_offset = 0.
     END.
     ELSE bc_offset = 0.
          shre_date = DATE('01/' + string(MONTH(TODAY) MOD 12 + 1,'99') + '/' + IF MONTH(TODAY) = 12 THEN string(YEAR(TODAY) + 1,'9999') ELSE STRING(YEAR(TODAY),'9999')).
          eff_date = MIN(TODAY + bc_offset, shre_date).
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
    FIND FIRST po1_tmp WHERE po1_sess = g_sess AND po1_nbr <> bc_po_nbr NO-LOCK NO-ERROR.
   IF AVAILABLE po1_tmp THEN do:
       MESSAGE '存在未收订单！' VIEW-AS ALERT-BOX ERROR.
       UNDO,RETRY.
   END.
     ELSE DO:
    
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
        input STRING(eff_date),
         input """",
        output success)"}
    IF  NOT success THEN do:
      /* ASSIGN
          bc_po_nbr = ''.
       DISP bc_po_nbr WITH FRAME bc.*/
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_po_nbr WITH FRAME bc.
       {bcpodlock.i "bc_po_nbr" } 
       ENABLE bc_id WITH FRAME bc.
 
   END.
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
       ASSIGN  bc_site = ''
     bc_loc = ''.
       DISP bc_site bc_loc WITH FRAME bc.
        bc_id = bc_id:SCREEN-VALUE.
        
       APPLY 'entry':u TO bc_id.
       FIND FIRST b_co_mstr WHERE b_co_code = bc_id AND NOT can-find(FIRST bid1_tmp WHERE bid1_sess = g_sess AND IF bid1_par_id <> '' THEN bid1_par_id = substr(b_co_btype,2) ELSE NO NO-LOCK) /*AND b_co_ref = ''*/ EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE b_co_mstr AND b_co_ref = ''  THEN DO:
          mtype = IF b_co_status = 'po' THEN b_co_status ELSE ''.
       FIND FIRST bid1_tmp WHERE bid1_sess = g_sess AND (IF mtype = 'po' THEN bid1_par_id = bc_id ELSE bid1_id = bc_id) NO-LOCK  NO-ERROR.
       IF AVAILABLE bid1_tmp THEN DO:
           MESSAGE '已扫条码！' VIEW-AS ALERT-BOX ERROR.
           bc_id = ''.
           DISP bc_id WITH FRAME bc.
           UNDO,RETRY.
       END.
       ELSE DO:
       
       
           
               bc_part = b_co_part.
               bc_lot = b_co_lot.
                bc_qty = b_co_qty_cur.
             IF mtype = 'po' THEN DO:  
                 mqty = 0.
            FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = bc_part AND b_co_lot = bc_lot AND b_co_status = 'ac' AND substr(b_co_btype,2) = bc_id NO-LOCK:
               mqty = mqty + b_co_qty_cur.
               CREATE bid1_tmp.
    ASSIGN bid1_sess = g_sess
        bid1_id = b_co_code
           bid1_lot = bc_lot
           bid1_par_id = bc_id.
            END.
             END.
            
             FIND FIRST b_co_mstr WHERE b_co_code = bc_id   /*AND b_co_ref = ''*/ EXCLUSIVE-LOCK NO-ERROR.
            IF IF mtype = 'po' THEN mqty = bc_qty  ELSE YES THEN DO:
           
               {bcrun.i ""bcmgcheck.p"" "(input ""po_rct"" ,
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
         input mtype,
        output success)"}
       
          IF NOT success THEN DO:
          ASSIGN
              bc_id = ''.
          DISP bc_id WITH FRAME bc.
          
          UNDO,RETRY.
          END.
         ELSE DO:
             bc_po_line = lntyp.
              DISP bc_po_line WITH FRAME bc. 
              /*bc_part = b_co_part.
                  bc_qty = b_co_qty_cur.
                  bc_lot = b_co_lot.*/
              IF mtype = 'po' THEN
              FOR EACH bid1_tmp WHERE bid1_sess = g_sess AND   bid1_par_id = bc_id:
                   bid1_line = INTEGER(bc_po_line).
                   END.
          FIND FIRST po1_tmp WHERE po1_sess = g_sess AND po1_nbr = bc_po_nbr AND po1_line = INTEGER(bc_po_line) AND po1_part = bc_part AND po1_lot <> bc_lot NO-LOCK NO-ERROR.
      IF AVAILABLE po1_tmp THEN DO:
        MESSAGE '相同采购项次不允许不同批次！' VIEW-AS ALERT-BOX ERROR.
       
        bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
    END. 
    ELSE DO:
       
      
          {bcrun.i ""bcmgcheck.p"" "(input ""po_rct"" ,
        input """",
        input """", 
        input bc_part, 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input bc_po_line,
         input """", 
        input STRING((IF AVAILABLE po1_tmp THEN po1_qty ELSE 0) + bc_qty),
         input """",
        output success)"}
            IF NOT success THEN  DO:
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
                bc_po_qty = qty.
                  bc_qty = b_co_qty_cur.
                 /* FIND FIRST IN_MSTR WHERE IN_part = b_co_part NO-LOCK NO-ERROR.
                 IF AVAILABLE IN_mstr THEN 
                                          assign
                                             bc_site = IN_site
                                             bc_loc = IN_user1.*/
                 ASSIGN bc_site = 'dcec-' + SUBSTR(bc_po_nbr,LENGTH(bc_po_nbr),1)
                  bc_loc = 'temp'.
                /* FIND FIRST b_po_rec WHERE b_po_recdate = (IF issch THEN TODAY ELSE pod_due_date) AND b_po_ponbr = bc_po_nbr AND b_po_poln = bc_po_line AND b_po_popart = bc_part NO-LOCK NO-ERROR.
                     IF AVAILABLE b_po_rec THEN bc_rec_qty = b_po_*/.
                 DISP bc_po_nbr bc_part bc_lot /*bc_pack*/ bc_site bc_loc bc_po_qty bc_qty  WITH FRAME bc.
                
                    
                 /*IF bc_site <> '' AND bc_loc <> '' THEN RUN main.
                            ELSE do:*/
                                ENABLE bc_site WITH FRAME bc.
                                APPLY 'entry':u TO bc_site.
                            /*END.*/
      
               END. /*b_co_mstr*/
        END. /*po-rct*/
         END. /*po1_tmp*/
           END. /*po-rct*/
           END.
           ELSE DO:
               MESSAGE '大签数量与小签不一致!' VIEW-AS ALERT-BOX ERROR.
                FOR EACH bid1_tmp WHERE bid1_sess = g_sess AND bid1_par_id = bc_id:
         DELETE bid1_tmp.
       END.
               bc_id = ''.
               DISP bc_id WITH FRAME bc.
               UNDO,RETRY.
           
           END.
           END. /*b_co_ref*/
             
      END. /*po1_tmp*/
           ELSE do:
                IF AVAILABLE b_co_mstr AND b_co_ref <> '' THEN MESSAGE bc_id ' 为进口件条码，清按货运单入库！' VIEW-AS ALERT-BOX ERROR.
                                         ELSE  MESSAGE bc_id '无效条码！' VIEW-AS ALERT-BOX ERROR.
                ASSIGN bc_id = ''.
                 DISP bc_id WITH FRAME bc.
                 UNDO,RETRY.
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
         FIND FIRST pod_det WHERE pod_nbr = bc_po_nbr AND STRING(pod_line) = bc_po_line NO-LOCK NO-ERROR.
     IF pod_site <> bc_site THEN DO:
      ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
                MESSAGE '地点不一致，不能收货！' VIEW-AS ALERT-BOX ERROR.
               UNDO,RETRY.
         END.
     ELSE DO:
    
         DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
      RUN barscan.
         END.
          END.     
       
   
  
     END.
     ON 'choose':U OF bc_button
     DO:
       
         RUN main.
     END.

 
PROCEDURE barscan:
 IF mtype <> 'po' THEN DO:
   FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
               CREATE bid1_tmp.
    ASSIGN bid1_sess = g_sess
        bid1_id = bc_id
           bid1_lot = bc_lot
          bid1_par_id = SUBSTR(b_co_btype,2)
           bid1_line = INTEGER(bc_po_line).
       
             END.
    FIND FIRST po1_tmp WHERE po1_sess = g_sess AND po1_nbr = bc_po_nbr AND po1_line = INTEGER(bc_po_line) AND po1_part = bc_part AND po1_lot = bc_lot EXCLUSIVE-LOCK NO-ERROR.
     
           
    IF AVAILABLE po1_tmp THEN po1_qty = po1_qty + bc_qty.
    ELSE DO:
   
    CREATE po1_tmp.
    ASSIGN po1_sess = g_sess
          po1_nbr = bc_po_nbr
          po1_line = INTEGER(bc_po_line)
        po1_site = bc_site
        po1_loc = bc_loc
         po1_part = bc_part
        po1_lot = bc_lot
        po1_qty =  bc_qty.
        END.
           
   
    bc_id = ''.
    DISP bc_id po1_qty WITH FRAME bc.
    ENABLE bc_id bc_button WITH FRAME bc.
    APPLY 'entry':u TO bc_id.
    END.

PROCEDURE main:
      DEF VAR mtime AS INT.
       DEF VAR mdate AS DATE.
       DEF VAR ismodi AS LOGICAL.
          DISABLE  bc_id WITH FRAME bc.
       { bcrun.i ""bcmgcheck.p"" "(input ""period"" ,
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
     FIND FIRST po_mstr WHERE po_nbr = bc_po_nbr NO-LOCK NO-ERROR.
     FIND FIRST gl_ctrl NO-LOCK NO-ERROR.

     OUTPUT TO value(g_sess).
     PUT "@@batchload poporc.p" SKIP.
      PUT UNFORMAT '"' bc_po_nbr '"' SKIP.
          PUT  "- - " string(eff_date) " Y N N " SKIP.
        IF  NOT po_fix_rate AND po_cur <> gl_base_curr THEN  PUT '- -' SKIP.
     FOR EACH po1_tmp WHERE po1_sess = g_sess NO-LOCK:
       
      
          
     FIND FIRST pod_det WHERE pod_nbr = po1_nbr AND pod_line = po1_line NO-LOCK NO-ERROR.
     IF pod_site <> po1_site THEN DO:
     
     /*{bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
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
        input ""rct-po"" , 
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
IF NOT success THEN LEAVE.*/
         MESSAGE '地点不一致，不能收货！' VIEW-AS ALERT-BOX ERROR.
         success = NO.
         LEAVE.
     END.
  ELSE DO:
  {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
        input po1_site,
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
        input po1_site, 
        input po1_loc, 
        input po1_part, 
        input po1_lot,
         input """", 
        input ""rct-po"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
END.
        /*   FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
               */
               FIND FIRST pt_mstr WHERE pt_part = po1_part NO-LOCK NO-ERROR.
               
                         /*  IF AVAILABLE pt_mstr AND AVAILABLE pod_det AND AVAILABLE po_mstr THEN DO:*/
                  
                   
                
              
        
          PUT UNFORMAT string(po1_line) SKIP.
          PUT UNFORMAT string(po1_qty)  ' - - ' pt_um ' - - "' po1_site '" "' po1_loc '"' ' "' po1_lot '"'  SKIP.
         
               END.

               PUT '.' SKIP.
          PUT     SKIP (3)
              "." SKIP
              "@@END" SKIP.
               OUTPUT CLOSE.
               IF NOT success THEN do:
                  OS-DELETE VALUE(g_sess).
                   LEAVE.
               END.
          mtime = TIME.
          mdate = TODAY.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
                OS-DELETE VALUE('out.txt').
                FOR EACH po1_tmp WHERE po1_sess = g_sess NO-LOCK:
               
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'rct-po' AND tr_program = 'poporc.p' AND tr_nbr = po1_nbr AND tr_line = po1_line AND tr_serial = po1_lot AND tr_site =  po1_site AND tr_loc =  po1_loc  AND tr_qty_loc = po1_qty AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.
             IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX ERROR.
             
             NEXT.
               END.
       
              
         
        FIND FIRST po_mstr WHERE po_nbr = po1_nbr NO-LOCK NO-ERROR.
        FIND FIRST pod_det WHERE pod_nbr = po_nbr NO-LOCK NO-ERROR.
      

          FIND FIRST b_po_wkfl WHERE b_po_due_date  =  (IF issch THEN TODAY ELSE pod_due_date) AND b_po_nbr = po1_nbr AND b_po_line = string(po1_line)  AND b_po_part = po1_part   EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE b_po_wkfl THEN
                  ASSIGN
                      b_po_qty_rec = b_po_qty_rec + po1_qty.
          FIND FIRST b_po_rec WHERE b_po_recdate = (IF issch THEN TODAY ELSE pod_due_date) AND b_po_ponbr = po1_nbr AND b_po_poln = string(po1_line) AND b_po_popart = po1_part EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAILABLE b_po_rec THEN
                        ASSIGN
                           b_po_recqty = b_po_recqty + po1_qty.
                     ELSE DO:
                         CREATE b_po_rec.
                         ASSIGN
                             b_po_recdate = IF issch THEN TODAY ELSE pod_due_date
                             b_po_ponbr = po1_nbr
                              b_po_poln = STRING(po1_line)
                              b_po_popart = po1_part
                              b_po_recqty =  po1_qty  + (IF issch THEN 0 ELSE (IF AVAILABLE pod_det THEN (pod_qty_rcvd * IF pod_um_conv <> 0 THEN pod_um_conv ELSE 1  /*- pod_qty_rtn*/) ELSE 0)) .
                     END.
                     /*IF AVAILABLE b_po_rec THEN bc_rec_qty = b_po_recqty.*/
            /* ELSE DO:
                 CREATE b_po_wkfl.
                 ASSIGN 
                     b_po_nbr = bc_po_nbr
                     b_po_line = bc_po_line
                     b_po_part = b_co_part
                     b_po_qty_req = bc_po_qty
                     b_po_qty_rec = b_co_qty_cur
                     b_pod_due_date = IF issch THEN TODAY ELSE pod_due_date
                         b_po_staff = IF AVAILABLE in_mstr THEN IN__qadc01 ELSE ''
                  b_po_prod = IF AVAILABLE pt_mstr THEN pt_prod_line ELSE '' 
                  b_po_vend = po_vend.
     
             END.*/
                  IF AVAILABLE tr_hist THEN   bc_rec =  tr_lot.
                  ismodi = NO.
                  FOR EACH bid1_tmp WHERE bid1_sess = g_sess AND bid1_line = po1_line AND bid1_lot = po1_lot:
       FIND FIRST b_co_mstr WHERE b_co_code = bid1_id EXCLUSIVE-LOCK NO-ERROR.
       
     IF AVAILABLE b_co_mstr THEN
       assign
             b_co_status = 'rct'
             b_co_site = bc_site
             b_co_loc = bc_loc
            /* b_co_vend =  po_vend */
            b_co_ord = po_nbr
            b_co_line = string(po1_line)
            b_co_due_date = IF issch THEN TODAY ELSE pod_due_date
       /*b_co_qty_req = bc_po_qty*/.
            /* IF mtype = 'po' /*AND NOT ismodi*/ THEN DO: */
               FIND FIRST b_co_mstr WHERE b_co_code = bid1_par_id EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE b_co_mstr THEN ASSIGN b_co_status = 'ia'
                                     /* ismodi = YES*/.
           /* END. */   
          
           END.
     END.
    
     /*  {bctrcr.i
         &ord=bc_po_nbr
         &mline=bc_po_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short="if available b_po_rec then b_co_qty_req - b_po_recqty else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-po"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=b_co_vend}
 
           b_tr_trnbr_qad =  IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.

            */
            
            


             


           
             
             
             
             
             
             
             
           /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
     FOR EACH bid1_tmp WHERE bid1_sess = g_sess:
         DELETE bid1_tmp.
     END.
     FOR EACH po1_tmp WHERE po1_sess = g_sess:
         DELETE po1_tmp.
     END.
     RELEASE b_po_wkfl.
             {bcrelease.i}
                 {bcpodrelease.i}
    ASSIGN
      /*bc_lot = ''
         bc_qty = 0
     bc_part = ''*/
     bc_id = ''
   .
             DISABLE bc_button WITH FRAME bc.
     DISP bc_id bc_site bc_loc bc_lot bc_qty bc_part bc_rec WITH FRAME bc.
     ENABLE bc_po_nbr WITH FRAME bc.
     /* ENABLE bc_id WITH FRAME bc.
    APPLY 'entry':u TO bc_id.*/
     
END.



    {BCTRAIL.I}
