{mfdeclre.i }
{bcdeclre.i }
    
    {bcwin09.i}
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
/*DEFINE BUTTON bc_button1 LABEL "确认" SIZE 8 BY 1.50.*/
DEFINE BUTTON bc_button LABEL "删除" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR qty_iss AS DECIMAL .
DEF VAR mid AS RECID.

DEF VAR bc_ship AS CHAR  FORMAT "x(18)" LABEL "发运单".
 DEF TEMP-TABLE shiplist_tmp 
     FIELD shiplist_sess LIKE g_sess
     FIELD ship_so_nbr LIKE so_nbr 
     FIELD ship_so_line LIKE sod_line 
     FIELD ship_so_part LIKE sod_part 
     FIELD ship_so_qty_open LIKE sod_qty_ord 
     FIELD ship_qty LIKE sod_qty_ord
    FIELD ship_site LIKE bc_site
     FIELD ship_loc LIKE bc_loc
     FIELD ship_code LIKE b_co_code
     FIELD ship_so_qty_req LIKE sod_qty_ord
     FIELD ship_so_qty_all LIKE sod_qty_ship
     FIELD ship_so_due_date LIKE sod_due_date
     FIELD ship_so_cust LIKE so_cust.
    
   DEF VAR iscontinue AS LOGICAL.
   
   /*  DEF TEMP-TABLE shipcode_tmp
         FIELD shipcode_sess LIKE g_sess
         FIELD shipcode_id LIKE b_co_code
         FIELD shipcode_so_nbr LIKE sod_nbr
         FIELD shipcode_so_line LIKE sod_line
         FIELD shipcode_part LIKE sod_part
         FIELD shipcode_qty LIKE b_co_qty_cur
         FIELD shipcode_site LIKE b_co_site
         FIELD shipcode_loc LIKE b_co_loc
         FIELD shipcode_so_due_date LIKE sod_due_date
         FIELD shipcode_so_qty_req LIKE sod_qty_ord
      FIELD shipcode_lot LIKE b_co_lot.*/
     DEFINE QUERY bc_qry FOR shiplist_tmp .
         DEF VAR msite AS CHAR.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          ship_so_nbr COLUMN-LABEL "销售订单"
   ship_so_line COLUMN-LABEL "行"
      /*  ship_code COLUMN-LABEL "条码"*/
        ship_so_part COLUMN-LABEL "零件号"
        ship_so_qty_open COLUMN-LABEL "待发量"
     ship_so_qty_all COLUMN-LABEL "备料量"
        
   
  
WITH NO-ROW-MARKERS SEPARATORS 3 DOWN WIDTH 29  /*TITLE "待收货清单"*/.
DEF QUERY shipcode_qry FOR b_shp_wkfl.
    DEF BROWSE shipcode_brw QUERY shipcode_qry
        DISP
           b_shp_code COLUMN-LABEL "条码"
          b_shp_so COLUMN-LABEL "订单"
          b_shp_line COLUMN-LABEL "行"
          b_shp_part COLUMN-LABEL "零件号"
         b_shp_qty COLUMN-LABEL "数量"
        b_shp_lot COLUMN-LABEL "批/序号"
         b_shp_site COLUMN-LABEL "地点"
        b_shp_loc COLUMN-LABEL "库位"
        WITH NO-ROW-MARKERS SEPARATORS 4 DOWN WIDTH 29 .
DEF FRAME bc
    bc_so_nbr AT ROW 1.2 COL 2.5
  /*  bc_ship AT ROW 2.4 COL 2.5*/
    bc_brw AT ROW 2.4 COL 1
   shipcode_brw AT  ROW 7.3 COL 1
    /*bc_so_part_desc  AT ROW 6 COL 1
    bc_so_part_desc1  NO-LABEL AT ROW 7 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
    
   /* bc_so_line AT ROW 9.7 COL 4*/
 bc_id AT ROW 13.8 COL 4
   
    /*bc_part AT ROW 12.1 COL 2.5
   
  
   bc_lot AT ROW 13.3 COL 1.6
   /* bc_so_nbr AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 14.5 COL 4 /*'EA' AT ROW 10.8 COL 22 */*/
   
   
  
   
    /*bc_button1 AT ROW 15 COL 8*/
    bc_button AT ROW 15 COL 10
    WITH SIZE 30 BY 17 TITLE "销售备料单维护"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

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
iscontinue = YES.
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
            

        DISABLE bc_so_nbr WITH FRAME bc.
  bc_ship = bc_so_nbr.
 
    FIND FIRST so_mstr WHERE so_nbr = bc_so_nbr  AND 
        can-find(FIRST sod_det WHERE sod_nbr = so_nbr AND (sod_qty_ord - sod_qty_ship) > 0 NO-LOCK) NO-LOCK NO-ERROR.
    IF AVAILABLE so_mstr THEN DO:
        FOR EACH so_mstr WHERE so_nbr = bc_so_nbr , 
            EACH sod_det WHERE sod_nbr = so_nbr AND (sod_qty_ord - sod_qty_ship) > 0 NO-LOCK:
            qty_iss = 0.
          /* ASSIGN bc_so_nbr = sod_nbr
                  bc_so_line = sod_line.
           {bcsodlock.i}*/
            /*FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_so = sod_nbr AND b_shp_line = sod_line AND b_shp_part = sod_part  NO-LOCK:
                qty_iss = qty_iss + b_shp_qty. 
            END.
            FOR EACH b_tr_hist WHERE b_tr_type = 'iss-so' AND b_tr_nbr = sod_nbr AND b_tr_line = sod_line AND b_tr_part = sod_part AND (b_tr_lot = '' OR b_tr_lot = ?) NO-LOCK:
                qty_iss = qty_iss + b_tr_qty_loc.
                END.*/
            FIND FIRST b_ex_sod WHERE b_ex_so = sod_nbr AND b_ex_soln = string(sod_line) EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN qty_iss = b_ex_issqty /*+ b_ex_all*/.
            ELSE qty_iss = 0.

            IF sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1) > qty_iss THEN DO:
              CREATE shiplist_tmp.
               ASSIGN 
                   shiplist_sess = g_sess
                   ship_so_nbr = sod_nbr
                   ship_so_line = sod_line
                   ship_so_part = sod_part
                   ship_so_qty_open = sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1) - (IF AVAILABLE b_ex_sod THEN qty_iss ELSE sod_qty_ship)
                   ship_so_qty_req = sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1)
                   ship_so_due_date = sod_due_date
                   ship_so_cust = so_cust
                   ship_so_qty_all = IF AVAILABLE b_ex_sod THEN b_ex_all ELSE 0.
 
            END.
         
        END.
        
      OPEN QUERY bc_qry FOR EACH shiplist_tmp  WHERE shiplist_sess = g_sess AND ship_so_qty_open <> 0.

    END.
    OPEN QUERY shipcode_qry FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_so_nbr AND b_shp_status = '' .
FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_so_nbr AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
ENABLE bc_brw shipcode_brw bc_id WITH FRAME bc.
IF AVAILABLE b_shp_wkfl THEN ENABLE bc_button WITH FRAME bc.
        END.
END.

/*ON CURSOR-DOWN OF bc_ship
DO:
    
       ASSIGN bc_ship.
       
    
END.

ON CURSOR-UP OF bc_ship
DO:
   
       ASSIGN bc_so_nbr.
       
   
END.*/
/*ON enter OF bc_ship
DO:
    RELEASE b_shp_wkfl.
    ASSIGN bc_ship.
   
    IF bc_ship = '' THEN do:
        iscontinue = NO.
        MESSAGE '货运单号不能为空!' VIEW-AS ALERT-BOX.
    END.
    IF NOT iscontinue THEN LEAVE.
    FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort  WHERE b_shp_shipper = bc_ship NO-LOCK NO-ERROR.
      IF AVAILABLE b_shp_wkfl THEN 
      
          IF b_shp_cust <> bc_so_nbr THEN do:
              iscontinue = NO.
              MESSAGE '该货运单不属于该客户!' VIEW-AS ALERT-BOX.
          END.

      
      
   IF NOT iscontinue THEN LEAVE.
    
       FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status  = 'c'  NO-LOCK NO-ERROR.
    IF  NOT AVAILABLE b_shp_wkfl THEN DO:
    FIND FIRST so_mstr WHERE so_nbr = bc_so_nbr  AND 
        can-find(FIRST sod_det WHERE sod_nbr = so_nbr AND (sod_qty_ord - sod_qty_ship) > 0 NO-LOCK) NO-LOCK NO-ERROR.
    IF AVAILABLE so_mstr THEN DO:
        FOR EACH so_mstr WHERE so_nbr = bc_so_nbr , 
            EACH sod_det WHERE sod_nbr = so_nbr AND (sod_qty_ord - sod_qty_ship) > 0 NO-LOCK:
            qty_iss = 0.
          /* ASSIGN bc_so_nbr = sod_nbr
                  bc_so_line = sod_line.
           {bcsodlock.i}*/
            /*FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_so = sod_nbr AND b_shp_line = sod_line AND b_shp_part = sod_part  NO-LOCK:
                qty_iss = qty_iss + b_shp_qty. 
            END.
            FOR EACH b_tr_hist WHERE b_tr_type = 'iss-so' AND b_tr_nbr = sod_nbr AND b_tr_line = sod_line AND b_tr_part = sod_part AND (b_tr_lot = '' OR b_tr_lot = ?) NO-LOCK:
                qty_iss = qty_iss + b_tr_qty_loc.
                END.*/
            FIND FIRST b_ex_sod WHERE b_ex_so = bc_so_nbr AND b_ex_soln = bc_so_line EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN qty_iss = b_ex_issqty + b_ex_all.
            ELSE qty_iss = 0.

            IF sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1) > qty_iss THEN DO:
              CREATE shiplist_tmp.
               ASSIGN 
                   shiplist_sess = g_sess
                   ship_so_nbr = sod_nbr
                   ship_so_line = sod_line
                   ship_so_part = sod_part
                   ship_so_qty_open = sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1) - qty_iss
                   ship_so_qty_req = sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1)
                   ship_so_due_date = sod_due_date
                   ship_so_cust = so_cust.
 
            END.
         
        END.
         DISABLE bc_ship WITH FRAME bc.
      OPEN QUERY bc_qry FOR EACH shiplist_tmp  WHERE shiplist_sess = g_sess AND ship_so_qty_open <> 0.
ENABLE bc_brw shipcode_brw bc_id WITH FRAME bc.
    END.
        ELSE do:
            MESSAGE '该客户没有待发的货!'  VIEW-AS ALERT-BOX.
            /*ENABLE bc_so_nbr WITH FRAME bc.
            UNDO,RETRY.*/
        END.
      END.
      ELSE DO:
          MESSAGE '该发运单已发货!' VIEW-AS ALERT-BOX.
          ENABLE bc_ship WITH FRAME bc.
          UNDO,RETRY.
      END.
    OPEN QUERY shipcode_qry FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' .
FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b_shp_wkfl THEN ENABLE bc_button WITH FRAME bc.
END.*/

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
           {bcrun.i ""bcmgcheck.p"" "(input ""so_all"" ,
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

          IF NOT success THEN DO:
         ASSIGN bc_id = ''.
              DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
          END.
      ELSE DO: 
          IF b_co_part <> shiplist_tmp.ship_so_part OR b_co_qty_cur > shiplist_tmp.ship_so_qty_open THEN DO:
              MESSAGE  b_co_code ' 零件不匹配，或超过待发量！' VIEW-AS ALERT-BOX.
              ASSIGN bc_id = ''.
              DISP bc_id WITH FRAME bc.
              UNDO,RETRY.
          END.
          ELSE RUN main.
              /*DISABLE bc_id WITH FRAME bc.*/
             
             /* IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_so_nbr = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_so_nbr*/ bc_qty WITH FRAME bc.
                  END.*/
             /* mid = RECID(shiplist_tmp).
              FIND FIRST shiplist_tmp WHERE ship_code = b_co_code NO-LOCK NO-ERROR.
              IF NOT AVAILABLE shiplist_tmp THEN DO:*/
              
            /*  FIND FIRST shiplist_tmp WHERE RECID(shiplist_tmp) = mid EXCLUSIVE-LOCK NO-ERROR.*/
               /*FIND FIRST shipcode_tmp WHERE shipcode_id = b_co_code NO-LOCK NO-ERROR.
               IF NOT AVAILABLE shipcode_tmp THEN DO:
                   CREATE shipcode_tmp.
                   ASSIGN
                       shipcode_id = b_co_code
                       shipcode_so_nbr = shiplist_tmp.ship_so_nbr
                       shipcode_so_line = shiplist_tmp.ship_so_line
                       shipcode_part = b_co_part
                       shipcode_qty = b_co_qty_cur
                       shipcode_so_qty_req = shiplist_tmp.ship_so_qty_req
                       shipcode_so_due_date = shiplist_tmp.ship_so_due_date
                       shipcode_lot = b_co_lot.*/
                    
            
               
               /*ELSE do:
                   MESSAGE b_co_code ' 该条码已存在!' VIEW-AS ALERT-BOX.
                   UNDO,RETRY.
                  END.*/
                  
                  
                  /*shiplist_tmp.ship_issch = issch*/
                  
             
           /*   OPEN QUERY bc_qry FOR EACH shiplist_tmp NO-LOCK.
                  OPEN QUERY shipcode_qry FOR EACH shipcode_tmp NO-LOCK.
               FIND FIRST shipcode_tmp  NO-LOCK NO-ERROR.
        IF AVAILABLE shipcode_tmp THEN
         
            ENABLE bc_button1 bc_button2 WITH FRAME bc.
             
              APPLY 'entry':u TO bc_id.*/
              
      END.
          
      
         
    END.

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
     /*ON 'choose':U OF bc_button
     DO:
         DISABLE bc_id WITH FRAME bc.
         RUN main.

     END.*/
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
/*    
ON 'choose':U OF bc_button1
DO:
   RUN main.
END.
*/
ON 'choose':U OF bc_button
DO:
    DEF VAR oktocmt AS LOGICAL.
    DEF VAR id AS CHAR.
    id = b_shp_wkfl.b_shp_code.
    MESSAGE '确认解除条码 ' b_shp_wkfl.b_shp_code ' 备料吗？' VIEW-AS ALERT-BOX
    QUESTION BUTTON YES-NO
        UPDATE oktocmt.
    IF oktocmt THEN do:
        FIND FIRST b_co_mstr WHERE b_co_code = b_shp_wkfl.b_shp_code EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE b_co_mstr THEN
           ASSIGN
           b_co_ord = ''
           b_co_line = ''
           b_co_qty_req = 0
           b_co_due_date = ?
           b_co_cust = ''
           b_co_status = 'rct'.

       FIND FIRST shiplist_tmp WHERE shiplist_sess = g_sess AND ship_so_nbr = b_shp_wkfl.b_shp_so AND ship_so_line = b_shp_wkfl.b_shp_line EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE shiplist_tmp THEN
       assign
                        /* shiplist_tmp.ship_so_qty_open = ship_so_qty_open + b_co_qty_cur*/
                         shiplist_tmp.ship_so_qty_all = ship_so_qty_all - b_co_qty_cur.
        FIND FIRST b_ex_sod WHERE b_ex_so = b_shp_wkfl.b_shp_so AND b_ex_soln = STRING(b_shp_wkfl.b_shp_line) EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN
                 ASSIGN
                b_ex_all = b_ex_all - b_co_qty_cur.
       FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' AND b_shp_code = id EXCLUSIVE-LOCK NO-ERROR.
IF  AVAILABLE b_shp_wkfl THEN
       DELETE b_shp_wkfl.
      OPEN QUERY shipcode_qry FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' .
          FIND FIRST b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_shp_wkfl THEN DISABLE bc_button WITH FRAME bc.
          OPEN QUERY bc_qry FOR EACH shiplist_tmp  WHERE shiplist_sess = g_sess AND ship_so_qty_open <> 0.

           END.


END.
 


PROCEDURE main:
  
    
   /* FOR EACH shiplist_tmp WHERE ship_code <> '' AND ship_qty <> 0 AND ship_site <> '' AND ship_loc <> '' EXCLUSIVE-LOCK:
   */
  


           
   FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_co_mstr THEN
           ASSIGN
           b_co_ord = shiplist_tmp.ship_so_nbr
           b_co_line = STRING(shiplist_tmp.ship_so_line)
           b_co_qty_req = shiplist_tmp.ship_so_qty_req
           b_co_due_date = shiplist_tmp.ship_so_due_date
           b_co_cust = shiplist_tmp.ship_so_cust
           b_co_status = 'all'.
          assign
                        /* shiplist_tmp.ship_so_qty_open = ship_so_qty_open - b_co_qty_cur*/
                         shiplist_tmp.ship_so_qty_all = ship_so_qty_all + b_co_qty_cur.
        /* FIND FIRST b_shp_wkfl WHERE b_shp_shipper = bc_ship AND b_shp_so = shipcode_so_nbr AND b_shp_line = shipcode_so_line AND b_shp_part = b_co_part AND b_shp_lot = b_co_lot AND b_shp_site  = shipcode_site AND b_shp_loc = shipcode_loc EXCLUSIVE-LOCK NO-ERROR.   
         IF AVAILABLE b_shp_wkfl THEN
              ASSIGN
               
             b_shp_qty = b_shp_qty + b_co_qty_cur.
             
             ELSE DO:*/
               
         CREATE b_shp_wkfl.
           ASSIGN
               b_shp_code = b_co_code
               b_shp_shipper = bc_ship
               b_shp_so = shiplist_tmp.ship_so_nbr
               b_shp_line = shiplist_tmp.ship_so_line
               b_shp_part = b_co_part
               b_shp_lot = b_co_lot
               b_shp_qty = b_co_qty_cur
               b_shp_cust = shiplist_tmp.ship_so_cust
               b_shp_site = b_co_site
               b_shp_loc = b_co_loc.
           
            FIND FIRST b_ex_sod WHERE b_ex_so = b_shp_so AND b_ex_soln = STRING(b_shp_line) EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN
                 ASSIGN
                b_ex_all = b_ex_all + b_co_qty_cur.
           ELSE DO:
               
               FIND FIRST sod_det WHERE sod_nbr = b_shp_so AND sod_line = b_shp_line NO-LOCK NO-ERROR.

               CREATE b_ex_sod.
               ASSIGN
                   b_ex_so = b_shp_so
                   b_ex_soln = string(b_shp_line)
                   b_ex_soqty = b_co_qty_req
                   b_ex_all = b_co_qty_cur
                   b_ex_issqty = IF AVAILABLE sod_det THEN sod_qty_ship ELSE 0.
           END.
              
   OPEN QUERY shipcode_qry FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bc_ship AND b_shp_status = '' .
       
 OPEN QUERY bc_qry FOR EACH shiplist_tmp  WHERE shiplist_sess = g_sess AND ship_so_qty_open <> 0.
     
          /* RELEASE b_shp_wkfl.*/
           {bcrelease.i}
       ASSIGN bc_id = ''.
           DISP bc_id WITH FRAME bc.
        ENABLE bc_id bc_button WITH FRAME bc.
        APPLY 'entry':u TO bc_id.
     
END.



    {BCTRAIL.I}
