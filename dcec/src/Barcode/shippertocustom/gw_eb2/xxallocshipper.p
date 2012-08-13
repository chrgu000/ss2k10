{mfdtitle.i}
    DEF VAR mdate AS DATE LABEL "日期".
DEF VAR mdate1 AS DATE LABEL "至".
DEF VAR ISfirst AS logical.
DEF VAR iscal AS LOGICAL.
DEF VAR mprofit AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99" LABEL "毛利".
DEF VAR mcheckstr AS CHAR.
DEF VAR mprice AS DECIMAL.
DEF VAR mqty AS INT FORMAT "->>,>>>,>>>,>>9" LABEL "数量".
DEF VAR mamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" LABEL "销售额".
DEF VAR contract AS CHAR FORMAT "x(20)"  LABEL "原本合同号".
DEF VAR shipper LIKE ABS_id LABEL "货运单号".
DEF VAR xxid AS RECID.
DEF BUFFER absitem FOR ABS_mstr.
   DEF VAR pre_order LIKE ABS_order.
DEF VAR pre_line LIKE ABS_line.
DEF VAR pre_item LIKE ABS_item.
DEF VAR pre_cust LIKE ad_name.
DEF VAR cust LIKE cm_addr.
DEF VAR cust1 LIKE cm_addr.
DEF VAR nbr LIKE so_nbr.
DEF VAR nbr1 LIKE so_nbr.
FORM 
    SKIP(0.5)
   cust COLON 15 LABEL "客户"
    cust1 COLON 45 LABEL "至"
    SKIP(0.5)
    nbr COLON 15 LABEL "合同号"
    nbr1 COLON 45 LABEL "至"
   
    
   
    WITH FRAME a WIDTH 80 SIDE-LABELS THREE-D.
DEF FRAME out
    
    shipper COLON 12 
   ABS_mstr.ABS_shp_date COLUMN-LABEL "维护日期"
    /*contract */
    ad_name LABEL "客户"
WITH WIDTH 120 STREAM-IO DOWN.
DEF FRAME subout
    
    
    absitem.ABS_order LABEL "订单号" COLON 12
    absitem.ABS_line LABEL "行"
    absitem.ABS_item COLUMN-LABEL "零件号"
    mqty
   
    WITH WIDTH 130 STREAM-IO DOWN.
REPEAT:
    
   UPDATE cust cust1 nbr nbr1 WITH FRAME a.
  IF cust1 = '' THEN cust1 = hi_char.
  IF nbr1 = '' THEN nbr1 = hi_char.

     {mfselbpr.i "printer" 80} 
 
   {mfphead.i}
          isfirst = YES.
         mqty = 0.
        
          mcheckstr = ''.
         FOR EACH cm_mstr WHERE cm_addr >= cust AND cm_addr <= cust1 NO-LOCK:
          FOR EACH so_mstr WHERE so_cust = cm_addr AND so_nbr >= nbr AND so_nbr <= nbr1 NO-LOCK :
             FOR EACH sod_det WHERE sod_nbr = so_nbr NO-LOCK:
             
              FOR EACH absitem WHERE absitem.ABS_order = sod_nbr AND ABSitem.ABS_line = STRING(sod_line) AND absitem.abs_loc <> '8888' NO-LOCK BREAK BY ABSitem.ABS_par_id:
          
    
             IF LAST-OF(absitem.ABS_par_id) THEN DO:
            
   
                         
               FIND FIRST ABS_mstr WHERE abs_mstr.abs_par_id = '' AND ABS_mstr.ABS_id = absitem.ABS_par_id NO-LOCK NO-ERROR.
                  FIND FIRST ad_mstr WHERE ad_addr = so_cust NO-LOCK NO-ERROR.
              IF AVAILABLE ad_mstr THEN pre_cust = ad_name.
              ELSE pre_cust = ''.
                 DISP substr(ABS_mstr.ABS_id,2,50) @ shipper ad_name abs_mstr.ABS_shp_date WITH FRAME out. 

                  END.
         END.
                 
              END.
         END.
         END.
                 
             /*    
                 FOR EACH absitem WHERE absitem.ABS_par_id = abs_mstr.ABS_id  AND absitem.abs_loc = '8888' NO-LOCK BY absitem.ABS_order BY absitem.ABS_line:
                  IF NOT isFIRST AND (mcheckstr <>  absItem.ABS_order + absitem.ABS_line) THEN do:
                    
                     /* DISP pre_order @ absitem.ABS_order  pre_line @ absitem.abs_line pre_item @ absitem.ABS_item mqty  WITH FRAME subout. 
                */
                
                mamt = 0.
                mqty = 0.
                 END.
              
                  mqty = mqty + absitem.ABS_qty.
                  isfirst = NO.
               mcheckstr =  absitem.ABS_order + absitem.ABS_line.
              
                  pre_order = absitem.ABS_order.
                  pre_line = absitem.ABS_line.
                  pre_item = absitem.ABS_item.

                IF xxid = RECID(absitem) THEN do:
                    DISP absitem.ABS_order  absitem.abs_line absitem.ABS_item mqty  WITH FRAME subout. 
                
               
                 END.  
               END.
                
          END.*/
 {mftrl080.i} 
          
          END.
