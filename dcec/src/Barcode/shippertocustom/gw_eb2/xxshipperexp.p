{mfdtitle.i}
   DEFINE VAR shipper LIKE ABS_ID LABEL "货运单号".
DEFINE VAR part LIKE ABS_item LABEL "零件号".
DEFINE VAR inv_qty LIKE ABS_qty LABEL "开票数量" INITIAL "0".
DEFINE BUFFER absmstr1 FOR ABS_mstr.
    DEFINE BUFFER absmstr2 FOR ABS_mstr.
        DEF BUFFER ABSitem FOR ABS_mstr.
        DEFINE VAR remain_qty LIKE ABS_qty.
        DEFINE VAR mcount AS INT.
        DEFINE  VAR mrecno AS INT.
        DEFINE VAR iscontinue AS LOGICAL INITIAL "no".
       define var tot_qty like abs_qty.
      DEF SHARED VAR GLOBAL_recid AS RECID. 
     DEF VAR mabs_id AS CHAR.
     DEF VAR msubid AS CHAR. 
     DEF VAR contract AS CHAR FORMAT "x(20)" LABEL "原本合同号".
     DEF VAR mfile AS CHAR FORMAT "x(40)" LABEL "文件".
     DEF VAR mstr AS CHAR.
     DEF VAR isunmatch AS LOGICAL.
     DEF TEMP-TABLE minvoice 
        
         FIELD mso LIKE sod_nbr
           FIELD mline LIKE sod_line
           FIELD mpart LIKE sod_part
           FIELD mserial LIKE tr_serial
           FIELD mqty AS INT
         FIELD mshipper LIKE ABS_id.
      DEF TEMP-TABLE shipper_no FIELD mshp_no LIKE ABS_id. 
     FORM 
      SKIP(0.5)
      mfile COLON 20
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
   DEFINE FRAME unmatch
       mso  colon 12 COLUMN-LABEL "订单号"
       mline COLUMN-LABEL "行"

      mpart COLUMN-LABEL "零件号"
       mqty COLUMN-LABEL "数量"
       mserial COLUMN-LABEL "批/序号"
          WITH STREAM-IO WIDTH 120 no-attr-space DOWN OVERLAY .
REPEAT:
FOR EACH minvoice:
      DELETE minvoice.
  END.
  FOR EACH shipper_no:
      DELETE shipper_no.
  END.
 
   isunmatch = NO.
 
 
 UPDATE mfile WITH FRAME a.
  
    IF mfile = "" THEN do:
        MESSAGE "文件不能为空!" VIEW-AS ALERT-BOX BUTTON OK. 
        next-prompt mfile WITH FRAME a.
        UNDO,RETRY.
        
      END. 
    
      
    
     
       find FIRST qad_wkfl no-lock where
                     qad_key1 = "xxshipperexp.p" NO-ERROR .

                  if available qad_wkfl and
                     qad_key4 <> mfguser
                  then do:
                     /* SALES ORDER # IS BEING CONFIRMED BY USER # */
                   MESSAGE "该货运单分解已被使用！" VIEW-AS ALERT-BOX BUTTON OK. 
                     undo,retry .
                 
                  end.  /* IF AVAILABLE qad_wkfl */
                  else if not available qad_wkfl then do:
                     create qad_wkfl.
                     assign
                        qad_key1       = "xxshipperexp.p"
                       /* qad_key2       = mshp_no*/
                         qad_key3       = "xxshipperexp.p"
                        qad_key4       = mfguser
                        qad_charfld[1] = global_userid
                        
                        qad_date[1]    = today
                        qad_charfld[5] = string(time, "hh:mm:ss").
                     if recid(qad_wkfl) = -1 then .
                  end. 
          INPUT FROM VALUE(mfile).
     IMPORT  DELIMITER ";" contract.
    
  REPEAT:
 
   
  
 mstr = ''.
   
    IMPORT  DELIMITER ";" mstr.
        CREATE minvoice.
       
        
        
        mso = SUBSTR(mstr,1,8).
mline = integer(SUBSTR(mstr,9,4)).
mpart = SUBSTR(mstr,13,18).
mserial = SUBSTR(mstr,31,18).
mqty = integer(SUBSTR(mstr,49,8)).
  END. 
  
 {mfselbpr.i "printer" 80} 
            {mfphead.i}
  FOR EACH minvoice EXCLUSIVE-LOCK:
            FIND FIRST absitem WHERE absitem.ABS_item = mpart AND absitem.abs_lot = mserial AND absitem.ABS_order = mso AND absitem.ABS_line = string(mline) AND absitem.ABS_loc = '8888' AND absitem.ABS__qad09 <> 'exp'  AND absitem.ABS_qty >= mqty AND absitem.ABS_status <> ' y' AND absitem.ABS_status <> 'yy' NO-LOCK NO-ERROR.
            IF AVAILABLE ABSitem  THEN do:
                
                mshipper = substr(ABSitem.ABS_par_id,2,50).
               FIND FIRST shipper_no WHERE mshp_no = mshipper NO-LOCK NO-ERROR.
               IF NOT AVAILABLE shipper_no THEN DO: 
                   CREATE shipper_no.
              
                mshp_no = substr(ABSitem.ABS_par_id,2,50).
                 END.
            END.
           
            END.
       FOR EACH minvoice WHERE mshipper = '' NO-LOCK:
             DISP mso mline mpart mqty mserial WITH FRAME unmatch.
            isunmatch = YES.
       END.
   
IF isunmatch THEN  DO:
    PUT SKIP.
    PUT SPACE(15).
    PUT "上述订单行无法匹配,或已分解！".
    
    END.
      
        FOR EACH shipper_no NO-LOCK :

          

  /* ELSE OF IF AVAILABLE qad_wkfl */

            
      
      
      
     
   
  
  
       
           
           
              FIND FIRST ABSmstr1 WHERE absmstr1.ABS_par_id = '' and substr(absmstr1.ABS_id,2,50) = mshp_no AND absmstr1.ABS_status <> " y" and absmstr1.ABS_status <> "yy" NO-LOCK NO-ERROR.
              
                mcount = 0.  
              FOR EACH absmstr2 WHERE  absmstr2.ABS_par_id = '' AND SUBSTR(absmstr2.ABS_id,2,50) BEGINS mshp_no NO-LOCK:
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
           /* FIND FIRST ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order <> "" AND absmstr2.abs_line <> "" AND absmstr2.abs_item = part AND absmstr2.ABS_qty >= inv_qty NO-LOCK  NO-ERROR.*/
               
            
              FOR EACH minvoice WHERE mshipper = mshp_no NO-LOCK  BY mpart:
                  
                FIND FIRST  ABSmstr2 WHERE absmstr2.abs_par_id <> "" AND  absmstr2.ABS_par_id = absmstr1.ABS_id AND absmstr2.abs_order = mso AND absmstr2.abs_line = STRING(mline) AND absmstr2.abs_item = mpart AND absmstr2.abs_lot = mserial AND absmstr2.ABS_loc = '8888' AND absmstr2.ABS_qty > 0 NO-LOCK NO-ERROR . 
                   IF AVAILABLE absmstr2 THEN DO:
                  
                     mabs_id = REPLACE(absmstr2.ABS_id,absmstr2.ABS_par_id,msubid).                    
                     CREATE ABS_mstr.
               BUFFER-COPY 
                   absmstr2
                     EXCEPT
                          ABS_mstr.abs_par_id  abs_mstr.abs_qty ABS_mstr.abs_id ABS_mstr.ABS__qad09
                     TO ABS_mstr
                    ASSIGN  ABS_mstr.ABS_par_id = absmstr1.ABS_id + "-" + STRING(mrecno)
                   ABS_mstr.ABS_id =  mabs_id          
                   ABS_mstr.ABS_qty = mqty  
                   ABS_mstr.ABS__qad09 = 'exp'  .
               /* DISPLAY ABSmstr2.ABS_item absmstr2.abs_lot ABSmstr2.ABS_qty WITH FRAME c.*/
                IF mqty = absmstr2.ABS_qty THEN DO:
              
                FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = RECID(absmstr2) EXCLUSIVE-LOCK NO-ERROR.
                DELETE ABS_mstr.
                  END. 
                  ELSE DO:
                  
                       FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = RECID(absmstr2) EXCLUSIVE-LOCK NO-ERROR.
                      ABS_mstr.ABS_qty = ABS_mstr.ABS_qty - mqty.
                      END.
                   
                 END.
              END.
               FOR EACH ABS_mstr WHERE abs_mstr.ABS_par_id = msubid NO-LOCK:
           DISPLAY ABS_mstr.ABS_item abs_mstr.abs_lot  ABS_mstr.ABS_qty WITH FRAME c.

                END.              

       
             
        
 
            
    
                
  
            
           
                  
                  
                  
                  END.
      
                  
                  {mftrl080.i} 

                       FOR EACH qad_wkfl EXCLUSIVE-LOCK where
                     qad_key1 = "xxshipperexp.p" :
     DELETE qad_wkfl.
                       END.
 END.
