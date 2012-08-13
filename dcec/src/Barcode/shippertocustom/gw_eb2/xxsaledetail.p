{mfdtitle.i}
    DEF VAR mdate AS DATE LABEL "日期".
DEF VAR mdate1 AS DATE LABEL "至".
DEF VAR ISfirst AS logical.
DEF VAR iscal AS LOGICAL.
DEF VAR mprofit AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99" LABEL "毛利".
DEF VAR mcheckstr AS CHAR.
DEF VAR mprice AS DECIMAL.
DEF VAR msubprice AS DECIMAL.
DEF VAR mqty AS INT FORMAT "->>,>>>,>>>,>>9" LABEL "数量".
DEF VAR msubprofit AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" LABEL "毛利".
DEF VAR mamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" LABEL "销售额".
DEF VAR msubqty AS INT FORMAT "->>,>>>,>>>,>>9" LABEL "数量".
DEF VAR msubamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" LABEL "销售额".
DEF VAR mso LIKE so_nbr.
DEF VAR mso1 LIKE so_nbr.
DEF VAR part LIKE pt_part.
DEF VAR part1 LIKE pt_part.
DEF VAR cmdate AS CHAR FORMAT "x(8)".
DEF VAR cmdate1 AS CHAR FORMAT "x(8)".
DEF VAR XXID AS RECID.
DEF VAR MCST LIKE MAMT.
DEF VAR pre_date LIKE ABS__qad08.
DEF VAR pre_order LIKE ABS_order.
DEF VAR pre_line LIKE ABS_line.
DEF VAR pre_item LIKE ABS_item.
FORM 
     SKIP(0.5)
    mso COLON 15  LABEL "订单号" 
    mso1 COLON 45 LABEL "至"
    SKIP(0.5)
    part COLON 15 LABEL "零件号"
    part1 COLON 45 LABEL "至"
    SKIP(0.5)
    mdate COLON 15
    mdate1 COLON 45
   
    WITH FRAME a WIDTH 80 SIDE-LABELS THREE-D.
DEF FRAME out
     SKIP(1)
    ABS__qad08 COLON 12 LABEL "日期"
    SKIP(1)
    ABS_order  COLON 12 LABEL "订单号"
    ABS_line   COLON 40 LABEL "行"
    SKIP(1)
    ABS_item COLON 12 LABEL "零件号"
  
    mqty COLON 40
    mamt COLON 65
    mprofit COLON 90
    WITH WIDTH 130 STREAM-IO SIDE-LABELS.
DEF FRAME subout
    
    wod_part COLON 12 LABEL "零件号"
    msubqty
    msubamt
    
    
    msubprofit
    WITH WIDTH 100 STREAM-IO DOWN.
DEF FRAME out1
     SKIP(1)
    ABS__qad08 COLON 12 LABEL "日期"
    SKIP(1)
    ABS_order  COLON 12 LABEL "订单号"
    ABS_line   COLON 40 LABEL "行"
    SKIP(1)
    ABS_item COLON 12 LABEL "零件号"
  
    mqty COLON 40
    mamt COLON 65
    mprofit COLON 90
    WITH WIDTH 130 STREAM-IO SIDE-LABELS.
DEF FRAME subout1
    
    wod_part COLON 12 LABEL "零件号"
    msubqty
    msubamt
    
    
    msubprofit
    WITH WIDTH 100 STREAM-IO DOWN.
REPEAT:
    IF mdate = low_date THEN mdate = ?.
    IF mdate1 = hi_date THEN mdate1 = ?.
   UPDATE mdate mdate1 part part1 mso mso1 WITH FRAME a.
  

     {mfselbpr.i "printer" 80} 
 IF mdate = ? THEN mdate = low_date.
   IF mdate1 = ? THEN mdate1 = hi_date.
     IF mso1 = '' THEN mso1 = hi_char.
   IF part1 = '' THEN part1 = hi_char.   
   cmdate = string(YEAR(mdate)) + string(MONTH(mdate)) + string(DAY(mdate)).
     cmdate1 = string(YEAR(mdate1)) + string(MONTH(mdate1)) + string(DAY(mdate1)).
   {mfphead.i}
          isfirst = YES.
          iscal = YES.
          mprofit = 0.
          mcheckstr = ''.
        mqty = 0.
        mamt = 0.
            FOR LAST ABS_mstr WHERE ABS_loc = '8888' AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 AND ABS_order >= mso AND ABS_order <= mso1 AND ABS_item >= part AND ABS_item <= part1  NO-LOCK BY ABS__qad08 BY ABS_order BY ABS_line :
               XXID = RECID(ABS_MSTR).
                END.
        FOR EACH ABS_mstr WHERE ABS_loc = '8888' AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 AND ABS_order >= mso AND ABS_order <= mso1 AND ABS_item >= part AND ABS_item <= part1  NO-LOCK BY ABS__qad08 BY ABS_order BY ABS_line :
             IF NOT isFIRST AND (mcheckstr <> ABS__qad08 + ABS_order + ABS_line) THEN do:
                    DISP  pre_date @ ABS__qad08  pre_order @ ABS_order pre_line @ ABS_line pre_item @ ABS_item mqty mamt mprofit WITH FRAME out.
                 
                    
                    FOR EACH wod_det WHERE wod_nbr = (pre_order + '.' + pre_line)  NO-LOCK:
                        FIND FIRST sob_det WHERE sob_nbr = pre_order AND STRING(sob_line) = pre_line AND sob_part = wod_part NO-LOCK NO-ERROR.
                        IF AVAILABLE sob_det THEN msubprice = sob_price.
                          ELSE DO:
                         
                        FIND FIRST ibh_hist WHERE ibh_nbr = pre_order AND STRING(ibh_line) = pre_line AND ibh_part = wod_part NO-LOCK NO-ERROR.
                        msubprice = ibh_price. 
                        END.  
                         DISP   wod_part wod_bom_qty * mqty @ msubqty msubprice * wod_bom_qty * mqty @ msubamt (msubprice * wod_bom_qty * mqty - wod_bom_amt * wod_bom_qty * mqty) @ msubprofit WITH FRAME subout.
                           
                          
                          
                         
                      
             END. 

                    
                    
                    
                    mprofit = 0.
                 iscal = YES.
                mqty = 0.
                mamt = 0.
                 END.
             IF iscal  THEN DO:  
                  FIND FIRST tr_hist WHERE tr_type = 'iss-so' AND tr_nbr = ABS_order AND STRING(tr_line) = ABS_line AND tr_loc = '8888' AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.
                             IF AVAILABLE tr_hist THEN mprice = tr_price. 
                             ELSE DO:
                             FIND FIRST sod_det WHERE sod_nbr = ABS_order AND string(sod_line) = abs_line NO-LOCK NO-ERROR.
                    IF AVAILABLE sod_det THEN mprice = sod_price.
                    
                    
                       
                        
                        
                        END.
                 
                 

                                        mcst = 0.
                
                
              
               /* FIND FIRST tr_hist WHERE tr_type = 'rct-tr' AND tr_loc = '8888' AND tr_nbr = ABS_order AND string(tr_line) = ABS_line AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.
                          IF AVAILABLE tr_hist THEN mcst = tr_price.*/
                                         

                
                 FOR EACH wod_det  WHERE wod_nbr = (ABS_order + '.' + ABS_line) NO-LOCK :
                
                   /* FIND FIRST sob_det WHERE sob_nbr = ABS_order AND STRING(sob_line) = ABS_line AND sob_part = wod_part  /*AND (substring(sob_feature,13,1) = "o"
  or substring(sob_serial,15,1)  = "o") */ NO-LOCK NO-ERROR.
                 IF AVAILABLE sob_det THEN */

                   




                         mcst = mcst + wod_bom_amt * wod_bom_qty.

         /* ELSE   DO:

              FIND FIRST ibh_hist WHERE ibh_nbr = ABS_order AND STRING(ibh_line) = ABS_line AND ibh_part = wod_part AND  (substring(ibh_feature,13,1) = "o"
  or substring(ibh_serial,15,1)  = "o")   NO-LOCK NO-ERROR.
   IF AVAILABLE ibh_hist THEN 

                   





                         mcst = mcst + wod_bom_amt * wod_bom_qty.

          


               END.*/

                    
                    
                    
                    END.
              
            
             iscal = NO.    
               END.     
               mprofit = mprofit + (mprice * ABS_qty - mcst * ABS_qty).
                   mamt = mamt + mprice * ABS_qty.
                   
         
             mqty = mqty + ABS_qty.
             
                
               
                  mcheckstr = ABS__qad08 + ABS_order + ABS_line.  
                  pre_date = ABS__qad08.
                  pre_order = ABS_order.
                  pre_line = ABS_line.
                  pre_item = ABS_item.
                  isfirst = NO.
            
                IF RECID(ABS_MSTR) = XXID THEN do:
                   DISP  ABS__qad08 ABS_order ABS_line ABS_item mqty mamt mprofit WITH FRAME out1.


                   FOR EACH wod_det WHERE wod_nbr = (ABS_order + '.' + abs_line)  NO-LOCK:
                       FIND FIRST sob_det WHERE sob_nbr = ABS_order AND STRING(sob_line) = ABS_line AND sob_part = wod_part NO-LOCK NO-ERROR.
                       IF AVAILABLE sob_det THEN msubprice = sob_price.
                         ELSE DO:

                       FIND FIRST ibh_hist WHERE ibh_nbr = abs_order AND STRING(ibh_line) = abs_line AND ibh_part = wod_part NO-LOCK NO-ERROR.
                       msubprice = ibh_price. 
                       END.  
                        DISP  wod_part wod_bom_qty * mqty @ msubqty msubprice * wod_bom_qty * mqty @ msubamt (msubprice * wod_bom_qty * mqty - wod_bom_amt * wod_bom_qty * mqty) @ msubprofit WITH FRAME subout1.





            END. 

             mprofit = 0.
                 iscal = YES.
                mqty = 0.
                mamt = 0.
                  END.
                  
                  
                  END.

           
          {mftrl080.i} 
          END.
