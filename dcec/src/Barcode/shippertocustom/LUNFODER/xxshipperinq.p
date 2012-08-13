{mfdtitle.i}
DEFINE VAR shipto LIKE ABS_shipto.
DEFINE VAR shipto1 LIKE ABS_shipto.
 define var itemdesc LIKE PT_DESC1.
define var mshipper like abs_id.
define var mamount like sod_price.
define var msocost like pt_xtot_std.
DEFINE VAR shipdate AS DATE.
DEFINE VAR shipdate1 AS DATE.
DEFINE VAR part LIKE pt_part.
DEFINE VAR part1 LIKE pt_part.
DEFINE VAR mold AS INT INITIAL "0".
DEFINE var mref LIKE ABS__qad01 FORMAT "x(20)".
DEFINE VAR ship_qty AS INT.
DEFINE BUFFER absmstr FOR ABS_mstr.
    DEFINE var miscontinue AS LOGICAL INITIAL YES.
    DEFINE var isrecord AS LOGICAL INITIAL NO.
    FORM 
    SKIP(1)
    shipto COLON 12 LABEL "货物发往"
    shipto1 COLON 35 LABEL "至"
          SKIP(0.5)
        part COLON 12 LABEL "零件号"
        part1 COLON 35 LABEL "至"
        SKIP(0.5)
        shipdate COLON 12 LABEL "发运日期"
        shipdate1 COLON 35 LABEL "至"
      
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.


 DEFINE FRAME c
      abs_mstr.ABS_shipto COLUMN-LABEL "货物发往"
     ad_sort COLUMN-LABEL "客户名称"
     mshipper COLUMN-LABEL "货运单号"
    mref COLUMN-LABEL "参考号" 
     sod_nbr   column-LABEL "订单号"
     sod_line COLUMN-LABEL "行号"
     /* mold COLUMN-LABEL "库存账龄"  */
     ABS_mstr.ABS_shp_date  COLUMN-LABEL "发运日期"
      ABSmstr.ABS_item  COLUMN-LABEL "零件号"
      pt_desc1  COLUMN-LABEL "零件描述" 
     ABSmstr.ABS_lotser  COLUMN-LABEL "批/序号"
      ship_qty  COLUMN-LABEL "数量"

     /* mamount   COLUMN-LABEL "订单金额" */
     msocost  COLUMN-LABEL "销售成本"
     
    /* PT_DESC2  NO-LABEL*/ 
     WITH WIDTH 210  stream-io  down  .


 
REPEAT:
    do with frame a:
            shipdate = ?.
            shipdate1 = ?.
        set shipto shipto1 editing:
               IF FRAME-FIELD = "shipto" THEN DO:
              
                    {mfnp05.i abs_mstr abs_id
                        "abs_id begins 's' or abs_id begins 'p'"
                         abs_shipto
                        "input shipto"}
                IF recno <> ? THEN do:
               shipto = abs_shipto.
               
                DISPLAY shipto WITH FRAME a.
                
                
                 end.
                    
                    
                    END.
                  IF FRAME-FIELD = "shipto1" THEN DO:
                  
                      
                     {mfnp05.i abs_mstr abs_id
                        "abs_id begins 's' or abs_id begins 'p'"
                         abs_shipto
                        "input shipto1"}
                IF recno <> ? THEN do:
              
              shipto1 = abs_shipto.
                DISPLAY shipto1 WITH FRAME a.
                      
                      end.
                      END.



                   END.
                    set part part1 editing:
               IF FRAME-FIELD = "part" THEN DO:
              
                    {mfnp.i pt_mstr part pt_part part pt_part pt_part}
                       
                IF recno <> ? THEN do:
               part = pt_part.
               
                DISPLAY part WITH FRAME a.
                
                
                 end.
                    
                    
                    END.
                  IF FRAME-FIELD = "part1" THEN DO:
                  
                     {mfnp.i pt_mstr part1 pt_part part1 pt_part pt_part}
                IF recno <> ? THEN do:
              
              part1 = pt_part.
                DISPLAY part1 WITH FRAME a.
                      
                      end.
                      END.



                   END.
               UPDATE shipdate shipdate1 WITH FRAME a.
                END.
             
  IF part1 = "" THEN part1 = hi_char.
             IF shipto1 = "" THEN shipto1 = hi_char.
             IF shipdate = ? THEN shipdate = low_date.
             IF shipdate1 = ? THEN shipdate1 = hi_date.
        /* display shipdate shipdate1.*/
          {mfselbpr.i "printer" 80} 
            
             {mfphead.i}
            
                  mainloop:
                  
                  FOR EACH ABS_mstr WHERE abs_mstr.ABS_shipto >= shipto AND abs_mstr.ABS_shipto <= shipto1 and abs_mstr.abs_shp_date >= shipdate and abs_mstr.abs_shp_date <= shipdate1 
                      AND abs_mstr.ABS_par_id = '' AND (abs_mstr.abs_id BEGINS 'p' OR abs_mstr.abs_id BEGINS 's') AND ABS_MSTR.ABS_STATUS <> " y" AND ABS_mstr.ABS_status <> "yy" NO-LOCK  :
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

                 
               
                 if page-size - line-counter < 2 then page.
                 FIND FIRST ad_mstr WHERE ad_addr = abs_mstr.ABS_shipto /*AND (ad_type = 'ship-to' OR ad_type = 'customer' OR ad_type = 'dock')*/ NO-LOCK NO-ERROR.
                 PUT SKIP.
                 PUT SKIP.
                mshipper = SUBSTRING(abs_mstr.ABS_id,2,50).
                 /*DISPLAY  abs_mstr.ABS_shipto ad_sort mshipper WITH FRAME b.*/
                

                 
                 FOR EACH ABSmstr WHERE absmstr.abs_par_id <> "" AND  absmstr.abs_item >= part AND absmstr.abs_ITEM <= part1 AND   absmstr.ABS_par_id = abs_mstr.ABS_id AND absmstr.abs_order <> "" AND absmstr.abs_line <> "" AND absmstr.abs_loc = '8888'  NO-LOCK  :
                     
                    /* FIND FIRST sod_det WHERE sod_nbr = absmstr.ABS_order AND string(sod_line) = absmstr.ABS_line NO-LOCK NO-ERROR.
                       IF AVAILABLE sod_det THEN mprice = sod_price.
                     IF NOT AVAILABLE sod_det THEN 
                           FIND FIRST idh_hist WHERE idh_nbr = absmstr.ABS_order AND string(idh_line) =  absmstr.ABS_line AND idh_part = absmstr.ABS_item NO-LOCK NO-ERROR.*/

                     FIND FIRST pt_mstr WHERE absmstr.ABS_item = pt_part NO-LOCK NO-ERROR.
                   
                 
                    mamount =  sod_price * abs(absmstr.ABS_qty).
                   for LAST sct_det where sct_part = absmstr.ABS_item and sct_sim = 'standard' by sct_cst_date :
                   
                    msocost = sct_cst_tot * abs(absmstr.ABS_qty).
                   end.
                     mold = TODAY - abs_mstr.ABS_shp_date.
                     mref = ABSMSTR.ABS__CHR05.
                     DISPLAY abs_mstr.ABS_shipto 
                     ad_sort 
                     mshipper
                        mref 
                         ABS_order
                      ABS_line
                         ABS_mstr.ABS_shp_date 
                     /*mold*/
                     ABSmstr.ABS_item 
                     pt_desc1 
                     ABSmstr.abs_qty @ ship_qty
                     ABSmstr.ABS_lotser 
                     /*mamount */
                     msocost WITH frame c .
                   if pt_desc2 <> '' then do:
                     down 1 .
                    put space(116).
                    put pt_desc2.
                   
                 end.
                 END.
             
                 END.
                 
                 END.
               {mftrl080.i} 
              
              END.
