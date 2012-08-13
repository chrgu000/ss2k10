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
DEF VAR bc_so_nbr AS CHAR FORMAT "x(8)"    LABEL "采购单".
DEF VAR bc_so_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_so_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "删除" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR qty_iss AS DECIMAL .
DEF VAR mid AS RECID.
DEF VAR bc_cust AS CHAR  FORMAT "x(8)" LABEL "客户".
DEF VAR bc_ship AS CHAR  FORMAT "x(18)" LABEL "发运单".
 
     
     DEFINE QUERY bc_qry FOR b_shp_wkfl.
         DEF VAR msite AS CHAR.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          b_shp_code COLUMN-LABEL "条码"
          b_shp_so COLUMN-LABEL "订单"
          b_shp_line COLUMN-LABEL "行"
          b_shp_part COLUMN-LABEL "零件号"
        b_shp_lot COLUMN-LABEL "批/序号"
         b_shp_qty COLUMN-LABEL "数量"
        b_shp_site COLUMN-LABEL "地点"
        b_shp_loc COLUMN-LABEL " 库位"
        
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  /*TITLE "待收货清单"*/.

DEF FRAME bc
   
    bc_ship AT ROW 1.2 COL 2.5
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
    WITH SIZE 30 BY 12 TITLE "销售发运单删除"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_ship 
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
ON enter OF bc_ship
DO:
    ASSIGN bc_ship.
    DISABLE bc_ship WITH FRAME bc.
    IF bc_ship <> '' THEN  DO:
   
   FIND FIRST b_shp_wkfl WHERE b_shp_shipper = bc_ship AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_shp_wkfl THEN DO:
   
      OPEN QUERY bc_qry FOR EACH b_shp_wkfl WHERE b_shp_shipper = bc_ship AND b_shp_status = '' NO-LOCK.
           FIND FIRST b_shp_wkfl WHERE b_shp_shipper = bc_ship AND b_shp_status = '' EXCLUSIVE-LOCK NO-ERROR.
          ENABLE bc_button WITH FRAME bc.

       END.
      ELSE DO:
    
          MESSAGE '该发运单不存在或已发运!' VIEW-AS ALERT-BOX.
          ENABLE bc_ship WITH FRAME bc.
          UNDO,RETRY.
      END.
    END.
    ELSE do:
          MESSAGE '发运单号不能为空!' VIEW-AS ALERT-BOX.
          ENABLE bc_ship WITH FRAME bc.
          UNDO,RETRY.
         END.
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
          DEF VAR oktocmt AS LOGICAL.
    MESSAGE '确认删除取消条码 ' b_shp_wkfl.b_shp_code ' 备料吗？' VIEW-AS ALERT-BOX
    QUESTION BUTTON YES-NO
        UPDATE oktocmt.
    IF oktocmt THEN do:
        
        bc_id = b_shp_wkfl.b_shp_code.
        RUN main.
    END.
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
   
   FIND FIRST b_co_mstr WHERE b_co_code = bc_id AND b_co_status = 'all' EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_co_mstr THEN DO:
  
   ASSIGN 
        b_co_cust = ''
        b_co_qty_req = 0
       b_co_due_date = ?
       b_co_ord = ''
       b_co_line = ''
       b_co_status = 'rct'.
    FIND FIRST b_shp_wkfl WHERE b_shp_shipper = bc_ship AND b_shp_status = '' AND b_shp_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_shp_wkfl THEN
          DELETE b_shp_wkfl.
   END.
   ELSE MESSAGE '该条码已解除！' VIEW-AS ALERT-BOX.
       
           RELEASE b_shp_wkfl.
           {bcrelease.i}
      
     
END.



    {BCTRAIL.I}
