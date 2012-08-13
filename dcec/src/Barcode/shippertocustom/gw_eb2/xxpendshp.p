{mfdtitle.i}
    DEF VAR mdate AS DATE LABEL "����".
DEF VAR mdate1 AS DATE LABEL "��".
DEF VAR ISfirst AS logical.
DEF VAR iscal AS LOGICAL.
DEF VAR mprofit AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99" LABEL "ë��".
DEF VAR mcheckstr AS CHAR.
DEF VAR mprice AS DECIMAL.
DEF VAR mqty AS INT FORMAT "->>,>>>,>>>,>>9" LABEL "����".
DEF VAR mamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" LABEL "���۶�".
DEF VAR contract AS CHAR FORMAT "x(20)"  LABEL "ԭ����ͬ��".
DEF VAR shipper LIKE ABS_id LABEL "���˵���".
DEF VAR xxid AS RECID.
DEF BUFFER absitem FOR ABS_mstr.
   DEF VAR pre_order LIKE ABS_order.
DEF VAR pre_line LIKE ABS_line.
DEF VAR pre_item LIKE ABS_item.
DEF VAR pre_cust LIKE ad_name.
FORM 
    SKIP(0.5)
   contract COLON 20 
   
    
   
    WITH FRAME a WIDTH 80 SIDE-LABELS THREE-D.
DEF FRAME out
    
    shipper COLON 12 
   
    contract 
    ad_name LABEL "�ͻ�"
WITH WIDTH 120 STREAM-IO DOWN.
DEF FRAME subout
    
    
    absitem.ABS_order LABEL "������" COLON 12
    absitem.ABS_line LABEL "��"
    absitem.ABS_item COLUMN-LABEL "�����"
    mqty
   
    WITH WIDTH 130 STREAM-IO DOWN.
REPEAT:
    
   UPDATE contract WITH FRAME a.
  

     {mfselbpr.i "printer" 80} 
 
   {mfphead.i}
          isfirst = YES.
         mqty = 0.
        
          mcheckstr = ''.
         FOR EACH ABS_mstr WHERE ABS__qad10 = contract  NO-LOCK BY ABS_id:
        
                          FIND FIRST absitem WHERE absitem.ABS_par_id = abs_mstr.ABS_id  AND absitem.abs_loc = '8888' NO-LOCK NO-ERROR.
                 IF AVAILABLE absitem THEN DO:
               
                 FIND FIRST so_mstr WHERE so_nbr = absitem.ABS_order NO-LOCK NO-ERROR.
              IF AVAILABLE so_mstr THEN 
                  FIND FIRST ad_mstr WHERE ad_addr = so_cust NO-LOCK NO-ERROR.
              IF AVAILABLE ad_mstr THEN pre_cust = ad_name.
              ELSE pre_cust = ''.
                 DISP substr(ABS_mstr.ABS_id,2,50) @ shipper contract ad_name WITH FRAME out. 

                 END.
                 
         END.
                 /*FOR EACH absitem WHERE absitem.ABS_par_id = abs_mstr.ABS_id  AND absitem.abs_loc = '8888' NO-LOCK BY absitem.ABS_order BY absitem.ABS_line:
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
