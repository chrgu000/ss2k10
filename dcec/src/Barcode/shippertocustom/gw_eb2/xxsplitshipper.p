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
      DEF SHARED VAR GLOBAL_recid AS RECID. 
     DEF VAR mabs_id AS CHAR.
     DEF VAR msubid AS CHAR. 
     DEF VAR contract AS CHAR FORMAT "x(20)" LABEL "原本合同号".
     FORM 
    SKIP(0.5)
    shipper COLON 15
    part COLON 45
    skip(0.5)
         contract COLON 15
         inv_qty COLON 45
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
 DEFINE FRAME b
    
      abs_mstr.ABS_shipto colon 12 LABEL "货物发往"
      SKIP(1)
     /* ad_sort colon 12 LABEL "客户名称" 
      SKIP(1)*/
    ABS_mstr.ABS_id colon 12 LABEL "货运单号"
     SKIP(1) 
     abs_mstr.abs__qad10 COLON 12 LABEL "原本合同号"
     WITH  WIDTH 180 STREAM-IO SIDE-LABEL.
 DEFINE FRAME c
     ABS_mstr.ABS_item  colon 12 COLUMN-LABEL "零件号"
     abs_mstr.ABS_lot COLUMN-LABEL "批/序号"

     ABS_mstr.ABS_qty COLUMN-LABEL "数量"
     WITH STREAM-IO WIDTH 120 no-attr-space DOWN OVERLAY .
 DEFINE FRAME d
     ABS_mstr.ABS_item  colon 12 COLUMN-LABEL "零件号"
     abs_mstr.ABS_lot COLUMN-LABEL "批/序号"

     ABS_mstr.ABS_qty COLUMN-LABEL "数量"
     WITH STREAM-IO WIDTH 120 no-attr-space DOWN OVERLAY .
REPEAT:

   DO TRANSACTION ON ERROR UNDO,RETRY:
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

        FIND FIRST ABSmstr1 WHERE absmstr1.ABS_par_id = '' and substr(absmstr1.ABS_id,2,50) = shipper AND absmstr1.ABS_status <> " y" and absmstr1.ABS_status <> "yy" NO-LOCK NO-ERROR.


         IF NOT AVAILABLE absmstr1 THEN DO:
             MESSAGE "货运单号无效或已销售成本已结转!" VIEW-AS ALERT-BOX BUTTON OK. 
        next-prompt shipper WITH FRAME a.
        UNDO,RETRY.
             END.
      
      
     END.
    
        do transaction on error undo, retry:
        SET part WITH FRAME a WITH EDITING:
        {mfnp05.i absmstr1 abs_par_id
                       "substr(absmstr1.abs_par_id,2,50) = shipper "
                        absmstr1.abs_item
                       "input part"}
               IF recno <> ? THEN do:
              part = ABSMSTR1.ABS_item.

               DISPLAY part WITH FRAME a.
               END.
    END.
        
        
        IF part = "" THEN DO:
            MESSAGE "零件号不能为空!" VIEW-AS ALERT-BOX BUTTON OK. 
          
              NEXT-PROMPT part WITH FRAME A.
          UNDO,RETRY.
            
            END.
      
          FIND FIRST ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  substr(absmstr2.ABS_par_id,2,50) = shipper AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part  NO-LOCK  NO-ERROR.
          IF NOT AVAILABLE absmstr2 THEN DO:
          MESSAGE "无效零件号!" VIEW-AS ALERT-BOX BUTTON OK. 
       NEXT-PROMPT part WITH FRAME a.
      UNDO,RETRY.
            END.

          
          
         END.
     DO TRANSACTION ON ERROR UNDO,RETRY:
       UPDATE contract WITH FRAME a.
       IF contract = '' THEN DO:
       MESSAGE "合同号不能为空!" VIEW-AS ALERT-BOX BUTTON OK. 
          NEXT-PROMPT contract WITH FRAME A.
          UNDO,RETRY.
           END.
        
     END.
      DO TRANSACTION ON ERROR UNDO,RETRY:
     UPDATE inv_qty WITH FRAME a.
        IF inv_qty <= 0  THEN DO:
          MESSAGE "数量不能为零!" VIEW-AS ALERT-BOX BUTTON OK. 
          NEXT-PROMPT INV_QTY WITH FRAME A.
          UNDO,RETRY.
            
            END.
      END.
  {mfselbpr.i "printer" 80} 
            {mfphead.i}
 find qad_wkfl no-lock where
                     qad_key1 = "xxsplitshipper.p" and
                     qad_key2 = shipper no-error.

                  if available qad_wkfl and
                     qad_key4 <> mfguser
                  then do:
                     /* SALES ORDER # IS BEING CONFIRMED BY USER # */
                   MESSAGE "该货运单被锁住！" VIEW-AS ALERT-BOX BUTTON OK. 
                     undo,retry .
                 
                  end.  /* IF AVAILABLE qad_wkfl */
                  else if not available qad_wkfl then do:
                     create qad_wkfl.
                     assign
                        qad_key1       = "xxsplitshipper.p"
                        qad_key2       = shipper
                         qad_key3       = "xxsplitshipper.p"
                        qad_key4       = mfguser
                        qad_charfld[1] = global_userid
                        
                        qad_date[1]    = today
                        qad_charfld[5] = string(time, "hh:mm:ss").
                     if recid(qad_wkfl) = -1 then .
                  end.  /* ELSE OF IF AVAILABLE qad_wkfl */

            
      
      
      
      iscontinue = NO.
     FIND FIRST ABSmstr1 WHERE absmstr1.ABS_par_id = '' and substr(absmstr1.ABS_id,2,50) = shipper AND absmstr1.ABS_status <> " y" and absmstr1.ABS_status <> "yy" NO-LOCK NO-ERROR.

     FIND FIRST ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item <> part  NO-LOCK  NO-ERROR.
   IF NOT AVAILABLE absmstr2  THEN DO:
  
   tot_qty = 0.
  FOR EACH ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part  NO-LOCK :
      tot_qty = tot_qty + absmstr2.ABS_qty.
       
       
       END.
       
       IF tot_qty > inv_qty THEN iscontinue = YES.
      ELSE 
          IF tot_qty = inv_qty THEN DO:
              
               FIND FIRST ABS_mstr WHERE abs_mstr.ABS_par_id = '' and substr(abs_mstr.ABS_id,2,50) = shipper AND abs_mstr.ABS_status <> " y" and abs_mstr.ABS_status <> "yy"  EXCLUSIVE-LOCK NO-ERROR.
              abs_mstr.abs__qad10 = contract.
              DISPLAY  substr(abs_mstr.ABS_id,2,50) @ ABS_mstr.ABS_id  ABS_mstr.abs_shipto abs_mstr.abs__qad10 WITH FRAME b. 
              FOR EACH ABS_mstr WHERE   substr(abs_mstr.ABS_Par_id,2,50) = shipper AND abs_mstr.ABS_status <> " y" and abs_mstr.ABS_status <> "yy"  NO-LOCK: 
                  DISPLAY ABS_mstr.ABS_item abs_mstr.abs_lot  ABS_mstr.ABS_qty WITH FRAME d.           

                           END.
              END.
              ELSE MESSAGE "该货运单不符合分解条件!" VIEW-AS ALERT-BOX BUTTON OK. 
   END.
    ELSE do:
      tot_qty = 0.
        FOR EACH ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part  NO-LOCK :
      tot_qty = tot_qty + absmstr2.ABS_qty.
       
       
       END.
       IF tot_qty >= inv_qty THEN iscontinue = YES.
       ELSE  MESSAGE "该货运单不符合分解条件!" VIEW-AS ALERT-BOX BUTTON OK. 

    END.
   
  
  
       
             IF iscontinue THEN DO:
             shipper = replace(shipper,"-","").
              FIND FIRST ABSmstr1 WHERE absmstr1.ABS_par_id = '' and substr(absmstr1.ABS_id,2,50) = shipper AND absmstr1.ABS_status <> " y" and absmstr1.ABS_status <> "yy" NO-LOCK NO-ERROR.
              
                mcount = 0.  
              FOR EACH absmstr2 WHERE  absmstr2.ABS_par_id = '' AND SUBSTR(absmstr2.ABS_id,2,50) BEGINS shipper NO-LOCK:
             mcount = mcount + 1.
         END.
         mrecno = mcount.
      
      msubid = absmstr1.ABS_id + "-" + STRING(mrecno).
         CREATE ABS_mstr.
        BUFFER-COPY
            absmstr1
              EXCEPT ABS_mstr.ABS_id abs_mstr.abs__qad01 ABS_mstr.ABS__qad10
             TO ABS_mstr
             ASSIGN ABS_mstr.ABS_id = absmstr1.ABS_id + "-" + STRING(mrecno)
           abs_mstr.abs__qad01 =  substring(absmstr1.abs__qad01,1,40) + STRING(substring(ABS_mstr.ABS_id,2),"x(20)")
            ABS_mstr.ABS__qad10 = contract.
            DISPLAY  substr(abs_mstr.ABS_id,2,50) @ ABS_mstr.ABS_id ABS_mstr.abs_shipto abs_mstr.abs__qad10 WITH FRAME b. 
            GLOBAL_recid = RECID(ABS_mstr).
            FIND FIRST ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part AND absmstr2.ABS_qty >= inv_qty NO-LOCK  NO-ERROR.
         
            IF AVAILABLE absmstr2 THEN DO:
              mabs_id = REPLACE(absmstr2.ABS_id,absmstr2.ABS_par_id,msubid).
                CREATE ABS_mstr.
               BUFFER-COPY 
                   absmstr2
                     EXCEPT
                         abs_mstr.abs_id ABS_mstr.abs_par_id   ABS_mstr.ABS_qty 
                     TO ABS_mstr
                   ASSIGN  abs_mstr.abs_id = mabs_id                     
                   ABS_mstr.ABS_par_id = absmstr1.ABS_id + "-" + STRING(mrecno)
                  
                   ABS_mstr.ABS_qty = inv_qty.
              /* DISPLAY ABSmstr2.ABS_item absmstr2.abs_lot ABSmstr2.ABS_qty WITH FRAME c.*/
               FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = RECID(absmstr2) EXCLUSIVE-LOCK NO-ERROR.
                IF absmstr2.ABS_qty = inv_qty THEN DELETE ABS_mstr.
                  ELSE  ABS_mstr.ABS_qty = absmstr2.ABS_qty - inv_qty.

                           
                
                END.
                ELSE DO:
                 remain_qty = inv_qty.
                  
                 FOR EACH ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part NO-LOCK  :
                   
                     mabs_id = REPLACE(absmstr2.ABS_id,absmstr2.ABS_par_id,msubid).                    
                     CREATE ABS_mstr.
               BUFFER-COPY 
                   absmstr2
                     EXCEPT
                          ABS_mstr.abs_par_id  ABS_mstr.abs_id
                     TO ABS_mstr
                    ASSIGN  ABS_mstr.ABS_par_id = absmstr1.ABS_id + "-" + STRING(mrecno)
                   ABS_mstr.ABS_id =  mabs_id          
                       .
               /* DISPLAY ABSmstr2.ABS_item absmstr2.abs_lot ABSmstr2.ABS_qty WITH FRAME c.*/
                 remain_qty = remain_qty - absmstr2.abs_qty. 
                FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = RECID(absmstr2) EXCLUSIVE-LOCK NO-ERROR.
                DELETE ABS_mstr.
                 
                   IF remain_qty = 0 THEN LEAVE.
                  END.
                    
                    END.

 
              
              FOR EACH ABS_mstr WHERE abs_mstr.ABS_par_id = msubid NO-LOCK:
           DISPLAY ABS_mstr.ABS_item abs_mstr.abs_lot  ABS_mstr.ABS_qty WITH FRAME c.

 END.
            
        
 
            
    
                  END.
      {mftrl080.i} 
         find qad_wkfl EXCLUSIVE-LOCK where
                     qad_key1 = "xxsplitshipper.p" and
                     qad_key2 = shipper no-error.
     DELETE qad_wkfl.
 END.
