DEF OUTPUT PARAMETER pass AS LOGICAL.
DEF SHARED TEMP-TABLE cimchk_list
    FIELD cimchk_code AS CHAR
    FIELD cimchk_value AS CHAR.

pass = YES.
    FOR EACH cimchk_list  NO-LOCK:
    
   FIND FIRST CODE_mstr WHERE CODE_fldname = cimchk_code NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = cimchk_code AND CODE_value = cimchk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
              MESSAGE '清校验 ' +  cimchk_code + ' 通用代码!' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
              END.
       END.
        END.  






/*
       WHEN 'ad_state' THEN DO:
     
    FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_state'NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_state' AND CODE_value = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
              MESSAGE '清校验 ad_state 通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.
        END.     /* FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_format' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_format' AND CODE_value = "" NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = t_sup_code.
          t_er_xmlfield = ''.
              t_er_qadfield = 'ad_format'.
          t_er_mess = 'Please check format generalized code!'.
              END.
       END.*/
       WHEN 'ad_county' THEN DO:
      
        
        
        FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_county' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_county' AND CODE_value = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                   pass = NO.
              MESSAGE '清校验 ad_county通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.


       END.
              
       
       
       WHEN 'ad_type' THEN DO:
      
       
       FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_type' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_type' AND CODE_value = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
              MESSAGE '清校验 ad_type通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.


       END.


       WHEN 'vd_shipvia' THEN DO:
      
              FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_shipvia' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_shipvia' AND CODE_value = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                   pass = NO.
              MESSAGE '清校验 vd_shipvia 通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.
       END.


       WHEN 'vd_buyer' THEN DO:
       
       FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_buyer'NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_buyer' AND CODE_value = cimschk_value NO-LOCK NO-ERROR.
               IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                  
              MESSAGE '清校验 vd_buyer通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
               END.


       END.



       WHEN 'vd_promo' THEN  DO:
       
     FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_promo'NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_promo' AND CODE_value = cimschk_value NO-LOCK NO-ERROR.
               IF NOT AVAILABLE CODE_mstr THEN do:
                   pass = NO.
              MESSAGE '清校验 vd_promo 通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.
       END.



       WHEN 'ctry_ctry_code' THEN DO:
   
              FIND FIRST ctry_mstr WHERE ctry_ctry_code = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ctry_mstr THEN do:
                  pass = NO.
                  pass = NO.
              MESSAGE '清校验 ctry_ctry_code通用代码!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.


       WHEN 'ad_addr' THEN  DO:
      
           FIND FIRST ad_mstr WHERE ad_addr = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ad_mstr THEN do:
                  pass = NO.
                 pass = NO.
              MESSAGE '清校验ad_addr!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.


       WHEN 'cu_curr'  THEN  DO:
      
     FIND FIRST cu_mstr WHERE cu_curr = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE cu_mstr THEN do:
                  
                  pass = NO.
              MESSAGE '清校验cu_curr!' VIEW-AS ALERT-BOX ERROR.
              END.
       END.


       WHEN 'ct_code' THEN  DO:
      
           FIND FIRST ct_mstr WHERE ct_code = cimschk_value NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ctry_mstr THEN do:
                  pass = NO.
                  pass = NO.
              MESSAGE '清校验ct_code!' VIEW-AS ALERT-BOX ERROR.
              END.

       END.


       WHEN 'ac_code' THEN  DO:
      
   
          FIND FIRST ac_mstr WHERE ac_code = cimschk_value NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ac_mstr THEN do:
                  pass = NO.
                  
              MESSAGE '清校验ac_code!' VIEW-AS ALERT-BOX.
               END.
             
       END.
          

        WHEN 'ac_code' THEN  DO:
      
   
          FIND FIRST ac_mstr WHERE ac_code = cimschk_value NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ac_mstr THEN do:
                  pass = NO.
                  
              MESSAGE '清校验ac_code!' VIEW-AS ALERT-BOX.
               END.
             
       END.*/




