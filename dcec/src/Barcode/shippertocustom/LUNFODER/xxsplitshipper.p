{mfdtitle.i}
   DEFINE VAR shipper LIKE ABS_ID LABEL "货运单号".
DEFINE VAR part LIKE ABS_item LABEL "零件号".
DEFINE VAR inv_qty LIKE ABS_qty LABEL "开票数量" INITIAL "0".
DEFINE BUFFER absmstr1 FOR ABS_mstr.
    DEFINE BUFFER absmstr2 FOR ABS_mstr.
        DEFINE VAR remain_qty LIKE ABS_qty.
        DEFINE VAR mcount AS INT.
        DEFINE  VAR mrecno AS INT.
        DEFINE VAR iscontinue AS LOGICAL INITIAL "no".
       define var tot_qty like abs_qty.
        FORM 
    SKIP(0.5)
    shipper COLON 12
    part COLON 40
    inv_qty COLON 65
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
 DEFINE FRAME b
    
      abs_mstr.ABS_shipto colon 12 LABEL "货物发往"
      SKIP(1)
     /* ad_sort colon 12 LABEL "客户名称" 
      SKIP(1)*/
    ABS_mstr.ABS_id colon 12 LABEL "货运单号"
      WITH  WIDTH 180 STREAM-IO SIDE-LABEL.
 DEFINE FRAME c
     ABS_mstr.ABS_item  colon 12 COLUMN-LABEL "零件号"
     ABS_mstr.ABS_qty COLUMN-LABEL "数量"
     WITH STREAM-IO WIDTH 80 no-attr-space DOWN OVERLAY .
REPEAT:

   /* DO TRANSACTION ON ERROR UNDO,RETRY:*/
    SET shipper  WITH FRAME a EDITING:
    
    {mfnp05.i abs_mstr abs_id
                       "abs_id begins 's' or abs_id begins 'p'"
                        abs_id
                       "input shipper"}
               IF recno <> ? THEN do:
              shipper = substr(abs_id,2,50).

               DISPLAY shipper WITH FRAME a.
               END.

    END.
    
    IF shipper = "" THEN do:
        MESSAGE "货运单号不能为空!" VIEW-AS ALERT-BOX BUTTON OK. 
        next-prompt shipper WITH FRAME a.
        UNDO,RETRY.
        
      END. 
    if lookup(shipper,"-") = 1 then DO:
      
             MESSAGE '货运单号含有非法字符"-"!' VIEW-AS ALERT-BOX BUTTON OK. 
        next-prompt shipper WITH FRAME a.
        UNDO,RETRY.
        
        END.

        FIND ABSmstr1 WHERE absmstr1.ABS_par_id = '' and substr(absmstr1.ABS_id,2,50) = shipper AND absmstr1.ABS_status <> " y" and absmstr1.ABS_status <> "yy" NO-LOCK NO-ERROR.


         IF NOT AVAILABLE absmstr1 THEN DO:
             MESSAGE "货运单号无效或已销售成本已结转!" VIEW-AS ALERT-BOX BUTTON OK. 
        next-prompt shipper WITH FRAME a.
        UNDO,RETRY.
             END.
      
      
     /* END.*/
     /* DO TRANSACTION ON ERROR UNDO,RETRY:*/
       
        SET part WITH FRAME a WITH EDITING:
        {mfnp05.i absmstr1 abs_par_id
                       "absmstr1.abs_par_id begins 's' or absmstr1.abs_par_id begins 'p'"
                        absmstr1.abs_item
                       "input part"}
               IF recno <> ? THEN do:
              part = ABSMSTR1.ABS_item.

               DISPLAY part WITH FRAME a.
               END.
    END.
        
        
        IF part = "" THEN DO:
            MESSAGE "零件号不能为空!" VIEW-AS ALERT-BOX BUTTON OK. 
          next-prompt part WITH FRAME A.
          UNDO,RETRY.
            
            END.
      
          FIND ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  substr(absmstr2.ABS_par_id,2,50) = shipper AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part  NO-LOCK  NO-ERROR.
          IF NOT AVAILABLE absmstr2 THEN DO:
          MESSAGE "无效零件号!" VIEW-AS ALERT-BOX BUTTON OK. 
       next-prompt part WITH FRAME a.
       UNDO,RETRY.
            END.

          
          
       /*   END.*/
     /* DO TRANSACTION ON ERROR UNDO,RETRY:*/
       
        UPDATE inv_qty WITH FRAME a.
        IF inv_qty <= 0  THEN DO:
          MESSAGE "数量不能为零!" VIEW-AS ALERT-BOX BUTTON OK. 
          next-prompt INV_QTY WITH FRAME A.
          UNDO,RETRY.
            
            END.
    /* END.*/

     iscontinue = NO.
     FIND ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item <> part  NO-LOCK  NO-ERROR.
   IF NOT AVAILABLE absmstr2  THEN DO:
  
   tot_qty = 0.
  FOR EACH ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part  NO-LOCK :
      tot_qty = tot_qty + absmstr2.ABS_qty.
       
       
       END.
   IF tot_qty > inv_qty THEN iscontinue = YES.
      ELSE  MESSAGE "该货运单不符合分解条件!" VIEW-AS ALERT-BOX BUTTON OK. 
   END.
    ELSE iscontinue = YES.
    
   IF iscontinue THEN DO:
  
  
         {mfselbpr.i "printer" 80} 
            {mfphead.i}
             shipper = replace(shipper,"-","").
              FIND ABSmstr1 WHERE absmstr1.ABS_par_id = '' and substr(absmstr1.ABS_id,2,50) = shipper AND absmstr1.ABS_status <> " y" and absmstr1.ABS_status <> "yy" NO-LOCK NO-ERROR.
              
                mcount = 0.  
              FOR EACH absmstr2 WHERE  absmstr2.ABS_par_id = '' AND SUBSTR(absmstr2.ABS_id,2,50) BEGINS shipper NO-LOCK:
             mcount = mcount + 1.
         END.
         mrecno = mcount.
       
      
         CREATE ABS_mstr.
        BUFFER-COPY
            absmstr1
              EXCEPT ABS_mstr.ABS_id
             TO ABS_mstr
             ASSIGN ABS_mstr.ABS_id = absmstr1.ABS_id + "-" + STRING(mrecno).
            DISPLAY  abs_mstr.ABS_id ABS_mstr.abs_shipto WITH FRAME b. 
        FIND ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part AND absmstr2.ABS_qty >= inv_qty NO-LOCK  NO-ERROR.
         
            IF AVAILABLE absmstr2 THEN DO:
               CREATE ABS_mstr.
               BUFFER-COPY 
                   absmstr2
                     EXCEPT
                         abs_mstr.abs_id ABS_mstr.abs_par_id   ABS_mstr.ABS_qty 
                     TO ABS_mstr
                   ASSIGN  abs_mstr.abs_id = "i" + absmstr1.ABS_id + "-" + STRING(mrecno) + absmstr2.ABS_order + "    " + "00"   
                   ABS_mstr.ABS_par_id = absmstr1.ABS_id + "-" + STRING(mrecno)
                   
                   ABS_mstr.ABS_qty = inv_qty.
               DISPLAY ABS_mstr.ABS_item ABS_mstr.ABS_qty WITH FRAME c.
               FIND ABS_mstr WHERE RECID(ABS_mstr) = RECID(absmstr2) EXCLUSIVE-LOCK NO-ERROR.
                IF absmstr2.ABS_qty = inv_qty THEN DELETE ABS_mstr.
                  ELSE  ABS_mstr.ABS_qty = absmstr2.ABS_qty - inv_qty.

                           
                
                END.
                ELSE DO:
                 remain_qty = inv_qty.
                  FOR EACH ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part NO-LOCK  :
                     CREATE ABS_mstr.
               BUFFER-COPY 
                   absmstr2
                     EXCEPT
                          ABS_mstr.abs_par_id  ABS_mstr.abs_id
                     TO ABS_mstr
                    ASSIGN  ABS_mstr.ABS_par_id = absmstr1.ABS_id + "-" + STRING(mrecno)
                   ABS_mstr.ABS_id = 'i' + absmstr1.ABS_id + "-" + STRING(mrecno) + absmstr2.ABS_order + "    " + '00'       
                       .
                DISPLAY ABS_mstr.ABS_item ABS_mstr.ABS_qty WITH FRAME c.
               FIND ABS_mstr WHERE RECID(ABS_mstr) = RECID(absmstr2) EXCLUSIVE-LOCK NO-ERROR.
                DELETE ABS_mstr.
                   remain_qty = remain_qty - absmstr2.abs_qty. 
                   IF remain_qty = 0 THEN LEAVE.
                  END.
                    
                    END.


              
              
            
        
 
              {mftrl080.i} 
    
                  END.
    
 END.
