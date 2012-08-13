{mfdtitle.i}
    DEF VAR m_year AS INT FORMAT "9999" LABEL "年".
    DEF VAR m_month AS INT FORMAT "99" LABEL "月".
DEF VAR ISfirst AS logical.
DEF VAR iscal AS LOGICAL.
DEF VAR mprofit AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99" LABEL "毛利".
DEF VAR mcheckstr AS CHAR.
DEF VAR mprice AS DECIMAL.
DEF VAR mqty AS INT FORMAT "->>,>>>,>>>,>>9" LABEL "数量".
DEF VAR mopamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" LABEL "选配成本".
DEF VAR mtotamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" .
DEF VAR mso LIKE so_nbr.
DEF VAR mso1 LIKE so_nbr.
DEF VAR part LIKE pt_part.
DEF VAR part1 LIKE pt_part.
DEF VAR XXID AS RECID.
DEF VAR mcst LIKE MTOTAMT.
DEF VAR pre_date LIKE ABS__qad08.
DEF VAR pre_order LIKE ABS_order.
DEF VAR pre_line LIKE ABS_line.
DEF VAR pre_item LIKE ABS_item.
DEF VAR madcst LIKE mtotamt.
DEF VAR isDISP AS LOGICAL .
DEF VAR m_tr_qty LIKE tr_qty_loc.


FORM 
     SKIP(0.5)
   m_year COLON 15 
    m_month COLON 45
    SKIP(0.5)
    part COLON 15 LABEL "零件号"
    part1 COLON 45 LABEL "至"
   
   
    WITH FRAME a WIDTH 80 SIDE-LABELS THREE-D.
DEF FRAME out
    
    
    ABS_order  COLON 12 LABEL "订单号"
    ABS_line LABEL "行"
    ABS_item LABEL "零件号"
     pt_prod_line LABEL "产品类"
   mopamt LABEL "成本"
    WITH WIDTH 150 STREAM-IO DOWN.
REPEAT:
   
    m_year = YEAR(TODAY).
    m_month = MONTH(TODAY).
    UPDATE m_year m_month WITH FRAME a.
    IF m_year = ? THEN do:
        MESSAGE "年不能为空" VIEW-AS ALERT-BOX BUTTON OK. 
                     undo,retry .
        end.
        IF m_month = ? OR m_month < 1 OR m_month > 12 THEN do:
        MESSAGE "无效月!" VIEW-AS ALERT-BOX BUTTON OK. 
                     undo,retry .
        end.
    UPDATE part part1 WITH FRAME a.
  

     {mfselbpr.i "printer" 80} 
 
   IF mso1 = '' THEN mso1 = hi_char.
   IF part1 = '' THEN part1 = hi_char.
   {mfphead.i}
          isfirst = YES.
          iscal = YES.
          mprofit = 0.
          mcheckstr = ''.
         mopamt = 0.
                mqty = 0.
                mtotamt = 0.
                isdisp = NO. 
                
            /*    FOR LAST ABS_mstr WHERE ABS_loc = '8888' AND SUBSTR(ABS__qad08,1,4) = string(m_year) AND SUBSTR(ABS__qaD08,5,2) = STRING(m_month,"99")  AND ABS_item >= part AND ABS_item <= part1  AND CAN-FIND(  FIRST pt_mstr WHERE pt_part = ABS_item AND pt_pm_code = 'c'  NO-LOCK )  NO-LOCK   BY ABS_order BY ABS_line:
                   

                     XXID = RECID(ABS_MSTR).
                    
                     END.*/

                    /* FOR LAST ABS_mstr WHERE ABS_loc = '8888' AND SUBSTR(ABS__qad08,1,4) = string(m_year) AND SUBSTR(ABS__qaD08,5,2) = STRING(m_month,"99")  AND ABS_item >= part AND ABS_item <= part1 
                         AND NOT CAN-FIND( FIRST  tr_hist WHERE tr_type = 'iss-so' AND tr_loc = '8888' AND tr_nbr = ABS_order AND string(tr_line) = ABS_line AND tr_ship_id = SUBSTR(ABS_par_id,2,50) AND tr_serial = abs_lot NO-LOCK ) AND
                         CAN-FIND(  FIRST pt_mstr WHERE pt_part = ABS_item AND pt_pm_code = 'c'  NO-LOCK ) 
                             NO-LOCK  BY ABS_item  BY ABS_order BY ABS_line:
                  

                     XXID = RECID(ABS_MSTR).
                      
                     END.*/
                FOR EACH ABS_mstr WHERE ABS_loc = '8888' AND SUBSTR(ABS__qad08,1,4) = string(m_year) AND SUBSTR(ABS__qaD08,5,2) = STRING(m_month,"99") AND ABS_item >= part AND ABS_item <= part1  AND CAN-FIND(  FIRST pt_mstr WHERE pt_part = ABS_item AND pt_pm_code = 'c'  NO-LOCK )  NO-LOCK  BREAK BY (trim(ABS_order) + trim(ABS_line)) :
                        
                  /*
                    IF NOT isFIRST AND (mcheckstr <>  ABS_order + ABS_line) THEN do:
                      
                   /*  m_tr_qty = 0.
                   FOR EACH tr_hist WHERE tr_type = 'iss-so' AND tr_loc = '8888' AND tr_nbr = pre_order AND string(tr_line) = pre_line   NO-LOCK:
                    m_tr_qty = m_tr_qty + tr_qty_loc.
                        END.
                      mopamt = mopamt - mcst * m_tr_qty.*/
                      mtotamt = mtotamt + mopamt. 
                   IF mopamt <> 0 THEN
                     FIND pt_mstr WHERE pt_part = pre_item NO-LOCK NO-ERROR.
                            DISP  pre_order @ ABS_order pre_line @ ABS_line pre_item @ ABS_item pt_prod_line mopamt WITH FRAME out.
              
                 iscal = YES.
               mopamt = 0.
                 END.*/
             IF iscal  THEN DO:  
                  

                                        mcst = 0.
                FIND FIRST wo_mstr WHERE wo_nbr = (ABS_order + '.' + ABS_line) AND wo_type = 'f' NO-LOCK NO-ERROR.
                IF AVAILABLE wo_mstr THEN DO:
               
                FOR EACH wod_det  WHERE wod_nbr = (ABS_order + '.' + ABS_line) NO-LOCK :
                
                  /*  FIND FIRST sob_det WHERE sob_nbr = ABS_order AND STRING(sob_line) = ABS_line AND sob_part = wod_part  AND (substring(sob_feature,13,1) = "o"
  or substring(sob_serial,15,1)  = "o") NO-LOCK NO-ERROR.
                 IF AVAILABLE sob_det THEN */

                   




                         mcst = mcst + wod_bom_amt * wod_bom_qty.

         /* ELSE   DO:

              FIND FIRST ibh_hist WHERE ibh_nbr = ABS_order AND STRING(ibh_line) = ABS_line AND ibh_part = wod_part AND  (substring(ibh_feature,13,1) = "o"
  or substring(ibh_serial,15,1)  = "o")   NO-LOCK NO-ERROR.
   IF AVAILABLE ibh_hist THEN 

                   





                         mcst = mcst + wod_bom_amt * wod_bom_qty.

          


               END.*/

                    
                    
                    
                    END.
                   /* FIND FIRST tr_hist WHERE tr_type = 'rct-tr' AND tr_loc = '8888' AND tr_nbr = ABS_order AND string(tr_line) = ABS_line AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.

                    madcst = tr_price.*/
                 END.   
             iscal = NO.  
               
               END.     
              mopamt = mopamt + (mcst * ABS_qty ).
                   
              
             
             
            
               
                  mcheckstr =  ABS_order + ABS_line.  
                  pre_order = ABS_order.
                  pre_line = ABS_line.
                  pre_item = ABS_item.
                  isfirst = NO.
                  
                
           /* IF xxid = RECID(ABS_mstr) THEN do:*/
                    
               IF LAST-OF(trim(ABS_order) + trim(ABS_line)) THEN DO:
               
               /*  m_tr_qty = 0.
                   FOR EACH tr_hist WHERE tr_type = 'iss-so' AND tr_loc = '8888' AND tr_nbr = ABS_order AND string(tr_line) = ABS_line   NO-LOCK:
                    m_tr_qty = m_tr_qty + tr_qty_loc.
                        END.
                      mopamt = mopamt - mcst * m_tr_qty.*/
                       mtotamt = mtotamt + mopamt.   
                   IF mopamt <> 0 THEN DO:
                   
            /*    PUT SKIP. */
               FIND pt_mstr WHERE pt_part = ABS_item NO-LOCK NO-ERROR.
                DISP  ABS_order ABS_line ABS_item pt_prod_line mopamt WITH FRAME out.
               
               END.
               iscal = YES.
               mopamt = 0.
                 END.
                  
                  
                  isdisp = YES.
                      END.
                  
   IF isdisp then DO: 
       put skip(1). 
  
PUT SPACE(48). put "合计". put space(2).
PUT '--------------'.

put skip.
PUT SPACE(50). 
PUT mtotamt. 
 END.
 {mftrl080.i} 
          
          END.
