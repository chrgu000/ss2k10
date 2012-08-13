{mfdeclre.i}
    {bcdeclre.i}
DEF INPUT PARAMETER bd_case AS CHAR.
DEF INPUT PARAMETER bd_site AS CHAR.
DEF INPUT PARAMETER bd_loc AS CHAR.
DEF INPUT PARAMETER bd_part AS CHAR.
DEF INPUT PARAMETER bd_lotser AS CHAR.
DEF INPUT PARAMETER bd_ref AS CHAR.
DEF INPUT PARAMETER bd_tr_type AS CHAR.
DEF INPUT PARAMETER bd_code AS CHAR.
DEF INPUT PARAMETER bd_ord AS CHAR.   
 DEF INPUT PARAMETER bd_line AS CHAR.
 DEF INPUT PARAMETER bd_data AS CHAR.
 DEF INPUT PARAMETER bd_op AS CHAR.
 DEF INPUT PARAMETER bd_mch AS CHAR.
DEF OUTPUT PARAMETER succ AS LOGICAL.
/*DEF SHARED  TEMP-TABLE iss_list
    FIELD iss_part AS CHAR
    FIELD iss_lotser AS CHAR
    FIELD iss_ref AS CHAR
    FIELD iss_um AS CHAR
    FIELD iss_qty AS DECIMAL
    FIELD iss_site AS CHAR
    FIELD iss_loc AS CHAR.
DEF SHARED  TEMP-TABLE bd_merge_list
    FIELD bd_merge_id AS CHAR
    FIELD bd_merge_part AS CHAR
    FIELD bd_merge_lotser AS CHAR
    FIELD bd_merge_ref AS CHAR
    FIELD bd_merge_qty AS decimal.*/

succ = YES.

CASE bd_case :

    WHEN 'part' THEN DO:
 succ = YES.
    FIND FIRST pt_mstr WHERE pt_part = bd_part NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pt_mstr THEN DO:
    succ = NO.
MESSAGE "��Ч�����" VIEW-AS ALERT-BOX ERROR.
        
        END.

END.

    WHEN 'bd_loc' THEN DO:
    succ = YES.
       FIND b_loc_mstr WHERE b_loc_code = bd_code NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b_loc_mstr THEN DO:
      
       succ = NO.
   MESSAGE "��Ч��λ���룡" VIEW-AS ALERT-BOX ERROR.

           END.

   END.

    WHEN 'period' THEN DO:
     succ = YES.
        FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE glc_cal THEN DO:
      FIND FIRST glcd_det WHERE glcd_per = glc_per NO-LOCK NO-ERROR.
      IF glcd_closed <> YES AND glcd_gl_clsd <> YES AND glcd_yr_clsd <> YES THEN
         succ  = NO.
       MESSAGE "����ڼ��ѹرգ�" VIEW-AS ALERT-BOX ERROR.
    END.
    ELSE DO:

        succ  = NO.
       MESSAGE "��Ч����ڼ䣡" VIEW-AS ALERT-BOX ERROR.
    END.

    END.
        

    WHEN 'si_au' THEN DO:
    
       
        
           {gprun.i ""gpsiver.p"" "(input bd_site, input recid(si_mstr), output succ)"}
             
            IF NOT succ THEN MESSAGE "�޵�ǰ�ص�Ȩ�ޣ�" VIEW-AS ALERT-BOX ERROR.
            
           
            
            
            
            
        
        END.
         WHEN 'site' THEN DO:
    
        FIND FIRST si_mstr WHERE si_site = bd_site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE si_mstr THEN  DO:
                succ = NO.
MESSAGE "��Ч�ص㣡" VIEW-AS ALERT-BOX ERROR.
            
            
            END.
        
            
            
            
        
        END.
        
        
 WHEN 'loc' THEN DO:
    
        FIND FIRST loc_mstr WHERE loc_loc = bd_Loc AND loc_site = bd_site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE loc_mstr THEN  DO:
                succ = NO.
MESSAGE "��Ч��λ��" VIEW-AS ALERT-BOX ERROR.
            
            
            END.
        ELSE succ = YES.
        
        END.
        
         WHEN 'icoverissue' THEN DO:
    
        FIND FIRST ld_det WHERE ld_site = bd_site AND ld_loc = bd_loc AND ld_part = bd_part AND ld_lot = bd_lotser AND ld_ref = bd_ref NO-LOCK NO-ERROR.
        IF  AVAILABLE ld_det THEN  DO:
                FIND FIRST IS_mstr WHERE IS_status = ld_status NO-LOCK NO-ERROR.
                IF AVAILABLE IS_mstr THEN  DO:
                  IF NOT IS_overissue THEN DO:
                  succ = NO.
                      
                  MESSAGE "��������棡" VIEW-AS ALERT-BOX ERROR.

                      END.
                ELSE succ = YES.
                      
                      END.
        END.
                    END.


    WHEN 'ictr_typ' THEN DO:

FIND FIRST ld_det WHERE ld_site = bd_site AND ld_loc = bd_loc AND ld_part = bd_part AND ld_lot = bd_lotser AND ld_ref = bd_ref NO-LOCK NO-ERROR.
IF  AVAILABLE ld_det THEN  DO:
FIND FIRST IS_mstr WHERE IS_status = ld_status NO-LOCK NO-ERROR.
IF AVAILABLE IS_mstr THEN  DO:
   FIND FIRST isd_det WHERE isd_status = is_status AND isd_tr_type = bd_tr_type NO-LOCK NO-ERROR.
   IF AVAILABLE isd_det THEN DO:
       succ = NO.

    MESSAGE bd_tr_type + " �����ƣ�" VIEW-AS ALERT-BOX ERROR.

       
       END.
    
   ELSE succ = YES.
END.
END.
  ELSE DO:
  FIND FIRST loc_mstr WHERE loc_site = bd_site AND loc_loc = bd_loc NO-LOCK NO-ERROR.
IF AVAILABLE loc_mstr THEN DO:
    FIND FIRST IS_mstr WHERE IS_status = loc_status NO-LOCK NO-ERROR.
    IF AVAILABLE IS_mstr THEN
    FIND FIRST isd_det WHERE isd_status = is_status AND isd_tr_type = bd_tr_type NO-LOCK NO-ERROR.
   IF AVAILABLE isd_det THEN DO:
       succ = NO.

    MESSAGE bd_tr_type + " �����ƣ�" VIEW-AS ALERT-BOX ERROR.

       
       END.
    
   ELSE succ = YES.
    
    
    END.
      
      
      END.


END.

            
            WHEN 'bd' THEN DO:
    
        FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND IF bd_data = 'in' THEN b_co_status = 'actived' ELSE IF bd_data = 'out' THEN b_co_status = 'received' ELSE YES NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b_co_mstr THEN  DO:
                succ = NO.
MESSAGE "��Ч���룡" VIEW-AS ALERT-BOX ERROR.
            
            
            END.
        ELSE DO: 
            
            
            
            
            succ = YES.
        
                 
                 
                 
                 END.
        
        END.
            
    WHEN 'bd_match' THEN DO:

FIND FIRST b_co_mstr WHERE b_co_code = bd_code NO-LOCK NO-ERROR.
IF  AVAILABLE b_co_mstr THEN  DO:
      FIND FIRST iss_list WHERE iss_part = bd_part AND iss_lotser = bd_lotser AND iss_ref = bd_ref NO-LOCK NO-ERROR.
      IF NOT AVAILABLE iss_list THEN DO:
          succ = NO.
MESSAGE "���벻���б��У�" VIEW-AS ALERT-BOX ERROR.

          
          
          
          END.
ELSE succ = YES.
  END.


END.

 WHEN 'bd_exp' THEN DO:
IF LENGTH(bd_code) = 18 THEN DO:
    succ = NO.
   
    MESSAGE "���벻���Ϸֽ�ԭ��" VIEW-AS ALERT-BOX ERROR.

END.
    ELSE DO:
    
FIND FIRST b_co_mstr WHERE b_co_code = bd_code NO-LOCK NO-ERROR.
IF  AVAILABLE b_co_mstr THEN  DO:
     IF b_co_qty_cur <= 1 THEN DO:
    
      
          succ = NO.
MESSAGE "���벻���Ϸֽ�ԭ��" VIEW-AS ALERT-BOX ERROR.

          
          
          
          END.
ELSE succ = YES.
  END.
    END.

END.



WHEN 'bd_merge' THEN DO:
DEF VAR isfirst AS LOGICAL.
DEF VAR checkstr AS CHAR.
checkstr = ''.
isfirst = YES.
 succ = YES.
     FOR EACH bd_merge_list NO-LOCK :
         FIND FIRST b_loc_mstr WHERE b_loc_code = bd_code NO-LOCK NO-ERROR.
         IF AVAILABLE b_loc_mstr THEN DO:
             succ = NO.
                 MESSAGE "���벻���Ϻϲ�ԭ��" VIEW-AS ALERT-BOX ERROR.
              LEAVE.
         END.
         IF NOT isfirst AND checkstr <> bd_merge_part + bd_merge_lotser + bd_merge_ref THEN DO:
     
      
          succ = NO.
MESSAGE "���벻���Ϻϲ�ԭ��" VIEW-AS ALERT-BOX ERROR.
LEAVE.
 END.
          
       checkstr =  bd_merge_part + bd_merge_lotser + bd_merge_ref.  
          
          END.

  END.

    WHEN 'po' THEN DO:
    
        FIND FIRST po_mstr WHERE po_nbr = bd_ord AND po_stat <> 'c' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE po_mstr THEN DO:
        
            succ = NO.
MESSAGE "�ɹ����ѽ�򲻴��ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE do:
             FIND FIRST po_mstr WHERE po_nbr = bd_ord AND po_blank = '' NO-LOCK NO-ERROR.
            IF NOT AVAILABLE po_mstr THEN DO:
             succ = NO.
MESSAGE "�ɹ���Ϊ��������" VIEW-AS ALERT-BOX ERROR.
                
                
                END.
          ELSE   succ = YES.
        
        END.
    END.
 
        WHEN 'pod' THEN DO:
    
        FIND FIRST pod_det WHERE pod_nbr = bd_ord AND string(pod_line) = bd_line AND pod_stat <> 'c' AND pod_type <> 'm'  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pod_det THEN DO:
        
            succ = NO.
MESSAGE "�ɹ������ѽ�򲻴��ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE succ = YES.
        
        
        END.


          WHEN 'so' THEN DO:
    
        FIND FIRST so_mstr WHERE so_nbr = bd_ord NO-LOCK NO-ERROR.
        IF NOT AVAILABLE so_mstr THEN DO:
        
            succ = NO.
MESSAGE "���۶��������ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
ELSE succ = YES.
        
        
    END.

        WHEN 'sod' THEN DO:
    
        FIND FIRST sod_det WHERE sod_nbr = bd_ord AND string(sod_line) = bd_line  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE sod_det THEN DO:
        
            succ = NO.
MESSAGE "���۶����в����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE succ = YES.
        
        
        END.
WHEN 'wo' THEN DO:
    
        FIND FIRST wo_mstr WHERE wo_nbr = bd_ord NO-LOCK NO-ERROR.
       IF NOT AVAILABLE wo_mstr THEN DO:
            succ = NO.
MESSAGE "�ӹ��������ڣ�" VIEW-AS ALERT-BOX ERROR.
          
           
            END.
        
        ELSE succ = YES.
        
        
    END.

         WHEN 'woid' THEN DO:
    
        FIND FIRST wo_mstr WHERE wo_nbr = bd_ord AND wo_lot = bd_line  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE wo_mstr THEN DO:
        
            succ = NO.
MESSAGE "�ӹ���ʶ�����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
ELSE succ = YES.
         END.



             WHEN 'prod_line' THEN DO:
    
        FIND FIRST ln_mstr WHERE ln_line = bd_line  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ln_mstr THEN DO:
        
            succ = NO.
MESSAGE "�����߲����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE succ = YES.
        
        
        END.


             WHEN 'emp' THEN DO:
    
        FIND FIRST emp_mstr WHERE emp_addr = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE emp_mstr THEN DO:
        
            succ = NO.
MESSAGE "��Ա�����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        ELSE succ = YES.
        
        
        
        END.

  WHEN 'route' THEN DO:
    
        FIND FIRST ro_det WHERE ro_routing = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ro_det THEN DO:
        
            succ = NO.
MESSAGE "�������̲����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE DO:
         FIND FIRST pt_mstr WHERE pt_part = bd_part AND pt_routing = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pt_mstr THEN DO:
        
            succ = NO.
MESSAGE "���Ǹ����Ϲ�������" VIEW-AS ALERT-BOX ERROR.

            
            
            
            END.
           ELSE succ = YES.
           
           
           
           
           
           END.
           
           
          
        
        END.
            
         WHEN 'bom' THEN DO:
    
        FIND FIRST bom_mstr WHERE bom_parent = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ro_det THEN DO:
        
            succ = NO.
MESSAGE "���ϴ��벻���ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE do:
           
           FIND FIRST pt_mstr WHERE pt_part = bd_part AND pt_bom_code = bd_data NO-LOCK NO-ERROR.
           IF NOT AVAILABLE pt_mstr THEN DO:
          
           succ = NO.
           MESSAGE "���Ǹ����ϵ�BOM!" VIEW-AS ALERT-BOX ERROR.
            END.
        ELSE succ = YES.
       END.
        END.    



          WHEN 'op' THEN DO:
    
        FIND FIRST ro_det WHERE ro_routing = bd_data AND string(ro_op) = bd_op AND ro_milestone NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE ro_det THEN DO:
        
            succ = NO.
MESSAGE "���������" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
            
            
          WHEN 'shift' THEN DO:
    
        FIND FIRST shop_cal WHERE shop_site  = bd_data  NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE shop_cal THEN DO:
        
            succ = NO.
MESSAGE "��β����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    


          WHEN 'dep' THEN DO:
    
        FIND FIRST dpt_mstr WHERE dpt_dept  = bd_data  NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE dpt_mstr THEN DO:
        
            succ = NO.
MESSAGE "���Ų����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    


          WHEN 'wkctr' THEN DO:
    
        FIND FIRST wc_mstr WHERE wc_wkctr  = bd_data  NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE wc_mstr THEN DO:
        
            succ = NO.
MESSAGE "�������Ĳ����ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
            
              WHEN 'mch' THEN DO:
    
        FIND FIRST wc_mstr WHERE wc_wkctr  = bd_data  AND wc_mch = bd_mch NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE wc_mstr THEN DO:
        
            succ = NO.
MESSAGE "���������ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
        
        
        
              WHEN 'shipper' THEN DO:
    
        FIND FIRST abs_mstr WHERE abs_id  = bd_ord   NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE abs_mstr THEN DO:
        
            succ = NO.
MESSAGE "���ϵ������ڣ�" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
        
        
        
  WHEN 'acct' THEN DO:

FIND FIRST ac_mstr WHERE ac_code = bd_data NO-LOCK NO-ERROR.
IF NOT AVAILABLE ac_mstr THEN DO:

    succ = NO.
    MESSAGE "��Ч�˻���" VIEW-AS ALERT-BOX.
    
END.
ELSE succ = YES.


  END.




  END.
        
        
        
        
      



























END CASE.
