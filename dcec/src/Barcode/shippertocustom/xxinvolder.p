{mfdtitle.i}
    DEFINE VAR molder1 AS INT INITIAL "30".
  DEFINE VAR molder2 AS INT INITIAL "60".

  DEFINE VAR molder3 AS INT INITIAL "90".
  DEFINE VAR cust LIKE ABS_shipto.
  DEFINE VAR cust1 LIKE ABS_shipto.
  DEFINE BUFFER ABSmstr FOR ABS_mstr.
  define buffer absmstr2 for abs_mstr.
  DEFINE var miscontinue AS LOGICAL INITIAL YES.
    DEFINE var isrecord AS LOGICAL INITIAL NO.
 define var msocost like pt_xtot_std.
 define var totamt1 as decimal .
 define var totamt2 as decimal .
 define var totamt3 as decimal .
   DEFINE VAR ship_amt1 AS DECIMAL.
   DEFINE VAR ship_amt2 AS DECIMAL.
   DEFINE VAR ship_amt3 AS DECIMAL.
   DEFINE VAR OPEN_amt1 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
   DEFINE VAR open_amt2 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
   DEFINE VAR open_amt3 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
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
         
     
       
       define frame c
   
      ad_addr AT 15 NO-LABEL
                       ad_sort NO-LABEL
                      totamt1 NO-LABEL
                      totamt2 NO-LABEL
                       totamt3 NO-LABEL
                        with  WIDTH 132 stream-io NO-ATTR-SPACE down.
  
  
  
  REPEAT:
  
  
  UPDATE cust cust1 molder1 molder2 molder3 WITH FRAME a.
IF molder1 = ? THEN molder1 = 30.
IF molder2 = ? THEN molder2 = 60.
IF molder3 = ? THEN molder3 = 90.
IF cust1 = '' THEN cust1 = hi_char.
 
   {mfselbpr.i "printer" 80} 
            
             {mfphead.i}
  VIEW FRAME PHEAD1.
  
  PUT SPACE(15).
   PUT  "货物发往" .
   PUT space(1).
PUT "客户名称" .
PUT SPACE(24).
  PUT  molder1  . put space(10).
      PUT  molder2 . put space(10).

PUT molder3 .
PUT skip.
 PUT SPACE(15).
  PUT "--------". 
  PUT space(1).
  PUT "-------------------------------".
 put space(2).
  PUT "---------------" .
  PUT space(2).
 PUT  "----------------" .
 PUT space(2).
 PUT "----------------".

    /* VIEW FRAME PHEAD1.*/
  
                   FOR EACH ad_mstr WHERE ad_addr >= cust and ad_addr <= cust1 and (ad_type = 'ship-to' OR ad_type = 'customer') NO-LOCK :
  find first abs_mstr where ABS_mstr.ABS_shipto = ad_addr no-lock no-error.
  if available abs_mstr then do:
      totamt1 = 0.
                 totamt2 = 0.
                 totamt3 = 0.
                 ship_amt1 = 0.
                 ship_amt2 = 0.
                   ship_amt3 = 0.
                 FOR EACH so_mstr WHERE so_cust = ABS_mstr.ABS_shipto NO-LOCK:
                       for each sod_det where sod_nbr = so_nbr no-lock:
                    for LAST sct_det where sct_part = sod_part and sct_sim = 'standard' by sct_cst_date :
                   
                    
                          
                 
                    
                    
                     FOR EACH tr_hist WHERE tr_nbr = sod_nbr AND tr_loc = '8888' AND tr_type = 'iss-so'   AND (TODAY - tr_date) <= molder1 and tr_part = sod_part NO-LOCK:
          
         if tr_qty_chg = 0 then
              ship_amt1 = ship_amt1 +  tr_qty_loc * sct_cst_tot.
             else
              ship_amt1 = ship_amt1 +  tr_qty_chg * sct_cst_tot.

                
              
                     END.
          
           FOR EACH tr_hist WHERE tr_nbr = sod_nbr AND tr_loc = '8888' AND tr_type = 'iss-so'  AND (TODAY - tr_date) > molder1 AND (TODAY - tr_date) <= molder2 and tr_part = sod_part NO-LOCK:

          
                if tr_qty_chg = 0 then
              ship_amt1 = ship_amt1 +  tr_qty_loc * sct_cst_tot.
             else
              ship_amt1 = ship_amt1 +  tr_qty_chg * sct_cst_tot.

              
              
                     END.
          
           FOR EACH tr_hist WHERE tr_nbr = sod_nbr AND tr_loc = '8888' AND tr_type = 'iss-so'   AND (TODAY - tr_date) > molder2 AND (TODAY - tr_date) <= molder3 and tr_part = sod_part NO-LOCK:

          
              if tr_qty_chg = 0 then
              ship_amt1 = ship_amt1 +  tr_qty_loc * sct_cst_tot.
             else
              ship_amt1 = ship_amt1 +  tr_qty_chg * sct_cst_tot.

              
              
              
                     END.
         end.
          END.
            end.     
                 
                 
                 FOR EACH ABS_mstr WHERE ABS_mstr.ABS_shipto = ad_addr AND  
                      abs_mstr.ABS_par_id = '' AND (abs_mstr.abs_id BEGINS 'p' OR abs_mstr.abs_id BEGINS 's') /*AND ABS_MSTR.ABS_STATUS <> " y" AND ABS_mstr.ABS_status <> "yy" */  by abs_mstr.abs_shp_date  :
                  miscontinue = YES.
                 isrecord = NO.
                 
                 
                /*  IF ABS_status = ' y' or abs_status = 'yy' THEN DO:
                    for first ih_hist WHERE ih_bol = SUBSTRING(ABS_id,2,50) NO-LOCK:
                    
                   
                     miscontinue = NO.
                     
                     END.
                 end.*/
            FOR FIRST ABSmstr WHERE absmstr.abs_par_id <> "" AND  absmstr.ABS_par_id = abs_mstr.ABS_id AND absmstr.abs_order <> "" AND absmstr.abs_line <> "" NO-LOCK :
             isrecord = YES.    
              END.
               
                 IF miscontinue AND isrecord THEN DO:

                 
               
                 if page-size - line-counter < 2 then do:
                     page.
                 PUT SPACE(15).
   VIEW FRAME PHEAD1.
  PUT SPACE(15).
   PUT  "货物发往" .
   PUT space(1).
PUT "客户名称" .
PUT SPACE(24).
  PUT  molder1  . put space(10).
      PUT  molder2 . put space(10).

PUT molder3 .
PUT skip.
 PUT SPACE(15).
  PUT "--------". 
  PUT space(1).
  PUT "-------------------------------".
 put space(2).
  PUT "---------------" .
  PUT space(2).
 PUT  "----------------" .
 PUT space(2).
 PUT "----------------".

                 END.
                           

                
                 FOR EACH ABSmstr WHERE absmstr.abs_par_id <> "" AND   absmstr.ABS_par_id = abs_mstr.ABS_id AND absmstr.abs_order <> "" AND absmstr.abs_line <> "" AND absmstr.abs_loc = '8888'   NO-LOCK  :
                     
                     FIND FIRST sod_det WHERE sod_nbr = absmstr.ABS_order AND string(sod_line) = absmstr.ABS_line NO-LOCK NO-ERROR.
                     FIND FIRST pt_mstr WHERE absmstr.ABS_item = pt_part NO-LOCK NO-ERROR.
               
                      for LAST sct_det where sct_part = absmstr.ABS_item and sct_sim = 'standard' by sct_cst_date :
                   
                    msocost = sct_cst_tot * absmstr.ABS_qty .
                              
                   end.

                     IF TODAY - abs_mstr.ABS_shp_date <= molder1  THEN do:
                     /* msocost = pt_xtot_std * absmstr.ABS_qty.*/
                    totamt1 = totamt1 + msocost.
             
                    END.
                IF (TODAY - abs_mstr.ABS_shp_date) > molder1 AND (TODAY - abs_mstr.ABS_shp_date) <= molder2  THEN do:
          /* msocost = pt_xtot_std * absmstr.ABS_qty.*/
          totamt2 = totamt2 + msocost.
      END.

     IF (TODAY - abs_mstr.ABS_shp_date) > molder2 AND (TODAY - abs_mstr.ABS_shp_date) <= molder3  THEN do:
          /* msocost = pt_xtot_std * absmstr.ABS_qty.*/
          totamt3 = totamt3 + msocost.
      END.



                 END.
                 

                 
                 
                 END.

    
             


END.  
  
   open_amt1 = totamt1 + ship_amt1.
 OPEN_amt2 = totamt2 + ship_amt2.
 OPEN_amt3 = totamt3 + ship_amt3.
PUT SKIP.
    PUT SPACE(15.5).
      PUT  ad_addr. PUT SPACE(1).
                     PUT  ad_sort. put space(1).
              
                  put open_AMT1 .   
                      PUT open_amt2 . 
                      PUT open_amt3 .


end.
 end.
{mftrl080.i} 
 end.
