{mfdtitle.i}
DEFINE VAR shipto LIKE ABS_shipto.
DEFINE VAR shipto1 LIKE ABS_shipto.
 define var itemdesc as char format "x(48)".
define var mshipper like abs_id.
define var mamount like sod_price.
define var msocost like pt_xtot_std.
DEFINE BUFFER absmstr FOR ABS_mstr.
    DEFINE var miscontinue AS LOGICAL INITIAL YES.
    FORM 
    SKIP(1)
    shipto COLON 12 LABEL "���﷢��"
    shipto1 COLON 35 LABEL "��"
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
  DEFINE FRAME b
    
      ABS_shipto colon 12 LABEL "���﷢��"
      SKIP(1)
      ad_sort colon 12 LABEL "�ͻ�����" 
      SKIP(1)
    mshipper colon 12 LABEL "���˵���"
      WITH  WIDTH 185 STREAM-IO SIDE-LABEL.
 DEFINE FRAME c
 
      sod_nbr colon 12 column-LABEL "������"
     ABS_mstr.ABS_shp_date COLON 27 LABEL "��������"
      ABSmstr.ABS_item  COLON 43 LABEL "�����"
      pt_desc1 COLON 61  LABEL "�������"
     ABSmstr.ABS_lotser COLON 88 LABEL "��/���"
      ABSmstr.ABS_qty COLON 111 LABEL "����"

      mamount COLON 126  LABEL "�������"
     msocost COLON 141 LABEL "���۳ɱ�"
     skip(1)
     PT_DESC2 COLON 66 NO-LABEL
      WITH WIDTH 180  .

/* DEFINE FRAME c
 
      sod_nbr  colon 12 column-LABEL "������"
     ABS_mstr.ABS_shp_date  LABEL "��������"
      ABSmstr.ABS_item  LABEL "�����"
      pt_desc1   LABEL "�������"
     ABSmstr.ABS_lotser  LABEL "��/���"
      ABSmstr.ABS_qty  LABEL "����"

      mamount   LABEL "�������"
     msocost  LABEL "���۳ɱ�"
     skip(1)
     PT_DESC2 COLON 66 NO-LABEL
      WITH WIDTH 180 overlay down  .*/

 
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
                  
                  FOR EACH ABS_mstr WHERE ABS_shipto >= shipto AND ABS_shipto <= shipto1 AND ABS_status BEGINS 'y' AND (abs_id BEGINS 'p' OR abs_id BEGINS 's') NO-LOCK WITH FRAME b :
                  miscontinue = YES.
                 IF ABS_status = 'yy' THEN DO:
                    for first ih_hist WHERE ih_bol = SUBSTRING(ABS_id,2,50) NO-LOCK:
                    
                   
                     miscontinue = NO.
                     
                     END.
                 end.
                 IF miscontinue THEN DO:
                 
                 if page-size - line-counter < 2 then page.
                 FIND ad_mstr WHERE ad_addr = ABS_shipto AND ad_type = 'ship-to' NO-LOCK.
                 PUT SKIP.
                 PUT SKIP.
                mshipper = SUBSTRING(ABS_id,2,50).
                 DISPLAY  ABS_shipto ad_sort mshipper.

                 
                 FOR EACH ABSmstr WHERE absmstr.abs_status = "" AND  absmstr.ABS_par_id = abs_mstr.ABS_id NO-LOCK  :
                   FIND sod_det WHERE sod_nbr = absmstr.ABS_order AND string(sod_line) = absmstr.ABS_line NO-LOCK.
                     FIND pt_mstr WHERE absmstr.ABS_item = pt_part NO-LOCK.
                    /* itemdesc = pt_desc1 + pt_desc2.*/
                    mamount =  sod_price * absmstr.ABS_qty.
                    msocost = pt_xtot_std * absmstr.ABS_qty.
                     PUT SKIP.  
                     DISPLAY sod_nbr 
                     ABS_mstr.ABS_shp_date 
                     ABSmstr.ABS_item 
                     pt_desc1 pt_desc2
                     ABSmstr.abs_qty 
                     ABSmstr.ABS_lotser 
                     mamount 
                     msocost WITH FRAME c  .
                 END.
             
                 END.
                  
                 END.
               {mftrl080.i} 
              
              END.
