{mfdeclre.i }
{bcdeclre.i }
    
    {bcwin04.i}
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_po_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_po_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "在途库".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)"    LABEL "采购单".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_poshp AS CHAR FORMAT "x(20)" LABEL "货运单号".
DEF VAR mid AS recID.
 DEF TEMP-TABLE rectr1_tmp 
     FIELD rectr1_sess LIKE g_sess
     FIELD rectr1_po_nbr LIKE po_nbr 
     FIELD rectr1_po_line LIKE pod_line 
     FIELD rectr1_po_part LIKE pod_part 
     FIELD rectr1_po_qty LIKE pod_qty_ord 
     FIELD rectr1_qty LIKE pod_qty_ord
     FIELD rectr1_po_part_lot LIKE b_co_lot
     FIELD rectr1_site LIKE bc_site
     FIELD rectr1_loc LIKE bc_loc
     FIELD rectr1_code LIKE b_co_code
     FIELD rectr1_issch AS LOGICAL
     FIELD rectr1_bar_qty LIKE pod_qty_ord
     FIELD rectr1_site1 LIKE bc_site
     FIELD rectr1_loc1 LIKE bc_site.
     DEFINE QUERY bc_qry FOR rectr1_tmp.
         DEF VAR msite AS CHAR.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
         rectr1_code COLUMN-LABEL "条码"
        rectr1_po_part COLUMN-LABEL "零件号"
        rectr1_po_part_lot COLUMN-LABEL "批/序号"
    rectr1_po_qty COLUMN-LABEL "订单量"
        rectr1_bar_qty COLUMN-LABEL "条码数量"
        rectr1_qty COLUMN-LABEL "实收数量" 
        rectr1_po_nbr COLUMN-LABEL "采购单"
   rectr1_po_line COLUMN-LABEL "行"
        
        rectr1_site  COLUMN-LABEL "地点"
        rectr1_loc COLUMN-LABEL "外库"
         rectr1_site1 COLUMN-LABEL "地点"
        rectr1_loc1 COLUMN-LABEL "在途库"
   
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  /*TITLE "待收货清单"*/.

DEF FRAME bc
    bc_poshp AT ROW 1.2 COL 2.5
    bc_brw AT ROW 2.4 COL 1
   
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
   /* bc_po_nbr AT ROW 8 COL 2.5*/
   /* bc_po_line AT ROW 9.7 COL 4*/
 

    /*bc_part AT ROW 12.1 COL 2.5
   
  
   bc_lot AT ROW 13.3 COL 1.6
   /* bc_poshp AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 14.5 COL 4 /*'EA' AT ROW 10.8 COL 22 */*/
   
    bc_site AT ROW 9.6 COL 4

    bc_loc AT ROW 10.8 COL 4 
  
   
    bc_button AT ROW 12 COL 10
    WITH SIZE 30 BY 14 TITLE "进口材料移库-至在途库" SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_poshp 
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
ON CURSOR-DOWN OF bc_poshp
DO:
    
       ASSIGN bc_poshp.
       FIND FIRST b_co_mstr USE-INDEX b_co_sort5  NO-LOCK WHERE  b_co_ref <> ''  AND b_co_cntst = '' AND b_co_status = 'rct' AND  b_co_ref > bc_poshp  NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_poshp = b_co_ref.
           DISPLAY bc_poshp WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_poshp
DO:
   
        ASSIGN bc_poshp.
       FIND LAST b_co_mstr USE-INDEX b_co_sort5 NO-LOCK WHERE b_co_ref <> ''  AND b_co_cntst = '' AND b_co_status = 'rct' AND b_co_ref < bc_poshp NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_poshp = b_co_ref.
           DISPLAY bc_poshp WITH FRAME bc.
       END.
   
END.
ON enter OF bc_poshp
DO:
    bc_poshp = bc_poshp:SCREEN-VALUE.
   FIND FIRST b_co_mstr USE-INDEX b_co_sort5 WHERE  b_co_ref <> ''   AND b_co_cntst = '' AND b_co_status = 'rct' AND b_co_ref = bc_poshp     EXCLUSIVE-LOCK NO-ERROR.
  
   IF NOT AVAILABLE b_co_mstr THEN DO:
   
   MESSAGE '货运单不存在,或未入外库，或所属条码处于盘点状态!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.  
        END.
        ELSE DO:
             FOR EACH b_co_mstr USE-INDEX b_co_ref WHERE b_co_ref = bc_poshp AND b_co_cntst = '' AND b_co_status = 'rct' NO-LOCK:
                CREATE rectr1_tmp.
                ASSIGN
                    rectr1_sess = g_sess
                    rectr1_code = b_co_code   
                    rectr1_po_part = b_co_part
                        rectr1_po_part_lot = b_co_lot
                    rectr1_po_nbr = b_co_ord
                
                 rectr1_po_qty = b_co_qty_req
                 rectr1_bar_qty = b_co_qty_cur
                 rectr1_po_line = integer(b_co_line)
                    rectr1_site = b_co_site
                    rectr1_loc = b_co_loc
                    rectr1_qty = b_co_qty_cur.

                END.
                FIND FIRST b_co_mstr USE-INDEX b_co_sort5 WHERE  b_co_ref <> ''  AND b_co_cntst = ''  AND b_co_status = 'rct' AND b_co_ref = bc_poshp     EXCLUSIVE-LOCK NO-ERROR.

                OPEN QUERY bc_qry FOR EACH rectr1_tmp WHERE rectr1_sess = g_sess.

        DISABLE bc_poshp WITH FRAME bc.
            ENABLE bc_brw   bc_site WITH FRAME bc.
            APPLY 'entry':u TO bc_site.
            
    
        END.
END.


  
/*
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
       
       UNDO,RETRY.

    END.
   ELSE DO: 
       

       DISABLE bc_po_nbr WITH FRAME bc.
     
       ENABLE bc_id WITH FRAME bc.
       APPLY 'entry':u TO bc_id.
 
   END.
  
    END.*/

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
/*ON CURSOR-DOWN OF bc_id
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
        
             FIND FIRST rectr1tr1_tmp WHERE rectr1_code = bc_id NO-LOCK NO-ERROR.
         IF NOT AVAILABLE rectr1tr1_tmp THEN DO: MESSAGE '该条码不属于该包装的有效条码!' VIEW-AS ALERT-BOX.
         UNDO,RETRY.
         END.
         ELSE DO:
         
          /* {bcrun.i ""bcmgcheck.p"" "(input ""bd"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input ""potr"", 
        input """",
         input """",
        output success)"}

          IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO: */
          
              DISABLE bc_id WITH FRAME bc.
              FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
             /* IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_poshp = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_poshp*/ bc_qty WITH FRAME bc.
                  END.*/
              
              FIND FIRST rectr1tr1_tmp WHERE rectr1_code = b_co_code NO-LOCK NO-ERROR.
              mid = rectr1ID(rectr1tr1_tmp).
              
             
              ASSIGN
                  
                  rectr1tr1_tmp.rectr1_qty = b_co_qty_cur.
                
              
              OPEN QUERY bc_qry FOR EACH rectr1tr1_tmp NO-LOCK.
              ENABLE bc_site WITH FRAME bc.
              APPLY 'entry':u TO bc_site.
             
              
     /* END.*/
          
      END.
         
    END.*/

     ON enter OF bc_site
DO:
         
         bc_site = bc_site:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site.
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
       
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
           IF NOT success THEN do:
               ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               
               UNDO,RETRY.
           END.
           ELSE DO:
           
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
      
        FOR EACH rectr1_tmp WHERE rectr1_sess = g_sess:
            
            ASSIGN 
              rectr1_site1 = bc_site
             rectr1_loc1 = bc_loc.
        END.
         
          OPEN QUERY bc_qry FOR EACH rectr1_tmp WHERE rectr1_sess = g_sess NO-LOCK. 
                /*ENABLE bc_id WITH FRAME bc.*/
              FIND FIRST rectr1_tmp WHERE rectr1_sess = g_sess AND (rectr1_bar_qty <> rectr1_qty OR rectr1_site = '' OR rectr1_loc = '' OR rectr1_site1 = '' OR rectr1_loc1 = '' OR (rectr1_site = rectr1_site1 AND rectr1_loc = rectr1_loc1)) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE rectr1_tmp THEN
          ENABLE bc_button WITH FRAME bc.  
        ELSE DO:
        MESSAGE '存在数量不一致，或地点库位空或相同!' VIEW-AS ALERT-BOX.
         ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               ENABLE bc_site WITH FRAME bc.
              APPLY 'entry':u TO bc_site.
         UNDO,RETRY.
        END.
      END.
             
 
     END.
     ON 'choose':U OF bc_button
     DO:
         RUN main.

     END.
  /*  ON enter OF bc_loc
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
       ENABLE bc_button WITH FRAME bc.
        
        
        
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
        
         
    FOR EACH rectr1_tmp WHERE rectr1_sess = g_sess EXCLUSIVE-LOCK:
   FIND FIRST b_co_mstr WHERE b_co_code = rectr1_code AND  b_co_cntst = '' AND b_co_status = 'rct' AND b_co_site = rectr1_site AND b_co_loc = rectr1_loc EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_co_mstr THEN DO:
    
            {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
        input rectr1_site,
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
        input rectr1_site1,
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
        input rectr1_site, 
        input rectr1_loc, 
        input rectr1_po_part, 
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
        input rectr1_site1, 
        input rectr1_loc1, 
        input rectr1_po_part, 
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
     
        
         FIND FIRST po_mstr WHERE po_nbr = rectr1_po_nbr NO-LOCK NO-ERROR.  
        
           /* FIND FIRST b_po_wkfl WHERE b_po_due_date = b_co_due_date AND b_po_nbr = b_co_ord AND b_po_line = b_co_line AND b_po_part = b_co_part NO-LOCK NO-ERROR.
         
           */

             assign
              
              b_co_site = rectr1_site1
              b_co_loc = rectr1_loc1.
                
            
         {bctrcr.i
         &ord=rectr1_po_nbr
         &mline=rectr1_po_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-tr"'
          &mtime=TIME
           &b_loc=rectr1_loc
           &b_site=rectr1_site
           &b_usrid=g_user
           &b_addr=b_co_vend}
           ASSIGN b_tr_site1 = rectr1_site1
                b_tr_loc1 = rectr1_loc1.
             {bctrcr.i
         &ord=rectr1_po_nbr
         &mline=rectr1_po_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-tr"'
          &mtime=TIME
           &b_loc=b_co_loc
           &b_site=b_co_site
           &b_usrid=g_user
           &b_addr=b_co_vend}
           ASSIGN b_tr_site1 = rectr1_site
                b_tr_loc1 = rectr1_loc.
        DELETE rectr1_tmp. 
     END.
     ELSE MESSAGE rectr1_code ' 未入外库或已移库，或处于盘点状态!' VIEW-AS ALERT-BOX.
    END.
       OPEN QUERY bc_qry FOR EACH rectr1_tmp WHERE rectr1_sess = g_sess NO-LOCK.
         
           {bcrelease.i}
       DISABLE ALL WITH FRAME bc.
       ENABLE bc_poshp WITH FRAME bc.
  
     
END.



    {BCTRAIL.I}
