{mfdtitle.i}
    DEFINE VAR molder1 AS INT INITIAL "30".
  DEFINE VAR molder2 AS INT INITIAL "60".

  DEFINE VAR molder3 AS INT INITIAL "90".
  DEFINE VAR cust LIKE ABS_shipto.
  DEFINE VAR cust1 LIKE ABS_shipto.
  
   DEFINE VAR OPEN_amt1 AS DECIMAL FORMAT "->>,>>>,>>9.99".
   DEFINE VAR open_amt2 AS DECIMAL FORMAT "->>,>>>,>>9.99".
   DEFINE VAR open_amt3 AS DECIMAL FORMAT "->>,>>>,>>9.99".
 FORM
    skip(0.5)
    cust COLON 12 label "销往"
      cust1 COLON 35 label  "至"
      SKIP(0.5)
    molder1 COLON 12 label "库龄1"
    molder2 COLON 35 label "库龄2"

    molder3 COLON 55 label "库龄3"

    WITH FRAME a THREE-D SIDE-LABEL.

   FORM HEADER
 SPACE(15) 
  
 "客户库龄报表"
 SKIP(2)

        WITH STREAM-IO /*GUI*/  frame phead1 
width 132 no-attr-space.
         
     
       
       DEFINE FRAME c
cm_addr colon 12 COLUMN-LABEL "销往"  SKIP(0.5)

  cm_SORT colon 12 COLUMN-LABEL "客户名称"
    WITH WIDTH 150 STREAM-IO SIDE-LABEL.
  
  
  
  REPEAT:
  
  
  UPDATE cust cust1 molder1 molder2 molder3 WITH FRAME a.
IF molder1 = ? THEN molder1 = 30.
IF molder2 = ? THEN molder2 = 60.
IF molder3 = ? THEN molder3 = 90.
IF cust1 = '' THEN cust1 = hi_char.
 
   {mfselbpr.i "printer" 80} 
            
             {mfphead.i}
  VIEW FRAME PHEAD1.
  
  

    /* VIEW FRAME PHEAD1.*/
  
                   FOR EACH cm_mstr WHERE cm_addr >= cust and cm_addr <= cust1 /*and (ad_type = 'ship-to' OR ad_type = 'customer' OR ad_type = 'dock')*/ NO-LOCK :
  /*find first abs_mstr where ABS_mstr.ABS_shipto = ad_addr no-lock no-error.*/
  /*if available abs_mstr then do:*/
      
             disp cm_addr cm_sort with frame c.
  PUT SKIP(1).                 
PUT SPACE(15).
   PUT  "零件号" .
   PUT space(12).
PUT "序号" .
PUT SPACE(14).
  PUT  molder1  . put space(10).
      PUT  molder2 . put space(10).

PUT molder3 .
PUT skip.
 PUT SPACE(15).
  PUT "----------------". 
  PUT space(1).
  PUT "----------------".
 put space(2).
  PUT "----------------" .
  PUT space(2).
 PUT  "----------------" .
 PUT space(2).
 PUT "----------------".
                 FOR EACH so_mstr WHERE so_cust = cm_addr NO-LOCK:
               
                 FOR EACH ABS_mstr WHERE ABS_loc = '8888' AND ABS_order = so_nbr  NO-LOCK  BY ABS_order BY ABS_line :
                     OPEN_amt1 = 0.
                     OPEN_amt2 = 0.
                     OPEN_amt3 = 0.
                     FIND FIRST tr_hist WHERE tr_type = 'iss-so' AND tr_serial = ABS_lot AND tr_nbr = ABS_order AND string(tr_line) = ABS_line  AND tr_ship_id = SUBSTR(abs_par_id,2,50) NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE tr_hist THEN DO:
                     FIND FIRST sod_det WHERE sod_nbr = abs_order AND string(sod_line) = ABS_line NO-LOCK NO-ERROR.
                     FIND FIRST tr_hist WHERE tr_type = 'rct-tr' AND tr_loc = '8888' AND tr_serial = ABS_lot AND tr_nbr = ABS_order AND string(tr_line) = ABS_line  AND tr_ship_id = SUBSTR(abs_par_id,2,50) NO-LOCK NO-ERROR.
                  IF AVAILABLE tr_hist THEN DO:
                
                     IF (TODAY - tr_date) <= molder1 THEN    OPEN_amt1 = sod_price * ABS_qty. 

                               IF (TODAY - tr_date) > molder1 AND (TODAY - tr_date) <= molder2 THEN   OPEN_amt2 = sod_price * ABS_qty .  
                        IF  (TODAY - tr_date) > molder2 AND (TODAY - tr_date) <= molder3 THEN   OPEN_amt3 = sod_price * ABS_qty. 
                      PUT SKIP.
      PUT SPACE(15).
        PUT  ABS_item. 
                       PUT  ABS_lot. PUT SPACE(1).

                   PUT OPEN_amt1. PUT SPACE(3.5).
                        PUT open_amt2 .  PUT SPACE(3.5).
                        PUT open_amt3 .

                      
                      END.
                  END.
              END.
                   
                 END.
                   END.
                 
                    
                    
                   
{mftrl080.i} 
 end.
