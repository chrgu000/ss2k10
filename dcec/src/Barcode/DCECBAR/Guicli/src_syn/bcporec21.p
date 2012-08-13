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
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)"    LABEL "采购单".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_pack AS CHAR FORMAT "x(20)" LABEL "包装号".
DEF VAR mid AS RECID.
 DEF TEMP-TABLE rec1list_tmp 
     FIELD rec1_sess LIKE g_sess
     FIELD rec1_po_nbr LIKE po_nbr 
     FIELD rec1_po_line LIKE pod_line 
     FIELD rec1_po_part LIKE pod_part 
     FIELD rec1_po_qty LIKE pod_qty_ord 
     FIELD rec1_qty LIKE pod_qty_ord
     FIELD rec1_po_part_lot LIKE b_co_lot
     FIELD rec1_site LIKE bc_site
     FIELD rec1_loc LIKE bc_loc
     FIELD rec1_code LIKE b_co_code
     FIELD rec1_issch AS LOGICAL
     FIELD rec1_bar_qty LIKE pod_qty_ord.
     DEFINE QUERY bc_qry FOR rec1list_tmp.
         DEF VAR msite AS CHAR.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
         rec1_code COLUMN-LABEL "条码"
        rec1_po_part COLUMN-LABEL "零件号"
        rec1_po_part_lot COLUMN-LABEL "批/序号"
    rec1_po_qty COLUMN-LABEL "订单量"
  rec1_bar_qty COLUMN-LABEL "条码数量"
     rec1_qty COLUMN-LABEL "实收数量"  
        rec1_po_nbr COLUMN-LABEL "采购单"
   rec1_po_line COLUMN-LABEL "行"
       
        rec1_site  COLUMN-LABEL "地点"
        rec1_loc COLUMN-LABEL "库位"
 
   
  
WITH NO-ROW-MARKERS SEPARATORS 4 DOWN WIDTH 29  /*TITLE "待收货清单"*/.

DEF FRAME bc
    bc_pack AT ROW 1.2 COL 2.5
    bc_brw AT ROW 2.4 COL 1
   
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
    bc_po_nbr AT ROW 8 COL 2.5
   /* bc_po_line AT ROW 9.7 COL 4*/
  bc_id AT ROW 9.2 COL 4

    /*bc_part AT ROW 12.1 COL 2.5
   
  
   bc_lot AT ROW 13.3 COL 1.6
   /* bc_pack AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 14.5 COL 4 /*'EA' AT ROW 10.8 COL 22 */*/
   
    bc_site AT ROW 10.4 COL 4

    bc_loc AT ROW 10.4 COL 20 NO-LABEL
  
   
    bc_button AT ROW 12 COL 10
    WITH SIZE 30 BY 14 TITLE "PO收货-进口"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_pack 
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
ON CURSOR-DOWN OF bc_pack
DO:
    
       ASSIGN bc_pack.
       FIND FIRST b_co_mstr USE-INDEX b_co_sort5 NO-LOCK WHERE  b_co_ref <> '' AND b_co_cntst = '' AND (b_co_status = 'ac' OR b_co_status = 'iss') AND b_co_ref > bc_pack  NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_pack = b_co_ref.
           DISPLAY bc_pack WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_pack
DO:
   
        ASSIGN bc_pack.
       FIND LAST b_co_mstr USE-INDEX b_co_sort5 NO-LOCK WHERE b_co_ref <> '' AND b_co_cntst = '' AND (b_co_status = 'ac' OR b_co_status = 'iss') AND b_co_ref < bc_pack NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_pack = b_co_ref.
           DISPLAY bc_pack WITH FRAME bc.
       END.
   
END.
ON enter OF bc_pack
DO:
    bc_pack = bc_pack:SCREEN-VALUE.
   FIND FIRST b_co_mstr  USE-INDEX b_co_sort5 WHERE  b_co_ref <> '' AND b_co_cntst = '' AND (b_co_status = 'ac' OR b_co_status = 'iss') AND b_co_ref = bc_pack    EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE b_co_mstr THEN DO:
   
   MESSAGE '包装号不存在,或已入库，或所属条码处于盘点状态!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.  
        END.
        ELSE DO:
            FOR EACH b_co_mstr USE-INDEX b_co_sort5 WHERE b_co_ref = bc_pack AND b_co_cntst = '' AND (b_co_status = 'ac' OR b_co_status = 'iss') NO-LOCK:
                CREATE rec1list_tmp.
                ASSIGN
                    rec1_sess = g_sess
                    rec1_code = b_co_code   
                    rec1_po_part = b_co_part
                        rec1_po_part_lot = b_co_lot
                    rec1_bar_qty = b_co_qty_cur.
             

                END.
                FIND FIRST b_co_mstr USE-INDEX b_co_sort5 WHERE  b_co_ref <> '' AND b_co_cntst = '' AND (b_co_status = 'ac' OR b_co_status = 'iss') AND b_co_ref = bc_pack    EXCLUSIVE-LOCK NO-ERROR.
                OPEN QUERY bc_qry FOR EACH rec1list_tmp WHERE rec1_sess = g_sess.

        DISABLE bc_pack WITH FRAME bc.
    ENABLE bc_brw bc_po_nbr WITH FRAME bc.
    
        END.
END.

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
       APPLY 'entry':u TO bc_id.
 
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
       FIND FIRST b_co_mstr  NO-LOCK WHERE b_co_code > bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_id
DO:
   
        ASSIGN bc_id.
       FIND LAST b_co_mstr   NO-LOCK WHERE b_co_code < bc_id NO-ERROR.
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
           FIND FIRST rec1list_tmp WHERE rec1_sess = g_sess AND rec1_code = bc_id NO-LOCK NO-ERROR.
         IF NOT AVAILABLE rec1list_tmp THEN DO: MESSAGE '该条码不属于该包装的有效条码!' VIEW-AS ALERT-BOX.
      
        ASSIGN bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
         
         END.
         ELSE DO:
       
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
         input """",
        output success)"}

          IF NOT success THEN 
       DO:
        ASSIGN bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
          END.
      ELSE DO: 
          
              DISABLE bc_id WITH FRAME bc.
              
             /* IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_pack = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_pack*/ bc_qty WITH FRAME bc.
                  END.*/
             /* .
             
              IF NOT AVAILABLE rec1list_tmp THEN DO:
              
              FIND FIRST rec1list_tmp WHERE rec1ID(rec1list_tmp) = mid EXCLUSIVE-LOCK NO-ERROR.*/
               FIND FIRST rec1list_tmp WHERE rec1_sess = g_sess AND rec1_code = b_co_code NO-LOCK NO-ERROR.
               mid = RECID(rec1list_tmp).
           IF AVAILABLE rec1list_tmp THEN
                  ASSIGN
                  rec1list_tmp.rec1_po_nbr = bc_po_nbr
                  
                  rec1list_tmp.rec1_po_qty = qty
                  rec1list_tmp.rec1_qty = b_co_qty_cur
                  rec1list_tmp.rec1_po_line = integer(lntyp)
                  rec1list_tmp.rec1_issch = issch
                 /* rec1list_tmp.rec1_po_part_lot = b_co_lot*/.
              
              OPEN QUERY bc_qry FOR EACH rec1list_tmp WHERE rec1_sess = g_sess NO-LOCK.
              ENABLE bc_site WITH FRAME bc.
              APPLY 'entry':u TO bc_site.
             /* END.
              ELSE do:
                  MESSAGE '该条码已存在!' VIEW-AS ALERT-BOX.
                  ENABLE bc_po_nbr WITH FRAME bc.
              END.*/
              
      END.
      END.
      
         
    END.

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
           FIND FIRST rec1list_tmp WHERE RECID(rec1list_tmp) = mid EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN
              rec1list_tmp.rec1_site = bc_site
              rec1list_tmp.rec1_loc = bc_loc.
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
      OPEN QUERY bc_qry FOR EACH rec1list_tmp WHERE rec1_sess = g_sess NO-LOCK.
          ENABLE bc_po_nbr bc_brw WITH FRAME bc.
          FIND FIRST rec1list_tmp WHERE rec1_sess = g_sess AND (rec1_code = '' OR rec1_po_nbr = '' OR rec1_po_line = 0 OR rec1_po_qty = 0 OR rec1_qty <> rec1_bar_qty OR rec1_site = '' OR rec1_loc = '' ) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE rec1list_tmp THEN
          ENABLE bc_button WITH FRAME bc.  
     
             
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
    FOR EACH rec1list_tmp WHERE rec1_sess = g_sess EXCLUSIVE-LOCK:
    {bccntlock.i "rec1_site" "rec1_loc"}
  FIND FIRST b_co_mstr WHERE b_co_code = rec1_code AND b_co_cntst = '' AND (b_co_status = 'ac' OR b_co_status = 'iss') EXCLUSIVE-LOCK NO-ERROR.
           
    IF AVAILABLE b_co_mstr THEN DO:
   
      {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
        input rec1_site,
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
        input rec1_site, 
        input rec1_loc, 
        input rec1_po_part, 
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
        
         FIND FIRST po_mstr WHERE po_nbr = rec1_po_nbr NO-LOCK NO-ERROR.  
        
            
          
           

             assign
              b_co_status = 'rct'
              b_co_site = rec1_site
              b_co_loc = rec1_loc
           /* b_co_vend = po_vend*/
            b_co_ord = rec1_po_nbr
            b_co_line = string(rec1_po_line)
             /*b_co_due_date = IF rec1_issch THEN TODAY ELSE po_due_date*/
                 b_co_qty_req = rec1_po_qty.
         {bctrcr.i
         &ord=rec1_po_nbr
         &mline=rec1_po_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=rec1_po_qty
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-po"'
          &mtime=TIME
           &b_loc=b_co_loc
           &b_site=b_co_site
           &b_usrid=g_user
           &b_addr=b_co_vend}
        DELETE rec1list_tmp. 
          
    END.
     ELSE MESSAGE rec1_code ' 已入库，或处于盘点状态!' VIEW-AS ALERT-BOX.
    END.
       OPEN QUERY bc_qry FOR EACH rec1list_tmp WHERE rec1_sess = g_sess NO-LOCK.
           RELEASE b_po_wkfl.
           {bcrelease.i}
       DISABLE ALL WITH FRAME bc.
       ENABLE bc_pack WITH FRAME bc.
  
     
END.



    {BCTRAIL.I}
