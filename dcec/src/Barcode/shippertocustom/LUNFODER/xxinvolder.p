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
 define var totqty1 as decimal .
 define var totqty2 as decimal .
 define var totqty3 as decimal .
  
   DEFINE VAR OPENamt1 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
   DEFINE VAR openamt2 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
   DEFINE VAR openamt3 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
  DEF TEMP-TABLE trno_tmp
      FIELD trno LIKE tr_trnbr.
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
                      totqty1 NO-LABEL
                      totqty2 NO-LABEL
                       totqty3 NO-LABEL
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
  
                   FOR EACH cm_mstr WHERE cm_addr >= cust and cm_addr <= cust1 /*and (ad_type = 'ship-to' OR ad_type = 'customer' OR ad_type = 'dock')*/ NO-LOCK :
  /*find first abs_mstr where ABS_mstr.ABS_shipto = ad_addr no-lock no-error.*/
  /*if available abs_mstr then do:*/
              openamt1 = 0.
              openamt2 = 0.
              openamt3 = 0.
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
                 FOR EACH so_mstr WHERE so_cust = cm_addr NO-LOCK:
                       for each sod_det where sod_nbr = so_nbr no-lock:
                           
                              
                           totqty1 = 0.
                 totqty2 = 0.
                 totqty3 = 0.
         
            
                
                 
                /* FOR EACH ABS_mstr WHERE ABS_mstr.ABS_shipto = ad_addr AND  
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
              END.*/
               
                /* IF miscontinue AND isrecord THEN DO:*/

                 
               
             
                           


FOR EACH ABSmstr WHERE ABSmstr.ABS_par_id <> ""  AND absmstr.abs_ord = sod_nbr AND absmstr.abs_line = string(sod_line) AND ABSmstr.ABS_item = sod_part AND absmstr.abs_loc = '8888' NO-LOCK:

                   FIND FIRST abs_mstr WHERE abs_mstr.abs_par_id = '' and abs_mstr.abs_id = absmstr.ABS_par_id NO-LOCK NO-ERROR .
                     
                     FIND FIRST pt_mstr WHERE absmstr.ABS_item = pt_part NO-LOCK NO-ERROR.
               
                    

                   
                     IF TODAY - abs_mstr.ABS_shp_date <= molder1  THEN do:
                     /* msocost = pt_xtot_std * absmstr.ABS_qty.*/
                    totqty1 = totqty1 + absmstr.ABS_qty.
                    END.
                IF (TODAY - abs_mstr.ABS_shp_date) > molder1 AND (TODAY - abs_mstr.ABS_shp_date) <= molder2  THEN do:
          /* msocost = pt_xtot_std * absmstr.ABS_qty.*/
         totqty2 = totqty2 +  absmstr.ABS_qty.
      END.

     IF (TODAY - abs_mstr.ABS_shp_date) > molder2 AND (TODAY - abs_mstr.ABS_shp_date) <= molder3  THEN do:
          /* msocost = pt_xtot_std * absmstr.ABS_qty.*/
         totqty3 = totqty3 + absmstr.ABS_qty.
      END.
      
         END.


               
     
      FOR EACH trno_tmp:
          DELETE trno_tmp.
      END.
      For LAST sct_det where sct_part = sod_part and sct_sim = 'standard' AND (sct_site = '1000' OR sct_site = '9000') no-lock  by sct_cst_date  :


      FOR EACH tr_hist WHERE tr_type = 'iss-so' AND tr_loc = '8888' AND tr_nbr = sod_nbr  AND tr_line = sod_line AND tr_part = sod_part and tr_qty_loc < 0 NO-LOCK BY tr_date  BY ABS(tr_qty_loc) :
         
            FIND FIRST trno_tmp WHERE trno = tr_trnbr  NO-LOCK NO-ERROR.
            IF NOT AVAILABLE trno_tmp THEN DO:
            
         IF totqty3 <> 0  THEN  
          IF ABS(tr_qty_loc) <= totqty3 THEN DO:
           totqty3 = totqty3 - ABS(tr_qty_loc).
           CREATE trno_tmp.   
           trno = tr_trnbr.
              END.
            
             
          
          
          
          IF totqty3 = 0 THEN LEAVE.
             
             
             
             
             
             END.
            END.
   
     IF totqty3 <> 0 THEN openamt3 = openamt3 + totqty3 * sct_cst_tot.

 FOR EACH tr_hist WHERE tr_type = 'iss-so' AND tr_loc = '8888' AND tr_nbr = sod_nbr  AND tr_line = sod_line AND tr_part = sod_part and tr_qty_loc < 0 NO-LOCK BY tr_date  BY ABS(tr_qty_loc) :
              
            FIND FIRST trno_tmp WHERE trno = tr_trnbr  NO-LOCK NO-ERROR.
            IF NOT AVAILABLE trno_tmp THEN DO:
            
         IF totqty2 <> 0  THEN  
          IF ABS(tr_qty_loc) <= totqty2 THEN DO:
           totqty2 = totqty2 - ABS(tr_qty_loc).
           CREATE trno_tmp.   
           trno = tr_trnbr.
              END.
            
             
          
          
          
          IF totqty2 = 0 THEN LEAVE.
             
             
             
             
             
             END.
            END.
         
             IF totqty2 <> 0 THEN openamt2 = openamt2 + totqty2 * sct_cst_tot.
            
            
            
            FOR EACH tr_hist WHERE tr_type = 'iss-so' AND tr_loc = '8888' AND tr_nbr = sod_nbr  AND tr_line = sod_line AND tr_part = sod_part and tr_qty_loc < 0 NO-LOCK BY tr_date  BY ABS(tr_qty_loc) :
       
            FIND FIRST trno_tmp WHERE trno = tr_trnbr  NO-LOCK NO-ERROR.
            IF NOT AVAILABLE trno_tmp THEN DO:
            
         IF totqty1 <> 0  THEN  
          IF ABS(tr_qty_loc) <= totqty1 THEN DO:
           totqty1 = totqty1 - ABS(tr_qty_loc).
           CREATE trno_tmp.   
           trno = tr_trnbr.
              END.
            
             
          
          
          
          IF totqty1 = 0 THEN LEAVE.
             
             
             
             
             
             END.
            END.
         
             IF totqty1 <> 0 THEN openamt1 = openamt1 + totqty1 * sct_cst_tot.
            
              end.   
                 
            
                  





                 

                 END.
                END.

    
             


/*END.*/  
  
  
PUT SKIP.
    PUT SPACE(15.5).
      PUT  cm_addr. PUT SPACE(1).
                     PUT  cm_sort. put space(1).
              
                  put openAMT1 .   
                      PUT openamt2 . 
                      PUT openamt3 .


/*end.*/
 end.
{mftrl080.i} 
 end.
