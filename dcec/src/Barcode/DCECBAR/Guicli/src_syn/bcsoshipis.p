{mfdeclre.i }
{bcdeclre.i }
    
    {bcwin02.i}
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_so_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_so_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_so_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_so_nbr AS CHAR FORMAT "x(8)"    LABEL "销售单".
DEF VAR bc_so_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_so_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR qty_iss AS DECIMAL .
DEF VAR mid AS RECID.
DEF VAR bc_cust AS CHAR  FORMAT "x(8)" LABEL "客户".
DEF VAR bc_ship AS CHAR  FORMAT "x(18)" LABEL "发运单".
 DEF TEMP-TABLE shipcode_tmp
     FIELD shipcode_sess LIKE g_sess    
     FIELD shipcode_id LIKE b_co_code
         FIELD shipcode_so_nbr LIKE sod_nbr
         FIELD shipcode_so_line LIKE sod_line
         FIELD shipcode_part LIKE sod_part
         FIELD shipcode_qty LIKE b_co_qty_cur
         FIELD shipcode_site LIKE b_co_site
         FIELD shipcode_loc LIKE b_co_loc
          FIELD shipcode_lot LIKE b_co_lot.
    
     
     DEFINE QUERY bc_qry FOR shipcode_tmp.
         DEF VAR msite AS CHAR.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          shipcode_id COLUMN-LABEL "条码"
          shipcode_so_nbr COLUMN-LABEL "订单"
          shipcode_so_line COLUMN-LABEL "行"
          shipcode_part COLUMN-LABEL "零件号"
        shipcode_lot COLUMN-LABEL "批/序号"
         shipcode_qty COLUMN-LABEL "数量"
         shipcode_site COLUMN-LABEL "地点"
        shipcode_loc COLUMN-LABEL " 库位"
        
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  /*TITLE "待收货清单"*/.

DEF FRAME bc
   
    bc_so_nbr AT ROW 1.2 COL 2.5
    bc_brw AT ROW 2.4 COL 1
   
    /*bc_so_part_desc  AT ROW 6 COL 1
    bc_so_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
    
   /* bc_so_line AT ROW 9.7 COL 4*/
/*  bc_id AT ROW 9.2 COL 4*/

    /*bc_part AT ROW 12.1 COL 2.5
   
  
   bc_lot AT ROW 13.3 COL 1.6
   /* bc_cust AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 14.5 COL 4 /*'EA' AT ROW 10.8 COL 22 */*/
   
   
  
   
    bc_button AT ROW 9.6 COL 10
    WITH SIZE 30 BY 12 TITLE "销售发运-按备料单"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_so_nbr
   /* bc_so_line
  
    bc_id  bc_button */ 
     WITH FRAME bc IN WINDOW c-win.
/*
bc_sub = NO.
DISP bc_sub WITH FRAME bc.*/
/*DISABLE bc_so_part_desc  bc_so_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_so_qty
  /*  bc_so_part_desc  
    bc_so_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/
/*ON CURSOR-DOWN OF bc_cust
DO:
    
       ASSIGN bc_cust.
       FIND FIRST cm_mstr NO-LOCK WHERE cm_addr > bc_cust  NO-ERROR.
       IF AVAILABLE cm_mstr THEN DO:
           ASSIGN bc_cust = cm_addr.
           DISPLAY bc_cust WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_cust
DO:
   
        ASSIGN bc_cust.
       FIND LAST cm_mstr NO-LOCK WHERE cm_addr < bc_cust NO-ERROR.
       IF AVAILABLE cm_mstr THEN DO:
           ASSIGN bc_cust = cm_addr.
           DISPLAY bc_cust WITH FRAME bc.
       END.
   
END.
ON enter OF bc_cust
DO:
    bc_cust = bc_cust:SCREEN-VALUE.
  FIND LAST cm_mstr NO-LOCK WHERE cm_addr = bc_cust NO-ERROR.
   IF NOT AVAILABLE cm_mstr THEN DO:
   
   MESSAGE '无效客户!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.  
        END.
        ELSE DO:
            

        DISABLE bc_cust WITH FRAME bc.
    ENABLE  bc_ship WITH FRAME bc.
    
        END.
END.*/

/*ON CURSOR-DOWN OF bc_ship
DO:
    
       ASSIGN bc_ship.
       
    
END.

ON CURSOR-UP OF bc_ship
DO:
   
       ASSIGN bc_so_nbr.
       
   
END.*/
ON CURSOR-DOWN OF bc_so_nbr
DO:
    
       ASSIGN bc_so_nbr.
       FIND FIRST so_mstr NO-LOCK WHERE so_nbr > bc_so_nbr  NO-ERROR.
       IF AVAILABLE so_mstr THEN DO:
           ASSIGN bc_so_nbr = so_nbr.
           DISPLAY bc_so_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_so_nbr
DO:
   
        ASSIGN bc_so_nbr.
       FIND LAST so_mstr NO-LOCK WHERE so_nbr < bc_so_nbr NO-ERROR.
       IF AVAILABLE so_mstr THEN DO:
           ASSIGN bc_so_nbr = so_nbr.
           DISPLAY bc_so_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_so_nbr
DO:
    {bcsodrelease.i}
    bc_so_nbr = bc_so_nbr:SCREEN-VALUE.
  FIND FIRST so_mstr  WHERE so_nbr = bc_so_nbr EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE so_mstr THEN DO:
   
   MESSAGE '无效订单!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.  
        END.
        ELSE DO:
   bc_ship = bc_so_nbr.
    FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship  AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
    IF   AVAILABLE b_shp_wkfl THEN DO:
        
        FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' NO-LOCK:
            
            CREATE shipcode_tmp.
         ASSIGN
             shipcode_sess = g_sess
             shipcode_id = b_shp_code
             shipcode_so_nbr = b_shp_so
             shipcode_so_line = b_shp_line
             shipcode_part = b_shp_part
             shipcode_lot = b_shp_lot
             shipcode_qty = b_shp_qty
             shipcode_site = b_shp_site
             shipcode_loc = b_shp_loc.
       END.
        FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship  AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
       OPEN QUERY bc_qry FOR EACH shipcode_tmp WHERE shipcode_sess = g_sess NO-LOCK.
           FOR EACH shipcode_tmp WHERE shipcode_sess = g_sess NO-LOCK:
               FIND FIRST b_co_mstr WHERE b_co_code = shipcode_id AND b_co_status = 'all' NO-LOCK NO-ERROR.
               IF NOT AVAILABLE b_co_mstr THEN DO:
                   MESSAGE b_co_code ' 已出货或盘亏,请将其从备料单删除!' VIEW-AS ALERT-BOX.
                   success =  NO.
                   LEAVE.
               END.
           END.
           IF NOT success THEN LEAVE.
           ENABLE bc_button bc_brw WITH FRAME bc.

       END.
     /* ELSE DO:
    
          MESSAGE '该发运单不存在或已发运!' VIEW-AS ALERT-BOX.
          ENABLE bc_ship WITH FRAME bc.
          UNDO,RETRY.
      END.*/
    END.
   /* ELSE do:
          MESSAGE '发运单号不能为空!' VIEW-AS ALERT-BOX.
          ENABLE bc_ship WITH FRAME bc.
          UNDO,RETRY.
         END.*/
END.

/*
ON CURSOR-DOWN OF bc_so_nbr
DO:
    
       ASSIGN bc_ship.
       FIND FIRST so_mstr NO-LOCK WHERE so_nbr > bc_so_nbr NO-ERROR.
       IF AVAILABLE so_mstr THEN DO:
           ASSIGN bc_so_nbr = so_nbr.
           DISPLAY bc_so_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_so_nbr
DO:
   
       ASSIGN bc_so_nbr.
       FIND LAST so_mstr NO-LOCK WHERE so_nbr < bc_so_nbr NO-ERROR.
       IF AVAILABLE so_mstr THEN DO:
           ASSIGN bc_so_nbr = so_nbr.
           DISPLAY bc_so_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_so_nbr
DO:
    bc_so_nbr = bc_so_nbr:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""so"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_so_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: 
       

       DISABLE bc_so_nbr WITH FRAME bc.
     
       ENABLE bc_id WITH FRAME bc.
       APPLY 'entry':u TO bc_id.
 
   END.
  
    END.
*/
/*
   ON enter OF bc_so_line
DO:
        bc_so_line = bc_so_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""sod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_so_nbr, 
        input bc_so_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""sod"" ,
            INPUT bc_so_nbr,
            INPUT bc_so_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_so_part = part.
    bc_so_qty = qty.
  
    DISP /*bc_so_part bc_so_qty*/ WITH FRAME bc.
     DISABLE bc_so_line WITH FRAME bc. 
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
        
           
         
           {bcrun.i ""bcmgcheck.p"" "(input ""so_iss"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input shiplist_tmp.ship_so_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}

          IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO: 
          
              /*DISABLE bc_id WITH FRAME bc.*/
              FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
             /* IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_cust = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_cust*/ bc_qty WITH FRAME bc.
                  END.*/
              mid = RECID(shiplist_tmp).
              FIND FIRST shiplist_tmp WHERE ship_code = b_co_code NO-LOCK NO-ERROR.
              IF NOT AVAILABLE shiplist_tmp THEN DO:
              
              FIND FIRST shiplist_tmp WHERE RECID(shiplist_tmp) = mid EXCLUSIVE-LOCK NO-ERROR.
              ASSIGN
                  
                  shiplist_tmp.ship_code = b_co_code
                  
                  shiplist_tmp.ship_qty = b_co_qty_cur
                  shiplist_tmp.ship_site = b_co_site
                  shiplist_tmp.ship_loc = b_co_loc
                  /*shiplist_tmp.ship_issch = issch*/.
              
              OPEN QUERY bc_qry FOR EACH shiplist_tmp NO-LOCK.
               FIND FIRST shiplist_tmp WHERE   ship_code <> '' AND ship_qty <> 0  AND  ship_site <> '' AND ship_loc <> ''  NO-LOCK NO-ERROR.
        IF AVAILABLE shiplist_tmp THEN
          ENABLE bc_button WITH FRAME bc.  
              END.
              ELSE do:
                  MESSAGE '该条码已存在!' VIEW-AS ALERT-BOX.
                  ENABLE bc_id WITH FRAME bc.
                  APPLY 'entry':u TO bc_id.
              END.
              
      END.
          
      
         
    END.*/

    /* ON enter OF bc_site
DO:
         
         bc_site = bc_site:SCREEN-VALUE.
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
           IF NOT success THEN UNDO,RETRY.
           ELSE DO:
           FIND FIRST shiplist_tmp WHERE RECID(shiplist_tmp) = mid EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN
              shiplist_tmp.ship_site = bc_site
              shiplist_tmp.ship_loc = bc_loc.
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
      OPEN QUERY bc_qry FOR EACH shiplist_tmp NO-LOCK.
          ENABLE  bc_brw WITH FRAME bc.
         
     
             
      END.
   
 
     END.*/
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
   DEF VAR umconv AS DECIMAL.
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
         input ""SO"", 
        input """",
         input """",
        output success)"}   
              IF NOT success THEN LEAVE.
    FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship  AND b_shp_status = '' EXCLUSIVE-LOCK:
   
     FIND FIRST b_co_mstr WHERE b_co_code = b_shp_code AND b_co_cntst = '' AND (b_co_status = 'rct' OR b_co_status = 'all') EXCLUSIVE-LOCK NO-ERROR.  
           IF AVAILABLE b_co_mstr THEN DO:
         
    
      {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
        input b_shp_site,
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
     
{bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input b_shp_site, 
        input b_shp_loc, 
        input b_shp_part, 
        input """",
         input """", 
        input ""iss-so"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      

 {bcrun.i ""bcmgcheck.p"" "(input ""so_iss"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input b_shp_code, 
        input b_shp_so, 
        input """",
         input b_shp_shipper, 
        input """",
         input """",
        output success)"}
           END.
      ELSE DO: MESSAGE '存在条码已发货或盘亏,或处于盘点状态！' view-as alert-box.
      success = NO.
      END.
    END.
      IF success THEN 
          FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship  AND b_shp_status = '' EXCLUSIVE-LOCK:
           {bccntlock.i "b_shp_site" "b_shp_loc"}
          {bcsodlock.i}
           {bcrun.i ""bcmgcheck.p"" "(input ""so_iss"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input b_shp_code, 
        input b_shp_so, 
        input """",
         input b_shp_shipper, 
        input """",
         input """",
        output success)"}
              IF NOT success  THEN LEAVE.
     FIND FIRST b_co_mstr WHERE b_co_code = b_shp_code AND  b_co_cntst = '' AND (b_co_status = 'rct' OR b_co_status = 'all') EXCLUSIVE-LOCK NO-ERROR.  
           IF AVAILABLE b_co_mstr THEN DO:
          
                FIND FIRST sod_det WHERE sod_nbr = b_shp_so AND sod_line = b_shp_line NO-LOCK NO-ERROR.
           IF AVAILABLE sod_det THEN umconv = IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1.
            
                                                                                        
            
                 OUTPUT TO value(g_sess).
                
              PUT "@@batchload sosois.p" SKIP.
          PUT UNFORMAT b_shp_so ' - - - -' SKIP.
         PUT UNFORMAT string(b_shp_line) ' -' SKIP.
         PUT UNFORMAT STRING(b_co_qty_cur / umconv) ' "' b_co_site '" "' b_co_loc '"' ' "     "' SKIP.
         PUT '.' SKIP.
         PUT  SKIP(2).
        PUT '-' SKIP.
     PUT '-' SKIP.
     PUT '.' SKIP.
     PUT '@@END' SKIP.
          OUTPUT CLOSE.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
           FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date = TODAY AND tr_type = 'iss-so' AND tr_program = 'sosois.p' AND tr_nbr = b_shp_so AND tr_line = b_shp_line AND tr_site = b_co_site AND tr_loc = b_co_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ /*tr_part = b_co_part AND*/ tr_serial = ''  AND tr_qty_loc = (b_co_qty_cur * -1) AND tr_userid = g_user /*AND tr_time >= TIME - 20 AND tr_time <= TIME*/  NO-LOCK NO-ERROR.
         
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
               
               
               
               
               
               
               assign
              b_co_status = 'iss'
             .
         
        FIND FIRST b_ex_sod WHERE b_ex_so = b_shp_so AND b_ex_soln = string(b_shp_line) EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN
                 ASSIGN
                     
                    b_ex_issqty = b_ex_issqty + b_co_qty_cur
                     b_ex_all = b_ex_all - b_co_qty_cur.
           ELSE DO:
              FIND FIRST sod_det WHERE sod_nbr = b_shp_so AND sod_line = b_shp_line NO-LOCK NO-ERROR.
               CREATE b_ex_sod.
               ASSIGN
                   b_ex_so = bc_so_nbr
                   b_ex_soln = bc_so_line
                   b_ex_soqty = b_co_qty_req
                   b_ex_issqty = (IF AVAILABLE sod_det THEN sod_qty_ship ELSE 0) + b_co_qty_cur.
           END.
               
              
         {bctrcr.i
         &ord=b_shp_so
         &mline=b_shp_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=b_shp_shipper
         &b_qty_req=b_co_qty_req
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-so"'
          &mtime=TIME
           &b_loc=b_shp_loc
           &b_site=b_shp_site
           &b_usrid=g_user
           &b_addr=?}
           b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.
       b_shp_status = 'c'.
           END.
           ELSE MESSAGE b_shp_code ' 已发运或盘亏,或处于盘点状态!' VIEW-AS ALERT-BOX.
           {bcsodrelease.i}
    END.
       
           RELEASE b_shp_wkfl.
           {bcrelease.i}
       DISABLE bc_button WITH FRAME bc.
       ENABLE bc_so_nbr WITH FRAME bc.
  
     
END.



    {BCTRAIL.I}
