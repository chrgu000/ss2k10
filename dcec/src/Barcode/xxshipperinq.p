{mfdtitle.i}
DEFINE VAR shipto LIKE ABS_shipto.
DEFINE VAR shipto1 LIKE ABS_shipto.
 define var itemdesc LIKE PT_DESC1.
define var mshipper like abs_id.
define var mamount like sod_price.
define var msocost like pt_xtot_std.
DEFINE BUFFER absmstr FOR ABS_mstr.
    DEFINE var miscontinue AS LOGICAL INITIAL YES.
    DEFINE var isrecord AS LOGICAL INITIAL NO.
    FORM 
    SKIP(1)
    shipto COLON 12 LABEL "货物发往"
    shipto1 COLON 35 LABEL "至"
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
  DEFINE FRAME b
    
      abs_mstr.ABS_shipto colon 12 LABEL "货物发往"
      SKIP(1)
      ad_sort colon 12 LABEL "客户名称" 
      SKIP(1)
    mshipper colon 12 LABEL "货运单号"
      WITH  WIDTH 180 STREAM-IO SIDE-LABEL.
 /*DEFINE  FRAME c
 
      sod_nbr colon 12 column-LABEL "订单号"
     ABS_mstr.ABS_shp_date COLON 27 column-LABEL "发运日期"
      ABSmstr.ABS_item  COLON 43 column-LABEL "零件号"
      pt_desc1 COLON 61  column-LABEL "零件描述"
     ABSmstr.ABS_lotser COLON 88 column-LABEL "批/序号"
      ABSmstr.ABS_qty COLON 111 column-LABEL "数量"

      mamount COLON 126  column-LABEL "订单金额"
     msocost COLON 141 column-LABEL "销售成本"
   
     PT_DESC2 COLON 66 NO-LABEL
      WITH WIDTH 175  STREAM-IO no-attr-space down overlay .*/

 DEFINE FRAME c
 
      sod_nbr  COLON 12 column-LABEL "订单号"
     ABS_mstr.ABS_shp_date  COLUMN-LABEL "发运日期"
      ABSmstr.ABS_item  COLUMN-LABEL "零件号"
      pt_desc1  COLUMN-LABEL "零件描述" 
     ABSmstr.ABS_lotser  COLUMN-LABEL "批/序号"
      ABSmstr.ABS_qty  COLUMN-LABEL "数量"

      mamount   COLUMN-LABEL "订单金额"
     msocost  COLUMN-LABEL "销售成本"
     
     PT_DESC2  NO-LABEL
     WITH WIDTH 175  STREAM-IO no-attr-space down overlay .


 
REPEAT:
    do with frame a:
               prompt-for shipto shipto1 editing:
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
                END.


          {mfselbpr.i "printer" 80} 

             IF shipto1 = " " THEN shipto1 = hi_char.
              {mfphead.i}
             
                  mainloop:
                  
                  FOR EACH ABS_mstr WHERE abs_mstr.ABS_shipto >= shipto AND abs_mstr.ABS_shipto <= shipto1 AND abs_mstr.ABS_par_id = '' AND (abs_mstr.abs_id BEGINS 'p' OR abs_mstr.abs_id BEGINS 's') NO-LOCK  :
                  miscontinue = YES.
                 isrecord = NO.
                  
                 
                  IF ABS_status = ' y' or abs_status = 'yy' THEN DO:
                    for first ih_hist WHERE ih_bol = SUBSTRING(ABS_id,2,50) NO-LOCK:
                    
                   
                     miscontinue = NO.
                     
                     END.
                 end.
            FOR FIRST ABSmstr WHERE absmstr.abs_par_id <> "" AND  absmstr.ABS_par_id = abs_mstr.ABS_id AND absmstr.abs_order <> "" AND absmstr.abs_line <> "" NO-LOCK :
             isrecord = YES.    
              END.
                 IF miscontinue AND isrecord THEN DO:

                 
               
                 if page-size - line-counter < 2 then page.
                 FIND ad_mstr WHERE ad_addr = abs_mstr.ABS_shipto AND (ad_type = 'ship-to' OR ad_type = 'customer') NO-LOCK NO-ERROR.
                 PUT SKIP.
                 PUT SKIP.
                mshipper = SUBSTRING(abs_mstr.ABS_id,2,50).
                 DISPLAY  abs_mstr.ABS_shipto ad_sort mshipper WITH FRAME b.
                

                 
                 FOR EACH ABSmstr WHERE absmstr.abs_par_id <> "" AND  absmstr.ABS_par_id = abs_mstr.ABS_id AND absmstr.abs_order <> "" AND absmstr.abs_line <> "" NO-LOCK  :
                     
                     FIND sod_det WHERE sod_nbr = absmstr.ABS_order AND string(sod_line) = absmstr.ABS_line NO-LOCK NO-ERROR.
                     FIND pt_mstr WHERE absmstr.ABS_item = pt_part NO-LOCK NO-ERROR.
                   
                  
                    mamount =  sod_price * absmstr.ABS_qty.
                    msocost = pt_xtot_std * absmstr.ABS_qty.
                     
                     DISPLAY sod_nbr 
                     ABS_mstr.ABS_shp_date 
                     ABSmstr.ABS_item 
                     pt_desc1 
                     ABSmstr.abs_qty 
                     ABSmstr.ABS_lotser 
                     mamount 
                     msocost WITH frame c .
                   if pt_desc2 <> '' then do:
                     down 1 .
                    put space(50).
                    put pt_desc2.
                   
                 end.
                 END.
             
                 END.
                 
                 END.
               {mftrl080.i} 
              
              END.
