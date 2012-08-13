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
DEF VAR mso LIKE so_nbr.
DEF VAR mso1 LIKE so_nbr.
DEF VAR part LIKE pt_part.
DEF VAR part1 LIKE pt_part.
DEF VAR cost AS  DECIMAL FORMAT  "->>,>>>,>>>,>>9.99".
DEF VAR ITEM_desc AS CHAR FORMAT "x(48)".
DEF VAR subcost LIKE cost.
DEF VAR cmdate AS CHAR FORMAT "x(8)".
DEF VAR cmdate1 AS CHAR FORMAT "x(8)".
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
    
   SKIP(0.5)
    ABS_order LABEL "订单号" COLON 12
    ABS_line LABEL "行" COLON 35
    SKIP(0.5)
    ABS_item LABEL "零件号" COLON 12
    cost LABEL "成本" COLON 35
  SKIP(0.5)
   ITEM_desc COLON 12 LABEL "零件描述"
  
    WITH WIDTH 100 STREAM-IO SIDE-LABELS.
DEF FRAME subout
    
    wod_part COLON 12 LABEL "零件号"
    pt_desc1 LABEL "零件描述"
    subcost LABEL "成本" 
    WITH WIDTH 100 STREAM-IO DOWN.

DEF FRAME out1
    
   SKIP(0.5)
    ABS_order LABEL "订单号" COLON 12
    ABS_line LABEL "行" COLON 35
    SKIP(0.5)
    ABS_item LABEL "零件号" COLON 12
    cost LABEL "成本" COLON 35
  SKIP(0.5)
   ITEM_desc COLON 12 LABEL "零件描述"
  
    WITH WIDTH 100 STREAM-IO SIDE-LABELS.
DEF FRAME subout1
    
    wod_part COLON 12 LABEL "零件号"
    pt_desc1 LABEL "零件描述"
    subcost LABEL "成本" 
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
         mamt = 0.
                mqty = 0.
          
               
                FOR EACH sod_det WHERE sod_nbr >= mso AND sod_nbr <= mso1 AND sod_part >= part AND sod_part <= part1 NO-LOCK:
                
                FIND FIRST ABS_mstr WHERE ABS_loc = '8888' AND abs_order = sod_nbr AND abs_line = string(sod_line) AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1  NO-LOCK  NO-ERROR.
                FIND FIRST pt_mstr WHERE pt_part = ABS_item AND PT_pm_code = 'c' NO-LOCK NO-ERROR.
                
                 IF AVAILABLE pt_mstr THEN DO:
            
                cost = 0.
                FOR EACH wod_det WHERE wod_nbr = (ABS_order + '.' + abs_line)  NO-LOCK:
                  
                         cost = cost + wod_bom_amt * wod_bom_qty. 
                           
                          
                          
                         
             END. 
                DISP ABS_order ABS_line ABS_item cost (pt_desc1 + pt_desc2) @ item_desc WITH FRAME out.
                           FOR EACH wod_det WHERE wod_nbr = (ABS_order + '.' + abs_line)  NO-LOCK:
                  
                           FIND FIRST pt_mstr WHERE pt_part = ABS_item NO-LOCK NO-ERROR.
                           
                          
                          
                         DISP wod_part pt_desc1 wod_bom_amt @ subcost WITH FRAME subout.
                         IF pt_desc2 <> '' THEN DO:
                          DOWN 1.
                          PUT SPACE(35).
                          PUT pt_desc2.
                             END.
             END. 
              END.   
             END.
                
                
                FOR EACH idh_hist WHERE idh_nbr >= mso AND idh_nbr <= mso1 AND idh_part >= part AND idh_part <= part1 NO-LOCK:
                
                FIND FIRST ABS_mstr WHERE ABS_loc = '8888' AND abs_order = idh_nbr AND abs_line = string(idh_line) AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 NO-LOCK  NO-ERROR.
                    FIND FIRST pt_mstr WHERE pt_part = ABS_item AND PT_pm_code = 'c' NO-LOCK NO-ERROR.
                IF AVAILABLE pt_mstr THEN DO:               
                    DISP 'ok'. 
                    cost = 0.
                FOR EACH wod_det WHERE wod_nbr = (ABS_order + '.' + abs_line)  NO-LOCK:
                  
                         cost = cost + wod_bom_amt * wod_bom_qty. 
                           
                          
                          
                         
             END. 
                DISP ABS_order ABS_line ABS_item cost (pt_desc1 + pt_desc2) @ item_desc WITH FRAME out1.
                           FOR EACH wod_det WHERE wod_nbr = (ABS_order + '.' + abs_line)  NO-LOCK:
                  
                           FIND FIRST pt_mstr WHERE pt_part = ABS_item NO-LOCK NO-ERROR.
                           
                          
                          
                         DISP wod_part pt_desc1 wod_bom_amt @ subcost WITH FRAME subout1.
                         IF pt_desc2 <> '' THEN DO:
                          DOWN 1.
                          PUT SPACE(35).
                          PUT pt_desc2.
                             END.
             END. 
                END.
             END.
                 {mftrl080.i} 
               
END.
